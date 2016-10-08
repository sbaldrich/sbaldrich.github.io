---
layout: post
title: "Deploying a ML-based Model Using Boot and H2O"
modified:
categories: blog
excerpt: ""
tags: []
image:
  feature:
date: 2016-10-08T09:54:38-05:00
---

There are many tutorials out there that teach how to train a basic ML model using R, Scikit-Learn, H2O, TensorFlow, etc.
However --more often than not-- we do not only want to train a model but use it to make real time predictions.
This post will briefly describe a way I've used to deal with that second part of the problem, training a couple of simple models
on the [Iris dataset](https://en.wikipedia.org/wiki/Iris_flower_data_set) using H2O and deploying them using a boot-powered application
that provides realtime predictions using a REST endpoint.

All code can be found [here](http://github.com/sbaldrich/h2o-iris-predictor).

### The Models

The models trained for this tutorial are fairly simple and do not deal with important issues such as feature engineering, validation, etc. because
that is not the focus of the post. Both a Random Forest and a GBM are trained using the four features in the data set as well as a new one that
is computed as the sum of the petal and sepal lengths. Below is the code for the RandomForestClassifier, the GBM code is mostly the same:

{% highlight R %}
library(h2o)
library(dplyr)

h2o.init(nthreads = -1)
train.data <- iris %>%
                mutate(Length.Sum = Petal.Length + Sepal.Length) %>%
                rename(petal_wid = Petal.Width,
                       petal_len = Petal.Length,
                       length_sum = Length.Sum,
                       sepal_len = Sepal.Length,
                       sepal_wid = Sepal.Width) %>% as.h2o
iris.rf = h2o.randomForest(y = 5, x = c(1,2,3,4,6),
          training_frame = train.data, ntrees = 50, max_depth = 100, model_id = "RFIrisPredictor")

print(iris.rf)

if (! file.exists("tmp")) {
        dir.create("tmp")
}
h2o.download_pojo(iris.rf, path = "tmp")
{% endhighlight %}

There isn't much going on here besides those last lines. I'm downloading a POJO with the trained model and putting it on a temporal
directory to be compiled later on. The compilation step is handled separately from that of the application because we'd like to be
able to create and deploy new models without needing to recompile (nor redeploy) our application. The relevant lines of the model
compilation script are shown below:

{% highlight bash %}
#train_models.sh

#!/usr/bin/env bash
# Train a Random Forest and a GBM and place their jar files on the tmp directory.
mkdir tmp
echo "Training the random forest and generating its jar file"
r -f iris_random_forest.R
cd tmp
cat <(echo -e package com.baldrichcorp.ml.generated\;\\n) RFIrisPredictor.java > tmp.java
mv tmp.java RFIrisPredictor.java
javac -d . RFIrisPredictor.java -cp h2o-genmodel.jar
jar cf RFIrisPredictor.jar com
rm -r com RFIrisPredictor.java
cd ..
# ... do the same thing for the GBM
{% endhighlight %}

The only important part here is that I'm properly setting up the package in which I want the models to be put and that I'm
using the `h2o-genmodel.jar` required by H2O to compile the POJO. This jar must also be packaged with the application for
the models to be used during runtime.

It is your job to define a way in which the jar files are going to be obtained by the application, this example uses an H2
database. This means that it is necessary to create means for the jar files to be stored as `Lob`s in the database. Since that is a
common task, I won't get into the details of it and simply store the files upon application startup using a Bean.

{% highlight java %}
//H2oIrisPredictorApplication.java
//...
@Service
   static class DatabaseLoader {
       @Autowired
       PredictorRepository repository;

       @PostConstruct
       void initDatabase() {
           InputStream rfis = this.getClass().getResourceAsStream("/RFIrisPredictor.jar");
           InputStream gbmis = this.getClass().getResourceAsStream("/GBMIrisPredictor.jar");
           try {
               System.out.println("Saving Random Forest predictor");
               byte[] data = FileCopyUtils.copyToByteArray(rfis);
               Predictor predictor = new Predictor("com.baldrichcorp.ml.generated.RFIrisPredictor", "RFIrisPredictor", data, Arrays.asList("sepal_width","sepal_length"));
               repository.save(predictor);
               System.out.println("Saving Gradient Boosting predictor");
               data = FileCopyUtils.copyToByteArray(gbmis);
               predictor = new Predictor("com.baldrichcorp.ml.generated.GBMIrisPredictor", "GBMIrisPredictor", data, Arrays.asList("sepal_length"));
               repository.save(predictor);
           } catch (IOException ex) {
               System.err.println("Sorry :(");
           }
       }
   }
{% endhighlight %}  

### Setting up the application

The above section intends to show that model training can be done independently from the application development process, i.e., you can train and prepare
models for deployment at any time; even after your application is already on a production environment. I include the execution of the script on the build
file as well as other custom tasks only for development (and illustration) purposes. The relevant additions to `build.gradle` are shown below:

{% highlight groovy %}

//... build script config

repositories {
	flatDir {dirs "lib"} // We'll put the h2o jar here.
	mavenCentral()
}

dependencies {
  compile name: 'h2o-genmodel'
  //... more dependencies (spring-boot, lombok, etc.)
}

task deleteTmp(type: Delete) {
    delete "tmp/"
}

task trainModels(type: Exec, dependsOn: deleteTmp) {
    commandLine "sh", "train_models.sh"
}

task placeGenModelJar(type: Copy, dependsOn: trainModels) {
    from "tmp/h2o-genmodel.jar"
    into "lib"
}

task placePredictionModels(type: Copy, dependsOn: placeGenModelJar){
    from("tmp/"){
		include "\*.jar"
    }
	into "src/main/resources"
	exclude "h2o-genmodel.jar"
}

task(generateModels, dependsOn: placePredictionModels) << {
}

compileJava.dependsOn generateModels

task cleanGenerated(type: Delete) {
    delete "tmp",
            "lib/h2o-genmodel.jar",
            "src/main/resources/GBMIrisPredictor.jar",
			"src/main/resources/RFIrisPredictor.jar"
}

clean.dependsOn cleanGenerated
{% endhighlight %}

## Serving predictions

Boot makes the development process really simple. This is not more than a common web application with
some REST endpoints, so I'll try to describe only the important aspects that allow for loading the models during
runtime.

#### 1. Getting the jars

Since we have stored the jar files in our database, it makes sense to have a way of loading the model classes
during runtime, the following method inside the `Predictor` class handles exactly that:

{% highlight java %}
// com.baldrichcorp.ml.domain.Predictor.java
//...
@Transient
@Getter(AccessLevel.NONE)
private EasyPredictModelWrapper model;
//...
public Optional<EasyPredictModelWrapper> obtainModel() {
        if (model == null) {
            synchronized (this) {
                if (model != null)
                    return Optional.of(model);
                try {
                    log.info("Instantiating GenModel for [" + qualifiedName + "]");
                    File file = new File(identifier);
                    FileCopyUtils.copy(data, file);
                    JarFile jar = new JarFile(file);

                    Enumeration<JarEntry> entries = jar.entries();
                    URL[] urls = {new URL("file:" + file.getAbsolutePath())};
                    URLClassLoader loader = new URLClassLoader(urls, Thread.currentThread().getContextClassLoader());
                    Map<String, Class<?>> classes = new HashMap<>();

                    while (entries.hasMoreElements()) {
                        JarEntry je = entries.nextElement();
                        if (!je.getName().endsWith(".class")) {
                            continue;
                        }
                        String className = je.getName().substring(0, je.getName().length() - 6);
                        className = className.replace("/", ".");
                        classes.put(className, loader.loadClass(className));
                    }
                    loader.close();
                    jar.close();
                    model = new EasyPredictModelWrapper((GenModel) classes.get(qualifiedName).newInstance());
                    return Optional.of(model);
                } catch (IOException | ClassNotFoundException | InstantiationException |
                        IllegalAccessException ex) {
                    log.error("Couldn't instantiate GenModel for class" + qualifiedName + ".", ex);
                    return Optional.empty();
                }

            }
        }
        return Optional.of(model);
    }
{% endhighlight %}

We don't want to load the model from the jar file every time we need to use it, so a field is used as a simple cache.
Now, this wouldn't help us at all if the `Predictor`s are always loaded from the database (because the model field is marked as `@Transient`)
so we rely on Springs `@Cacheable` annotation:

{% highlight java %}
//...
public interface PredictorRepository extends CrudRepository<Predictor, Long> {
    @Override
    @Cacheable("predictors")
    Predictor findOne(Long id);
}
{% endhighlight %}

#### 2. Associating Features to Models

It is reasonable to think that most models will use the same flower attributes (sepal length, sepal width, petal length, petal width) but
different computed features (such as the sum of the lengths I've used in the models). To allow for new models to declaratively select the
features it will use I considered two options:

1. Store the features in the database along with javascript code and compute them using Nashorn. Although this approach sounded interesting,
the fact that the feature computation code wasn't compiled along with the application opened the way for bugs to creep in easily, so wen't with
option number 2.

2. Create the feature computation code inside the application and let all models select a subset of them for making predictions. The drawback of
this approach is that recompilation and redeployment are necessary for adding new features but it is a price I was willing to pay at the moment.

To ensure that the features declared by the new models were valid, I added a custom validator for the Predictor entity:

{% highlight java %}
// FeatureValidator.java
//...
public class FeatureValidator implements ConstraintValidator<FeaturesExist, Predictor> {
    @Override
    public void initialize(FeaturesExist constraintAnnotation) {
    }

    @Override
    public boolean isValid(Predictor predictor, ConstraintValidatorContext context) {
        if (!isNull(predictor.getFeatures()) && !predictor.getFeatures().isEmpty()) {
            Set<String> validFeatures = Arrays.asList(FlowerFeature.values()).stream().map(FlowerFeature::name).collect(toSet());
            for (String feature : predictor.getFeatures())
                if (!validFeatures.contains(feature))
                    return false;
            return true;
        }
        return false;
    }
}


// Predictor.java
//...
@Getter
@Entity
@ToString
@FeaturesExist
@Slf4j
public class Predictor { ... }

{% endhighlight %}

## Conclusion

That's all folks.

Clearly there is more to it than only these few snippets, but the gist of it is here. I recommend you take a look
at the [code](http://github.com/sbaldrich/h2o-iris-predictor) if you want to see more. Also, see [this](https://www.youtube.com/watch?v=jSN2y6j0Mxk)
talk from where I came up with this idea.

---
layout: post
title: "Fun with Spring Boot: Part I"
categories: blog
tags: [spring boot, spring, java, web, spring-data, rest]
date: 2016-01-30T16:06:33-05:00
---

I've been playing for a while with Spring and Spring boot and found out that Boot's reputation of really making easier Spring development is not undeserved.
As a simple demonstration, this post resumes a couple of features I've found very useful.  

## Spring Initializr

Spring provides a way to create starter projects with the [Spring Initializr](start.spring.io), just enter
the information about your project and you'll get a nice zipped file with your project all set up. Another way to do it is to create a starter project using [STS](http://spring.io/tools/sts) if you have it installed. Finally (and currently my favorite choice), you can use `curl` to obtain the project (I recommend using the `--data` argument to avoid annoying typos).

{% highlight bash %}
curl https://start.spring.io/starter.tgz --data @project-config | tar -xzvf -
{% endhighlight %}

With a project-config file such as:

{% highlight bash %}
dependencies=thymeleaf,data-jpa,data-rest,h2
&type=gradle-project
&groupId=com.baldrichcorp
&artifactId=boot-example
&name=BootSample
&baseDir=boot-sample
&packageName=boot.example
{% endhighlight %}

To run the application, use the `bootRun` task. By default, it will be listening on `localhost:8080` using an embedded Tomcat (*yup, no Tomcat setup needed*).

## Controllers, Services and templates

Since Boot takes care of configuration (in an opinionated but easily customizable way), we can start coding Services and Controllers right away. Also, if Thymeleaf is listed among the dependencies of the project, there is no additional configuration to be done. The `ViewResolver` is automatically configured to prefix `/templates` and append `.html` to the views returned by our controllers (**e.g.,** returning `"hello"` in a Controller would look for the `templates/hello.html` template), so we can just start to add templates to the `src/main/resources/templates/` directory.

#### Setting up the front-end

Boot serves by default static resources located inside `public`, `resources`, and `META-INF/resources` inside the `src/main/java` directories, so all style and javascript resources can be put in any of those directories to be served by Spring. If we wanted to use, say, *JQuery* and *Bootstrap* in a web app, we could download and put them in one of the mentioned directories or let [bower](http://bower.io/#install-bower) handle this for us. To do this, we must first let `bower` know that we want our libraries to be installed in `src/main/resources/**` using a `.bowerrc` file with the following contents:

```
{"directory": "src/main/resources/public"}
```

Then, use `bower init` to setup bower and `bower install jquery bootstrap --save` to install *JQuery* and *Bootstrap* to the project.

![boot-hello-world-bower](/figs/2016-01-30-fun-with-spring-boot-part-1/boot-hello-world-bower.png)

This configuration would let us refer to any *Bootsrap* or *JQuery* assets from our templates:

{% highlight html %}
<!DOCTYPE html>
  ...
  <head>
    <script src="/jquery/dist/jquery.min.js"></script>
    <script src="/bootstrap/dist/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="/bootstrap/dist/css/bootstrap-theme.min.css"></link>
    <link rel="stylesheet" href="/bootstrap/dist/css/bootstrap.min.css"></link>
  </head>
  ...
</html>
{% endhighlight %}

## Spring Data and Spring Data rest

If we list `data-rest` as a dependency of our project, we can benefit from the creation of REST endpoints to query and modify repositories. Just create some Spring Data repositories and *voilá*, you get your REST endpoints.
Say we have a simple data model composed of team `Team` and `Developer` classes, where each team has a name and a set of developers and each developer has a name and a skill. We can create repositories for these entities as follows:

{% highlight java %}

//TeamRepository.java
public interface TeamRepository extends PagingAndSortingRepository<Team, Long>{ }

//DeveloperRepository.java
public interface DeveloperRepository extends PagingAndSortingRepository<Developer, Long>{
  Iterable<Developer> findBySkill(@Param("skill") String skill);
}
{% endhighlight %}

The creation of these repositories and the fact that we have included *Spring Data Rest* (and transitively *Spring HATEOAS* and *Jackson mapper*), is enough to let us access these repositories via REST endpoints. We can even insert data into the database using POST requests.

![boot-data-rest-query](/figs/2016-01-30-fun-with-spring-boot-part-1/boot-rest-data.gif)

> **Tip**: by adding H2 to the dependencies of the project, Boot automatically configures an embedded database in `create-drop` mode. Setting the `spring.datasource.platform` property in the *application.properties* file lets us tell Boot to run database population script upon startup.

### Conclusion

These are just a couple among a lot (really, *a lot*) of useful features of Spring Boot (for example, they have great integration with Amazon Cloud Services and Netflix' OSS). Boot can greatly reduce the time necessary for configuring Spring, allowing to focus on creating powerful applications.

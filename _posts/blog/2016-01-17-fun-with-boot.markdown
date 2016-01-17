---
layout: post
title: "Fun with Spring Boot - I"
modified:
categories: blog
excerpt:
tags: [spring boot, spring, java, web]
image:
  feature:
date: 2016-01-17T12:30:33-05:00
---

I've been playing for a while with Spring and Spring boot and found out that Boot's reputation of really making easier Spring development is not undeserved.
As a simple demonstration, this post resumes some steps required to setup a simple web application with Boot.  

## Spring Initializr

Spring provides a way to create starter projects with the [Spring Initializr](start.spring.io), enter
the information about your project and you'll get a nice zipped file with your project all set up, another way to do it s to create a starter project using [STS](http://spring.io/tools/sts) if you have it installed. Finally (and currently my favorite choice), you can use `curl` to obtain the project. I recommend using the `--data` argument to avoid stupid mistakes when generating the project.

{% highlight bash %}
curl https://start.spring.io/starter.tgz --data @project-config | tar -xzvf -
{% endhighlight %}

With a project-config file such as:

{% highlight bash %}
dependencies=thymeleaf
&type=gradle-project
&groupId=com.baldrichcorp
&artifactId=boot-example
&name=BootSample
&baseDir=boot-sample
&packageName=boot.example
{% endhighlight %}

## Creating a simple controller

Since all dependencies have been taken care of, we can start coding our application. Let's add a simple controller.

> src/main/java/boot/example/BootSampleApplication.java

{% highlight java %}
package boot.example;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

@SpringBootApplication
public class BootSampleApplication {

  public static void main(String[] args) {
    SpringApplication.run(BootSampleApplication.class, args);
  }

  @Controller
  static class SimpleController{
    @RequestMapping("/")
    @ResponseBody
    public String home(){
      return "<h3>Hello world!!</h3>";
    }
  }
}
{% endhighlight %}

Run the application by using the `bootRun` task and visit `localhost:8080`

{% highlight bash %}
./gradlew bootRun
{% endhighlight %}

![boot-hello-world](/images/posts/boot-hello-world.png)

## Setting up the frontend

Spring Boot by default serves static resources located at `src/main/java/{public,META-INF/resources,static,resources}`, so all style and javascript sources can be put there.
Say we want to use *JQuery* and *Bootstrap* in our web app, we could download them and put them in one of the mentioned directories or let `bower` handle this for us. To use `bower` we must first let it know that we want our libraries to be installed in `src/main/resources/..` using a `.bowerrc` file with the following contents:

```
{
  "directory": "src/main/resources/public"
}
```

> Don't have bower? [get it](http://bower.io/#install-bower)

Then, use `bower init` to setup bower and `bower install jquery bootstrap --save` to install *JQuery* and *Bootstrap* to the project.

![boot-hello-world-bower](/images/posts/boot-hello-world-bower.png)

```
bower install jquery bootstrap --save`
```

Now we can add an html page and style it using Bootstrap.

> src/main/resources/templates/hello.html

{% highlight html %}
<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org"
  xmlns:layout="http://www.ultraq.net.nz/web/thymeleaf/layout">
  <head>
    <script src="/jquery/dist/jquery.min.js"></script>
    <script src="/bootstrap/dist/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="/bootstrap/dist/css/bootstrap-theme.min.css"></link>
    <link rel="stylesheet" href="/bootstrap/dist/css/bootstrap.min.css"></link>
  </head>
  <body>
    <span class="label label-info">Hello world!</span>
  </body>
</html>
{% endhighlight %}

To return it, there is only a couple of small changes that need to be done to our controller:

> src/main/java/boot/example/BootSampleApplication.java

{% highlight java %}
  ...
  @Controller
  static class SimpleController{
    @RequestMapping("/")
    //@ResponseBody
    public String home(){
      return "hello";
    }
  }
}
{% endhighlight %}

![boot-hello-world-bootstrap](/images/posts/boot-hello-world-bootstrap.png)

### Conclusion

This is a very -*very*– basic use of Boot. However, it shows that Boot can greatly reduce the time necessary for configuring Spring, thus allowing to really focus on programming the particular characteristics of applications.

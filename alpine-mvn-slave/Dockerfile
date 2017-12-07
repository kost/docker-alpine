FROM alpine-slave-base:latest

MAINTAINER ming.chen<uchenm@163.com>

RUN mkdir /home/jenkins/.m2
RUN chown -R jenkins:jenkins /home/jenkins/.m2/

RUN MAVEN_VERSION=3.3.9 \
 && cd /usr/share \
 && wget -q http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz -O - | tar xzf - \
 && mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven \
 && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn
ENV MAVEN_HOME /usr/share/maven

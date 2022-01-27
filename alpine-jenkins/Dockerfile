FROM alpine-openjdk:8u131

RUN apk --no-cache add curl bash fontconfig ttf-dejavu

ENV JENKINS_USER jenkins
ENV JENKINS_VERSION 2.92
ENV JENKINS_HOME /var/jenkins_home
ENV JAVA_OPTS -Djava.awt.headless=true

RUN mkdir $JENKINS_HOME && adduser -Dh $JENKINS_HOME $JENKINS_USER && cd $JENKINS_HOME && curl -sL http://mirrors.jenkins.io/war/$JENKINS_VERSION/jenkins.war -o $JENKINS_HOME/jenkins.war && chown -R $JENKINS_USER $JENKINS_HOME && mv $JENKINS_HOME/jenkins.war /usr/share/jenkins.war

USER $JENKINS_USER
EXPOSE 8080
EXPOSE 50000
VOLUME /var/jenkins_home

CMD /usr/bin/java $JAVA_OPTS -jar /usr/share/jenkins.war


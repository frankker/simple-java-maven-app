FROM openjdk:8-alpine
RUN mkdir -p /opt/todobackend
WORKDIR /opt/todobackend
COPY target/my-app-1.0-SNAPSHOT.jar /opt/todobackend
EXPOSE 8082
ENV JAVA_ARGS=""
#CMD ["java", "$JAVA_ARGS", "-jar", "todobackend-0.0.1-SNAPSHOT.jar"]
CMD java $JAVA_ARGS -jar my-app-1.0-SNAPSHOT.jar

## Alpine Linux with OpenJDK JRE
#FROM openjdk:8-jre-alpine
## copy WAR into image
#COPY my-app-1.0-SNAPSHOT.jar /app.jar
## run application with this command line
#CMD ["/usr/bin/java", "-jar", "-Dspring.profiles.active=default", "/app.jar"]
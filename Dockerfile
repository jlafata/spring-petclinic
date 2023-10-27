# Use Ubuntu Jammy as the base image
FROM ubuntu:jammy as build

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Update the package list and install necessary packages
RUN apt-get update && apt-get install -y openjdk-17-jdk maven

# Set the working directory inside the container
WORKDIR /workspace/app
EXPOSE 8080

# Copy the contents of your project to the container
#COPY . /app
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .
COPY src src

RUN mvn install -DskipTests
RUN mkdir -p target/dependency && (cd target/dependency; jar -xf ../*.jar)

FROM ubuntu:jammy
RUN apt-get update && apt-get install -y openjdk-17-jdk

VOLUME /tmp
ARG DEPENDENCY=/workspace/app/target/dependency
COPY --from=build ${DEPENDENCY}/BOOT-INF/lib /app/lib
COPY --from=build ${DEPENDENCY}/META-INF /app/META-INF
COPY --from=build ${DEPENDENCY}/BOOT-INF/classes /app

ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64/jre/bin/java

# Run 'mvn spring-boot:run' when the container starts
#CMD ["mvn", "spring-boot:run"]
ENTRYPOINT ["java","-cp","app:app/lib/*","org.springframework.samples.petclinic.PetClinicApplication"]


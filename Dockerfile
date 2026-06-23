# Stage 1: Build the war file
FROM maven:3.8.5-openjdk-17-slim AS build
WORKDIR /app
COPY pom.xml .
# Pre-download dependencies to speed up builds
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Run Tomcat
FROM tomcat:10.1-jdk17-temurin
WORKDIR /usr/local/tomcat

# Copy the JNDI JDBC driver to Tomcat's global lib folder
COPY --from=build /root/.m2/repository/com/mysql/mysql-connector-j/8.3.0/mysql-connector-j-8.3.0.jar /usr/local/tomcat/lib/

# Copy the built war file
COPY --from=build /app/target/sewvana.war /usr/local/tomcat/webapps/sewvana.war

# Configure Tomcat to listen to dynamic port from environment variable ($PORT)
RUN sed -i 's/port="8080"/port="${port.http}"/g' /usr/local/tomcat/conf/server.xml

# Set default port java opt
ENV CATALINA_OPTS="-Dport.http=8080"

# Expose default port
EXPOSE 8080

# Run tomcat with dynamic port configuration
CMD ["sh", "-c", "export CATALINA_OPTS=\"$CATALINA_OPTS -Dport.http=${PORT:-8080}\" && catalina.sh run"]

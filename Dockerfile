# --- Stage 1: Build Stage ---
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app

# Copy the pom.xml and source code
COPY pom.xml .
COPY src ./src
COPY .mvn ./.mvn
COPY mvnw .
COPY mvnw.cmd .

# Build the application and skip tests (since they ran in the CI stage)
RUN chmod +x mvnw && ./mvnw clean package -DskipTests

# --- Stage 2: Production Stage ---
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# Install curl for health checks (optional)
RUN apk add --no-cache curl

# Create a non-root user for security
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring

# Copy the built WAR file from the build stage
COPY --from=build /app/target/*.war app.war

# Expose the standard Spring Boot port
EXPOSE 8080

# Environment variables with sensible defaults
ENV SPRING_PROFILES_ACTIVE=prod
ENV SPRING_DATASOURCE_URL=jdbc:mysql://repairshop-db:3306/repairshop_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true
ENV SPRING_DATASOURCE_USERNAME=repairshop
ENV SPRING_DATASOURCE_PASSWORD=repairshop

# Run the standalone Spring Boot application
ENTRYPOINT ["java", "-jar", "app.war"]

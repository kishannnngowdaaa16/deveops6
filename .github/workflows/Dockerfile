
# Step 1: Build stage using Maven and JDK 17
FROM maven:3.8.6-openjdk-17-slim AS build

WORKDIR /app

# Copy Maven configuration and source code
COPY pom.xml .
COPY src ./src

# Download dependencies
RUN mvn dependency:go-offline -B

# Compile test classes without executing tests
RUN mvn test-compile

# Step 2: Runtime stage
FROM openjdk:17-slim

WORKDIR /app

# Install Chromium and required dependencies
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    curl \
    unzip \
    libglib2.0-0 \
    libnss3 \
    libfontconfig1 \
    chromium \
    && rm -rf /var/lib/apt/lists/*

# Copy application from build stage
COPY --from=build /app /app

# Configure Chromium binary
ENV CHROME_BIN=/usr/bin/chromium

# Execute TestNG Selenium tests
CMD ["mvn", "test"]

# Build stage
FROM maven:3.8.6-openjdk-17-slim AS build

WORKDIR /app

COPY pom.xml .
COPY src ./src

RUN mvn dependency:go-offline -B
RUN mvn test-compile

# Runtime stage
FROM maven:3.8.6-openjdk-17-slim

WORKDIR /app

RUN apt-get update && apt-get install -y \
    chromium \
    libglib2.0-0 \
    libnss3 \
    libfontconfig1 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=build /app /app

ENV CHROME_BIN=/usr/bin/chromium

CMD ["mvn", "test"]
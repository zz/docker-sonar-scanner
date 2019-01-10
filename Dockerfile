FROM openjdk:8-jdk-alpine
## Based on this example http://stackoverflow.com/a/40612088/865222
ENV SONAR_SCANNER_VERSION 3.3.0.1492

RUN apk add --no-cache wget && \
    wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}.zip && \
    unzip sonar-scanner-cli-${SONAR_SCANNER_VERSION}.zip && \
    cd /usr/bin && ln -s /sonar-scanner-${SONAR_SCANNER_VERSION}/bin/sonar-scanner sonar-scanner && \
    mkdir -p /sonar-scanner-${SONAR_SCANNER_VERSION}/jre/bin/ && \
    cd /sonar-scanner-${SONAR_SCANNER_VERSION}/jre/bin/ && \
    ln -s /usr/bin/java java && \
    cd / && rm sonar-scanner-cli-${SONAR_SCANNER_VERSION}.zip && \
    apk del wget && \
    ln -s /usr/bin/sonar-scanner-run.sh /bin/gitlab-sonar-scanner

COPY sonar-scanner-run.sh /usr/bin


#!/bin/sh
# https://docs.sonarqube.org/latest/analysis/analysis-parameters/
# https://github.com/gabrie-allaigre/sonar-gitlab-plugin

if [ -z ${SONAR_URL+x} ]; then
  echo "Undefined \"SONAR_URL\" env" && exit 1
fi

URL=$SONAR_URL

COMMAND="sonar-scanner -Dsonar.host.url=$URL"

if ! grep -q sonar.projectKey "sonar-project.properties"; then
  if [ -z ${SONAR_PROJECT_KEY+x} ]; then
    SONAR_PROJECT_KEY=$CI_PROJECT_NAME
  fi
  COMMAND="$COMMAND -Dsonar.projectKey=$SONAR_PROJECT_KEY"
fi

if [ -z ${SONAR_PROJECT_VERSION+x} ]; then
  SONAR_PROJECT_VERSION=$CI_BUILD_ID
fi

if [ -z ${SONAR_GITLAB_PROJECT_ID+x} ]; then
  SONAR_GITLAB_PROJECT_ID=$CI_PROJECT_ID
fi

if [ ! -z ${SONAR_TOKEN+x} ]; then
  COMMAND="$COMMAND -Dsonar.login=$SONAR_TOKEN"
fi

if [ ! -z ${SONAR_PROJECT_VERSION+x} ]; then
  COMMAND="$COMMAND -Dsonar.projectVersion=$SONAR_PROJECT_VERSION"
fi

if [ ! -z ${SONAR_DEBUG+x} ]; then
  COMMAND="$COMMAND -X"
fi

if [ ! -z ${SONAR_JAVA_BINARIES+x} ]; then
  COMMAND="$COMMAND -Dsonar.java.binaries=$SONAR_JAVA_BINARIES"
fi

if [ ! -z ${SONAR_SOURCES+x} ]; then
  COMMAND="$COMMAND -Dsonar.sources=$SONAR_SOURCES"
fi

if [ ! -z ${SONAR_EXCLUSIONS+x} ]; then
  COMMAND="$COMMAND -Dsonar.exclusions=$SONAR_EXCLUSIONS"
fi

if [ ! -z ${SONAR_ENCODING+x} ]; then
  COMMAND="$COMMAND -Dsonar.sourceEncoding=$SONAR_ENCODING"
fi

# analysis by default
if [ -z ${SONAR_ANALYSIS_MODE+x} ]; then
  SONAR_ANALYSIS_MODE="preview"
fi

if [ $SONAR_ANALYSIS_MODE == "preview" ]; then
  COMMAND="$COMMAND -Dsonar.issuesReport.console.enable=true"
  COMMAND="$COMMAND -Dsonar.gitlab.failure_notification_mode=exit-code"

  if [ ! -z ${SONAR_GITLAB_PROJECT_ID+x} ]; then
    COMMAND="$COMMAND -Dsonar.gitlab.project_id=$SONAR_GITLAB_PROJECT_ID"
  fi

  if [ ! -z ${CI_BUILD_REF+x} ]; then
    COMMAND="$COMMAND -Dsonar.gitlab.commit_sha=$CI_BUILD_REF"
  fi

  if [ ! -z ${CI_BUILD_REF_NAME+x} ]; then
    COMMAND="$COMMAND -Dsonar.gitlab.ref_name=$CI_BUILD_REF_NAME"
  fi
fi

$COMMAND $1

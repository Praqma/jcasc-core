#!/usr/bin/env bash

unset https_proxy
unset http_proxy
unset no_proxy

# if `docker run` first argument start with `-` the user is passing jenkins swarm launcher arguments
if [[ $# -lt 1 ]] || [[ "$1" == "-"* ]]; then

  # jenkins swarm slave
  JAR=`ls -1 /usr/share/jenkins/swarm-client-*.jar | tail -n 1`

  # Set master URL - jenkins name defined in docker-compose and available for reference in Docker network
  PARAMS="-master http://jenkins:8080"

  # Set default number of executors (2 by default)
  PARAMS="$PARAMS -executors ${NUM_OF_EXECUTORS:-2}"

  # Set mode for jobs execution - leave this machine for tied jobs only
  PARAMS="$PARAMS -mode exclusive "

  # Set labels to slave
  PARAMS="$PARAMS -labels \"linux\" -labels \"alpine\" -labels \"${JENKINS_SWARM_VERSION}\" -labels \"java\" -labels \"docker\" -labels \"swarm\" -labels \"utility-slave\""

  # User and password from environment
  PARAMS="$PARAMS -username ${JENKINS_RUNNER} -passwordFile /tmp/password"

  echo JENKINS_RUNNER ${JENKINS_RUNNER}
  echo Running java $JAVA_OPTS -jar $JAR -fsroot $HOME/slave $PARAMS "$@"
  exec java $JAVA_OPTS -jar $JAR -fsroot $HOME $PARAMS "$@"
fi

# As argument is not jenkins, assume user want to run his own process, for sample a `bash` shell to explore this image
exec "$@"
FROM anapsix/alpine-java

MAINTAINER Wurstmeister 

RUN apk add --update unzip wget curl docker jq coreutils

ENV KAFKA_VERSION="0.10.0.0" SCALA_VERSION="2.11"
ADD download-kafka.sh /tmp/download-kafka.sh
RUN chmod 777 /tmp/download-kafka.sh
RUN /tmp/download-kafka.sh && tar xfz /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /opt && rm /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz

VOLUME ["/kafka"]

ENV KAFKA_HOME /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION}
ADD start-kafka.sh /usr/bin/start-kafka.sh
ADD broker-list.sh /usr/bin/broker-list.sh
ADD create-topics.sh /usr/bin/create-topics.sh
RUN chmod 777 /usr/bin/start-kafka.sh
RUN chmod 777 /usr/bin/broker-list.sh
RUN chmod 777 /usr/bin/create-topics.sh

ADD increase-replication-factor.json ${KAFKA_HOME}/bin/increase-replication-factor.json
# Use "exec" form so that it runs as PID 1 (useful for graceful shutdown)
CMD ["start-kafka.sh"]

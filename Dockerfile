FROM centos:centos7

USER root

LABEL maintainer="Yildirim Adiguzel <yildirim.adiguzel@212data.com>"

LABEL vendor=212Data \
  com.212data.license="Apache License, Version 2.0" \
  com.212data.name="212Data Centos Java base image"

# configure java runtime
ENV JAVA_HOME=/opt/java \
  JAVA_VERSION_MAJOR=8 \
  JAVA_VERSION_MINOR=141 \
  JAVA_VERSION_BUILD=15 \
  JAVA_DOWNLOAD_HASH=336fa29ff2bb4ef291e347e091f7f4a7

# install curl, tar and clean yum
RUN yum install -y \
  curl tar wget\
  && yum clean all

# install Oracle JRE
RUN mkdir -p /opt \
  && curl --fail --silent --location --retry 3 \
  --header "Cookie: oraclelicense=accept-securebackup-cookie; " \
  http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-b${JAVA_VERSION_BUILD}/${JAVA_DOWNLOAD_HASH}/server-jre-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar.gz \
  | gunzip \
  | tar -x -C /opt \
  && ln -s /opt/jdk1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR} ${JAVA_HOME}

RUN mkdir -p /opt \
  && curl --fail --silent --location --retry 3 \
  https://archive.apache.org/dist/kafka/0.11.0.1/kafka_2.11-0.11.0.1.tgz \
  | gunzip \
  | tar -x -C /opt


WORKDIR "/opt"

COPY target/kafka-connect-couchbase-3.2.4-SNAPSHOT.jar /opt/kafka-connect-couchbase.jar
COPY config/quickstart-couchbase-source.properties /opt/quickstart-couchbase-source.properties
COPY config/connect-standalone.properties /opt/connect-standalone.properties

COPY entrypoint.sh /opt/entrypoint.sh

RUN chmod 777 entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
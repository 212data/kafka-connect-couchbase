#!/bin/sh

echo "zookeeper will be started"
env CLASSPATH=./* /opt/kafka_2.11-0.11.0.1/bin/connect-standalone.sh /opt/connect-standalone.properties /opt/quickstart-couchbase-source.properties
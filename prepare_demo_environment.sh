#!/bin/bash

mkdir lib

# Download stuff
curl -o lib/robotframework-3.0.2.jar -LO http://search.maven.org/remotecontent?filepath=org/robotframework/robotframework/3.0.2/robotframework-3.0.2.jar
curl -o lib/robotframework-jmslibrary-1.0.0.jar -L https://github.com/ilkkatoje/robotframework-jmslibrary/releases/download/1.0.0/robotframework-jmslibrary-1.0.0.jar
curl -o lib/apache-artemis-2.4.0-bin.tar.gz -L "https://www.apache.org/dyn/closer.cgi?filename=activemq/activemq-artemis/2.4.0/apache-artemis-2.4.0-bin.tar.gz&action=download"

# Extract JMS client jar and copy it in place
cd lib
tar -zxf apache-artemis-2.4.0-bin.tar.gz apache-artemis-2.4.0/lib/client/artemis-jms-client-all-2.4.0.jar
rm apache-artemis-2.4.0-bin.tar.gz
cp apache-artemis-2.4.0/lib/client/artemis-jms-client-all-2.4.0.jar .
rm -rf apache-artemis-2.4.0

# Start JMS server
cd ..
bin/start_artemis.sh

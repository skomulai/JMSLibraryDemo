#!/bin/bash

LIBDIR=$(dirname $(readlink -f $0))/../lib

java -cp $CLASSPATH:$LIBDIR/robotframework-jmslibrary-1.0.0.jar:$LIBDIR/robotframework-3.0.2.jar:$LIBDIR/artemis-jms-client-all-2.4.0.jar org.robotframework.RobotFramework $*

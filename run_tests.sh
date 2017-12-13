#!/bin/bash

mkdir -p htmloutput
bin/jrobot.sh -d htmloutput $* *.robot

#!/bin/bash

cat controller/Dockerfile | grep jenkins/jenkins | cut -f2 -d":"
#!/bin/bash

# test CircleCI env vars
echo $CIRCLE_PR_NUMBER
echo $CIRCLE_BRANCH
echo $CIRCLE_SHA1
echo $CIRCLE_BUILD_NUM

# test CircleCI env vars
echo ${CIRCLE_PR_NUMBER}
echo ${CIRCLE_BRANCH}
echo ${CIRCLE_SHA1}
echo ${CIRCLE_BUILD_NUM}

curl -X GET -H 'Content-Type: application/json' "http://www.earthtools.org/timezone/40.71417/-74.00639"
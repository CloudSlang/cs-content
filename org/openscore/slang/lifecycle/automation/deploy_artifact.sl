#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   This operation will do a PUT call to a file which contains the default Artifactory authentication flow will deploy an artifact to Artifactory
#
#   Inputs:
#       - host - machine host
#       - computerPort - the computer port
#       - group - the group of the artifact
#       - version - the version of the artifact
#       - repository - the repository name
#       - filePath - the artifact path
#   Outputs:
#       - returnResult - response of the operation
#       - statusCode - normal status code is 201
#       - errorMessage: returnResult if statusCode different than 201
#   Results:
#       - SUCCESS - operation succeeded (statusCode == '201')
#       - FAILURE - otherwise
####################################################

namespace: org.openscore.slang.lifecycle.automation

operation:
 name: deploy_artifact
 inputs:
   - host:
      default: "'16.22.65.27'"
      required: false
   - computerPort:
      default: "'8081'"
      required: false
   - group:
      default: "'petClinic'"
      required: false
   - version:
      default: "'1'"
      required: false
   - artifact:
      default: "'bla'"
      required: false
   - repository:
      default: "'/artifactory/simple/ext-release-local/'"
      required: false
   - filePath:
      default: "'somePath'"
      required: false
   - url:
      default: "'http://' + host + ':' + computerPort + '/artifactory/simple/ext-release-local/' + artifact + '/' + group + '/' + version + '/' + group + '-' + version + '.war'"
      override: true
   - body: # the filePath is harcoded, needs to be investigated to find an elegant solution to send the file path as parameter
      default: >
        open('C:/Users/utiud/Documents/My Received Files/petClinic.war', 'rb').read()
      override: true
   - contentType:
      default: "'application/octet-stream'"
      override: true
   - username:
      default: "'admin'"
      required: false
   - password:
      default: "'password'"
      required: false
   - method:
      default: "'put'"
      override: true
 action:
   java_action:
     className: org.openscore.content.httpclient.HttpClientAction
     methodName: execute
 outputs:
   - returnResult
   - statusCode: statusCode
   - errorMessage: returnResult if statusCode != '201' else ''
 results:
   - SUCCESS : statusCode == '201'
   - FAILURE

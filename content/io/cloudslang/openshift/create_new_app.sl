#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Creates an application in Helion Development Platform / openshift
# NOTE: This is experimental and while the app is created it cannot run yet
# WIP
#
# Inputs:
#   - host - Helion Development Platform / openshift host
#   - token - HDP / openshift authorisation token
#   - name - Name of the application to create
#   - space_guid - GUID of the HDP / openshift space to deploy to
#   - proxy_host - optional - proxy server used to access the web site - Default: none
#   - proxy_port - optional - proxy server port - Default: none
# Outputs:
#   - return_result - response of the operation
#   - status_code - normal status code is 202
#   - error_message: returnResult if statusCode != '202'
# Results:
#   - SUCCESS - operation succeeded (statusCode == '202')
#   - FAILURE - otherwise
####################################################
#####################################################
# Create OpenShift Application
#
# Inputs:
#   - cartridgeName - OpenShift machine host; can be any machine from the cluster
#   - restUrl - optional - path to the private key file
#   - username - OpenShift machine username
#   - password - optional - OpenShift machine password; can be empty since OpenShift machines use private key file authentication
# Outputs:
#   - cartbridgeName: cartbridgeName
#####################################################

namespace: io.cloudslang.openshift

imports:
  print: io.cloudslang.base.print

operation:
  name: create_new_app
  inputs:
    - cartridgeName:
        default: "'jbosseap'"
    - applicationName:
        default: "'mbeApp'"
    - host:
        default: "'openshift.redhat.com'"
    - username:
        default: "'bettan.michael@gmail.com'"
    - password:
        default: "'HP1nvent'"
    - url:
        default: "'https://' + host + '/broker/rest/domain/mbe0042/applications'"
        overridable: false
    - body:
        default: >
          '{ "name": "' + applicationName + '" , "cartridges": "' + cartridgeName +
          '"}'
        overridable: false
    - contentType:
        default: "'application/json'"
        overridable: false
    - trustAllRoots:
        default: "'true'"
    - method:
        default: "'post'"
        overridable: false
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxyHost:
        default: "proxy_host if proxy_host else ''"
        overridable: false
    - proxyPort:
        default: "proxy_port if proxy_port else ''"
        overridable: false
  action:
    java_action:
      className: io.cloudslang.content.httpclient.HttpClientAction
      methodName: execute
  outputs:
    - return_result: returnResult
    - status_code: "'' if 'statusCode' not in locals() else statusCode"
    - error_message: returnResult if 'statusCode' not in locals() or statusCode != '201' else ''

  results:
    - SUCCESS: "'statusCode' in locals() and statusCode == '201'"
    - FAILURE
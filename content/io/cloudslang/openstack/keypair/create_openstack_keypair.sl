#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Creates an OpenStack keypair for the instance
#
# Inputs:
#   - host - OpenStack machine host
#   - compute_port - optional - port used for OpenStack computations - Default: 8774
#   - token - OpenStack token obtained after authentication
#   - tenant_id - OpenStack tenant id obtained after authentication
#   - keypair_name - name of the keypair that will be created
#   - proxy_host - optional - proxy server used to access the web site - Default: none
#   - proxy_port - optional - proxy server port - Default: none
#   - public_key - optional - public ssh key to import. If not provided, a key is generated
# Outputs:
#   - return_result - response of the operation
#   - status_code - normal status code is 200
#   - error_message: returnResult if statusCode != '200'
# Results:
#   - SUCCESS - operation succeeded (statusCode == '200')
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.openstack.keypair

operation:
  name: create_openstack_keypair
  inputs:
    - host
    - compute_port:
        default: "'8774'"
    - token
    - tenant_id
    - keypair_name
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
    - public_key:
        required: false
    - public_key_expression:
        default: "', \"public_key\": \"' + public_key + '\" }}' if public_key else ' }}'"
        overridable: false
    - headers:
        default: "'X-AUTH-TOKEN:' + token"
        overridable: false
    - url:
        default: "'http://' + host + ':' + compute_port + '/v2/' + tenant_id + '/os-keypairs'"
        overridable: false
    - body:
        default: >
          '{"keypair": { "name": "' + keypair_name + '\"' + public_key_expression
        overridable: false
    - contentType:
        default: "'application/json'"
        overridable: false
    - method:
        default: "'post'"
        overridable: false
  action:
    java_action:
      className: io.cloudslang.content.httpclient.HttpClientAction
      methodName: execute
  outputs:
    - return_result: returnResult
    - status_code: "'' if 'statusCode' not in locals() else statusCode"
    - error_message: returnResult if 'statusCode' not in locals() or statusCode != '200' else ''

  results:
    - SUCCESS: "'statusCode' in locals() and statusCode == '200'"
    - FAILURE
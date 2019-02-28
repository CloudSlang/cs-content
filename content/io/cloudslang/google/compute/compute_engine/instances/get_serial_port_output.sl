#   (c) Copyright 2019 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: This operation can be used to retrieve data from a port.
#!
#! @input project_id: Google Cloud project name.
#!                    Example: 'example-project-a'
#! @input zone: The name of the zone in which the instance lives.
#!              Examples: 'us-central1-a', 'us-central1-b', 'us-central1-c'
#! @input instance_name: Name of the Instance resource to get.
#!                       Example: 'operation-1234'
#! @input console_port: Specifies which COM or serial port to retrieve data from.
#!                      Valid: an integer between 1 and 4 (inclusive)
#!                      Default: '1'
#!                      Optional
#! @input start_index: The byte position from which to return the output. Use this to page through output
#!                     when the output is too large to return in a single request. For the initial request, leave
#!                     this field unspecified. For subsequent calls, this field should be set to the next value
#!                     returned in the previous call.
#!                     Default: '0'
#!                     Optional
#! @input access_token: The access token from get_access_token.
#! @input proxy_host: Proxy server used to access the provider services.
#!                    Optional
#! @input proxy_port: Proxy server port used to access the provider services.
#!                    Default: '8080'
#!                    Optional
#! @input proxy_username: Proxy server user name.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the <proxy_username> input value.
#!                        Optional
#! @input pretty_print: Whether to format the resulting JSON.
#!                      Valid: 'true', 'false'
#!                      Default: 'true'
#!                      Optional
#!
#! @output return_result: A string containing the read data from the port.
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise.
#! @output exception: Exception if there was an error when executing, empty otherwise.
#! @output next_index: The position of the last byte read.
#!
#! @result SUCCESS: The Instance was found and successfully retrieved.
#! @result FAILURE: The Instance was not found or some inputs were given incorrectly
#!
#!!#
########################################################################################################################

namespace: io.cloudslang.google.compute.compute_engine.instances

operation:
  name: get_serial_port_output

  inputs:
    - project_id
    - projectId:
        default: ${get('project_id', '')}
        required: false
        private: true
    - zone
    - instance_name
    - instanceName:
        default: ${get('instance_name', '')}
        required: false
        private: true
    - console_port:
        default: '1'
        required: false
    - consolePort:
        default: ${get('console_port', '')}
        required: false
        private: true
    - start_index:
        default: '0'
        required: false
    - startIndex:
        default: ${get('start_index', '')}
        required: false
        private: true
    - access_token:
        sensitive: true
    - accessToken:
        default: ${get('access_token', '')}
        required: false
        private: true
        sensitive: true
    - proxy_host:
        default: ''
        required: false
    - proxyHost:
        default: ${get('proxy_host', '')}
        required: false
        private: true
    - proxy_port:
        default: '8080'
        required: false
    - proxyPort:
        default: ${get('proxy_port', '')}
        required: false
        private: true
    - proxy_username:
        default: ''
        required: false
    - proxyUsername:
        default: ${get('proxy_username', '')}
        required: false
        private: true
    - proxy_password:
        default: ''
        required: false
        sensitive: true
    - proxyPassword:
        default: ${get('proxy_password', '')}
        required: false
        private: true
        sensitive: true

  java_action:
    gav: 'io.cloudslang.content:cs-google:0.4.2'
    class_name: io.cloudslang.content.google.actions.compute.compute_engine.instances.InstancesGetSerialPortOutput
    method_name: execute

  outputs:
    - return_code: ${returnCode}
    - return_result: ${returnResult}
    - exception: ${get('exception', '')}
    - next_index: ${get('nextIndex', '')}

  results:
    - SUCCESS: ${returnCode=='0'}
    - FAILURE

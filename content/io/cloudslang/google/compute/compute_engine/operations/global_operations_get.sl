#   (c) Copyright 2023 Open Text
#   This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: This operation can be used to retrieve a GlobalOperation resource, as JSON object.
#!
#! @input project_id: Google Cloud project name.
#!                    Example: 'example-project-a'
#! @input global_operation_name: Name of the GlobalOperation resource to return.
#!                             Example: 'operation-1234'
#! @input access_token: The access token returned by the get_access_token operation, with at least one of the following
#!                      scopes: 'https://www.googleapis.com/auth/compute.readonly',
#!                              'https://www.googleapis.com/auth/compute',
#!                              'https://www.googleapis.com/auth/cloud-platform'.
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
#! @output return_result: Contains the GlobalOperation resource, as a JSON object.
#! @output status: The status of the GlobalOperation resource: 'PENDING', 'RUNNING' or 'DONE'.
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise.
#! @output exception: Exception if there was an error when executing, empty otherwise.
#!
#! @result SUCCESS: The GlobalOperation resource has been successfully retrieved.
#! @result FAILURE: An error occurred while trying to get the GlobalOperation resource.
#!!#
########################################################################################################################

namespace: io.cloudslang.google.compute.compute_engine.operations

operation:
  name: global_operations_get

  inputs:
    - project_id
    - projectId:
        default: ${get('project_id', '')}
        required: false
        private: true
    - global_operation_name:
        default: ''
        required: false
    - globalOperationName:
        default: ${get('global_operation_name', '')}
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
    - pretty_print:
        default: 'true'
        required: false
    - prettyPrint:
        default: ${get('pretty_print', '')}
        required: false
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-google:0.4.11'
    class_name: io.cloudslang.content.google.actions.compute.compute_engine.operations.GlobalOperationsGet
    method_name: execute

  outputs:
    - return_code: ${returnCode}
    - status: ${status}
    - return_result: ${returnResult}
    - exception: ${get('exception', '')}

  results:
    - SUCCESS: ${returnCode=='0'}
    - FAILURE

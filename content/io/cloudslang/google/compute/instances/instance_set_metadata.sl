#   (c) Copyright 2017 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Sets metadata for the specified instance to the data provided to the operation. Can be used as a delete
#!               metadata as well.
#!               Note: 1) The total size of all metadata (keys and values) must be less than 512 KB.
#!                     2) For more information see:
#!                     https://cloud.google.com/compute/docs/reference/latest/instances/setMetadata
#!
#! @input project_id: Name of the Google Cloud project.
#!                    Example: my-project-123456
#! @input zone: Name of the zone for this request.
#!              Example: us-central1-c
#! @input instance_name: Name of the instance scoping this request as seen in the google cloud console
#!                       Example: https://console.cloud.google.com/compute/instances?project=my-project-123456
#! @input access_token: You can retrieve this access token using get_access_token operation.
#!                      This request requires authorization with at least one of the following scopes:
#!                      https://www.googleapis.com/auth/compute, https://www.googleapis.com/auth/cloud-platform
#! @input items_keys_list: Key for the metadata entry. Keys must conform to the following regexp: [a-zA-Z0-9-_]+, and be
#!                         less than 128 bytes in length. This is reflected as part of a URL in the metadata server.
#!                         Additionally, to avoid ambiguity, keys must not conflict with any other metadata keys for the
#!                         project.
#!                         The length of the items_keys_list must be equal with the length of the items_values_list.
#!                         Default: ''
#!                         Optional
#! @input items_values_list: Value for the metadata entry. These are free-form strings, and only have meaning as
#!                           interpreted by the image running in the instance. The only restriction placed on values is
#!                           that their size must be less than or equal to 32768 bytes.
#!                           The length of the items_keys_list must be equal with the length of the items_values_list.
#!                           Default: ''
#!                           Optional
#! @input scopes_delimiter: The delimiter to split the items_keys_list and items_values_list
#!                          Default: ','
#!                          Optional
#! @input proxy_host: Proxy server used to access the provider services
#!                    Default: ''
#!                    Optional
#! @input proxy_port: Proxy server port used to access the provider services
#!                    Default: '80'
#!                    Optional
#! @input proxy_username: Proxy server user name.
#!                        Default: ''
#!                        Optional
#! @input proxy_password: Proxy server password associated with the proxy_username input value.
#!                        Default: ''
#!                        Optional
#! @input pretty_print: Specify if you want to stylistic format the return result.
#!                      Default: 'true'
#!                      Optional
#!
#! @output return_result: Json result of the operation in case the operation executed, error message otherwise.
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise.
#! @output exception: Error message (stacktrace) if there was an error when executing, empty otherwise.
#!
#! @result SUCCESS: The operation executed successfully and the 'return_code' is 0.
#! @result FAILURE: The operation could not be executed or the value of the 'return_code' is different than 0.
#!!#
########################################################################################################################

namespace: io.cloudslang.content.google.compute.instances

operation:
  name: instance_set_metadata

  inputs:
    - project_id
    - projectId:
        default: ${get("project_id", "")}
        required: false
        private: true
    - zone
    - instance_name
    - instanceName:
        default: ${get("instance_name", "")}
        required: false
        private: true
    - access_token:
        sensitive: true
    - accessToken:
        default: ${get("access_token", "")}
        required: false
        private: true
        sensitive: true
    - items_keys_list:
        default: ''
        required: false
    - itemsKeysList:
        default: ${get("items_keys_list", "")}
        required: false
        private: true
    - items_values_list:
        default: ''
        required: false
    - itemsValuesList:
        default: ${get("items_values_list", "")}
        required: false
        private: true
    - scopes_delimiter:
        default: ','
        required: false
    - scopesDelimiter:
        default: ${get("scopes_delimiter", "")}
        required: false
        private: true
    - proxy_host:
        default: ''
        required: false
    - proxyHost:
        default: ${get("proxy_host", "")}
        required: false
        private: true
    - proxy_port:
        default: '80'
        required: false
    - proxyPort:
        default: ${get("proxy_port", "")}
        required: false
        private: true
    - proxy_username:
        default: ''
        required: false
    - proxyUsername:
        default: ${get("proxy_username", "")}
        required: false
        private: true
    - proxy_password:
        default: ''
        required: false
        sensitive: true
    - proxyPassword:
        default: ${get("proxy_password", "")}
        required: false
        private: true
        sensitive: true
    - pretty_print:
        default: 'true'
        required: false
    - prettyPrint:
        default: ${get("pretty_print", "")}
        required: false
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-google-cloud:0.0.1'
    class_name: io.cloudslang.content.gcloud.actions.compute.instances.InstanceSetMetadata
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${get("exception", "")}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE
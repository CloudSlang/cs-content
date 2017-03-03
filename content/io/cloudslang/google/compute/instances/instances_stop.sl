#   (c) Copyright 2017 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Stops a Virtual Machine instance.
#!               For more information see: https://cloud.google.com/compute/docs/instances/
#!
#! @input project_id: Name of the Google Cloud project.
#!                    Example: 'my-project-123456'
#! @input zone: Name of the zone for this request.
#!              Example: 'us-central1-c'
#! @input instance_name: Name of the instance scoping this request as seen in the google cloud console
#!                       Example: 'https://console.cloud.google.com/compute/instances?project=my-project-123456'
#! @input access_token: The access token returned by the get_access_token operation, with at least one of the following
#!                      scopes: 'https://www.googleapis.com/auth/compute',
#!                              'https://www.googleapis.com/auth/cloud-platform'
#! @input proxy_host: Proxy server used to access the provider services
#!                    Default: ''
#!                    Optional
#! @input proxy_port: Proxy server port used to access the provider services
#!                    Default: '8080'
#!                    Optional
#! @input proxy_username: Proxy server user name.
#!                        Default: ''
#!                        Optional
#! @input proxy_password: Proxy server password associated with the proxy_username input value.
#!                        Default: ''
#!                        Optional
#! @input pretty_print: Whether to format the resulting JSON.
#!                      Default: 'true'
#!                      Optional
#!
#! @output zone_operation_name: Name of the launched ZoneOperation. Use this with the zone_operations_get operation to
#!                              get the status of the ZoneOperation.
#! @output return_result: Json result of the operation in case the operation executed, error message otherwise.
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise.
#! @output exception: Error message (stacktrace) if there was an error when executing, empty otherwise.
#!
#! @result SUCCESS: The operation executed successfully and the 'return_code' is 0.
#! @result FAILURE: The operation could not be executed or the value of the 'return_code' is different than 0.
#!!#
########################################################################################################################

namespace: io.cloudslang.google.compute.instances

operation:
  name: instances_stop

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
    - proxy_host:
        default: ''
        required: false
    - proxyHost:
        default: ${get("proxy_host", "")}
        required: false
        private: true
    - proxy_port:
        default: '8080'
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
    class_name: io.cloudslang.content.gcloud.actions.compute.instances.InstancesStop
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${get("exception", "")}
    - zone_operation_name: ${get("zoneOperationName", "")}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE
#   (c) Copyright 2017 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: This operation can be used to delete an Instance resource. The operation returns a ZoneOperation
#!               resource as a JSON object and its name, that can be used to retrieve the status and progress of the
#!               ZoneOperation, using the zone_operations_get operation.
#!
#! @input project_id: Google Cloud project name.
#!                    Example: 'example-project-a'
#! @input zone: The name of the zone in which the instance lives.
#!              Examples: 'us-central1-a', 'us-central1-b', 'us-central1-c'
#! @input instance_name: Name of the Instance resource to delete.
#!                       Example: 'instance-1234'
#! @input access_token: The access token returned by the get_access_token operation, with at least one of the following
#!                      scopes: 'https://www.googleapis.com/auth/compute.readonly',
#!                              'https://www.googleapis.com/auth/compute',
#!                              'https://www.googleapis.com/auth/cloud-platform'.
#! @input proxy_host: Proxy server used to access the provider services.
#!                    Default: ''
#!                    Optional
#! @input proxy_port: Proxy server port used to access the provider services.
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
#! @output return_result: Contains the ZoneOperation resource, as a JSON object.
#! @output zone_operation_name: Contains the ZoneOperation name, if the returnCode is '0', otherwise it is empty.
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise.
#! @output exception: Exception if there was an error when executing, empty otherwise.
#!
#! @result SUCCESS: The Instance resource has been successfully marked for deletion.
#! @result FAILURE: An error occurred while trying to delete the Instance resource.
#!!#
########################################################################################################################

namespace: io.cloudslang.google.compute.utils

operation:
  name: instances_delete

  inputs:
    - project_id:
        sensitive: true
    - projectId:
        default: ${get('project_id', '')}
        required: false
        private: true
        sensitive: true
    - zone
    - instance_name:
        default: ""
        required: false
    - instanceName:
        default: ${get('instance_name', '')}
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
    gav: 'io.cloudslang.content:cs-google-cloud:0.0.1'
    class_name: io.cloudslang.content.gcloud.actions.compute.instances.InstancesGet
    method_name: execute

  outputs:
    - return_code: ${returnCode}
    - zone_operation_name: ${get('zoneOperationName'), '')}
    - return_result: ${returnResult}
    - exception: ${get('exception', '')}

  results:
    - SUCCESS: ${returnCode=='0'}
    - FAILURE

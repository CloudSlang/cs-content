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
#!
#! @input project_id: Google Cloud project name.
#!                    Example: 'example-project-a'
#! @input zone: The name of the zone in which the instance lives.
#!              Examples: 'us-central1-a', 'us-central1-b', 'us-central1-c'
#! @input instance_name: Name of the Instance resource to set the metadata to.
#!                       Example: 'operation-1234'
#! @input access_token: The access token from get_access_token.
#! @input items_keys_list: key for the metadata entry. Keys must conform to the following regexp: [a-zA-Z0-9-_]+,
#!                         and be less than 128 bytes in length. This is reflected as part of a URL in the metadata
#!                         server. Additionally, to avoid ambiguity, keys must not conflict with any other metadata
#!                         keys for the project. The length of the itemsKeysList must be equal with the length of
#!                         the itemsValuesList.
#!                         Optional
#! @input items_values_list: value for the metadata entry. These are free-form strings, and only have meaning as
#!                           interpreted by the image running in the instance. The only restriction placed on values
#!                           is that their size must be less than or equal to 32768 bytes. The length of the
#!                           itemsKeysList must be equal with the length of the itemsValuesList.
#!                           Optional
#! @input items_delimiter: The delimiter to split the <items_keys_list> and <items_values_list>
#!                         Default: ','
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
#! @output return_result: Contains the ZoneOperation resource, as a JSON object.
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise.
#! @output exception: Exception if there was an error when executing, empty otherwise.
#! @output zone_operation_name: Contains the ZoneOperation name, if the returnCode is '0', otherwise it is empty.
#!
#! @result SUCCESS: The request to set the Instance metadata was successfully sent.
#! @result FAILURE: An error occurred while trying to send the request.
#!
#!!#
########################################################################################################################

namespace: io.cloudslang.google.compute.compute_engine.instances

operation:
  name: set_instance_metadata

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
    - access_token:
        sensitive: true
    - accessToken:
        default: ${get('access_token', '')}
        required: false
        private: true
        sensitive: true
    - items_keys_list:
        default: ''
        required: false
    - itemsKeysList:
        default: ${get('items_keys_list', '')}
        required: false
        private: true
    - items_values_list:
        default: ''
        required: false
    - itemsValuesList:
        default: ${get('items_values_list', '')}
        required: false
        private: true
    - items_delimiter:
        default: ','
        required: false
    - itemsDelimiter:
        default: ${get('items_delimiter', '')}
        required: false
        private: true
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
    gav: 'io.cloudslang.content:cs-google:0.2.1'
    class_name: io.cloudslang.content.google.actions.compute.compute_engine.instances.InstancesSetMetadata
    method_name: execute

  outputs:
    - return_code: ${returnCode}
    - return_result: ${returnResult}
    - exception: ${get('exception', '')}
    - zone_operation_name: ${zoneOperationName}

  results:
    - SUCCESS: ${returnCode=='0'}
    - FAILURE

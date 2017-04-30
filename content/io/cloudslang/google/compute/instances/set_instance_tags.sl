#   (c) Copyright 2017 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: This operation can be used to set tags for an Instance resource. The operation returns a ZoneOperation resource
#!               as a JSON object, that can be used to retrieve the status and progress of the ZoneOperation, using the
#!               ZoneOperationsGet operation.
#!
#! @input project_id: Google Cloud project name.
#!                    Example: 'example-project-a'
#! @input zone: The name of the zone in which the instance lives.
#!              Examples: 'us-central1-a', 'us-central1-b', 'us-central1-c'
#! @input instance_name: Name of the Instance resource to set the tags to.
#!                      Example: 'operation-1234'
#! @input tags_list: List of tags to be set on the instance, separated by the <tags_delimiter> delimiter
#! @input tags_delimiter: Delimiter used for the list of tags from <tags_list> param.
#!                        Default: ','
#! @input access_token: The access token from get_access_token.
#! @input proxy_host: Optional - Proxy server used to access the provider services.
#! @input proxy_port: Optional - Proxy server port used to access the provider services.
#!                    Default: '8080'
#! @input proxy_username: Optional - Proxy server user name.
#! @input proxy_password: Optional - Proxy server password associated with the <proxy_username> input value.
#! @input pretty_print: Optional - Whether to format the resulting JSON.
#!                      Valid values: 'true', 'false'
#!                      Default: 'true'
#!
#! @output return_code: Generated description
#! @output return_result: Generated description
#! @output exception: Generated description
#! @output zone_operation_name: Generated description
#!
#! @result SUCCESS: Generated description
#! @result FAILURE: Generated description
#!!#
########################################################################################################################

namespace: io.cloudslang.google.compute.instances
operation:
  name: set_instance_tags
  inputs:
    - project_id:
        private: false
        sensitive: false
        required: true
    - projectId:
        default: ${get('project_id', '')}
        private: true
        sensitive: false
        required: false
    - zone:
        private: false
        sensitive: false
        required: true
    - instance_name:
        private: false
        sensitive: false
        required: true
    - instanceName:
        default: ${get('instance_name', '')}
        private: true
        sensitive: false
        required: false
    - tags_list:
        private: false
        sensitive: false
        required: false
    - tagsList:
        default: ${get('tags_list', '')}
        private: true
        sensitive: false
        required: false
    - tags_delimiter:
        private: false
        sensitive: false
        required: false
    - tagsDelimiter:
        default: ${get('tags_delimiter', '')}
        private: true
        sensitive: false
        required: false
    - access_token:
        private: false
        sensitive: true
        required: true
    - accessToken:
        default: ${get('access_token', '')}
        private: true
        sensitive: true
        required: false
    - proxy_host:
        private: false
        sensitive: false
        required: false
    - proxyHost:
        default: ${get('proxy_host', '')}
        private: true
        sensitive: false
        required: false
    - proxy_port:
        private: false
        sensitive: false
        required: false
    - proxyPort:
        default: ${get('proxy_port', '')}
        private: true
        sensitive: false
        required: false
    - proxy_username:
        private: false
        sensitive: false
        required: false
    - proxyUsername:
        default: ${get('proxy_username', '')}
        private: true
        sensitive: false
        required: false
    - proxy_password:
        private: false
        sensitive: true
        required: false
    - proxyPassword:
        default: ${get('proxy_password', '')}
        private: true
        sensitive: true
        required: false
    - pretty_print:
        private: false
        sensitive: false
        required: false
    - prettyPrint:
        default: ${get('pretty_print', '')}
        private: true
        sensitive: false
        required: false

  java_action:
    gav: 'io.cloudslang.content:cs-google-cloud:0.0.1'
    method_name: execute
    class_name: io.cloudslang.content.gcloud.actions.compute.instances.InstancesSetTags

  outputs:
    - return_code: ${returnCode}
    - return_result: ${returnResult}
    - exception: ${get('exception', '')}
    - zone_operation_name: ${zoneOperationName}

  results:
    - SUCCESS: ${returnCode=='0'}
    - FAILURE

#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Adds or overwrites one or more tags for the specified Amazon EC2 resource/resources.
#!               Note: Each resource can have a maximum of 10 tags. Each tag consists of a key and optional value. Tag
#!               keys must be unique per resource. For more information about tags, see Tagging Your Resources in the
#!               Amazon Elastic Compute Cloud User Guide. For more information about creating IAM policies that control
#!               users access to resources based on tags, see Supported Resource-Level Permissions for Amazon EC2 API
#!               Actions in the Amazon Elastic Compute Cloud User Guide.
#! @input provider: Cloud provider on which you have the resources - Default: 'amazon'
#! @input endpoint: Endpoint to which the request will be sent - Default: 'https://ec2.amazonaws.com'
#! @input identity: optional - Amazon Access Key ID
#! @input credential: optional - Amazon Secret Access Key that corresponds to the Amazon Access Key ID
#! @input proxy_host: optional - Proxy server used to access the provider services
#! @input proxy_port: optional - Proxy server port used to access the provider services - Default: '8080'
#! @input delimiter: optional - Delimiter that will be used - Default: ','
#! @input debug_mode: optional - If 'true' then the execution logs will be shown in CLI console - Default: 'false'
#! @input region: optional - Region where volume belongs. Ex: 'RegionOne', 'us-east-1'. ListRegionAction can be used in
#!                           order to get all regions - Default: 'us-east-1'
#! @input key_tags_string: String that contains one or more key tags separated by delimiter.
#! @input value_tags_string: String that contains one or more tag values separated by delimiter.
#! @input resource_ids_string: String that contains Id's of one or more resources to tag.
#!                             Ex: "ami-1a2b3c4d"
#! @output return_result: contains the exception in case of failure, success message otherwise
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise
#! @output error_message: error message if there was an error when executing, empty otherwise
#! @result SUCCESS: success message
#! @result FAILURE: an error occurred when trying to apply tags to resources
#!!#
####################################################
namespace: io.cloudslang.cloud.amazon_aws.tags

operation:
  name: apply_to_resources

  inputs:
    - provider: 'amazon'
    - endpoint: 'https://ec2.amazonaws.com'
    - identity:
        required: false
        sensitive: true
    - credential:
        required: false
        sensitive: true
    - proxy_host:
        required: false
    - proxyHost:
        default: ${get("proxy_host", "")}
        private: true
        required: false
    - proxy_port:
        required: false
    - proxyPort:
        default: ${get("proxy_port", "8080")}
        private: true
    - delimiter:
        default: ','
        required: false
    - debug_mode:
        required: false
    - debugMode:
        default: ${get("debug_mode", "false")}
        private: true
    - region:
        default: 'us-east-1'
        required: false
    - key_tags_string
    - keyTagsString:
        default: ${key_tags_string}
        private: true
    - value_tags_string
    - valueTagsString:
        default: ${value_tags_string}
        private: true
    - resource_ids_string
    - resourceIdsString:
        default: ${resource_ids_string}
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-jClouds:0.0.6'
    class_name: io.cloudslang.content.jclouds.actions.tags.ApplyToResourcesAction
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${get("exception", "")}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE
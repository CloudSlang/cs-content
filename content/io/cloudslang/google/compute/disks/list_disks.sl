#   (c) Copyright 2017 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: This operation can be used to retrieve the list of Disk resources, as JSON array.
#!
#! @input project_id: Google Cloud project name.
#!                    Example: 'example-project-a'
#! @input zone: The name of the zone in which the instance lives.
#!              Examples: 'us-central1-a', 'us-central1-b', 'us-central1-c'
#! @input access_token: The access token from get_access_token.
#! @input filter: Optional - Sets a filter expression for filtering listed resources, in the form filter={expression}.
#!                Your {expression} must be in the format: field_name comparison_string literal_string.
#!                The field_name is the name of the field you want to compare. Only atomic field types are
#!                supported (string, number, boolean). The comparison_string must be either eq (equals) or ne
#!                (not equals). The literal_string is the string value to filter to. The literal value must
#!                be valid for the type of field you are filtering by (string, number, boolean). For string
#!                fields, the literal value is interpreted as a regular expression using RE2 syntax. The
#!                literal value must match the entire field.
#!                For example, to filter for instances that do not have a name of example-instance, you would
#!                use filter=name ne example-instance.
#!                You can filter on nested fields. For example, you could filter on instances that have set
#!                the scheduling.automaticRestart field to true. Use filtering on nested fields to take
#!                advantage of labels to organize and search for results based on label values.
#!                To filter on multiple expressions, provide each separate expression within parentheses. For
#!                example, (scheduling.automaticRestart eq true) (zone eq us-central1-f). Multiple
#!                expressions are treated as AND expressions, meaning that resources must match all
#!                expressions to pass the filters.
#! @input order_by: Optional - Sorts list results by a certain order. By default, results are returned in alphanumerical
#!                  order based on the resource name.
#!                  You can also sort results in descending order based on the creation timestamp using
#!                  orderBy='creationTimestamp desc'. This sorts results based on the creationTimestamp field
#!                  in reverse chronological order (newest result first). Use this to sort resources like
#!                  operations so that the newest operation is returned first.
#!                  Currently, only sorting by name or creationTimestamp desc is supported.
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
#!
#! @result SUCCESS: Generated description
#! @result FAILURE: Generated description
#!!#
########################################################################################################################

namespace: io.cloudslang.google.compute.disks
operation:
  name: list_disks
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
    - access_token:
        private: false
        sensitive: true
        required: true
    - accessToken:
        default: ${get('access_token', '')}
        private: true
        sensitive: true
        required: false
    - filter:
        private: false
        sensitive: false
        required: false
    - order_by:
        private: false
        sensitive: false
        required: false
    - orderBy:
        default: ${get('order_by', '')}
        private: true
        sensitive: false
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
    class_name: io.cloudslang.content.gcloud.actions.compute.disks.DisksList

  outputs:
    - return_code: ${returnCode}
    - return_result: ${returnResult}
    - exception: ${get('exception', '')}

  results:
    - SUCCESS: ${returnCode=='0'}
    - FAILURE

#   (c) Copyright 2017 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Creates a disk resource in the specified project using the data included as inputs.
#!
#! @input project_id: Google Cloud project name.
#!                    Example: 'example-project-a'
#! @input access_token: The access token from get_access_token.
#! @input network_name: Name of the Network. Provided by the client when the Network is created. The name must be
#!                      1-63 characters long, and comply with RFC1035. Specifically, the name must be 1-63 characters
#!                      long and match the regular expression [a-z]([-a-z0-9]*[a-z0-9])? which means the first
#!                      character must be a lowercase letter, and all following characters must be a dash, lowercase
#! @input network_description: Optional - The description of the new Network
#! @input ip_v4_range: Optional - The range of internal addresses that are legal on this network. This range
#!                                is a CIDR specification, for example: 192.168.0.0/16. Provided by the client when the
#!                                network is created.
#! @input auto_create_subnetworks: Optional - When set to true, the network is created in 'auto subnet mode'. When set to false, the network
#!                                 is in 'custom subnet mode'.
#!                                 In 'auto subnet mode', a newly created network is assigned the default CIDR of 10.128.0.0/9 and
#!                                 it automatically creates one subnetwork per region.
#!                                 Note: If <ipV4RangeInp> is set, then this input is ignored
#! @input proxy_host: Optional - Proxy server used to access the provider services.
#! @input proxy_port: Optional - Proxy server port used to access the provider services.
#!                    Default: '8080'
#! @input proxy_username: Optional - Proxy server user name.
#! @input proxy_password: Optional - Proxy server password associated with the <proxy_username> input value.
#! @input pretty_print: Optional - Whether to format the resulting JSON.
#!                      Valid values: 'true', 'false'
#!                      Default: 'true'
#!
#! @output return_result: Contains the ZoneOperation resource, as a JSON object.
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise.
#! @output exception: Exception if there was an error when executing, empty otherwise.
#! @output zone_operation_name: Contains the ZoneOperation name, if the returnCode is '0', otherwise it is empty.
#!
#! @result SUCCESS: The request for the Network to be inserted was successfully sent.
#! @result FAILURE: An error occurred while trying to send the request.
#!
#!!#
########################################################################################################################

namespace: io.cloudslang.google.compute.networks
operation:
  name: insert_network
  inputs:
    - project_id
    - projectId:
        default: ${get('project_id', '')}
        required: false
        private: true
    - access_token:
        sensitive: true
    - accessToken:
        default: ${get('access_token', '')}
        required: false
        private: true
        sensitive: true
    - network_name:
        private: false
        sensitive: false
        required: true
    - networkName:
        default: ${get('network_name', '')}
        private: true
        sensitive: false
        required: false
    - network_description:
        private: false
        sensitive: false
        required: false
    - networkDescription:
        default: ${get('network_description', '')}
        private: true
        sensitive: false
        required: false
    - auto_create_subnetworks:
        private: false
        sensitive: false
        required: false
    - autoCreateSubnetworks:
        default: ${get('auto_create_subnetworks', '')}
        private: true
        sensitive: false
        required: false
    - ip_v4_range:
        private: false
        sensitive: false
        required: false
    - ipV4Range:
        default: ${get('ip_v_4_range', '')}
        private: true
        sensitive: false
        required: false
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
    method_name: execute
    class_name: io.cloudslang.content.gcloud.actions.compute.networks.NetworksInsert

  outputs:
    - return_code: ${returnCode}
    - return_result: ${returnResult}
    - exception: ${get('exception', '')}
    - zone_operation_name: ${zoneOperationName}

  results:
    - SUCCESS: ${returnCode=='0'}
    - FAILURE

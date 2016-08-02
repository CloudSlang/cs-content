#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Performs a health check on an OpenStack machine.
#!               Creates a server, checks it is up and then deletes it.
#!               If any steps fail it will send an email with an error report.
#! @input host: OpenStack machine host
#! @input identity_port: optional - port used for OpenStack authentication
#! @input compute_port: optional - port used for OpenStack computations
#! @input network_id: optional - ID of private network
#! @input server_name: optional - server name - Default: 'test-server'
#! @input img_ref: image reference of the server to be created
#! @input username: OpenStack username
#! @input password: OpenStack password
#! @input tenant_name: name of project on OpenStack
#! @input proxy_host: optional - proxy server used to access web site
#! @input proxy_port: optional - proxy server port
#! @input email_host: email host
#! @input email_port: email port
#! @input to: email recipient
#! @input from: email sender
#! @input uuid: uuid of the image to boot from - Example: 'b67f9da0-4a89-4588-b0f5-bf4d1940174'
#! @result SUCCESS:
#! @result CREATE_SERVER_FAILURE:
#! @result GET_AUTHENTICATION_TOKEN_FAILURE:
#! @result GET_TENANT_ID_FAILURE:
#! @result GET_AUTHENTICATION_FAILURE:
#! @result GET_SERVERS_FAILURE:
#! @result EXTRACT_SERVERS_FAILURE:
#! @result CHECK_SERVER_FAILURE:
#! @result SEND_EMAIL_FAILURE:
#! @result FAILURE:
#!!#
####################################################

namespace: io.cloudslang.cloud.openstack

imports:
  email: io.cloudslang.base.mail
  openstack: io.cloudslang.cloud.openstack
  servers: io.cloudslang.cloud.openstack.servers

flow:
  name: openstack_health_check
  inputs:
    - host
    - identity_port:
        required: false
    - compute_port:
        required: false
    - network_id:
        required: false
    - server_name: 'test-server'
    - img_ref
    - username
    - password:
        sensitive: true
    - tenant_name
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - email_host
    - email_port
    - to
    - from
    - uuid

  workflow:
    - create_server:
        do:
          servers.create_server_flow:
            - host
            - identity_port
            - compute_port
            - network_id
            - img_ref
            - username
            - password
            - tenant_name
            - server_name
            - proxy_host
            - proxy_port
            - uuid
        publish:
          - subflow_error: >
              ${'"Create Server": ' + error_message}
        navigate:
          - SUCCESS: validate_server_exists
          - GET_AUTHENTICATION_TOKEN_FAILURE: GET_AUTHENTICATION_TOKEN_FAILURE
          - GET_TENANT_ID_FAILURE: GET_TENANT_ID_FAILURE
          - GET_AUTHENTICATION_FAILURE: GET_AUTHENTICATION_FAILURE
          - ADD_NAME_FAILURE: ADD_NAME_FAILURE
          - ADD_IMG_REF_FAILURE: ADD_IMG_REF_FAILURE
          - ADD_FLAVOR_REF_FAILURE: ADD_FLAVOR_REF_FAILURE
          - ADD_AVAILABILITY_ZONE_FAILURE: ADD_AVAILABILITY_ZONE_FAILURE
          - ADD_KEY_NAME_FAILURE: ADD_KEY_NAME_FAILURE
          - ADD_ADMIN_PASS_FAILURE: ADD_ADMIN_PASS_FAILURE
          - ADD_USER_DATA_FAILURE: ADD_USER_DATA_FAILURE
          - ADD_NETWORK_FAILURE: ADD_NETWORK_FAILURE
          - ADD_METADATA_FAILURE: ADD_METADATA_FAILURE
          - ADD_DEFAULT_SECURITY_GROUP_FAILURE: ADD_DEFAULT_SECURITY_GROUP_FAILURE
          - ADD_SECURITY_GROUPS_FAILURE: ADD_SECURITY_GROUPS_FAILURE
          - ADD_BOOT_INDEX_FAILURE: ADD_BOOT_INDEX_FAILURE
          - ADD_UUID_FAILURE: ADD_UUID_FAILURE
          - ADD_SOURCE_TYPE_FAILURE: ADD_SOURCE_TYPE_FAILURE
          - ADD_DELETE_ON_TERMINATION_FAILURE: ADD_DELETE_ON_TERMINATION_FAILURE
          - ADD_BLOCK_DEVICE_MAPPING_FAILURE: ADD_BLOCK_DEVICE_MAPPING_FAILURE
          - ADD_PERSONALITY_FAILURE: ADD_PERSONALITY_FAILURE
          - CREATE_SERVER_FAILURE: CREATE_SERVER_FAILURE

    - validate_server_exists:
        do:
          openstack.validate_server_exists:
            - host
            - identity_port
            - compute_port
            - username
            - password
            - tenant_name
            - server_name
            - proxy_host
            - proxy_port
        publish:
          - subflow_error: >
               ${'"Validate Server": ' + error_message}
        navigate:
          - SUCCESS: delete_server
          - GET_AUTHENTICATION_TOKEN_FAILURE: GET_AUTHENTICATION_TOKEN_FAILURE
          - GET_TENANT_ID_FAILURE: GET_TENANT_ID_FAILURE
          - GET_AUTHENTICATION_FAILURE: GET_AUTHENTICATION_FAILURE
          - GET_SERVERS_FAILURE: GET_SERVERS_FAILURE
          - EXTRACT_SERVERS_FAILURE: EXTRACT_SERVERS_FAILURE
          - CHECK_SERVER_FAILURE: CHECK_SERVER_FAILURE

    - delete_server:
        do:
          servers.delete_server_flow:
            - host
            - identity_port
            - compute_port
            - username
            - password
            - tenant_name
            - server_name
            - proxy_host
            - proxy_port
        publish:
          - subflow_error: >
               ${'"Delete Server": ' + error_message}
        navigate:
          - SUCCESS: SUCCESS
          - GET_AUTHENTICATION_TOKEN_FAILURE: FAILURE
          - GET_TENANT_ID_FAILURE: FAILURE
          - GET_AUTHENTICATION_FAILURE: FAILURE
          - GET_SERVERS_FAILURE: FAILURE
          - GET_SERVER_ID_FAILURE: FAILURE
          - DELETE_SERVER_FAILURE: FAILURE

  results:
    - SUCCESS
    - CREATE_SERVER_FAILURE
    - GET_AUTHENTICATION_TOKEN_FAILURE
    - GET_TENANT_ID_FAILURE
    - GET_AUTHENTICATION_FAILURE
    - GET_SERVERS_FAILURE
    - EXTRACT_SERVERS_FAILURE
    - CHECK_SERVER_FAILURE
    - FAILURE
    - ADD_NAME_FAILURE
    - ADD_IMG_REF_FAILURE
    - ADD_FLAVOR_REF_FAILURE
    - ADD_AVAILABILITY_ZONE_FAILURE
    - ADD_KEY_NAME_FAILURE
    - ADD_ADMIN_PASS_FAILURE
    - ADD_USER_DATA_FAILURE
    - ADD_NETWORK_FAILURE
    - ADD_METADATA_FAILURE
    - ADD_DEFAULT_SECURITY_GROUP_FAILURE
    - ADD_SECURITY_GROUPS_FAILURE
    - ADD_BOOT_INDEX_FAILURE
    - ADD_UUID_FAILURE
    - ADD_SOURCE_TYPE_FAILURE
    - ADD_DELETE_ON_TERMINATION_FAILURE
    - ADD_BLOCK_DEVICE_MAPPING_FAILURE
    - ADD_PERSONALITY_FAILURE

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

namespace: io.cloudslang.openstack

imports:
  email: io.cloudslang.base.mail

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
    - password
    - tenant_name
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - email_host
    - email_port
    - to
    - from
  workflow:
    - create_server:
        do:
          create_openstack_server_flow:
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
        publish:
          - subflow_error: >
              ${'"Create Server": ' + error_message}
        navigate:
          SUCCESS: validate_server_exists
          GET_AUTHENTICATION_TOKEN_FAILURE: GET_AUTHENTICATION_TOKEN_FAILURE
          GET_TENANT_ID_FAILURE: GET_TENANT_ID_FAILURE
          GET_AUTHENTICATION_FAILURE: GET_AUTHENTICATION_FAILURE
          CREATE_SERVER_FAILURE: CREATE_SERVER_FAILURE

    - validate_server_exists:
        do:
          validate_server_exists:
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
          SUCCESS: delete_server
          GET_AUTHENTICATION_TOKEN_FAILURE: GET_AUTHENTICATION_TOKEN_FAILURE
          GET_TENANT_ID_FAILURE: GET_TENANT_ID_FAILURE
          GET_AUTHENTICATION_FAILURE: GET_AUTHENTICATION_FAILURE
          GET_SERVERS_FAILURE: GET_SERVERS_FAILURE
          EXTRACT_SERVERS_FAILURE: EXTRACT_SERVERS_FAILURE
          CHECK_SERVER_FAILURE: CHECK_SERVER_FAILURE

    - delete_server:
        do:
          delete_openstack_server_flow:
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
          SUCCESS: SUCCESS
          GET_AUTHENTICATION_TOKEN_FAILURE: FAILURE
          GET_TENANT_ID_FAILURE: FAILURE
          GET_AUTHENTICATION_FAILURE: FAILURE
          GET_SERVERS_FAILURE: FAILURE
          GET_SERVER_ID_FAILURE: FAILURE
          DELETE_SERVER_FAILURE: FAILURE

    - on_failure:
        - send_error_mail:
            do:
              email.send_mail:
                - hostname: ${email_host}
                - port: ${email_port}
                - from
                - to
                - subject: ${'Flow failure'}
                - body: ${'Failure from step ' + subflow_error}
            navigate:
              SUCCESS: SUCCESS
              FAILURE: SEND_EMAIL_FAILURE

  results:
    - SUCCESS
    - CREATE_SERVER_FAILURE
    - GET_AUTHENTICATION_TOKEN_FAILURE
    - GET_TENANT_ID_FAILURE
    - GET_AUTHENTICATION_FAILURE
    - GET_SERVERS_FAILURE
    - EXTRACT_SERVERS_FAILURE
    - CHECK_SERVER_FAILURE
    - SEND_EMAIL_FAILURE
    - FAILURE

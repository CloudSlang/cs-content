#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Authenticates and creates an OpenStack keypair.
#
# Inputs:
#   - host - OpenStack machine host
#   - identity_port - optional - port used for OpenStack authentication - Default: 5000
#   - compute_port - optional - port used for OpenStack computations - Default: 8774
#   - username - OpenStack username
#   - password - OpenStack password
#   - tenant_name - name of the project on OpenStack
#   - keypair_name - name of the keypair that will be created
#   - public_key - optional - public ssh key to import. If not provided, a key is generated
#   - proxy_host - optional - proxy server used to access the web site - Default: none
#   - proxy_port - optional - proxy server port - Default: none
# Outputs:
#   - return_result - response of the last operation that was executed
#   - error_message - error message of the operation that failed
# Results:
#   - SUCCESS - the OpenStack keypair was created
#   - GET_AUTHENTICATION_FAILURE - the authentication call fails
#   - GET_AUTHENTICATION_TOKEN_FAILURE - the authentication token cannot be obtained from authentication call response
#   - GET_TENANT_ID_FAILURE - the tenant_id corresponding to tenant_name cannot be obtained from authentication call response
#   - CREATE_KEY_PAIR_FAILURE - the OpenStack keypair could not be created
####################################################

namespace: io.cloudslang.openstack.keypair

imports:
 openstack_content: io.cloudslang.openstack

flow:
  name: create_openstack_keypair_flow
  inputs:
    - host
    - identity_port: "'5000'"
    - compute_port: "'8774'"
    - username
    - password
    - tenant_name
    - keypair_name
    - public_key:
        required: false
    - proxy_host:
        required: false
    - proxy_port:
        required: false
  workflow:
    - authentication:
        do:
          openstack_content.get_authentication_flow:
            - host
            - identity_port
            - username
            - password
            - tenant_name
            - proxy_host
            - proxy_port
        publish:
          - token
          - tenant_id
          - return_result
          - error_message
        navigate:
          SUCCESS: create_keypair
          GET_AUTHENTICATION_TOKEN_FAILURE: GET_AUTHENTICATION_TOKEN_FAILURE
          GET_TENANT_ID_FAILURE: GET_TENANT_ID_FAILURE
          GET_AUTHENTICATION_FAILURE: GET_AUTHENTICATION_FAILURE

    - create_keypair:
        do:
          create_openstack_keypair:
            - host
            - compute_port
            - token
            - tenant_id
            - keypair_name
            - public_key
            - proxy_host
            - proxy_port
        publish:
          - return_result
          - error_message
        navigate:
          SUCCESS: SUCCESS
          FAILURE: CREATE_KEY_PAIR_FAILURE

  outputs:
    - return_result
    - error_message

  results:
    - SUCCESS
    - GET_AUTHENTICATION_TOKEN_FAILURE
    - GET_TENANT_ID_FAILURE
    - GET_AUTHENTICATION_FAILURE
    - CREATE_KEY_PAIR_FAILURE
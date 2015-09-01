#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Authenticates and creates an OpenStack server.
#
# Inputs:
#   - host - OpenStack machine host
#   - identity_port - optional - port used for OpenStack authentication - Default: 5000
#   - compute_port - optional - port used for OpenStack computations - Default: 8774
#   - img_ref - image reference for server to be created
#   - username - OpenStack username
#   - password - OpenStack password
#   - tenant_name - name of the project on OpenStack
#   - server_name - server name
#   - proxy_host - optional - proxy server used to access the web site - Default: none
#   - proxy_port - optional - proxy server port - Default: none
# Outputs:
#   - return_result - response of the last operation that was executed
#   - error_message - error message of the operation that failed
####################################################

namespace: io.cloudslang.stackato

imports:
 stackato_utils: io.cloudslang.stackato.utils

flow:
  name: retrieve_space_details_flow
  inputs:
    - host
    - username
    - password
    - name
  workflow:
    - authentication:
        do:
          get_authentication_flow:
            - host
            - username
            - password
        publish:
          - token
          - return_result
          - error_message
    - listspaces:
        do:
          get_space_guid:
            - host
            - token
        publish:
          - return_result
          - error_message
          - response_body: return_result
    - parse_spaces:
        do:
          stackato_utils.parse_spaces:
            - json_authentication_response: response_body
            - spacename: name
        publish:
          - guid
          - error_message
    - getDetails:
        do:
          retrieve_space_details:
            - token
            - guid
            - host
        publish: 
          - return_result
          - space_details: return_result
    - parse_spacedetails:
        do:
          stackato_utils.parse_spacedetails:
            - space_json: space_details
          publish:
            - name
            - url
            - org_url

  outputs:
    - space_details
    - return_result
    - error_message
    - org_url
    - url




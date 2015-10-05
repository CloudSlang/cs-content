####################################################
#
# OpenStack content for HP Helion Public Cloud
# Modified from io.cloudslang.openstack (v0.8) content
#
# Ben Coleman, Sept 2015
# v0.1
#
####################################################

namespace: io.cloudslang.cloud_provider.hp_cloud

imports:
 openstack_utils: io.cloudslang.openstack.utils

flow:
  name: get_authentication_flow
  inputs:
    - host
    - identity_port:
        default: "'5000'"
    - username
    - password
    - tenant_name
    - proxy_host:
        required: false
    - proxy_port:
        required: false
  workflow:
    - get_token:
        do:
          get_authentication:
            - host
            - identity_port
            - username
            - password
            - tenant_name
            - proxy_host:
                required: false
            - proxy_port:
                required: false
        publish:
          - response_body: return_result
          - return_code
          - error_message

    - parse_authentication:
        do:
          openstack_utils.parse_authentication:
            - json_authentication_response: response_body
        publish:
          - token
          - tenant
          - error_message

  outputs:
    - token
    - tenant
    - return_result: response_body
    - error_message

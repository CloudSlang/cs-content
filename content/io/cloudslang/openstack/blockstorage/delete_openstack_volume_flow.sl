#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Deletes an OpenStack volume.
#
# Inputs:
#   - host - OpenStack machine host
#   - identity_port - optional - port used for OpenStack authentication - Default: 5000
#   - blockstorage_port - optional - port used for OpenStack computations - Default: 8776
#   - username - OpenStack username
#   - password - OpenStack password
#   - tenant_name - name of the project on OpenStack
#   - volume_name - name of server to delete
#   - tenant_name - name of the project on OpenStack
#   - proxy_host - optional - proxy server used to access the web site - Default: none
#   - proxy_port - optional - proxy server port - Default: none
# Outputs:
#   - return_result - response of the last operation that was executed
#   - error_message - error message of the operation that failed
####################################################

namespace: io.cloudslang.openstack.blockstorage

imports:
 openstack_content: io.cloudslang.openstack
 openstack_blockstorage: io.cloudslang.openstack.blockstorage
 openstack_utils: io.cloudslang.openstack.utils
flow:
  name: delete_openstack_volume_flow
  inputs:
    - host
    - identity_port:
        default: "'5000'"
    - blockstorage_port:
        default: "'8776'"
    - username
    - password
    - tenant_name
    - volume_name
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
            - proxy_host:
                required: false
            - proxy_port:
                required: false
        publish:
          - token
          - tenant
          - return_result
          - error_message
    - get_volumes:
        do:
          openstack_blockstorage.get_openstack_volumes:
            - host
            - blockstorage_port
            - token
            - tenant
            - proxy_host:
                required: false
            - proxy_port:
                required: false
        publish:
          - volume_list: return_result
          - return_result
          - error_message
    - get_volume_id:
        do:
          openstack_utils.get_volume_id:
            - volume_body: volume_list
            - volume_name: volume_name
        publish:
          - volume_id
          - return_result
          - error_message
    - delete_volume:
        do:
          openstack_blockstorage.delete_openstack_volume:
            - host
            - blockstorage_port
            - token
            - tenant
            - volume_id
            - proxy_host:
                required: false
            - proxy_port:
                required: false
        publish:
          - return_result
          - error_message
  outputs:
    - return_result
    - error_message
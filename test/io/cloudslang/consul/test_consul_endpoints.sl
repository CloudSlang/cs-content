#   (c) Copyright 2022 Micro Focus, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
########################################################################################################################

namespace: io.cloudslang.consul

imports:
  consul: io.cloudslang.consul
  ssh: io.cloudslang.base.ssh


flow:
  name: test_consul_endpoints
  inputs:
    - host
    - port:
        required: false
    - username
    - password:
        required: false
    - private_key_file:
        required: false
    - node
    - address
    - service

  workflow:

    - register_endpoint:
        do:
          consul.register_endpoint:
            - host
            - node
            - address
            - service
        navigate:
          - SUCCESS: get_catalog_services
          - FAILURE: FAIL_TO_REGISTER

    - get_catalog_services:
        do:
          consul.get_catalog_services:
            - host
            - node
            - address
            - service
        navigate:
          - SUCCESS: deregister_endpoint
          - FAILURE: FAIL_TO_GET_SERVICES
        publish:
          - services_after_register: ${return_result}
          - error_message

    - deregister_endpoint:
        do:
          consul.deregister_endpoint:
            - host
            - node
        navigate:
          - SUCCESS: get_catalog_services2
          - FAILURE: FAIL_TO_DEREGISTER

    - get_catalog_services2:
        do:
          consul.get_catalog_services:
            - host
            - node
            - address
            - service
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAIL_TO_GET_SERVICES
        publish:
          - services_after_deregister: ${return_result}
          - error_message
  outputs:
    - services_after_register: ${str(services_after_register)}
    - services_after_deregister: ${str(services_after_deregister)}
  results:
    - SUCCESS
    - FAIL_TO_REGISTER
    - FAIL_TO_DEREGISTER
    - FAIL_TO_GET_SERVICES

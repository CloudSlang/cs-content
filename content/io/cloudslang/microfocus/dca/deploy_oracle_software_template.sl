#   (c) Copyright 2018 Micro Focus, L.P.
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

namespace: io.cloudslang.dca

imports:
  templates: io.cloudslang.microfocus.dca.templates
  utils: io.cloudslang.microfocus.dca.utils
  auth: io.cloudslang.microfocus.dca.authentication

flow:
  name: deploy_oracle_software_template
  inputs:
    - protocol:
        default: 'https'
        required: false
    - idm_host
    - idm_port:
        default: '5443'
        required: false
    - idm_username
    - idm_password:
        sensitive: true
    - dca_host
    - dca_port:
        default: '443'
        required: false
    - dca_username
    - dca_password:
        sensitive: true
    - dca_tenant_name:
        default: 'PROVIDER'
        required: false
    - deployment_name
    - deployment_description:
        default: ''
        required: false
    - base_resource_uuid
    - base_resource_dns_name
    - base_resource_username
    - base_resource_password
    - oracle_base:
        default: '/opt/app/oraBase'
        required: false
    - clean_code_base:
        default: 'false'
        required: false
    - clean_jre:
        default: 'false'
        required: false
    - cleanup_on_failure:
        default: 'false'
        required: false
    - download_location:
        default: '/tmp'
        required: false
    - cleanup_on_success:
        default: 'false'
        required: false
    - debug_level:
        default: '5'
        required: false
    - extract_location:
        default: '/tmp'
        required: false
    - oracle_account:
        default: 'oracle'
        required: false
    - run_installer_parameters:
        default: '-ignoreSysPrereqs'
        required: false
    - cluster_nodes:
        default: ''
        required: false
    - dba_group:
        default: ''
        required: false
    - enable_dnfs:
        default: ''
        required: false
    - install_edition:
        default: ''
        required: false
    - install_response:
        default: ''
        required: false
    - inventory_files:
        default: ''
        required: false
    - network_admin_files:
        default: ''
        required: false
    - operator_group:
        default: ''
        required: false
    - oracle_home_name:
        default: ''
        required: false
    - rac_one_node_install:
        default: 'false'
        required: false
    - crs_base:
        default: 'false'
        required: false
    - timeout:
        default: '3000'
        required: false
    - polling_interval:
        default: '30'
        required: false
    - preemptive_auth:
        default: 'false'
        required: false
    - proxy_host:
        required: false
    - proxy_port:
        default: '8080'
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - trust_all_roots:
        default: 'false'
        required: false
    - x_509_hostname_verifier:
        default: 'strict'
        required: false
    - trust_keystore:
        required: false
    - trust_password:
        required: false
        sensitive: true
    - keystore:
        default: ''
        required: false
    - keystore_password:
        required: false
        sensitive: true
    - connect_timeout:
        required: false
    - socket_timeout:
        required: false
    - use_cookies:
        required: false
    - keep_alive:
        required: false
    - connections_max_per_route:
        required: false
    - connections_max_total:
        required: false

  workflow:
    - oracle_prerequisites_with_ssh:
        do:
          ssh.ssh_command:
            - host: ${base_resource_dns_name}
            - command: >
                echo $PATH
            - username: ${base_resource_username}
            - password: ${base_resource_password}
            - known_host_policy: 'add'
            - close_session: 'true'
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - use_shell: 'true'
        publish:
            - return_result
            - return_code
            - exception
        navigate:
          - SUCCESS: get_authentication_token
          - FAILURE: FAILURE

    - get_authentication_token:
        do:
          auth.get_authentication_token:
            - idm_host
            - idm_port
            - protocol
            - idm_username
            - idm_password
            - dca_username
            - dca_password
            - dca_tenant_name
            - preemptive_auth
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - trust_all_roots
            - x_509_hostname_verifier
            - trust_keystore
            - trust_password
            - keystore
            - keystore_password
            - connect_timeout
            - socket_timeout
            - use_cookies
            - keep_alive
            - connections_max_per_route
            - connections_max_total
        publish:
            - auth_token
            - refresh_token
            - return_code
            - exception
        navigate:
          - SUCCESS: create_oracle_software_resource_json
          - FAILURE: FAILURE

    - create_oracle_software_resource_json:
        do:
          utils.create_resource_json:
            - type_uuid: '28ee3f10-361e-40fa-a222-d8fc3d59a4da'
            - deploy_sequence: '1'
            - base_resource_uuid_list: ${base_resource_uuid}
            - base_resource_ci_type_list: 'node'
            - base_resource_type_uuid_list: ''
            - delimiter: '|'
            - deployment_parameter_name_list: >
                ${delimiter.join(['oracleBase', 'cleanCodeBase', 'cleanJRE', 'cleanupOnFailure', 'downloadLocation',
                'cleanupOnSuccess', 'debugLevel', 'extractLocation', 'oracleAccount', 'runInstallerParameters',
                'clusterNodes', 'dbaGroup', 'enableDNFS', 'installEdition', 'installResponse', 'inventoryFiles',
                'networkAdminFiles', 'operatorGroup', 'oracleHomeName', 'RACOneNodeInstall', 'crsBase'])}
            - deployment_parameter_value_list: >
                ${delimiter.join([oracle_base, clean_code_base, clean_jre, cleanup_on_failure,
                download_location, cleanup_on_success, debug_level, extract_location,
                oracle_account, run_installer_parameters, cluster_nodes, dba_group,
                enable_dnfs, install_edition, install_response, inventory_files,
                network_admin_files, operator_group, oracle_home_name, rac_one_node_install,
                crs_base])}
        publish:
          - exception
          - return_code
          - osr_json: ${return_result}
        navigate:
          - SUCCESS: deploy_template
          - FAILURE: FAILURE

    - deploy_template:
        do:
          templates.deploy_template:
            - dca_host
            - dca_port
            - protocol
            - auth_token
            - refresh_token
            - deployment_name
            - deployment_description
            - deployment_template_id: 'c58ba610-ea58-4d42-b178-a7a4d9b1f217'
            - deployment_resources_json
            - async: 'false'
            - timeout
            - polling_interval
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - trust_all_roots
            - x_509_hostname_verifier
            - trust_keystore
            - trust_password
            - keystore
            - keystore_password
            - connect_timeout
            - socket_timeout
            - use_cookies
            - keep_alive
            - connections_max_per_route
            - connections_max_total
        publish:
          - return_result
          - return_code
          - exception
          - status
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE

  outputs:
    - return_result: ${get('return_result', '')}
    - return_code: ${get('return_code', '')}
    - exception: ${get('exception', '')}
    - status: ${get('status', '')}

  results:
    - FAILURE
    - SUCCESS

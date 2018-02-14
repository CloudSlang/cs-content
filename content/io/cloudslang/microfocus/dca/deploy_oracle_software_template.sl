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
#!!
#! @description: This flow is used to deploy a RHEL 7 Template in Micro Focus DCA.
#!
#! @input protocol: The protocol to use when connecting to IdM.
#!                  Valid: 'http' or 'https'
#!                  Default: 'https'
#!                  Optional
#! @input idm_host: The hostname or IP of the IdM with which to authenticate.
#! @input idm_port: The port on which IdM is listening on the host.
#!                  Default: '5443'
#!                  Optional
#! @input idm_username: The IdM username to use when authenticating.
#! @input idm_password: The password of the IdM user.
#! @input dca_host: The hostname or IP of the DCA environment.
#! @input dca_port: The port on which the DCA environment is listening.
#!                  Default: '443'
#!                  Optional
#! @input dca_username: The DCA user to authenticate.
#! @input dca_password: The password of the DCA user.
#! @input dca_tenant_name: The tenant of the DCA user to authenticate.
#!                         Default: 'PROVIDER'
#!                         Optional
#! @input deployment_name: The display name of the deployment.
#! @input deployment_description: A description of the deployment.
#!                                Optional
#! @input base_resource_uuid: The UUID of the provisioned RHEL 7 resource.
#! @input base_resource_dns_name: The dns name of the provisioned RHEL 7 resource.
#! @input base_resource_username: The username of the credential associated with the RHEL 7 resource.
#! @input base_resource_password: The password associated with the username.
#! @input oracle_base: The fully-qualified path to the Oracle base directory where the admin directories will be located.
#!                     Example: '/u01/app/oracle'
#!                     Optional
#! @input clean_code_base: ?
#!                     Optional
#! @input clean_jre: ?
#!                   Optional
#! @input cleanup_on_failure: Indicates whether to remove downloaded and extracted files—to clean up the installation
#!                            directory—in the event of workflow failure.
#!                            Default: 'false'
#!                            Valid: 'true', 'false'
#!                            Optional
#! @input download_location: The directory where input files already exist or to which files will be downloaded from
#!                           the software repository.
#!                           Example: '/tmp'
#!                           Optional
#! @input cleanup_on_success: Indicates whether to remove downloaded and extracted files—to clean up the installation
#!                            directory—in the event of workflow success.
#!                            Default: 'false'
#!                            Valid: 'true', 'false'
#!                            Optional
#! @input debug_level: ?
#!                     Optional
#! @input extract_location: The directory location where the Oracle database software archives will be extracted.
#!                          It will be cleaned up at end of workflow execution. If not specified, a default will
#!                          be created.
#!                          Default: 'oracle'
#!                          Example: '/tmp'
#!                          Optional
#! @input oracle_account: Required only if inventory does not exist. The Oracle user that will own the Oracle Home.
#!                        Example: 'Maximum Availability'
#!                        Optional
#! @input run_installer_parameters: The parameters to pass to the Oracle runInstaller command.
#!                                  Default: '-ignoreSysPrereqs'
#!                                  Example: '-force'
#!                                  Optional
#! @input cluster_nodes: Required when provisioning a RAC database. Comma-separated list of nodes to install
#!                       software on. Leave blank for non-clustered environments.
#!                       Default: ''
#!                       Optional
#! @input dba_group: The DBA group to use for superuser access to the subsequent Oracle Database (typically dba).
#!                   If not specified, derived from the Oracle OS user.
#!                   Default: ''
#!                   Optional
#! @input enable_dnfs: When set to 'true' then the workflow will enable the Direct NFS option as part of the
#!                     Software Installation.
#!                     Optional
#! @input install_edition: The install edition of the Oracle installation.
#!                         Valid: 'SE' or 'EE'.
#!                         Default: 'EE'.
#!                         Optional
#! @input install_response: Location of the Oracle Universal Installer (OUI) response file.
#!                     Optional
#! @input inventory_files: Comma-separated list of fully-qualified Oracle inventory files. If this parameter is
#!                         not specified, the workflow looks for the oraInst.loc file in /etc and /var/opt/oracle.
#!                         Optional
#! @input network_admin_files: Comma-delimited list of files to be downloaded and placed in the CRS_HOME/network/admin
#!                             directory after the Oracle Software is installed.
#!                             Optional
#! @input operator_group: The operator group to use for operator access to the subsequent Oracle Database
#!                        (typically oper). If this parameter is not specified, it is derived from the Oracle OS user.
#!                        Optional
#! @input oracle_home_name: The Oracle Home name. If not specified, it is randomly generated.
#!                          Optional
#! @input rac_one_node_install: Set to true to install Oracle RAC One Node software using the
#!                              oracle.install.db.isRACOneInstall option.
#!                              Default: 'false'
#!                              Valid: 'true', 'false'
#!                              Optional
#! @input crs_base: ?
#!                  Optional
#! @input timeout: The timeout in seconds, in case the operation runs in sync mode.
#!                 Default: '1200'
#!                 Optional
#! @input polling_interval: The interval in seconds at which the deployment will be queried in sync mode.
#!                          Default: '30'
#!                          Optional
#! @input preemptive_auth: If this field is 'true' authentication info will be sent in the first request. If this is
#!                         'false' a request with no authentication info will be made and if server responds with 401
#!                         and a header like WWW-Authenticate: Basic realm="myRealm" only then the authentication info
#!                         will be sent.
#!                         Optional
#! @input proxy_host: The proxy server used to access the web site.
#!                    Optional
#! @input proxy_port: The proxy server port.
#!                    Valid values: -1 and integer values greater than 0. The value '-1' indicates that the proxy
#!                    port is not set and the protocol default port will be used. If the protocol is 'http' and the
#!                    'proxy_port' is set to '-1' then port '80' will be used.
#!                    Default: '8080'
#!                    Optional
#! @input proxy_username: The user name used when connecting to the proxy.
#!                        Optional
#! @input proxy_password: The proxy server password associated with the proxyUsername input value.
#!                        Optional
#! @input trust_all_roots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no
#!                         trusted certification authority issued it.
#!                         Default: 'false'
#!                         Optional
#! @input x_509_hostname_verifier: Specifies the way the server hostname must match a domain name in the subject's
#!                                 Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to
#!                                 "allow_all" to skip any checking. For the value "browser_compatible" the hostname
#!                                 verifier works the same way as Curl and Firefox. The hostname must match either the
#!                                 first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of
#!                                 the subject-alts. The only difference between "browser_compatible" and "strict" is
#!                                 that a wildcard (such as "*.foo.com") with "browser_compatible" matches all
#!                                 subdomains, including "a.b.foo.com".
#!                                 Default: 'strict'
#!                                 Optional
#! @input trust_keystore: The pathname of the Java TrustStore file. This contains certificates from other parties that
#!                        you expect to communicate with, or from Certificate Authorities that you trust to identify
#!                        other parties.  If the protocol (specified by the 'url') is not 'https' or if trustAllRoots is
#!                        'true' this input is ignored. Format: Java KeyStore (JKS)
#!                        Optional
#! @input trust_password: The password associated with the TrustStore file. If trustAllRoots is false and trustKeystore
#!                        is empty, trustPassword default will be supplied.
#!                        Optional
#! @input keystore: The pathname of the Java KeyStore file. You only need this if the server requires client
#!                  authentication. If the protocol (specified by the 'url') is not 'https' or if trustAllRoots is
#!                  'true' this input is ignored. Format: Java KeyStore (JKS)
#!                  Optional
#! @input keystore_password: The password associated with the KeyStore file. If trustAllRoots is false and keystore is
#!                           empty, keystorePassword default will be supplied.
#!                           Optional
#! @input connect_timeout: The time to wait for a connection to be established, in seconds. A timeout value of '0'
#!                         represents an infinite timeout.
#!                         Optional
#! @input socket_timeout: The timeout for waiting for data (a maximum period inactivity between two consecutive data
#!                        packets), in seconds. A socketTimeout value of '0' represents an infinite timeout.
#!                        Optional
#! @input use_cookies: Specifies whether to enable cookie tracking or not. Cookies are stored between consecutive calls
#!                     in a serializable session object therefore they will be available on a branch level. If you
#!                     specify a non-boolean value, the default value is used.
#!                     Optional
#! @input keep_alive: Specifies whether to create a shared connection that will be used in subsequent calls. If
#!                    keepAlive is false, the already open connection will be used and after execution it will close it.
#!                    Optional
#! @input connections_max_per_route: The maximum limit of connections on a per route basis.
#!                                   Optional
#! @input connections_max_total: The maximum limit of connections in total.
#!                               Optional
#!
#! @output return_result: In case of success, a JSON representation of the RHEL deployment, otherwise an error message.
#! @output return_code: The return code of the operation, 0 in case of success, -1 in case of failure
#! @output exception: In case of failure, the error message, otherwise empty.
#! @output status: The status of the deployment.
#!
#! @result SUCCESS: Operation succeeded, returnCode is '0'.
#! @result FAILURE: Operation failed, returnCode is '-1'.
#!!#
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
        default: 'EE'
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

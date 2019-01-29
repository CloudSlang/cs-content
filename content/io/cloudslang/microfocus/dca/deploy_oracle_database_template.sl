#   (c) Copyright 2019 Micro Focus, L.P.
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
#! @description: This flow is used to deploy an Oracle Database Template in Micro Focus DCA.
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
#! @input base_resource_uuid: The UUID of the unmanaged resource on which to deploy Oracle Database Template.
#! @input oracle_base: The fully-qualified path to the Oracle base directory where the admin directories are located.
#!                     Default: '/opt/app/oraBase'
#!                     Example: '/u01/app/oracle/product/12.1.0/dbhome_1'
#! @input datafile_location: The database file locations.
#!                           Default: '/opt/app/oracle/oradata'
#!                           Example: '+ASMDATA'
#! @input cleanup_on_failure: Indicates whether to remove downloaded and extracted files, to clean up the installation
#!                            directory, in the event of workflow failure.
#!                            Default: 'false'
#!                            Valid values: 'true', 'false'
#!                            Optional
#! @input cleanup_on_success: Indicates whether to remove downloaded and extracted files, to clean up the installation
#!                            directory, in the event of workflow success.
#!                            Default: 'false'
#!                            Valid values: 'true', 'false'
#!                            Optional
#! @input debug_level: Missing information for input.
#!                     Default: '6'
#!                     Optional
#! @input inventory_files: Comma-separated list of fully-qualified Oracle inventory files. If this parameter is not
#!                         specified, the workflow looks for the oraInst.loc file in /etc and /var/opt/oracle.
#!                         Optional
#! @input oracle_account: Required only if inventory does not exist. The Oracle user that will own the Oracle Home.
#!                        Default: 'oracle'
#!                        Optional
#! @input clean_code_base: Missing information for input.
#!                         Default: 'true'
#!                         Optional
#! @input clean_jre: Missing information for input.
#!                   Default: 'true'
#!                   Optional
#! @input archive_log_on: Missing information for input.
#!                        Default: 'false'
#!                        Optional
#! @input asm_password: Required when provisioning an Oracle database using ASM storage, representing the password
#!                      used to manage ASM.
#!                      Optional
#! @input cluster_nodes: Required when provisioning a RAC database. Comma-separated list of nodes where this database
#!                       will run.
#!                       Optional
#! @input dbca_character_set: Missing information for input.
#!                            Optional
#! @input dbca_national_character_set: Missing information for input.
#!                                     Optional
#! @input dbca_password_all: If set, this password will be used in the DBCA response file for the
#!                           oracle.install.db.config.starterdb.password.ALL setting and the remaining DBCA Password
#!                           inputs will be ignored.
#!                           Optional
#! @input dbca_password_dbsnmp: Missing information for input.
#!                              Optional
#! @input dbca_password_sys: Missing information for input.
#!                           Optional
#! @input dbca_response_file: Location of a DBCA response file in the software repository to download. If not specified,
#!                            a default will be used.
#!                            Optional
#! @input dbca_template_file: Location of a DBCA template file in the software repository to download. If not specified,
#!                            a default will be used.
#!                            Optional
#! @input local_listener: Set to True to ignore any GRID installation listener and any attempt to create a local
#!                        listener (in the Verify Listener step). If the environment does not include GRID, then the
#!                        local listener will be created regardless of this setting.
#!                        Optional
#! @input log_archive_destination: Missing information for input.
#!                                 Optional
#! @input log_archive_format: Missing information for input.
#!                            Optional
#! @input maximum_dump_file_size: Missing information for input.
#!                                Optional
#! @input net_ca_response_file: Location of a NetCA response file in the software repository to download. If not
#!                              specified, a default will be used.
#!                              Optional
#! @input policy_managed: Set to true if Database is policy managed and set to false if Database is admin managed.
#!                        Optional
#! @input rac_one_node: Set to true to provision an Oracle RAC One Node database.
#!                      Optional
#! @input rac_one_node_service_name: The name of the service to connect to the RAC One Node Database.
#!                                   Optional
#! @input redo_log_destination: Missing information for input.
#!                              Optional
#! @input variables_file: Location of a DBCA variables file in the software repository to download. If not specified,
#!                        a default will be used.
#!                        Optional
#! @input listener_configuration: Colon-separated name and port of the Oracle listener for this database. If left blank,
#!                                the Oracle default of LISTENER:1521 will be used.
#!                                Optional
#! @input dbca_password_sysman: Missing information for input.
#!                              Optional
#! @input dbca_password_system: Missing information for input.
#!                              Optional
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
#! @output return_result: In case of success, a JSON representation of the Oracle Database deployment,
#!                        otherwise an error message.
#! @output return_code: The return code of the operation, 0 in case of success, -1 in case of failure
#! @output exception: In case of failure, the error message, otherwise empty.
#! @output status: The status of the deployment.
#!
#! @result SUCCESS: Operation succeeded, returnCode is '0'.
#! @result FAILURE: Operation failed, returnCode is '-1'.
#!!#
########################################################################################################################

namespace: io.cloudslang.microfocus.dca

imports:
  templates: io.cloudslang.microfocus.dca.templates
  utils: io.cloudslang.microfocus.dca.utils
  auth: io.cloudslang.microfocus.dca.authentication

flow:
  name: deploy_oracle_database_template
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
    - oracle_base:
        default: '/opt/app/oraBase'
        required: false
    - datafile_location:
        default: '/opt/app/oracle/oradata'
        required: false
    - cleanup_on_failure:
        default: 'false'
        required: false
    - cleanup_on_success:
        default: 'false'
        required: false
    - debug_level:
        default: '6'
        required: false
    - inventory_files:
        default: ''
        required: false
    - oracle_account:
        default: 'oracle'
        required: false
    - clean_code_base:
        default: 'true'
        required: false
    - clean_jre:
        default: 'true'
        required: false
    - archive_log_on:
        default: 'false'
        required: false
    - asm_password:
        default: ''
        required: false
    - cluster_nodes:
        default: ''
        required: false
    - dbca_character_set:
        default: ''
        required: false
    - dbca_national_character_set:
        default: ''
        required: false
    - dbca_password_all:
        default: ''
        required: false
    - dbca_password_dbsnmp:
        default: ''
        required: false
    - dbca_password_sys:
        default: ''
        required: false
    - dbca_response_file:
        default: ''
        required: false
    - dbca_template_file:
        default: ''
        required: false
    - local_listener:
        default: ''
        required: false
    - log_archive_destination:
        default: ''
        required: false
    - log_archive_format:
        default: ''
        required: false
    - maximum_dump_file_size:
        default: ''
        required: false
    - net_ca_response_file:
        default: ''
        required: false
    - policy_managed:
        default: ''
        required: false
    - rac_one_node:
        default: ''
        required: false
    - rac_one_node_service_name:
        default: ''
        required: false
    - redo_log_destination:
        default: ''
        required: false
    - variables_file:
        default: ''
        required: false
    - listener_configuration:
        default: ''
        required: false
    - dbca_password_sysman:
        default: ''
        required: false
    - dbca_password_system:
        default: ''
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
          - SUCCESS: create_oracle_resource_json
          - FAILURE: FAILURE

    - create_oracle_resource_json:
        do:
          utils.create_resource_json:
            - type_uuid: '8475f05e-624c-42b7-a496-339a292c0c84'
            - deploy_sequence: '1'
            - base_resource_uuid_list: ${base_resource_uuid}
            - base_resource_ci_type_list: 'host_node'
            - base_resource_type_uuid_list: ''
            - deployment_parameter_name_list: >
                ${'|'.join(['oracleBase', 'datafileLocation', 'cleanupOnFailure', 'cleanupOnSuccess',
                'debugLevel', 'inventoryFiles', 'oracleAccount', 'cleanCodeBase', 'cleanJRE', 'archivelogON',
                'aSMPassword', 'clusterNodes', 'dBCACharacterSet', 'dBCANationalCharacterSet',
                'dBCAPasswordALL', 'dBCAPasswordDBSNMP', 'dBCAPasswordSYS', 'dBCAResponseFile', 'dBCATemplateFile',
                'localListener', 'logArchiveDestination', 'logArchiveFormat', 'maximumDumpFileSize',
                'netCAResponseFile', 'policyManaged', 'rACOneNode', 'rACOneNodeServiceName', 'redoLogDestinations',
                'variablesFile', 'listenerConfiguration', 'dBCAPasswordSYSMAN', 'dBCAPasswordSYSTEM'])}
            - deployment_parameter_value_list: >
                ${'|'.join([oracle_base, datafile_location, cleanup_on_failure, cleanup_on_success,
                debug_level, inventory_files, oracle_account, clean_code_base,
                clean_jre, archive_log_on, asm_password, cluster_nodes, dbca_character_set,
                dbca_national_character_set, dbca_password_all, dbca_password_dbsnmp, dbca_password_sys,
                dbca_response_file, dbca_template_file, local_listener, log_archive_destination,
                log_archive_format, maximum_dump_file_size, net_ca_response_file, policy_managed,
                rac_one_node, rac_one_node_service_name, redo_log_destination, variables_file,
                listener_configuration, dbca_password_sysman, dbca_password_system])}
            - delimiter: '|'
            - osr_json
        publish:
          - exception
          - return_code
          - deployment_resources_json: ${format('[%s]' % return_result)}
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
            - deployment_template_id: '46eef60c-748e-4d20-be30-0f02d1d76f53'
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

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
#! @input base_resource_password: The password of the credential associated with the RHEL 7 resource.
#! @input subscription_username: The username of the RHEL 7 subscription to register with.
#!                               Optional
#! @input subscription_password: The password of the RHEL 7 subscription to register with.
#!                               Optional
#! @input base_resource_proxy_host: The proxy host to be configured on the base resource.
#!                                  Optional
#! @input base_resource_proxy_port: The proxy prot to be configured on the base resource.
#!                                  Optional
#! @input base_resource_proxy_user: The proxy username to be configured on the base resource.
#!                                  Optional
#! @input base_resource_proxy_pass: The proxy password to be configured on the base resource.
#!                                  Optional
#! @input oracle_base: The fully-qualified path to the Oracle base directory where the admin directories will be located.
#!                     Example: '/u01/app/oracle'
#!                     Optional
#! @input clean_code_base: Missing information for input.
#!                     Optional
#! @input clean_jre: Missing information for input.
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
#! @input debug_level: Missing information for input.
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
#! @input crs_base: Missing information for input.
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

namespace: io.cloudslang.microfocus.dca

imports:
  templates: io.cloudslang.microfocus.dca.templates
  utils: io.cloudslang.microfocus.dca.utils
  auth: io.cloudslang.microfocus.dca.authentication
  ssh: io.cloudslang.base.ssh

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
    - subscription_username:
        required: false
    - subscription_password:
        required: false
    - base_resource_proxy_host:
        required: false
    - base_resource_proxy_port:
        required: false
    - base_resource_proxy_user:
        required: false
    - base_resource_proxy_pass:
        required: false
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
                ${format("""proxy_host=%s\n
                proxy_port=%s\n
                proxy_username=%s\n
                proxy_password=%s\n
                oracle_base=%s\n
                oracle_password=%s\n
                fqdn=%s\n
                subscription_username=%s\n
                subscription_password=%s\n

                #Subscribe to RHEL servers

                proxy_host_no_protocol=$(echo $proxy_host | sed 's/https\?:\/\///')\n
                sed -i "/^proxy_hostname/c\proxy_hostname = $proxy_host_no_protocol" /etc/rhsm/rhsm.conf\n
                sed -i "/^proxy_port/c\proxy_port = $proxy_port" /etc/rhsm/rhsm.conf\n
                sed -i "/^proxy_user/c\proxy_user = $proxy_username" /etc/rhsm/rhsm.conf\n
                sed -i "/^proxy_password/c\proxy_password = $proxy_password" /etc/rhsm/rhsm.conf\n

                subscription_status=$(subscription-manager list | grep Status | awk '{print $2}')

                if [ "$subscription_status" != "Subscribed" ]; then
                  subscription-manager register --username=$subscription_username --password=$subscription_password;
                  subscription-manager attach --auto --proxy=$proxy_host:$proxy_port --proxyuser=$proxy_username;
                fi

                #Add proxies

                if [[ ! -z "$proxy_host" ]]; then
                    if [[ ! -z "$proxy_username" ]]; then
                        echo "export http_proxy=$proxy_username:$proxy_password@$proxy_host:$proxy_port" >> ~/.bash_profile;
                        echo "export https_proxy=$proxy_username:$proxy_password@$proxy_host:$proxy_port" >> ~/.bash_profile;
                        echo "export HTTP_PROXY=$proxy_username:$proxy_password@$proxy_host:$proxy_port" >> ~/.bash_profile;
                        echo "export HTTPS_PROXY=$proxy_username:$proxy_password@$proxy_host:$proxy_port" >> ~/.bash_profile;
                    else
                        echo "export http_proxy=$proxy_host:$proxy_port" >> ~/.bash_profile;
                        echo "export https_proxy=$proxy_host:$proxy_port" >> ~/.bash_profile;
                        echo "export HTTP_PROXY=$proxy_host:$proxy_port" >> ~/.bash_profile;
                        echo "export HTTPS_PROXY=$proxy_host:$proxy_port" >> ~/.bash_profile;
                    fi
                    source ~/.bash_profile;
                fi

                #DCA Prerequisite Script for Oracle Software

                oracle_base_root=/$(echo "$oracle_base" | cut -d "/" -f2)\n

                #Create groups and users

                groupadd -g 501 oinstall\n
                groupadd -g 502 dba\n
                groupadd -g 503 oper\n
                groupadd -g 504 asmadmin\n
                groupadd -g 506 asmdba\n
                groupadd -g 505 asmoper\n
                useradd -u 502 -g oinstall -G dba,asmdba,oper oracle\n
                echo $oracle_password | passwd --stdin oracle\n
                mkdir -p $oracle_base/product/11.2.0/db_1\n
                chown -R oracle:oinstall $oracle_base_root\n
                chmod -R 775 $oracle_base_root\n

                #Install or upgrade RPMs

                yum -y install compat-libstdc++-33 gcc* gcc-c++-4.* glibc-devel-2.* glibc-headers-2.* libaio-devel-0.* libgomp-4.* libstdc++-devel-4.* sysstat* unixODBC-2.* unixODBC-devel-2.* libXp.so.6 libXtst* vim* elfutils-libelf-devel* glibc* make* glibc.i686 \n

                #Ensure firewall is off

                service iptables stop\n
                chkconfig iptables off\n
                service ip6tables stop\n
                chkconfig ip6tables off\n

                #Disable SELINUX permanently

                sed -i '/^SELINUX=/c\SELINUX=disabled' /etc/sysconfig/selinux\n

                #Also disable SELINUX temporarly so no reboot will be needed

                setenforce 0\n

                #Add FQDN to hosts

                public_ip=$(ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')\n
                echo "$public_ip minion1.$fqdn minion1" >> /etc/hosts\n

                #Edit sysctl

                printf "fs.suid_dumpable = 1 \nfs.aio-max-nr = 1048576 \nfs.file-max = 6815744 \nkernel.shmall = 2097152 \nkernel.shmmax = 2070833152 \nkernel.shmmni = 4096 \n# semaphores: semmsl, semmns, semopm, semmni \nkernel.sem = 250 32000 100 128 \nnet.ipv4.ip_local_port_range = 9000 65500 \nnet.core.rmem_default=4194304 \nnet.core.rmem_max=4194304 \nnet.core.wmem_default=262144 \nnet.core.wmem_max=1048586" >> /etc/sysctl.conf \n

                #Change current kernel parameters

                /sbin/sysctl -p

                #Edit limits.conf

                printf "oracle              soft    nproc   2047 \noracle              hard   nproc   16384 \noracle              soft    nofile  1024 \noracle              hard   nofile  65536 \noracle              soft    stack   10240" >> /etc/security/limits.conf \n

                #Create oracle profile

                touch ~oracle/.profile\n

                #Edit oracle profile

                printf "export TMP=/tmp \nexport TMPDIR=\$TMP \nexport ORACLE_HOSTNAME=$fqdn \nexport ORACLE_BASE=$oracle_base \nexport PATH=$PATH:\$ORACLE_HOME/bin:$PATH \nexport LD_LIBRARY_PATH=\$ORACLE_HOME/lib:/lib:/usr/lib \nexport CLASSPATH=\$ORACLE_HOME/jlib:\$ORACLE_HOME/rdbms/jlib \nexport TNS_ADMIN=\$ORACLE_HOME/network/admin" >> ~oracle/.profile \n

                #Edit oracle bash profile

                printf ". ./.profile" >> ~oracle/.bash_profile\n

                #Edit /etc/system

                printf "set max_nprocs = 16384" >> /etc/system\n

                exit 0\n""" %
                (get('base_resource_proxy_host', ''),
                get('base_resource_proxy_port', ''),
                get('base_resource_proxy_user', ''),
                get('base_resource_proxy_pass', ''),
                get('oracle_base', ''),
                get('base_resource_password', ''),
                get('base_resource_dns_name', ''),
                get('subscription_username', ''),
                get('subscription_password', '')))}
            - username: ${base_resource_username}
            - password: ${base_resource_password}
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - known_host_policy: 'add'
            - close_session: 'true'
            - use_shell: 'true'
            - pty: 'true'
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
            - type_uuid: 'cf916726-a1b2-4fbd-b373-78196069a2b2'
            - deploy_sequence: '1'
            - base_resource_uuid_list: ${base_resource_uuid}
            - base_resource_ci_type_list: 'host_node'
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
          - deployment_resources_json: ${"[" + return_result + "]"}
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

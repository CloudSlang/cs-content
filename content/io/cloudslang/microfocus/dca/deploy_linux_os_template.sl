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
#! @input base_resource_uuid: The UUID of the unmanaged resource on which to deploy RHEL Template.
#! @input credential_id: The UUID of the DCA Credential to assign to the deployment.
#! @input build_plan_id: The ID of the SA build plan.
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
#! @output resource_name: The name of the resource.
#! @output dns_name: The DNS name of the resource.
#! @output username: The username of the credential associated with the resource.
#! @output password: The password associated with the username.
#!
#! @result SUCCESS: Flow succeeded, returnCode is '0'.
#! @result FAILURE: Flow failed, returnCode is '-1'.
#!!#
########################################################################################################################

namespace: io.cloudslang.microfocus.dca

imports:
  templates: io.cloudslang.microfocus.dca.templates
  utils: io.cloudslang.microfocus.dca.utils
  auth: io.cloudslang.microfocus.dca.authentication
  resources: io.cloudslang.microfocus.dca.resources
  credentials: io.cloudslang.microfocus.dca.credentials

flow:
  name: deploy_linux_os_template
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
    - credential_id
    - build_plan_id
    - timeout:
        default: '1200'
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
          - SUCCESS: create_resource_json
          - FAILURE: FAILURE

    - create_resource_json:
        do:
          utils.create_resource_json:
            - type_uuid: '8475f05e-624c-42b7-a496-339a292c0c84'
            - deploy_sequence: '1'
            - base_resource_uuid_list: ${base_resource_uuid}
            - base_resource_ci_type_list: 'host_node'
            - base_resource_type_uuid_list: ''
            - delimiter: '|'
            - deployment_parameter_name_list: ${delimiter.join(['credentialId', 'buildPlanId'])}
            - deployment_parameter_value_list: ${delimiter.join([credential_id, build_plan_id])}
        publish:
          - deployment_resources_json: ${format("[%s]" % return_result)}
          - exception
          - return_code
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
            - deployment_template_id: '172256fa-b3ay-416o-bt64-91f8226ae4a5'
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
          - SUCCESS: get_resource_dns_name
          - FAILURE: FAILURE

    - get_resource_dns_name:
            do:
              resources.get_resource:
                - dca_host
                - dca_port
                - protocol
                - auth_token
                - refresh_token
                - resource_uuid: ${get('base_resource_uuid', '')}
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
              - resource_name: ${name}
              - dns_name
            navigate:
              - SUCCESS: get_user_and_password
              - FAILURE: FAILURE

    - get_user_and_password:
            do:
              credentials.get_credential_from_manager:
                - cm_host: 'dca-credential-manager'
                - cm_port: '5333'
                - protocol: 'http'
                - credential_uuid: ${get('credential_id', '')}
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
              - username
              - password
            navigate:
              - SUCCESS: SUCCESS
              - FAILURE: FAILURE

  outputs:
    - return_result: ${get('return_result', '')}
    - return_code: ${get('return_code', '')}
    - exception: ${get('exception', '')}
    - status: ${get('status', '')}
    - dns_name: ${get('dns_name', '')}
    - resource_name: ${get('resource_name', '')}
    - username: ${get('username', '')}
    - password:
        value: ${get('password', '')}
        sensitive: true

  results:
    - FAILURE
    - SUCCESS

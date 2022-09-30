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
#!!
#! @description: This flow is used to get the terraform resource offering ID.
#!
#! @input dnd_host: The hostname of the DND.
#! @input tenant_id: The tenant ID of the DND.
#! @input x_auth_token: The auth token of the DND.
#! @input proxy_host: Proxy server used to access the Terraform service.
#!                    Optional
#! @input proxy_port: Proxy server port used to access the Terraform service.
#!                    Optional
#! @input proxy_username: Proxy server user name.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the proxy_username input value.
#!                        Optional
#! @input worker_group: A worker group is a logical collection of workers. A worker may belong to more than one group
#!                      simultaneously.
#!                      Default: 'RAS_Operator_Path'
#!                      Optional
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
#!
#! @output ro_id: The terraform resource offering ID.
#!
#! @result FAILURE: There was an error while getting the terraform resource offering ID.
#! @result SUCCESS: The resource offering ID retrieved successfully.
#!!#
########################################################################################################################
namespace: io.cloudslang.hashicorp.terraform.automation_content.resourcesync.subflows
flow:
  name: get_resource_offering_id
  inputs:
    - dnd_host
    - tenant_id
    - x_auth_token:
        sensitive: true
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - worker_group:
        default: RAS_Operator_Path
        required: false
    - trust_all_roots:
        default: 'false'
        required: false
    - x_509_hostname_verifier:
        default: strict
        required: false
    - trust_keystore:
        required: false
    - trust_password:
        required: false
        sensitive: true
  workflow:
    - get_ro_id:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${'https://'+dnd_host+'/dnd/api/v1/'+tenant_id+'/resource/offering/'}"
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password:
                value: '${trust_password}'
                sensitive: true
            - headers: "${'content-type: application/json\\n'+'Accept: application/json\\n'+'X-Auth-Token:'+x_auth_token}"
            - worker_group: '${worker_group}'
        publish:
          - ro_list: '${return_result}'
        navigate:
          - SUCCESS: get_ro_id_python
          - FAILURE: on_failure
    - get_ro_id_value:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - striped_ro_id: '${ro_id.split("/resource/offering/")[1]}'
        publish:
          - ro_id: '${striped_ro_id}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - get_ro_id_python:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.hashicorp.terraform.automation_content.resourcesync.subflows.get_ro_id_python:
            - ro_list: '${ro_list}'
        publish:
          - ro_id: '${ro_id}'
        navigate:
          - SUCCESS: get_ro_id_value
  outputs:
    - ro_id
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_ro_id:
        x: 80
        'y': 120
      get_ro_id_value:
        x: 360
        'y': 120
        navigate:
          c7ded12a-68fc-d9a0-38d0-91594b4516f7:
            targetId: 67de1986-7692-b9c6-2f94-31425296446f
            port: SUCCESS
      get_ro_id_python:
        x: 200
        'y': 120
    results:
      SUCCESS:
        67de1986-7692-b9c6-2f94-31425296446f:
          x: 600
          'y': 120

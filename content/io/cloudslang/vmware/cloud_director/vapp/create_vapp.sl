#   Copyright 2024 Open Text
#   This program and the accompanying materials
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
#! @description: This flow is used to create vApp in VMware Cloud Director.
#!
#! @input protocol: The protocol for rest API call. Default: https
#! @input host_name: The host name of the VMWare vCloud director.
#! @input port: The port of the host. Default: 443
#! @input access_token: The authorization token for vCloud director.
#! @input vdc_id: The id of the virtual data center.
#! @input vapp_template_id: The template id of vApp.
#! @input vapp_name: The name of the zone where the disk is located.
#!                   Examples: 'us-central1-a, us-central1-b, us-central1-c'
#! @input storage_profile: The name of the storage profile to be associated with vApp.
#! @input compute_parameters: The input values of VM template name, CPU, memory and Hard disk for each VMs present in the vApp template in JSON format. '{"values":[{"name":"BastionServer","diskSize":10,"cpu":4,"memory":10},{"name":"DBServer","diskSize":10,"cpu":2,"memory":10}]}'
#! @input unique_id_for_vm: The random id which will append with vm name. Provide this if compute_parameters input value is given.
#! @input worker_group: A worker group is a logical collection of workers. A worker may belong to more than
#!                      one group simultaneously.
#!                      Default: 'RAS_Operator_Path'
#!                      Optional
#! @input proxy_host: The proxy server used to access the provider services.
#!                    Optional
#! @input proxy_port: The proxy server used to access the provider services.
#!                    Optional
#! @input proxy_username: The proxy server username.
#!                        Optional
#! @input proxy_password: The proxy server password associated with the proxy_username input value.
#!                        Optional
#! @input trust_all_roots: Specifies whether to enable weak security over SSL.Default: 'false'Optional
#! @input x_509_hostname_verifier: Specifies the way the server hostname must match a domain name inthe subject's Common Name (CN) or subjectAltName field of the X.509 certificateValid: 'strict', 'browser_compatible', 'allow_all'Default: 'strict'Optional
#! @input trust_keystore: The pathname of the Java TrustStore file. This contains certificates fromother parties that you expect to communicate with, or from Certificate Authorities thatyou trust to identify other parties.  If the protocol (specified by the 'url') is not'https' or if trust_all_roots is 'true' this input is ignored.Default value: '..JAVA_HOME/java/lib/security/cacerts'Format: Java KeyStore (JKS)Optional
#! @input trust_password: The password associated with the trust_keystore file. If trust_all_roots is falseand trust_keystore is empty, trust_password default will be supplied.Optional
#!
#! @output return_result: contains the exception in case of failure, success message otherwise.
#! @output return_code: "0" if operation was successfully executed, "-1" otherwise.
#! @output exception: exception if there was an error when executing, empty otherwise.
#!
#! @result SUCCESS: vApp created successfully.
#! @result FAILURE: Error while creating vApp.
#!!#
########################################################################################################################
namespace: io.cloudslang.vmware.cloud_director.vapp
flow:
  name: create_vapp
  inputs:
    - protocol: https
    - host_name
    - port: '443'
    - access_token:
        sensitive: true
    - vdc_id
    - vapp_template_id:
        sensitive: false
    - vapp_name
    - storage_profile:
        required: false
    - compute_parameters:
        required: false
    - unique_id_for_vm:
        required: false
    - worker_group:
        default: RAS_Operator_Path
        required: false
    - proxy_host:
        required: false
    - proxy_port:
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
        default: strict
        required: false
    - trust_keystore:
        required: false
    - trust_password:
        required: false
        sensitive: true
  workflow:
    - get_template_details:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.vmware.cloud_director.catalogs.templates.get_template_details:
            - host_name: '${host_name}'
            - port: '${port}'
            - protocol: '${protocol}'
            - access_token: '${access_token}'
            - template_id: '${vapp_template_id}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - worker_group: '${worker_group}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password:
                value: '${trust_password}'
                sensitive: true
        publish:
          - template_json: '${return_result}'
        navigate:
          - SUCCESS: form_vapp_request_body
          - FAILURE: on_failure
    - create_vapp_api_call:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${protocol + '://'+ host_name + ':' + port + '/api/vdc/'+vdc_id+'/action/instantiateVAppTemplate'}"
            - auth_type: anonymous
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
            - headers: "${'Accept: application/*+json;version=39.0.0-alpha' + '\\n' +'Authorization: ' + access_token + '\\n' +'Content-Type: application/vnd.vmware.vcloud.instantiateVAppTemplateParams+xml;charset=UTF-8'}"
            - body: '${vapp_request_body}'
            - content_type: application/json
            - worker_group: '${worker_group}'
        publish:
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - form_vapp_request_body:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.vmware.cloud_director.utils.create_vapp_request_body:
            - name: '${vapp_name}'
            - template_json: '${template_json}'
            - compute_parameters_json: '${compute_parameters}'
            - storage_profile: '${storage_profile}'
            - unique_id: '${unique_id_for_vm}'
        publish:
          - vapp_request_body: '${return_result}'
        navigate:
          - SUCCESS: create_vapp_api_call
  outputs:
    - return_result
    - return_code
    - exception
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_template_details:
        x: 40
        'y': 120
      create_vapp_api_call:
        x: 360
        'y': 120
        navigate:
          e5ab9dd5-9e18-47ab-6d0b-ca2f6c6054c2:
            targetId: 39b3c3fe-524e-b2fb-d62e-f1abcd08f3ba
            port: SUCCESS
      form_vapp_request_body:
        x: 200
        'y': 120
    results:
      SUCCESS:
        39b3c3fe-524e-b2fb-d62e-f1abcd08f3ba:
          x: 520
          'y': 120
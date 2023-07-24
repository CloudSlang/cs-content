#   (c) Copyright 2023 Open Text
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
#! @description: This operation is used to set labels for the database instance.
#!
#! @input access_token: The authorization token for google cloud.
#! @input project_id: Google Cloud project name.
#!                    Example: 'example-project-a'
#! @input instance_name: Name of the database Instance
#! @input worker_group: A worker group is a logical collection of workers. A worker may belong to more than
#!                      one group simultaneously.
#!                      Default: 'RAS_Operator_Path'
#!                      Optional
#! @input proxy_host: Proxy server used to access the provider services.
#!                    Optional
#! @input proxy_port: Proxy server port used to access the provider services.
#!                    Optional
#! @input proxy_username: Proxy server user name.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the <proxy_username> input value.
#!                        Optional
#! @input trust_all_roots: Specifies whether to enable weak security over SSL.
#!                         Default: 'false'
#!                         Optional
#! @input x_509_hostname_verifier: Specifies the way the server hostname must match a domain name in
#!                                 the subject's Common Name (CN) or subjectAltName field of the X.509 certificate
#!                                 Valid: 'strict', 'browser_compatible', 'allow_all'
#!                                 Default: 'strict'
#!                                 Optional
#! @input trust_keystore: The pathname of the Java TrustStore file. This contains certificates from
#!                        other parties that you expect to communicate with, or from Certificate Authorities that
#!                        you trust to identify other parties.  If the protocol (specified by the 'url') is not
#!                        'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Default value: '..JAVA_HOME/java/lib/security/cacerts'
#!                        Format: Java KeyStore (JKS)
#!                        Optional
#! @input trust_password: The password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#!                        Optional
#! @input hcmx_ci_instance_id: HCMX ci instance id. Default: '' Optional
#! @input hcmx_service_component_id: HCMX service component id. Default: '' Optional
#! @input hcmx_service_instance_id: HCMX service instance id. Default: '' Optional
#! @input hcmx_subscription_owner: HCMX subscription owner. Default: '' Optional
#! @input hcmx_subscription_id: HCMX subscription id. Default: '' Optional
#! @input hcmx_tenant_id: HCMX tenant id. Default: '' Optional
#!
#! @output return_result: This will contain the response entity.
#! @output status_code: 200 if request completed successfully, others in case something went wrong.
#!
#! @result SUCCESS: The database instance labels  has been  successfully set.
#! @result FAILURE: There was an error while trying to set labels for the the database instance.
#!!#
########################################################################################################################
namespace: io.cloudslang.google.databases.instances
imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
flow:
  name: set_database_labels
  inputs:
    - access_token:
        sensitive: true
    - project_id:
        sensitive: true
    - instance_name
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
    - hcmx_ci_instance_id:
        required: false
    - hcmx_service_component_id:
        required: false
    - hcmx_service_instance_id:
        required: false
    - hcmx_subscription_owner:
        required: false
    - hcmx_subscription_id:
        required: false
    - hcmx_tenant_id:
        required: false
  workflow:
    - list_to_json:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.google.databases.instances.utils.list_to_json:
            - hcmx_ci_instance_id: '${hcmx_ci_instance_id}'
            - hcmx_service_instance_id: '${hcmx_service_instance_id}'
            - hcmx_subscription_owner: '${hcmx_subscription_owner}'
            - hcmx_subscription_id: '${hcmx_subscription_id}'
            - hcmx_service_component_id: '${hcmx_service_component_id}'
            - hcmx_tenant_id: '${hcmx_tenant_id}'
        publish:
          - result
        navigate:
          - SUCCESS: api_call_for_set_labels
    - api_call_for_set_labels:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_patch:
            - url: "${'https://sqladmin.googleapis.com/v1/projects/'+project_id+'/instances/'+instance_name}"
            - auth_type: anonymous
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - request_character_set: utf-8
            - headers: "${'Authorization: '+access_token}"
            - body: "${'{\"settings\" : {\"userLabels\" : '+ result+'}}'}"
            - content_type: application/json
            - worker_group: '${worker_group}'
        publish:
          - return_result
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - return_result
    - status_code
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      list_to_json:
        x: 160
        'y': 400
      api_call_for_set_labels:
        x: 160
        'y': 200
        navigate:
          46296591-b011-90db-be37-f1d36d53a0b7:
            targetId: 11a314fb-962f-5299-d0a5-ada1540d2904
            port: SUCCESS
    results:
      SUCCESS:
        11a314fb-962f-5299-d0a5-ada1540d2904:
          x: 400
          'y': 200


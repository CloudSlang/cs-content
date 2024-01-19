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
#! @description: This operation is used to get the machine type that can be used to create an instance.
#!
#! @input json_token: Content of the Google Cloud service account JSON.
#! @input project_id: Google Cloud project id.
#!                    Example: "example-project-a".
#! @input zone: The name of the zone where the Disk resource is located.
#!              Examples: "us-central1-a", "us-central1-b", "us-central1-c".
#! @input machine_type: The machine type resource to use for this instance.
#!                      Example : "n1-standard-1".
#! @input scopes: Scopes that you might need to request to access Google Compute APIs, depending on the level of access you need.
#!                One or more scopes may be specified delimited by the <scopesDelimiter>.
#!                For a full list of scopes see https://developers.google.com/identity/protocols/googlescopes#computev1
#!                Note: It is recommended to use the minimum necessary scope in order to perform the requests.
#!                Example: 'https://www.googleapis.com/auth/compute.readonly'
#! @input auth_type: The authentication type.
#!                   Example : "basic".
#!                   Optional
#! @input proxy_host: The proxy server used to access the provider services.
#!                    Optional
#! @input proxy_port: The proxy server used to access the provider services.
#!                    Optional
#! @input proxy_username: The proxy server user name.
#!                        Optional
#! @input proxy_password: The proxy server password associated with the proxy_username input value.
#!                        Optional
#! @input worker_group: A worker group is a logical collection of workers. A worker may belong to more than
#!                      one group simultaneously.
#!                      Default: 'RAS_Operator_Path'
#!                      Optional
#! @input connect_timeout: The time to wait for a connection to be established, in seconds. A timeout value of '0'
#!                         represents an infinite timeout.
#!                         Default: '0'
#!                         Optional
#!
#! @output self_link: The URI of this resource.
#! @output return_code: "0" if operation was successfully executed, "-1" otherwise.
#! @output error_message: error message if one exists, empty otherwise
#! @output return_result: Task result or operation result.
#!!#
########################################################################################################################
namespace: io.cloudslang.google.compute.compute_engine.instances
flow:
  name: get_machine_type
  inputs:
    - json_token:
        sensitive: true
    - project_id:
        sensitive: true
    - zone
    - machine_type
    - scopes:
        default: 'https://www.googleapis.com/auth/compute'
        required: true
    - auth_type:
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
    - worker_group:
        default: RAS_Operator_Path
        required: false
    - connect_timeout:
        default: '0'
        required: false
  workflow:
    - get_access_token:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.google.authentication.get_access_token:
            - json_token:
                value: '${json_token}'
                sensitive: true
            - scopes: '${scopes}'
            - timeout: '600'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
        publish:
          - return_result: "${'Authorization: Bearer '+ str(return_result) +''}"
        navigate:
          - SUCCESS: http_client_get_Machine_Type
          - FAILURE: on_failure
    - http_client_get_Machine_Type:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${'https://compute.googleapis.com/compute/v1/projects/'+ str(project_id)+'/zones/'+str(zone)+'/machineTypes/'+str(machine_type)+''}"
            - auth_type: '${auth_type}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - connect_timeout: '${connect_timeout}'
            - headers: '${return_result}'
        publish:
          - return_result
          - error_message
          - status_code
        navigate:
          - SUCCESS: get_self_Link_of_the_Machine_Type
          - FAILURE: on_failure
    - get_self_Link_of_the_Machine_Type:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${return_result}'
            - json_path: selfLink
        publish:
          - self_link: '${return_result}'
          - return_code
          - error_message
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - self_link
    - return_code
    - error_message
    - return_result
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_access_token:
        x: 44
        'y': 157
      http_client_get_Machine_Type:
        x: 194
        'y': 158
      get_self_Link_of_the_Machine_Type:
        x: 338
        'y': 166
        navigate:
          f6e15fd4-1151-c4db-b618-2bbb40f552e0:
            targetId: 39b3c3fe-524e-b2fb-d62e-f1abcd08f3ba
            port: SUCCESS
    results:
      SUCCESS:
        39b3c3fe-524e-b2fb-d62e-f1abcd08f3ba:
          x: 473
          'y': 164

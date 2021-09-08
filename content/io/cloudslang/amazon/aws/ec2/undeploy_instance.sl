#   (c) Copyright 2019 EntIT Software LLC, a Micro Focus company, L.P.
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
#! @description: This flow terminates an instance. If the resources attached to the instance were created with the
#!               attribute delete_on_termination = true, they would be deleted when the instance is terminated,
#!               otherwise they would be only detached.
#!
#! @input identity: ID of the secret access key associated with your Amazon AWS account.
#! @input credential: Secret access key associated with your Amazon AWS account.
#! @input proxy_host: Proxy server used to access the provider services.
#! @input proxy_port: Proxy server port used to access the provider services.
#!                    Default: '8080'
#! @input proxy_username: Proxy server user name.
#! @input proxy_password: Proxy server password associated with the proxyUsername input value.
#! @input headers: String containing the headers to use for the request separated by new line (CRLF). The header
#!                 name-value pair will be separated by ":". Format: Conforming with HTTP standard for headers (RFC 2616).
#!                 Examples: "Accept:text/plain"
#! @input instance_id: The ID of the instance to be terminated.
#! @input polling_interval: The number of seconds to wait until performing another check.
#!                          Default: 10
#! @input polling_retries: The number of retries to check if the instance is stopped.
#!                         Default: 50
#!
#! @output output: contains the success message or the exception in case of failure
#! @output return_code: "0" if operation was successfully executed, "-1" otherwise
#! @output exception: Exception if there was an error when executing, empty otherwise
#!
#! @result SUCCESS: The server (instance) was successfully terminated
#! @result FAILURE: error terminating instance
#!!#
########################################################################################################################

namespace: io.cloudslang.amazon.aws.ec2

imports:
  network: io.cloudslang.amazon.aws.ec2.network
  instances: io.cloudslang.amazon.aws.ec2.instances

flow:
  name: undeploy_instance
  inputs:
    - identity
    - credential
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
    - headers:
        required: false
    - instance_id
    - polling_interval:
        required: false
    - polling_retries:
        required: false

  workflow:
    - terminate_instances:
        do:
          instances.terminate_instances:
            - identity
            - credential
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - headers
            - instance_ids_string: '${instance_id}'
        publish:
          - output: '${return_result}'
          - return_code
          - exception
        navigate:
          - SUCCESS: check_instance_state
          - FAILURE: on_failure

    - check_instance_state:
        loop:
          for: 'step in range(0, int(get("polling_retries", 50)))'
          do:
            instances.check_instance_state:
              - identity
              - credential
              - proxy_host
              - proxy_port
              - proxy_username
              - proxy_password
              - instance_id
              - instance_state: terminated
              - polling_interval
          break:
            - SUCCESS
          publish:
            - output
            - return_code
            - exception
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure

  outputs:
    - output
    - return_code
    - exception

  results:
    - SUCCESS
    - FAILURE

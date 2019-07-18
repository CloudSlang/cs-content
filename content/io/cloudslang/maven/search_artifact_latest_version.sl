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
#! @description: This flow returns the latest version of the artifact and lists details for most
#!               recent version released.
#!
#! @input artifact_id: Name of the artifact that you are searching in the Maven repository.
#!                       Example: 'cs-mail'
#! @input url: URL to the maven resource that the REST call is made.
#!             Default: 'http://search.maven.org/solrsearch/select?q=artifact_id&rows=20&wt=json'
#! @input proxy_host: Optional - Proxy server used to access the Maven repository (if required).
#! @input proxy_port: Optional - Proxy server port.
#!                    Default: '8080'
#! @input proxy_username: Optional - Username used when connecting to the proxy.
#! @input proxy_password: Optional - Proxy server password associated with the <proxy_username> input value.
#!
#! @output output: Full details about the specified artifact.
#! @output status_code: 200 if request completed successfully, others in case something went wrong.
#! @output version: The latest version of the artifact.
#!                  The version response will be empty ([]) if there is no artifact with that name.
#! @output return_code: '0' if success, '-1' otherwise.
#! @output error_message: If there is an error while trying to retrieve the latest artifact version.
#!
#! @result SUCCESS: The artifact version was retrieved successfully and return code = '0'.
#! @result FAILURE: There was an error while trying to retrieve the artifact version and return_code is '-1'.
#!!#
########################################################################################################################

namespace: io.cloudslang.maven

imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json

flow:
  name: search_artifact_latest_version

  inputs:
    - url:
        default: ${'http://search.maven.org/solrsearch/select?q=' + artifact_id + '&rows=20&wt=json'}
    - artifact_id:
        default: 'cs-mail'
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

  workflow:
    - search_artifact:
        do:
          http.http_client_get:
            - url
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
        publish:
          - output: ${return_result}
          - status_code
          - error_message
        navigate:
          - SUCCESS: retrieve_latest_version
          - FAILURE: FAILURE

    - retrieve_latest_version:
        do:
          json.json_path_query:
            - json_object: ${output}
            - json_path: 'response.docs.*.latestVersion'
        publish:
          - return_result
          - return_code
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE

  outputs:
    - output
    - status_code
    - version: ${return_result}
    - return_code
    - error_message

  results:
    - SUCCESS
    - FAILURE


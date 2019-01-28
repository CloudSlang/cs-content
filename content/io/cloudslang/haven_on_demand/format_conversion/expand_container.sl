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
#! @description: Extracts content from container files.
#!
#! @input api_key: API Keys
#! @input file: container file to expand
#! @input proxy_host: proxy server
#!                    optional
#! @input proxy_port: proxy server port
#!                    optional
#!                    default: '8080'
#!
#! @output references: references to content from the container file
#! @output error_message: error message if one exists, empty otherwise
#!
#! @result SUCCESS: container files content extracted successfully
#! @result FAILURE: There was an error while trying to extract content from the container files
#!!#
########################################################################################################################

namespace: io.cloudslang.haven_on_demand.format_conversion

imports:
  http: io.cloudslang.base.http
  print: io.cloudslang.base.print
  hod: io.cloudslang.haven_on_demand

flow:
  name: expand_container

  inputs:
    - api_key:
        sensitive: true
    - expand_container_api:
        default: "https://api.havenondemand.com/1/api/sync/expandcontainer/v1"
        private: true
    - file
    - proxy_host:
        required: false
    - proxy_port:
        required: false

  workflow:
    - expand_container:
        do:
          http.http_client_action:
            - url: ${str(expand_container_api)}
            - method: POST
            - proxy_host
            - proxy_port
            - multipart_bodies: ${"apikey=" + str(api_key)}
            - multipart_files: ${"file=" + file}
        publish:
            - error_message
            - return_result

    - get_results:
        do:
          hod.utils.get_docs_references:
           - json_input: ${return_result}
           - key: files
        publish:
           - references
           - error_message

    - on_failure:
          - print_fail:
                do:
                  print.print_text:
                    - text: ${"Error - " + error_message}

  outputs:
      - references
      - error_message

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
#! @description: Extracts metadata and text content from a file.
#!
#! @input api_key: API Key
#! @input text_extraction_api: URL to the HoD APi
#! @input reference: Haven OnDemand reference
#! @input additional_metadata: Optional - JSON object containing additional metadata to add
#!                             to the extracted documents.
#! @input extract_metadata: Optional - whether to extract metadata from the file.
#!                          default: true
#! @input extract_text: Optional - whether to extract text from the file
#!                      default: true
#! @input extract_xmlattributes: Optional - whether to extract XML attributes from the file.
#!                               default: false
#! @input password: Optional - password to use to extract the files
#! @input reference_prefix: string to add to the start of the reference of
#!                          documents that are extracted from a file. To add a
#!                          prefix for multiple files, specify prefixes in order,
#!                          separated by a space.
#!                          Optional
#! @input proxy_host: Optional - proxy server
#! @input proxy_port: Optional - proxy server port
#!
#! @output return_result: result of API
#! @output error_message: error message if one exists, empty otherwise
#!
#! @result SUCCESS: metadata and content successfully extracted from the file
#! @result FAILURE: There was an error while trying to extract metadata and/or context from the file
#!!#
########################################################################################################################

namespace: io.cloudslang.haven_on_demand.format_conversion

imports:
  http: io.cloudslang.base.http
  print: io.cloudslang.base.print

flow:
  name: text_extraction

  inputs:
    - api_key:
        sensitive: true
    - text_extraction_api:
        default: "https://api.havenondemand.com/1/api/sync/extracttext/v1"
        private: false
    - reference
    - additional_metadata:
        default: ""
        required: false
    - extract_metadata:
        default: "true"
        required: false
    - extract_text:
        default: "true"
        required: false
    - extract_xmlattributes:
        default: "false"
        required: false
    - password:
        required: false
        sensitive: true
    - reference_prefix:
        required: false
    - proxy_host:
        required: false
    - proxy_port:
        required: false

  workflow:
    - connect_to_server:
        do:
          http.http_client_post:
            - url: >
                ${str(text_extraction_api) + '?reference=' + str(reference) + '&additional_metadata=' +
                str(additional_metadata) + '&extract_metadata=' + extract_metadata + '&extract_text=' + extract_text +
                '&extract_xmlattributes=' + extract_xmlattributes + '&password=' + str(password) +
                '&reference_prefix=' + str(reference_prefix) + '&apikey=' + str(api_key)}
            - proxy_host
            - proxy_port
        publish:
          - error_message
          - return_result

    - on_failure:
        - print_fail:
            do:
              print.print_text:
                - text: ${"Error - " + error_message}

  outputs:
    - error_message
    - return_result

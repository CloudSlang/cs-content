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
#! @description: Adds content to an already existing text index.
#!
#! @input api_key: API key
#! @input reference: Optional - Haven OnDemand reference
#!                   exactly one of <reference>, <json> is required
#! @input json: Optional - JSON document to index
#!              exactly one of <reference>, <json> is required
#! @input index: name of the index to add to
#! @input additional_metadata: Optional - JSON object containing additional metadata to add to the indexed documents.
#!                             To add metadata for multiple files, specify objects in order, separated by an empty object.
#! @input duplicate_mode: Optional - method to use to handle duplicate documents
#!                        valid: duplicate, replace
#!                        default: replace
#! @input reference_prefix: Optional - string to add to the start of the reference of
#!                          documents that are extracted from a file.
#!                          To add a prefix for multiple files, specify prefixes
#!                          in order, separated by a space.
#! @input proxy_host: Optional - proxy server
#! @input proxy_port: Optional - proxy server port
#!
#! @output return_result: result of API
#! @output error_message: error message if one exists, empty otherwise
#!
#! @result SUCCESS: content successfully added to the text index
#! @result FAILURE: There was an error while trying to add content to the text index
#!!#
########################################################################################################################

namespace: io.cloudslang.haven_on_demand.unstructured_text_indexing

imports:
  http: io.cloudslang.base.http
  print: io.cloudslang.base.print

flow:
  name: add_to_text_index

  inputs:
    - api_key:
        sensitive: true
    - add_to_text_index_api:
        default: "https://api.havenondemand.com/1/api/sync/addtotextindex/v1"
        private: true
    - reference:
        required: false
    - json:
        required: false
    - index
    - additional_metadata:
        default: ""
        required: false
    - duplicate_mode:
        default: ""
        required: false
    - reference_prefix:
        default: ""
        required: false
    - proxy_host:
        required: false
    - proxy_port:
        required: false

  workflow:
    - connect_to_server:
        do:
          http.http_client_post:
            - url: ${str(add_to_text_index_api)}
            - proxy_host
            - proxy_port
            - body: >
                ${("reference=" + str(reference)) if reference else ("json=" + str(json)) + "&index=" + str(index) +
                "&additional_metadata=" + str(additional_metadata) + "&duplicate_mode=" + str(duplicate_mode) +
                "&reference_prefix=" + str(reference_prefix) + "&apikey=" + str(api_key)}
            - content_type: "application/x-www-form-urlencoded"
        publish:
            - error_message
            - return_result

    - on_failure:
        - print_fail:
            do:
              print.print_text:
                - text: ${"Error - " + str(error_message)}
  outputs:
    - error_message
    - return_result

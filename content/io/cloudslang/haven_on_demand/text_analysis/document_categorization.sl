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
#! @description: Categorizes documents according to a set of categories that you create.
#!
#! @input api_key: API key
#! @input reference: Haven OnDemand reference
#! @input index: text index to search for matching categories. Must be of the categorization flavor.
#! @input max_results: Optional - maximum number of categories to return
#!                     default: 10
#! @input print_value: Optional - types of fields and content to display in the results
#!                     default: fields
#! @input print_fields: names of fields to print in the results
#! @input proxy_host: Optional - proxy server
#! @input proxy_port: Optional - proxy server port
#!
#! @output return_result: result of API
#! @output error_message: error message if one exists, empty otherwise
#!
#! @result SUCCESS: documents successfully categorized based on categories created
#! @result FAILURE: There was an error while trying to categorize the documents
#!!#
########################################################################################################################

namespace: io.cloudslang.haven_on_demand.text_analysis

imports:
  http: io.cloudslang.base.http
  print: io.cloudslang.base.print

flow:
  name: document_categorization

  inputs:
    - api_key:
        sensitive: true
    - document_categorization_api:
        default: "https://api.havenondemand.com/1/api/sync/categorizedocument/v1"
        private: true
    - reference
    - index
    - max_results:
        default: "10"
        required: false
    - print_value:
        default: "fields"
        required: false
    - print_fields:
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
            - url: >
                ${str(document_categorization_api)+"?reference=" + str(reference) + "&index=" + str(index) +
                "&max_results=" + max_results + "&print=" + str(print_value) + "&print_fields=" +
                str(print_fields) + "&apikey=" + str(api_key)}
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

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
#! @description: Retrieves the unique values that occur in a particular field.
#!
#! @input api_key: API key
#! @input field_name: comma-separated list of field names to return values for
#! @input document_count: Optional - set to true to show the number of documents that
#!                        contain a parametric tag value
#!                        default: true
#! @input field_text: Optional - fields that result documents must contain, and the
#!                    conditions that these fields must meet for the documents
#!                    to return as results
#! @input indexes: Optional - text indexes to use to perform the parametric search
#! @input max_values: Optional - maximum number of values to return for each matched field name
#!                    valid: between 1 and 10000
#!                    default: 100
#! @input min_score: Optional - minimum percentage relevance that results must have for the
#!                   query to return
#!                   default: 0
#! @input sort: Optional - criteria to use for the result display order
#!              valid: off, document_count, alphabetical, reverse_alphabetical
#!                     number_increasing, number_decreasing
#!              default: off
#! @input text: Optional - query text
#!              default: *
#! @input query_profile: name of the query profile to apply
#! @input proxy_host: Optional - proxy server
#! @input proxy_port: Optional - proxy server port
#!
#! @output return_result: result of API
#! @output error_message: error message if one exists, empty otherwise
#!
#! @result SUCCESS: unique values from a particular field retrieved successfully
#! @result FAILURE: There was an error while trying to retrieve the unique values
#!!#
########################################################################################################################

namespace: io.cloudslang.haven_on_demand.search

imports:
  http: io.cloudslang.base.http
  print: io.cloudslang.base.print

flow:
  name: get_parametric_values

  inputs:
    - api_key:
        sensitive: true
    - get_parametric_values_api:
        default: "https://api.havenondemand.com/1/api/sync/getparametricvalues/v1"
        private: true
    - field_name
    - document_count:
        default: "true"
        required: false
    - field_text:
        default: ""
        required: false
    - indexes:
        default: ""
        required: false
    - max_values:
        default: "100"
        required: false
    - min_score:
        default: "0"
        required: false
    - sort:
        default: "off"
        required: false
    - text:
        default: '*'
        required: false
    - query_profile:
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
            - url: ${str(get_parametric_values_api) + '?field_name=' + str(field_name) + '&document_count='+ document_count + '&field_text=' + str(field_text) + '&indexes=' + str(indexes) + '&max_values=' + max_values +'&min_score=' + min_score + '&sort=' + str(sort) + '&text=' + str(text) +'&query_profile=' + str(query_profile) + '&apikey=' + str(api_key)}
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

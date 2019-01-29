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
#! @description: Creates a text index, which you can use to add your own content to Haven OnDemand.
#!
#! @input api_key: API key
#! @input index: name of index to create
#! @input flavor: Optional - configuration flavor of the text index
#!                valid: explorer, standard, categorization, custom_fields,
#!                       jumbo, querymanipulation
#!                default: explorer
#! @input description: Optional - description of the index
#! @input index_fields: Optional - custom fields that you want to define with the Index field type.
#!                      Relevant only for standard, custom_fields, explorer and jumbo flavors.
#! @input parametric_fields: Optional - custom fields that you want to define with the Parametric field type.
#!                           Relevant only for standard, categorization, custom_fields, explorer and jumbo flavors.
#! @input expire_time: Optional - time in minutes until a document in the index becomes eligible for automatic expiry.
#!                     Relevant only for standard, categorization, custom_fields, explorer and jumbo flavors.
#!                     default: 1
#! @input expire_date_fields: Optional - custom fields that you want to define with the Expire Date field type.
#!                            Relevant only for the custom_fields flavor.
#! @input numeric_fields: Optional - custom fields that you want to define with the Numeric field type.
#!                        Relevant only for the Custom_Fields flavor.
#! @input display_name: display name for the index
#! @input proxy_host: Optional - proxy server
#! @input proxy_port: Optional - proxy server port
#!
#! @output return_result: result of API
#! @output error_message: error message if one exists, empty otherwise
#!
#! @result SUCCESS: text index created successfully
#! @result FAILURE: There was an error while trying to create text index
#!!#
########################################################################################################################

namespace: io.cloudslang.haven_on_demand.unstructured_text_indexing

imports:
  http: io.cloudslang.base.http
  print: io.cloudslang.base.print

flow:
  name: create_text_index

  inputs:
    - api_key:
        sensitive: true
    - create_text_index_api:
        default: "https://api.havenondemand.com/1/api/sync/createtextindex/v1"
        private: true
    - index
    - flavor:
        default: "explorer"
        required: false
    - description:
        default: ""
        required: false
    - index_fields:
        default: ""
        required: false
    - parametric_fields:
        default: ""
        required: false
    - expire_time:
        default: ""
        required: false
    - expire_date_fields:
        default: ""
        required: false
    - numeric_fields:
        default: ""
        required: false
    - display_name:
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
                ${str(create_text_index_api) + '?index=' + str(index) + '&flavor=' + str(flavor) + '&description=' +
                str(description) + '&index_fields=' + '&index_fields'.join(index_fields.split(',')) +
                '&parametric_fields=' + str(parametric_fields) + '&expire_time=' + str(expire_time) +
                '&expire_date_fields=' + str(expire_date_fields) + '&numeric_fields=' +
                str(numeric_fields) + '&display_name=' +
                str(display_name) + '&apikey=' + str(api_key)}
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

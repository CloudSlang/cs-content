#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: The Create Text Index API allows you to create a text index, which you can use to add your own content to Haven OnDemand. You specify a name for the text index, which you can use to add data, and modify the index in future operations.
#! @input api_key: The API key to use to authenticate the API request.
#! @input create_text_index_api:
#! @input index: The name of the index to create.
#! @input flavor: The configuration flavor of the text index. See Index Flavors. Default value: explorer.
#! @input description: A brief description of the index.
#! @input index_fields: Custom fields that you want to define with the Index field type. Index fields contain document content, which receives linguistic processing for keyword and conceptual search.
#!                      This parameter is relevant only for Standard, Custom Fields, Explorer and Jumbo flavors
#! @input parametric_fields: Custom fields that you want to define with the Parametric field type. Parametric fields contain values that you want to use for search filtering and exact matches.
#!                            This parameter is relevant only for Standard, Categorization, Custom Fields, Explorer and Jumbo flavors.
#! @input expire_time: The time in minutes until a document in the index becomes eligible for automatic expiry. This parameter is relevant only for Standard, Categorization, Custom Fields, Explorer and Jumbo flavors.
#! @input expire_date_fields: Custom fields that you want to define with the Expire Date field type. Expire Date fields contain a date that you want to use to automatically expire the document.
#!                            This parameter is relevant only for the Custom_Fields flavor.
#! @input numeric_fields: Custom fields that you want to define with the Numeric field type. Numeric fields contain numeric values that you want to use for searches.
#!                        This parameter is relevant only for the Custom_Fields flavor.
#! @input display_name: A friendly name for the index.
#! @input proxy_host: optional - proxy server used to access the web site
#! @input proxy_port: optional - proxy server port - Default: '8080'
#! @output result: result: result The Create Text Index API
#! @output error_message: error message if there was an error when executing, empty otherwise
#!!#
####################################################

namespace: io.cloudslang.haven_on_demand.ediscovery.add_to_text_index

imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
  base: io.cloudslang.base.print

flow:
  name: create_text_index

  inputs:
    - api_key:
        default: ${get_sp('io.cloudslang.haven_on_demand.ediscovery.api_key')}
        sensitive: true
    - create_text_index_api: ${get_sp('io.cloudslang.haven_on_demand.ediscovery.create_text_index_api')}
    - index
    - flavor
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
        default: "1"
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
        default: ${get_sp('io.cloudslang.haven_on_demand.ediscovery.proxy_host')}
        required: false
    - proxy_port:
        default: ${get_sp('io.cloudslang.haven_on_demand.ediscovery.proxy_port')}
        required: false

  workflow:
      - connect_to_server:
          do:
            http.http_client_post:
              - url: ${str(create_text_index_api) + '?index=' + str(index) + '&flavor=' + str(flavor) + '&description=' + str(description) + '&index_fields=' + str(index_fields) + '&parametric_fields=' + str(parametric_fields) + '&expire_time=' + str(expire_time) + '&expire_date_fields=' + str(expire_date_fields) + '&numeric_fields=' + str(numeric_fields) + '&display_name=' + str(display_name) + '&apikey=' + str(api_key)}
              - proxy_host
              - proxy_port

          publish:
              - error_message
              - return_result
              - return_code

      - on_failure:
            - print_fail:
                  do:
                    base.print_text:
                       - text: ${str(return_result)}
  outputs:
      - error_message
      - result: ${return_result}

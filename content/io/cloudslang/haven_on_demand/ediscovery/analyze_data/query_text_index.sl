#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: The Query Text Index API searches for content in the Haven OnDemand databases. Your query can include natural language text, keywords, and Boolean expressions. The API returns documents from a specified text index that matches your query expression.
#! @input api_key: The API key to use to authenticate the API request.
#! @input query_text_index_api:
#! @input text: The query text.
#! @input absolute_max_results:  The absolute maximum number of results to return for this query. Default value: 6.
#! @input check_spelling: Whether to check the spelling of the input text. Default value: none.
#! @input end_tag: The closing HTML tag to use to highlight a match. If omitted, this is generated automatically from the start_tag.
#! @input field_text: The fields that result documents must contain, and the conditions that these fields must meet for the documents to return as results.
#! @input highlight: The highlighting option to use for the result text. Default value: off.
#! @input ignore_operators: This option disables wildcards, phrase queries, field restriction, and Boolean operations. Default value: false.
#! @input indexs: The text index to use to perform the parametric search. Default value: [wiki_eng].
#! @input max_date: The latest creation date or time that a document can have to return as a result.
#! @input max_page_results: The maximum number of results to return for this query from the absolute number of results returned. You can use this option with the start parameter to page results.
#!                          In this case, max_page_results sets the number of results to return in a particular page, while absolute_max_results sets the total maximum number of results the query can return.
#! @input min_date: The earliest creation date or time that a document can have to return as a result.
#! @input min_score: The minimum percentage relevance that results must have to the query to return. Default value: 0.
#! @input print_value: The types of fields and content to display in the results. Default value: fields.
#! @input print_fields: The names of fields to print in the results.
#! @input promotion: Set this parameter to true to return only promotion documents that return from query manipulation. This parameter is available only when you set the query_profile parameter. Default value: false.
#! @input query_profile: The name of the query profile that you want to apply.
#! @input sort: The criteria to use for the result display order. By default, results are displayed in order of relevance. Default value: relevance.
#! @input start: The number of the first result to display from the total list. You can use this option to return the query results in pages.
#!               This value must be greater than 1, and smaller than the value of absolute_max_results. Default value: 1.
#! @input start_tag: The opening HTML tag to use to highlight a match. Default value: <span style="background-color: yellow"> ('%3Cspan+style%3D%22background-color%3A+yellow%22%3E').
#! @input summary: The type of summary to create for result documents. Default value: off.
#! @input total_results: Set to true to return an estimate of the total number of result documents, and the total number of documents and document sections in the query text indexes.
#!                       This value is the number of matching documents in the specified text indexes, which might be larger than the value of absolute_max_results, or max_page_results. Default value: false.
#! @input proxy_host: optional - proxy server used to access the web site
#! @input proxy_port: optional - proxy server port - Default: '8080'
#! @output referneces: A Haven OnDemand referneces obtained from the Expand Container
#! @output error_message: error message if there was an error when executing, empty otherwise
#!!#
####################################################
namespace: io.cloudslang.haven_on_demand.ediscovery.analyze_data

imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
  base: io.cloudslang.base.print
  ediscovery: io.cloudslang.haven_on_demand.ediscovery

flow:
  name: query_text_index

  inputs:
    - api_key:
        default: ${get_sp('io.cloudslang.haven_on_demand.ediscovery.api_key')}
        sensitive: true
    - query_text_index_api: ${get_sp('io.cloudslang.haven_on_demand.ediscovery.query_text_index_api')}
    - text
    - absolute_max_results:
        required: false
        default: ""
    - check_spelling:
        required: false
        default: ""
    - end_tag:
        required: false
        default: ""
    - field_text:
        required: false
        default: ""
    - highlight:
        required: false
        default: ""
    - ignore_operators:
        required: false
        default: false
    - indexes
    - max_date:
        required: false
        default: ""
    - max_page_results:
        required: false
        default: ""
    - min_date:
        required: false
        default: ""
    - min_score:
        required: false
        default: 0
    - print_value:
        default: "fields"
    - print_fields:
        required: false
        default: ""
    - promotion:
        required: false
        default: false
    - query_profile:
        required: false
        default: ""
    - sort:
        required: false
        default: 'relevance'
    - start:
        required: false
        default: 1
    - start_tag:
        required: false
        default: '%3Cspan+style%3D%22background-color%3A+yellow%22%3E'
    - summary:
        required: false
        default: "off"
    - total_results:
        required: false
        default: false
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
              - url: ${str(query_text_index_api) + '?text=' + str(text) + '&absolute_max_results=' + str(absolute_max_results) + '&check_spelling=' + str(check_spelling) + '&end_tag=' + str(end_tag) + '&field_text='+ str(field_text) + '&highlight='+ str(highlight) + '&ignore_operators=' + str(ignore_operators) + '&indexes=' + str(indexes) + '&max_date=' + str(max_date) + '&max_page_results='+ str(max_page_results) + '&min_date='+ str(min_date) + '&min_score='+ str(min_score) + '&print='+ str(print_value) + '&print_fields='+ str(print_fields) + '&promotion=' + str(promotion) + '&query_profile=' + str(query_profile) +  '&sort=' + str(sort) + '&start=' + str(start) + '&start_tag=' + str(start_tag) + '&summary=' + str(summary) + '&total_results=' + str(total_results) + '&apikey=' + str(api_key)}
              - proxy_host
              - proxy_port

          publish:
              - error_message
              - return_result
              - return_code

          navigate:
             - SUCCESS: get_docs_references
             - FAILURE: FAILURE

       - get_docs_references:
           do:
             ediscovery.get_docs_references:
                - json_input: ${return_result}
                - key: "documents"
           publish:
              - error_message
              - references

       - on_failure:
            - print_fail:
                  do:
                    base.print_text:
                      - text: "${error_message}"
  outputs:
      - error_message
      - references

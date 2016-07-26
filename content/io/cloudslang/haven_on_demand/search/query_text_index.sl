#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Searches for content in the Haven OnDemand databases.
#! @input api_key: API key
#! @input text: query text.
#! @input absolute_max_results: absolute maximum number of results to return for
#!                              this query
#!                              optional
#!                              default: 6
#! @input check_spelling: whether to check the spelling of the input text
#!                        optional
#!                        valid: none, suggest, autocorrect
#!                        default: none
#! @input end_tag: closing HTML tag to use to highlight a match
#!                 optional
#! @input field_text: fields that result documents must contain, and the
#!                    conditions that these fields must meet for the documents
#!                    to return as results
#!                    optional
#! @input highlight: highlighting option to use for the result text
#!                   optional
#! @input ignore_operators: disables wildcards, phrase queries, field
#!                          restriction, and boolean operations
#!                          optional
#!                          default: false
#! @input index: text index to search in
#!               default: "wiki_eng"
#! @input max_date: latest creation date or time that a document can have to
#!                  return as a result
#!                  optional
#! @input max_page_results: maximum number of results to return for this query
#!                          from the absolute number of results returned. You
#!                          can use this option with the start parameter to page
#!                          results. In this case, max_page_results sets the
#!                          number of results to return in a particular page,
#!                          while absolute_max_results sets the total maximum
#!                          number of results the query can return.
#!                          optional
#! @input min_date: earliest creation date or time that a document can have to
#!                  return as a result
#!                  optional
#! @input min_score: minimum percentage relevance that results must have to the
#!                   query to return
#!                   optional
#!                   default: 0
#! @input print_value: types of fields and content to display in the results
#!                     optional
#!                     default: fields
#! @input print_fields: names of fields to print in the results
#!                      optional
#! @input promotion: set to true to return only promotion documents that return
#!                   from query manipulation. Available only when you set the
#!                   query_profile parameter.
#!                   optional
#!                   default: false
#! @input query_profile: name of the query profile that you want to apply
#!                       optional
#! @input sort: criteria to use for the result display order.
#!              optional
#!              default: relevance.
#! @input start: number of the first result to display from the total list.
#!               Must be greater than 1, and smaller than the value of
#!               absolute_max_results
#!               optional
#!               default: 1
#! @input start_tag: opening HTML tag to use to highlight a match
#!                   optional
#!                   default value: <span style="background-color: yellow">
#! @input summary: type of summary to create for result documents
#!                 optional
#!                 valid: concept, context, quick, off
#!                 default: off
#! @input total_results: set to true to return an estimate of the total number
#!                       of result documents, and the total number of documents
#!                       and document sections in the query text indexes
#!                       optional
#!                       default: false.
#! @input proxy_host: proxy server
#!                    optional
#! @input proxy_port: proxy server port
#!                    optional
#! @output return_result: result of API
#! @output error_message: error message if one exists, empty otherwise
#!!#
####################################################

namespace: io.cloudslang.haven_on_demand.search

imports:
  http: io.cloudslang.base.http
  print: io.cloudslang.base.print

flow:
  name: query_text_index

  inputs:
    - api_key:
        sensitive: true
    - query_text_index_api:
        default: "https://api.havenondemand.com/1/api/sync/querytextindex/v1"
        private: true
    - text
    - absolute_max_results:
        default: "6"
        required: false
    - check_spelling:
        default: "none"
        required: false
    - end_tag:
        default: ""
        required: false
    - field_text:
        default: ""
        required: false
    - highlight:
        default: ""
        required: false
    - ignore_operators:
        default: false
        required: false
    - index:
        default: "wiki_eng"
        required: false
    - max_date:
        default: ""
        required: false
    - max_page_results:
        default: ""
        required: false
    - min_date:
        default: ""
        required: false
    - min_score:
        default: 0
        required: false
    - print_value:
        default: "fields"
        required: false
    - print_fields:
        default: ""
        required: false
    - promotion:
        default: false
        required: false
    - query_profile:
        default: ""
        required: false
    - sort:
        default: 'relevance'
        required: false
    - start:
        default: 1
        required: false
    - start_tag:
        default: '%3Cspan+style%3D%22background-color%3A+yellow%22%3E'
        required: false
    - summary:
        default: "off"
        required: false
    - total_results:
        default: false
        required: false
    - proxy_host:
        required: false
    - proxy_port:
        required: false

  workflow:
    - connect_to_server:
        do:
          http.http_client_post:
            - url: ${str(query_text_index_api) + '?text=' + str(text) + '&absolute_max_results=' + str(absolute_max_results) + '&check_spelling=' + str(check_spelling) + '&end_tag=' + str(end_tag) + '&field_text='+ str(field_text) + '&highlight='+ str(highlight) + '&ignore_operators=' + str(ignore_operators) + '&indexes=' + str(index) + '&max_date=' + str(max_date) + '&max_page_results='+ str(max_page_results) + '&min_date='+ str(min_date) + '&min_score='+ str(min_score) + '&print='+ str(print_value) + '&print_fields='+ str(print_fields) + '&promotion=' + str(promotion) + '&query_profile=' + str(query_profile) +  '&sort=' + str(sort) + '&start=' + str(start) + '&start_tag=' + str(start_tag) + '&summary=' + str(summary) + '&total_results=' + str(total_results) + '&apikey=' + str(api_key)}
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

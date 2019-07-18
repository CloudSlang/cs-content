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
#! @description: Processes the result of a query to the Haven OnDeman text index.
#!
#! @input query_text: text of the query
#! @input query_result: single result from the query response
#!
#! @output built_results: HTML text containing query results with links
#!
#! @result SUCCESS: query result processed successfully
#! @result FAILURE: There was an error while trying to process the query result
#!!#
########################################################################################################################

namespace: io.cloudslang.haven_on_demand.examples.video_text_search

imports:
  comp: io.cloudslang.base.comparisons
  lists: io.cloudslang.base.lists
  strings: io.cloudslang.base.strings
  hod: io.cloudslang.haven_on_demand

flow:
  name: process_query_results

  inputs:
    - query_text
    - query_result
    - item_text:
        default: " "
        private: true

  workflow:
    - find_all:
        do:
          lists.find_all:
            - list: ${",".join(eval(query_result)['text'])}
            - element: ${query_text}
            - ignore_case: "true"
        publish:
          - indices
        navigate:
          - SUCCESS: check_emptiness

    - check_emptiness:
        do:
          comp.equals:
            - first: ${indices}
            - second: ${" "}
        navigate:
          - 'TRUE': SUCCESS
          - 'FALSE': build_header

    - build_header:
        do:
          strings.append:
            - origin_string: " "
            - text: >
                ${'<h3>' + eval(query_result)['title'] + ' - <a href="' +
                eval(query_result)['url'][0] + '">' + eval(query_result)['url'][0] + '</a></h3><br><ul>'}
        publish:
          - item_text: ${new_string}
        navigate:
          - SUCCESS: build_result

    - build_result:
        loop:
          for: index in indices.split()
          do:
            hod.examples.video_text_search.build_result:
              - item_text: >
                  ${'<h3>' + eval(query_result)['title'] + ' - <a href="' +
                  eval(query_result)['url'][0] + '">' + eval(query_result)['url'][0] + '</a></h3><br><ul>'}
              - query_result
              - index
          break: []
          publish:
            - item_text: ${item_added + '<br>'}
          navigate:
           - SUCCESS: build_footer

    - build_footer:
        do:
          strings.append:
            - origin_string: ${item_text}
            - text: '</ul>'
        publish:
          - item_text: ${new_string}
        navigate:
          - SUCCESS: SUCCESS

  outputs:
    - built_results: ${item_text}

  results:
    - SUCCESS

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
#! @description: Builds a Haven OnDemand index item from the result of the process_video flow.
#!
#! @input json_input: result of speech recognition API call
#! @input title: title for video to be added to the index
#! @input url: YouTube url for the video
#!
#! @output json_index_item: JSON representation of item to add to the index
#!
#! @result SUCCESS: index item created successfully from the result
#! @result FAILURE: There was an error while trying to create item index
#!!#
########################################################################################################################

namespace: io.cloudslang.haven_on_demand.examples.video_text_search

imports:
  json: io.cloudslang.base.json
  print: io.cloudslang.base.print
  strings: io.cloudslang.base.strings

flow:
  name: build_index_item

  inputs:
    - json_input
    - title
    - url
    - all_content:
        default: ""
        required: false
        private: true
    - all_offsets:
        default: ""
        required: false
        private: true
    - json_item:
        default: '{"document" : [{"title":"","content":"","url":"","text":[],"offset":[]}]}'
        private: true

  workflow:
    - get_doc_list:
        do:
          json.get_value:
            - json_input
            - json_path: ${"actions,0,result,document"}
        publish:
          - doc_list: ${return_result}
          - error_message

    - append_content:
        loop:
          for: item in eval(doc_list)
          do:
            strings.append:
              - origin_string: ${all_content}
              - text: ${item["content"] + " "}
          publish:
            - all_content: ${new_string}
          break: []
          navigate:
            - SUCCESS: append_offsets

    - append_offsets:
        loop:
          for: item in eval(doc_list)
          do:
            strings.append:
              - origin_string: ${all_offsets}
              - text: ${str(item["offset"]) + " "}
          publish:
            - all_offsets: ${new_string}
          break: []
          navigate:
            - SUCCESS: add_title

    - add_title:
        do:
          json.add_value:
            - json_input: ${json_item}
            - json_path: ${"document,0,title"}
            - value: ${title}
        publish:
          - json_item: ${return_result}
          - error_message

    - add_link:
        do:
          json.add_value:
            - json_input: ${json_item}
            - json_path: ${"document,0,url"}
            - value: ${url}
        publish:
          - json_item: ${return_result}
          - error_message

    - add_content:
        do:
          json.add_value:
            - json_input: ${json_item}
            - json_path: ${"document,0,content"}
            - value: ${all_content}
        publish:
          - json_item: ${return_result}
          - error_message

    - add_text:
        loop:
          for: i in range(0,len(all_content.split()))
          do:
            json.add_value:
              - json_input: ${json_item}
              - json_path: ${"document,0,text," + str(i)}
              - value: ${all_content.split()[i]}
          publish:
            - json_item: ${return_result}
            - error_message

    - add_offset:
        loop:
          for: i in range(0,len(all_offsets.split()))
          do:
            json.add_value:
              - json_input: ${json_item}
              - json_path: ${"document,0,offset," + str(i)}
              - value: ${all_offsets.split()[i]}
          publish:
            - json_item: ${return_result}
            - error_message

    - on_failure:
        - print_fail:
            do:
              print.print_text:
                  - text: ${"Error - " + str(error_message)}
  outputs:
    - json_index_item: ${json_item}

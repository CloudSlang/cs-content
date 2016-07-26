####################################################
#!!
#! @description: Builds a Haven OnDemand index item from the result of the process_video flow.
#!
#! @input json_input: result of speech recognition API call
#! @input title: title for video to be added to the index
#! @input url: YouTube url for the video
#! @output json_index_item: JSON representation of item to add to the index
#!!#
####################################################

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
        default: " "
        required: false
        private: true
    - all_offsets:
        default: " "
        required: false
        private: true
    - json_item:
        default: '{"document" : [{}]}'
        private: true

  workflow:
    - get_doc_list:
        do:
          json.get_value:
            - json_input
            - json_path: ${['actions', 0, 'result', 'document']}
        publish:
          - doc_list: ${value}
          - error_message
    - append_content:
        loop:
          for: item in doc_list
          do:
            strings.append:
              - origin_string: ${all_content}
              - text: ${item["content"] + " "}
          publish:
            - all_content: ${new_string}
    - append_offsets:
        loop:
          for: item in doc_list
          do:
            strings.append:
              - origin_string: ${all_offsets}
              - text: ${str(item["offset"]) + " "}
          publish:
            - all_offsets: ${new_string}
    - add_title:
        do:
          json.add_value:
            - json_input: ${json_item}
            - json_path: ${['document', 0, 'title']}
            - value: ${title}
        publish:
          - json_item: ${json_output}
          - error_message
    - add_link:
        do:
          json.add_value:
            - json_input: ${json_item}
            - json_path: ${['document', 0, 'url']}
            - value: ${url}
        publish:
          - json_item: ${json_output}
          - error_message
    - add_content:
        do:
          json.add_value:
            - json_input: ${json_item}
            - json_path: ${['document', 0, 'content']}
            - value: ${all_content}
        publish:
          - json_item: ${json_output}
          - error_message
    - add_text:
        do:
          json.add_value:
            - json_input: ${json_item}
            - json_path: ${['document', 0, 'text']}
            - value: ${all_content.split()}
        publish:
          - json_item: ${json_output}
          - error_message
    - add_offset:
        do:
          json.add_value:
            - json_input: ${json_item}
            - json_path: ${['document', 0, 'offset']}
            - value: ${all_offsets.split()}
        publish:
          - json_item: ${json_output}
          - error_message
    - on_failure:
        - print_fail:
            do:
              print.print_text:
                  - text: ${"Error - " + str(error_message)}
  outputs:
    - json_index_item: ${json_item}

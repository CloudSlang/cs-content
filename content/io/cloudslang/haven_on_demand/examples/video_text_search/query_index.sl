####################################################
#!!
#! @description: Queries a Haven OnDemand text index setup by the setup_index flow
#!               and sends the results as an email.
#!
#! @input api_key: API key
#! @input text: query text
#! @input index: index to query
#! @input proxy_host: proxy server
#!                    optional
#! @input proxy_port: proxy server port
#!                    optional

#! @output output_name: output_description
#! @result result_name: result_description
#!!#
####################################################

namespace: io.cloudslang.haven_on_demand.examples.video_text_search

imports:
  hod: io.cloudslang.haven_on_demand
  print: io.cloudslang.base.print
  json: io.cloudslang.base.json
  mail: io.cloudslang.base.mail

flow:
  name: query_index

  inputs:
    - api_key:
        default: ${get_sp('io.cloudslang.haven_on_demand.examples.video_text_search.api_key')}
        sensitive: true
    - text
    - index:
        default: "video_library"
        required: false
    - hostname: ${get_sp('io.cloudslang.haven_on_demand.examples.video_text_search.hostname')}
    - port: ${get_sp('io.cloudslang.haven_on_demand.examples.video_text_search.port')}
    - from: ${get_sp('io.cloudslang.haven_on_demand.examples.video_text_search.from')}
    - to: ${get_sp('io.cloudslang.haven_on_demand.examples.video_text_search.to')}
    - proxy_host:
        default: ${get_sp('io.cloudslang.haven_on_demand.examples.video_text_search.proxy_host', '')}
        required: false
    - proxy_port:
        default: ${get_sp('io.cloudslang.haven_on_demand.examples.video_text_search.proxy_port', '')}
        required: false
    - email_text:
        default: ${"<h1>Video Text Search</h1><h2>Query - " + text + "</h2><hr><br>"}
        private: true

  workflow:
    - perform_query:
        do:
          hod.search.query_text_index:
            - api_key
            - index
            - text
            - print_value: 'all'
            - proxy_host
            - proxy_port
        publish:
            - error_message
            - return_result
    - get_doc_list:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: ${['documents']}
        publish:
          - doc_list: ${value}
          - error_message
    - process_results:
        loop:
          for: item in doc_list
          do:
            hod.examples.video_text_search.process_query_results:
              - query_text: ${text}
              - query_result: ${item}
              - result_text: ${email_text}
          publish:
            - email_text: ${result_text + built_results}
    - send_results:
        do:
          mail.send_mail:
            - hostname
            - port
            - from
            - to
            - subject: ${"Video search results for " + text}
            - body: ${email_text}

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
#! @description: Queries a Haven OnDemand text index setup by the setup_index flow
#!               and sends the results as an email.
#!
#! @input api_key: API key
#! @input text: query text
#! @input index: index to query
#! @input hostname: SMTP hostname
#! @input port: SMTP port
#! @input from: sender email address
#! @input to: recipient email address
#! @input proxy_host: proxy server
#!                    Optional
#! @input proxy_port: proxy server port
#!                    Optional
#!
#! @result SUCCESS: text index setup queried successfully
#! @result FAILURE: There was an error while trying to query the text index setup
#!!#
########################################################################################################################

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
            - json_path: 'documents'
        publish:
          - doc_list: ${return_result}
          - error_message

    - process_results:
        loop:
          for: item in eval(doc_list)
          do:
            hod.examples.video_text_search.process_query_results:
              - query_text: ${text}
              - query_result: ${str(item)}
              - result_text: ${email_text}
          break: []
          publish:
            - email_text: ${result_text + built_results}
          navigate:
            - SUCCESS: send_results

    - send_results:
        do:
          mail.send_mail:
            - hostname
            - port
            - from
            - to
            - subject: ${"Video search results for " + text}
            - body: ${email_text}

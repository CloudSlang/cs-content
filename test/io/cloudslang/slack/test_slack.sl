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
#! @description: A master flow to test flows and operations from the slack folder.
#!
#! @input token: Authentication token bearing required scopes. Can be bot, workspace or user based token.
#! @input channel: Channel, private group, or IM channel to send message to. Can be an encoded ID, or a name.
#! @input text: Text of the message to send.
#!              This field is usually required, unless you're providing only attachments instead.
#! @input attachments: A JSON-based array of structured attachments, presented as a URL-encoded string.
#!                     Optional
#!
#! @result SUCCESS: All commands completed successfully thus Vault interaction occurred as:
#!                  seal status received, vault got unsealed, secrets list was retrieved,
#!                  particular secret was updated and read, vault was finally sealed.
#! @result FAILURE: Something went wrong. Most likely the return_result was not as expected.
#!!#
########################################################################################################################

namespace: io.cloudslang.slack

imports:
  slack: io.cloudslang.slack

flow:
  name: test_slack

  inputs:
    - token
    - channel
    - text

  workflow:
    - post_message_raw:
        do:
          slack.chat.post_message_raw:
            - token
            - channel
            - text
        publish:
          - return_result
          - status_code
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure

  results:
    - SUCCESS
    - FAILURE
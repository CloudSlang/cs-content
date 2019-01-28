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
#! @description: This flow wraps the send_sms_and_get_responses while reading the recipients from file and writing
#!               the responses to files.
#!
#! @input recipients_file: The path to the file with recipients of the messages. It should have a line for every recipient
#! @input responses_file: The path to the file with the responses. It will be cleared before adding the responses
#! @input message: The message to send.
#! @input auth_token: The Auth Token for this Account SID.
#! @input account_sid: The Account SID on behalf the message is sent.
#!                     If you are using a Twilio Trial account for this example, you will only be able to send SMS
#!                     messages to phone numbers that you have verified with Twilio. Phone numbers can be verified via
#!                     your Twilio Console's Verified Caller IDs (https://www.twilio.com/console/phone-numbers/verified).
#!                     The 'From' parameter will also need to be a phone number you purchased from Twilio
#!                     (https://www.twilio.com/console/phone-numbers/incoming).
#! @input twilio_num: The approved number that sends the message. Notice it should start with +. The number should be
#!                    registered in https://www.twilio.com/console/phone-numbers/incoming
#! @input proxy_host: Optional - The proxy to pass the HTTP call through.
#! @input proxy_port: Optional - The port of the proxy to pass the HTTP call through.
#! @input proxy_username: Optional - The username of the proxy to pass the HTTP call through.
#! @input proxy_password: Optional - The password of the proxy username to pass the HTTP call through.
#!
#! @output message_response: If the responses file was written successfully there will be a success message.
#!
#! @result SUCCESS: Twilio SMS sent and successfully retrieved responses with files.
#! @result FAILURE: There was an error while trying to send SMS or retrieve the responses with files.
#!!#
########################################################################################################################

namespace: io.cloudslang.twilio.sms

imports:
  files: io.cloudslang.base.filesystem
  twilio: io.cloudslang.twilio.sms

flow:
  name: send_sms_and_get_responses_with_files

  inputs:
    - recipients_file
    - responses_file
    - message
    - account_sid
    - twilio_num
    - auth_token:
        sensitive: true
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true

  workflow:
    - clear_response_file:
        do:
          files.delete:
            - source: ${responses_file}
        navigate:
          - SUCCESS: read_recipients
          - FAILURE: read_recipients

    - read_recipients:
        do:
          files.read_from_file:
            - file_path: ${recipients_file}
        publish:
          - invitees: ${read_text.replace("\n", ",")}
        navigate:
          - SUCCESS: send_sms_and_get_responses
          - FAILURE: FAILURE

    - send_sms_and_get_responses:
        do:
          twilio.send_sms_and_get_responses:
            - recipients: ${invitees}
            - message
            - account_sid
            - auth_token
            - twilio_num
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
        publish:
          - responses
        navigate:
          - SUCCESS: write_responses
          - FAILURE: FAILURE

    - write_responses:
        do:
          files.write_to_file:
            - file_path: ${responses_file}
            - text: ${responses.replace(",", "\n")}
        publish:
          - message_response: ${message}
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE

  outputs:
    - message_response

  results:
    - SUCCESS
    - FAILURE

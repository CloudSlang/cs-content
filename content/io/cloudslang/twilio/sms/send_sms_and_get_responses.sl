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
#! @description: This flow sends a few SMS messages using Twilio (www.twilio.com) and waits for responses from the
#!               recipients. The user should have an account created in Twilio and a verified number to send
#!               the messages from.
#!               See the settings in: https://www.twilio.com/console/account/settings
#!               If you are using a Twilio Trial account for this example, you will only be able to send SMS messages
#!               to phone numbers that you have verified with Twilio. Phone numbers can be verified via your Twilio
#!               Console's Verified Caller IDs (https://www.twilio.com/console/phone-numbers/verified).
#!               The 'From' parameter will also need to be a phone number you acquired from Twilio
#!               (https://www.twilio.com/console/phone-numbers/incoming).
#!
#! @input recipients: The recipients of the messages. It should be in the form of list.
#! @input message: The message to send.
#! @input account_sid: The Account SID on behalf the message is sent.
#!                     If you are using a Twilio Trial account for this example, you will only be able to send SMS
#!                     messages to phone numbers that you have verified with Twilio. Phone numbers can be verified via
#!                     your Twilio Console's Verified Caller IDs (https://www.twilio.com/console/phone-numbers/verified).
#!                     The 'From' parameter will also need to be a phone number you purchased from Twilio
#!                     (https://www.twilio.com/console/phone-numbers/incoming).
#! @input twilio_num: The approved number that sends the message. Notice it should start with +. The number should be
#!                    registered in https://www.twilio.com/console/phone-numbers/incoming
#! @input auth_token: The Auth Token for this Account SID.
#! @input proxy_host: Optional - The proxy to pass the HTTP call through.
#! @input proxy_port: Optional - The port of the proxy to pass the HTTP call through.
#! @input proxy_username: Optional - The username of the proxy to pass the HTTP call through.
#! @input proxy_password: Optional - The password of the proxy username to pass the HTTP call through.
#!
#! @output responses: Responses from the recipients that received the Twilio SMS successfully.
#!
#! @result SUCCESS: Twilio SMS sent successfully and retrieved SMS response.
#! @result FAILURE: There was an error while trying to send the SMS or retrieving the SMS response.
#!!#
########################################################################################################################

namespace: io.cloudslang.twilio.sms

imports:
  twilio: io.cloudslang.twilio.sms

flow:
  name: send_sms_and_get_responses

  inputs:
    - recipients
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
    - send_invitations:
        loop:
          for: recipient in recipients
          do:
            twilio.send_sms:
              - account_sid
              - auth_token
              - from_num: ${twilio_num}
              - to_num: ${recipient}
              - message
              - proxy_host
              - proxy_port
              - proxy_username
              - proxy_password
          break:
            - FAILURE
        navigate:
          - SUCCESS: retrieve_responses
          - FAILURE: FAILURE

    - retrieve_responses:
        loop:
          for: recipient in recipients
          do:
            twilio.retrieve_recipient_response:
              - account_sid
              - auth_token
              - from_num: ${recipient}
              - to_num: ${twilio_num}
              - proxy_host
              - proxy_port
              - proxy_username
              - proxy_password
              - responses
          break:
            - FAILURE
          publish:
            - responses: "${(str(responses) if (responses != None) else str('')) + str(from_num)+': ' + sms_message + ','}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE

  outputs:
    - responses

  results:
    - SUCCESS
    - FAILURE

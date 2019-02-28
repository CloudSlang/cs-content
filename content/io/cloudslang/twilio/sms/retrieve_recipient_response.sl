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
#! @description: This flow retrieves the recipient's response using Twilio (www.twilio.com).
#!               The returned value is the response from the recipient that the SMS has been sent to.
#!               The user should have an account created in Twilio and a verified number to retrieve the messages from.
#!               See the settings in: https://www.twilio.com/console/account/settings
#!               If you are using a Twilio Trial account for this example, you will only be able to retrieve the
#!               recipient's response messages from phone numbers that you have verified with Twilio.
#!               Phone numbers can be verified via your Twilio Console's Verified Caller IDs
#!               (https://www.twilio.com/console/phone-numbers/verified).
#!               The 'To' parameter will also need to be a phone number you acquired from Twilio
#!               (https://www.twilio.com/console/phone-numbers/incoming).
#!
#! @input account_sid: The Account SID on behalf the message is sent.
#!                     If you are using a Twilio Trial account for this example, you will only be able to send SMS
#!                     messages to phone numbers that you have verified with Twilio. Phone numbers can be verified via
#!                     your Twilio Console's Verified Caller IDs (https://www.twilio.com/console/phone-numbers/verified).
#!                     The 'From' parameter will also need to be a phone number you purchased from Twilio
#!                     (https://www.twilio.com/console/phone-numbers/incoming).
#! @input from_num: The approved number that sent the message. Notice it should start with +. For trial account the
#!                  number should be verified in https://www.twilio.com/console/phone-numbers/verified.
#! @input to_num: The number that the message was sent to. Notice it should start with +. The number should be verified
#!                registered in https://www.twilio.com/console/phone-numbers/incoming.
#! @input auth_token: The Auth Token for this Account SID.
#! @input proxy_host: Optional - The proxy to pass the HTTP call through.
#! @input proxy_port: Optional - The port of the proxy to pass the HTTP call through.
#! @input proxy_username: Optional - The username of the proxy to pass the HTTP call through.
#! @input proxy_password: Optional - The password of the proxy username to pass the HTTP call through.
#!
#! @output sms_message: The SMS message that was returned.
#!
#! @result SUCCESS: Recipient response retrieved successfully.
#! @result FAILURE: There was an error while trying to retrieve the recipient response.
#!!#
########################################################################################################################

namespace: io.cloudslang.twilio.sms

imports:
  flow: io.cloudslang.base.utils
  twilio: io.cloudslang.twilio.sms

flow:
  name: retrieve_recipient_response

  inputs:
    - account_sid
    - auth_token:
        sensitive: true
    - from_num
    - to_num
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
    - retrieve_last_sms:
        do:
          twilio.retrieve_last_sms:
            - account_sid
            - auth_token
            - from_num
            - to_num
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
        publish:
          - sms_message
        navigate:
          - SUCCESS: SUCCESS
          - NO_SMS: sleep
          - FAILURE: on_failure

    - sleep:
        do:
          flow.sleep:
            - seconds: '30'
        navigate:
          - SUCCESS: retrieve_last_sms
          - FAILURE: on_failure

  outputs:
    - sms_message

  results:
    - SUCCESS
    - FAILURE

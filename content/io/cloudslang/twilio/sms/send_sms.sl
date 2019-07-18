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
#! @description: This flow sends an SMS using Twilio (www.twilio.com). The user should have an account created in
#!               Twilio and a verified number to send the messages from.
#!               See the settings in: https://www.twilio.com/console/account/settings
#!               If you are using a Twilio Trial account for this example, you will only be able to send SMS messages
#!               to phone numbers that you have verified with Twilio. Phone numbers can be verified via your Twilio
#!               Console's Verified Caller IDs (https://www.twilio.com/console/phone-numbers/verified). The 'From'
#!               parameter will also need to be a phone number you acquired from Twilio
#!               (https://www.twilio.com/console/phone-numbers/incoming).
#!
#! @input account_sid: The Account SID on behalf the message is sent.
#!                     If you are using a Twilio Trial account for this example, you will only be able to send SMS
#!                     messages to phone numbers that you have verified with Twilio. Phone numbers can be verified via
#!                     your Twilio Console's Verified Caller IDs (https://www.twilio.com/console/phone-numbers/verified).
#!                     The 'From' parameter will also need to be a phone number you purchased from Twilio
#!                     (https://www.twilio.com/console/phone-numbers/incoming).
#! @input auth_token: The Auth Token for this Account SID.
#! @input api_version: Optional - Twilio API version.
#!                     Default: '2010-04-01'
#! @input from_num: The approved number that sends the message. Notice it should start with +. The number should be
#!                  registered in https://www.twilio.com/console/phone-numbers/incoming
#! @input to_num: The number to send the message to. Notice it should start with +. For trial account the number should
#!                be verified in https://www.twilio.com/console/phone-numbers/verified
#! @input message: The message to send.
#! @input proxy_host: Optional - The proxy to pass the HTTP call through.
#! @input proxy_port: Optional - The port of the proxy to pass the HTTP call through.
#! @input proxy_username: Optional - The username of the proxy to pass the HTTP call through.
#! @input proxy_password: Optional - The password of the proxy username to pass the HTTP call through.
#!
#! @output error_message: The HTTP error message detailing the failure.
#!
#! @result SUCCESS: SMS sent successfully.
#! @result FAILURE: There was an error while trying to send the SMS.
#!!#
########################################################################################################################

namespace: io.cloudslang.twilio.sms

imports:
  http: io.cloudslang.base.http

flow:
  name: send_sms

  inputs:
    - account_sid
    - from_num
    - to_num
    - message
    - api_version:
        default: '2010-04-01'
        required: false
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
    - send_message:
        do:
          http.http_client_post:
            - url: ${'https://api.twilio.com/' + api_version + '/Accounts/' + account_sid + '/SMS/Messages'}
            - auth_type: 'basic'
            - username: ${account_sid}
            - password: ${auth_token}
            - content_type: 'application/x-www-form-urlencoded'
            - body: ${'To=' + to_num.replace("+","%2B") + '&From=' + from_num.replace("+","%2B") + '&Body=' + message}
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
        publish:
          - error_message
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE

  outputs:
    - error_message

  results:
    - SUCCESS
    - FAILURE

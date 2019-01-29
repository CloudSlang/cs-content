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
#! @description: This flow retrieves an SMS using Twilio (www.twilio.com). The returned value is the last SMS that was sent.
#!               The user should have an account created in twilio and a verified number to retrieve the messages from.
#!               See the settings in: https://www.twilio.com/console/account/settings
#!               If you are using a Twilio Trial account for this example, you will only be able to retrieve SMS
#!               messages from phone numbers that you have verified with Twilio. Phone numbers can be verified via your
#!               Twilio Console's Verified Caller IDs (https://www.twilio.com/console/phone-numbers/verified).
#!               The 'To' parameter will also need to be a phone number you acquired from Twilio
#!               (https://www.twilio.com/console/phone-numbers/incoming).
#!
#! @input account_sid: The Account SID on behalf the message is sent,
#!                     If you are using a Twilio Trial account for this example, you will only be able to send SMS
#!                     messages to phone numbers that you have verified with Twilio. Phone numbers can be verified via
#!                     your Twilio Console's Verified Caller IDs (https://www.twilio.com/console/phone-numbers/verified).
#!                     The 'From' parameter will also need to be a phone number you purchased from Twilio
#!                     (https://www.twilio.com/console/phone-numbers/incoming).
#! @input from_num: The approved number that sent the message. Notice it should start with +. For trial account the
#!                  number should be verified in https://www.twilio.com/console/phone-numbers/verified
#! @input to_num: The number that the message was sent to. Notice it should start with +. The number should be verified
#!                registered in https://www.twilio.com/console/phone-numbers/incoming
#! @input api_version: Optional - Twilio API version.
#!                     Default: '2010-04-01'
#! @input auth_token: The Auth Token for this Account SID.
#! @input proxy_host: Optional - The proxy to pass the HTTP call through.
#! @input proxy_port: Optional - The port of the proxy to pass the HTTP call through.
#! @input proxy_username: Optional - The username of the proxy to pass the HTTP call through.
#! @input proxy_password: Optional - The password of the proxy username to pass the HTTP call through.
#!
#! @output sms_message: In case a relevant SMS was found, this field holds the text of that last SMS.
#! @output error_message: Exception in case something went wrong.
#!
#! @result SUCCESS: This result indicated that there is at least one SMS sent from the To number to the From number.
#! @result NO_SMS: This result indicates that there is no SMS sent from the To number to the From number.
#! @result FAILURE: Something went wrong.
#!!#
########################################################################################################################

namespace: io.cloudslang.twilio.sms

imports:
  strings: io.cloudslang.base.strings
  xml: io.cloudslang.base.xml
  http: io.cloudslang.base.http

flow:
  name: retrieve_last_sms

  inputs:
    - account_sid
    - from_num
    - to_num
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
    - retrieve_sms:
        do:
          http.http_client_get:
            - url: ${'https://api.twilio.com/' + api_version + '/Accounts/' + account_sid + '/SMS/Messages'}
            - auth_type: 'basic'
            - username: ${account_sid}
            - password: ${auth_token}
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - query_params: ${'From=' + from_num + '&To=' + to_num + '&pagesize=1'}
        publish:
          - sms_list: ${return_result}
          - error_message
        navigate:
          - SUCCESS: xpath_query
          - FAILURE: FAILURE

    - xpath_query:
        do:
          xml.xpath_query:
            - xml_document: ${sms_list}
            - xpath_query: '/TwilioResponse/SMSMessages/SMSMessage/Body/text()'
        publish:
          - selected_value
          - error_message
        navigate:
          - SUCCESS: string_equals
          - FAILURE: FAILURE

    - string_equals:
        do:
          strings.string_equals:
            - first_string: ${selected_value}
            - second_string: 'No match found'
        navigate:
          - SUCCESS: NO_SMS
          - FAILURE: SUCCESS

  outputs:
    - sms_message: ${selected_value}
    - error_message

  results:
    - SUCCESS
    - NO_SMS
    - FAILURE

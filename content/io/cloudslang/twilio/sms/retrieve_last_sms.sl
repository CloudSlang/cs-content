#!!
#! @description: This flow retrieves an SMS using twilio (www.twilio.com). The returned value is the last SMS that was sent.
#!               The user should have an account created in twilio and a verified number to retrieve the messages from.
#!               See the settings in: https://www.twilio.com/console/account/settings
#!               If you are using a Twilio Trial account for this example, you will only be able to retrieve SMS messages from phone numbers that you have verified with Twilio. Phone numbers can be verified via your Twilio Console's Verified Caller IDs (https://www.twilio.com/console/phone-numbers/verified). The 'To' parameter will also need to be a phone number you acquired from Twilio (https://www.twilio.com/console/phone-numbers/incoming).
#! @input account_sid: The Account SID on behalf the message is sent
#!                     If you are using a Twilio Trial account for this example, you will only be able to send SMS messages to phone numbers that you have verified with Twilio. Phone numbers can be verified via your Twilio Console's Verified Caller IDs (https://www.twilio.com/console/phone-numbers/verified). The 'From' parameter will also need to be a phone number you purchased from Twilio (https://www.twilio.com/console/phone-numbers/incoming).
#! @input auth_token: The Auth Token for this Account SID
#! @input from_num: The approved number that sent the message. Notice it should start with +. For trial account the number should be verified in https://www.twilio.com/console/phone-numbers/verified
#! @input to_num: The number that the message was sent to. Notice it should start with +. The number should be verified registered in https://www.twilio.com/console/phone-numbers/incoming
#! @input proxy_host: The proxy to pass the HTTP call through
#! @input proxy_port: The port of the proxy to pass the HTTP call through
#! @output sms_message: In case a  relevant SMS was found, this field holds the text of that last SMS
#! @result no_sms: This result indicates that there is no SMS sent from the To number to the From number
#!!#
namespace: io.cloudslang.twilio.sms
flow:
  name: retrieve_last_sms
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
  workflow:
    - http_client_get:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: '${"https://api.twilio.com/2010-04-01/Accounts/"+account_sid+"/SMS/Messages"}'
            - auth_type: basic
            - username: '${account_sid}'
            - password: '${auth_token}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - query_params: '${"From="+from_num+"&To="+to_num+"&pagesize=1"}'
        publish:
          - sms_list: '${return_result}'
          - error_message: '${error_message}'
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: xpath_query
    - xpath_query:
        do:
          io.cloudslang.base.xml.xpath_query:
            - xml_document: '${sms_list}'
            - xpath_query: '/TwilioResponse/SMSMessages/SMSMessage/Body/text()'
        publish:
          - selected_value: '${selected_value}'
          - error_message: '${error_message}'
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: string_equals
    - string_equals:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${selected_value}'
            - second_string: No match found
        navigate:
          - FAILURE: SUCCESS
          - SUCCESS: NO_SMS
  outputs:
    - sms_message: '${selected_value}'
    - error_message: '${error_message}'
  results:
    - FAILURE
    - SUCCESS
    - NO_SMS

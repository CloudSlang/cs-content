#!!
#! @description: This flow sends an SMS using twilio (www.twilio.com). The user should have an account created in twilio and a verified number to send the messages from.
#!               See the settings in: https://www.twilio.com/console/account/settings
#!               If you are using a Twilio Trial account for this example, you will only be able to send SMS messages to phone numbers that you have verified with Twilio. Phone numbers can be verified via your Twilio Console's Verified Caller IDs (https://www.twilio.com/console/phone-numbers/verified). The 'From' parameter will also need to be a phone number you acquired from Twilio (https://www.twilio.com/console/phone-numbers/incoming).
#! @input account_sid: The Account SID on behalf the message is sent
#!                     If you are using a Twilio Trial account for this example, you will only be able to send SMS messages to phone numbers that you have verified with Twilio. Phone numbers can be verified via your Twilio Console's Verified Caller IDs (https://www.twilio.com/console/phone-numbers/verified). The 'From' parameter will also need to be a phone number you purchased from Twilio (https://www.twilio.com/console/phone-numbers/incoming).
#! @input auth_token: The Auth Token for this Account SID
#! @input from_num: The approved number that sends the message. Notice it should start with +. The number should be registered in https://www.twilio.com/console/phone-numbers/incoming
#! @input to_num: The number to send the message to. Notice it should start with +. For trial account the number should be verified in https://www.twilio.com/console/phone-numbers/verified
#! @input message: The message to send
#! @input proxy_host: The proxy to pass the HTTP call through
#! @input proxy_port: The port of the proxy to pass the HTTP call through
#! @output error_message: The HTTP error message detailing the failure
#!!#
namespace: io.cloudslang.twilio.sms
flow:
  name: send_sms
  inputs:
    - account_sid
    - auth_token:
        sensitive: true
    - from_num
    - to_num
    - message
    - proxy_host:
        required: false
    - proxy_port:
        required: false
  workflow:
    - http_client_post:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: '${"https://api.twilio.com/2010-04-01/Accounts/"+account_sid+"/SMS/Messages"}'
            - auth_type: basic
            - username: '${account_sid}'
            - password: '${auth_token}'
            - content_type: application/x-www-form-urlencoded
            - body: '${"To="+to_num+"&From="+from_num+"&Body="+message}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
        publish:
          - error_message: '${error_message}'
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: SUCCESS
  outputs:
    - error_message:
        value: '${error_message}'
  results:
    - FAILURE
    - SUCCESS

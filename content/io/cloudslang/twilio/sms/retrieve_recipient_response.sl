#!!
#! @input account_sid: The Account SID on behalf the message is sent
#!                     If you are using a Twilio Trial account for this example, you will only be able to send SMS messages to phone numbers that you have verified with Twilio. Phone numbers can be verified via your Twilio Console's Verified Caller IDs (https://www.twilio.com/console/phone-numbers/verified). The 'From' parameter will also need to be a phone number you purchased from Twilio (https://www.twilio.com/console/phone-numbers/incoming).
#! @input auth_token: The Auth Token for this Account SID
#! @input from_num: The approved number that sent the message. Notice it should start with +. For trial account the number should be verified in https://www.twilio.com/console/phone-numbers/verified
#! @input to_num: The number that the message was sent to. Notice it should start with +. The number should be verified registered in https://www.twilio.com/console/phone-numbers/incoming
#! @input proxy_host: The proxy to pass the HTTP call through
#! @input proxy_port: The port of the proxy to pass the HTTP call through
#! @output sms_message: The SMS message that was returned
#!!#
namespace: io.cloudslang.twilio.sms
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
  workflow:
    - retrieve_last_sms:
        do:
          io.cloudslang.twilio.sms.retrieve_last_sms:
            - account_sid: ${account_sid}
            - auth_token: ${auth_token}
            - from_num: ${from_num}
            - to_num: ${to_num}
            - proxy_host: ${proxy_host}
            - proxy_port: ${proxy_port}
        publish:
          - sms_message: ${sms_message}
        navigate:
          - FAILURE: on_failure
          - NO_SMS: sleep
          - SUCCESS: SUCCESS
    - sleep:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '30'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: retrieve_last_sms
  outputs:
    - sms_message: ${sms_message}
  results:
    - FAILURE
    - SUCCESS

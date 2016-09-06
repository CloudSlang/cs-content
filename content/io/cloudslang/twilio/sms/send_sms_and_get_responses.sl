#!!
#! @description: This flow sends a few SMS messages using twilio (www.twilio.com) and waits for responses from the recipients. The user should have an account created in twilio and a verified number to send the messages from.
#!               See the settings in: https://www.twilio.com/console/account/settings
#!               If you are using a Twilio Trial account for this example, you will only be able to send SMS messages to phone numbers that you have verified with Twilio. Phone numbers can be verified via your Twilio Console's Verified Caller IDs (https://www.twilio.com/console/phone-numbers/verified). The 'From' parameter will also need to be a phone number you acquired from Twilio (https://www.twilio.com/console/phone-numbers/incoming).
#! @input recipients: The recipients of the messages. It should be in the form of list
#! @input message: The message to send
#! @input account_sid: The Account SID on behalf the message is sent
#!                     If you are using a Twilio Trial account for this example, you will only be able to send SMS messages to phone numbers that you have verified with Twilio. Phone numbers can be verified via your Twilio Console's Verified Caller IDs (https://www.twilio.com/console/phone-numbers/verified). The 'From' parameter will also need to be a phone number you purchased from Twilio (https://www.twilio.com/console/phone-numbers/incoming).
#! @input auth_token: The Auth Token for this Account SID
#! @input twilio_num: The approved number that sends the message. Notice it should start with +. The number should be registered in https://www.twilio.com/console/phone-numbers/incoming
#! @input proxy_host: The proxy to pass the HTTP call through
#! @input proxy_port: The port of the proxy to pass the HTTP call through
#! @output error_message: The HTTP error message detailing the failure
#!!#
namespace: io.cloudslang.twilio.sms
flow:
  name: send_sms_and_get_responses
  inputs:
    - recipients
    - message
    - account_sid
    - auth_token:
        sensitive: true
    - twilio_num
    - proxy_host:
        required: false
    - proxy_port:
        required: false
  workflow:
    - send_invitations:
        loop:
          for: "recipient in recipients"
          do:
            io.cloudslang.twilio.sms.send_sms:
              - account_sid: ${account_sid}
              - auth_token: ${auth_token}
              - from_num: ${twilio_num}
              - to_num: ${recipient}
              - message: ${message}
              - proxy_host: ${proxy_host}
              - proxy_port: ${proxy_port}
          break:
            - FAILURE
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: retrieve_responses
    - retrieve_responses:
        loop:
          for: "recipient in recipients"
          do:
            io.cloudslang.twilio.sms.retrieve_recipient_response:
              - account_sid: ${account_sid}
              - auth_token: ${auth_token}
              - from_num: ${recipient}
              - to_num: ${twilio_num}
              - proxy_host: ${proxy_host}
              - proxy_port: ${proxy_port}
              - responses
          break:
            - FAILURE
          publish:
            - responses: "${(str(responses) if (responses != None) else str(''))+str(from_num)+': '+sms_message+','}"
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: SUCCESS
  outputs:
    - responses: ${responses}
  results:
    - FAILURE
    - SUCCESS

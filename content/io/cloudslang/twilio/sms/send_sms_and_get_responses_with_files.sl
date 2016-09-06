#!!
#! @description: This flow wraps the send_sms_and_get_responses while reading the recipients from file and writing the responses to files
#! @input recipients_file: The path to the file with recipients of the messages. It should have a line for every recipient
#! @input responses_file: The path to the file with the responses. It will be cleared before adding the responses
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
  name: send_sms_and_get_responses_with_files
  inputs:
    - recipients_file
    - responses_file
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
    - clear_response_file:
        do:
          io.cloudslang.base.files.delete:
            - source: ${responses_file}
        navigate:
          - FAILURE: read_recipients
          - SUCCESS: read_recipients
    - read_recipients:
        do:
          io.cloudslang.base.files.read_from_file:
            - file_path: ${recipients_file}
        publish:
          - invitees: '${read_text.replace("\n", ",")}'
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: send_sms_and_get_responses
    - send_sms_and_get_responses:
        do:
          io.cloudslang.twilio.sms.send_sms_and_get_responses:
            - recipients: ${invitees}
            - message: ${message}
            - account_sid: ${account_sid}
            - auth_token: ${auth_token}
            - twilio_num: ${twilio_num}
            - proxy_host: ${proxy_host}
            - proxy_port: ${proxy_port}
        publish:
          - responses: ${responses}
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: write_responses
    - write_responses:
        do:
          io.cloudslang.base.files.write_to_file:
            - file_path: ${responses_file}
            - text: ${responses.replace(",", "\n")}
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS

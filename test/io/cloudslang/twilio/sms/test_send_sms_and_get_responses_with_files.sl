#!!
#! @input responses: This is internal value only to collect the responses that will be written to the file
#!!#
namespace: io.cloudslang.twilio.sms
flow:
  name: test_send_sms_and_get_responses_with_files
  inputs:
    - recipients_file
    - responses_file
  workflow:
    - send_sms_and_get_responses_with_files:
        do:
          io.cloudslang.twilio.sms.send_sms_and_get_responses_with_files:
            - recipients_file: ${recipients_file}
            - responses_file: ${responses_file}
            - message: 'How many will attend?'
            - account_sid: ${get_sp('io.cloudslang.twilio.sms.account-sid')}
            - auth_token: ${get_sp('io.cloudslang.twilio.sms.auth-token')}
            - twilio_num: ${get_sp('io.cloudslang.twilio.sms.twilio-phone-number')}
            - proxy_host: ${get_sp('io.cloudslang.twilio.sms.proxy-host')}
            - proxy_port: ${get_sp('io.cloudslang.twilio.sms.proxy-port')}
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS

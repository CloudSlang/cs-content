#!!
#! @input responses: This is internal value only to collect the responses that will be written to the file
#!!#
namespace: io.cloudslang.twilio.sms
flow:
  name: test_send_sms_and_get_responses
  inputs:
    - recipients
    - expected_responses
  workflow:
    - send_sms_and_get_responses:
        do:
          io.cloudslang.twilio.sms.send_sms_and_get_responses:
            - recipients: ${recipients}
            - message: 'How many will attend?'
            - account_sid: ${get_sp('io.cloudslang.twilio.sms.account-sid')}
            - auth_token: ${get_sp('io.cloudslang.twilio.sms.auth-token')}
            - twilio_num: ${get_sp('io.cloudslang.twilio.sms.twilio-phone-number')}
            - proxy_host: ${get_sp('io.cloudslang.twilio.sms.proxy-host')}
            - proxy_port: ${get_sp('io.cloudslang.twilio.sms.proxy-port')}
        publish:
          - actual_responses: '${responses}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: compare_responses
    - compare_responses:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: ${expected_responses}
            - second_string: ${actual_responses}
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS

namespace: io.cloudslang.twilio.sms
flow:
  name: test_retrieve
  inputs:
    - from_num:
        default: ${get_sp('io.cloudslang.twilio.sms.recipient-phone-number')}
  workflow:
    - retrieve_last_sms:
        do:
          io.cloudslang.twilio.sms.retrieve_last_sms:
            - account_sid: ${get_sp('io.cloudslang.twilio.sms.account-sid')}
            - auth_token: ${get_sp('io.cloudslang.twilio.sms.auth-token')}
            - from_num: ${from_num}
            - to_num: ${get_sp('io.cloudslang.twilio.sms.twilio-phone-number')}
            - proxy_host: ${get_sp('io.cloudslang.twilio.sms.proxy-host')}
            - proxy_port: ${get_sp('io.cloudslang.twilio.sms.proxy-port')}
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
          - NO_SMS: NO_SMS
  results:
    - FAILURE
    - SUCCESS
    - NO_SMS

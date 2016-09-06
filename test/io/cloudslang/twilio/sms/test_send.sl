#!!
#! @input message: The message to send
#!!#
namespace: io.cloudslang.twilio.sms
flow:
  name: test_send
  inputs:
    - message:
        default: Hi
  workflow:
    - send_sms:
        do:
          io.cloudslang.twilio.sms.send_sms:
            - account_sid: ${get_sp('io.cloudslang.twilio.sms.account-sid')}
            - auth_token: ${get_sp('io.cloudslang.twilio.sms.auth-token')}
            - to_num: ${get_sp('io.cloudslang.twilio.sms.recipient-phone-number')}
            - from_num: ${get_sp('io.cloudslang.twilio.sms.twilio-phone-number')}
            - message: '${message}'
            - proxy_host: ${get_sp('io.cloudslang.twilio.sms.proxy-host')}
            - proxy_port: ${get_sp('io.cloudslang.twilio.sms.proxy-port')}
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      send_sms:
        x: 217
        y: 169
        navigate:
          ddf132d6-5523-0c2e-cdf4-6a6076801d22:
            targetId: 2108ea7c-491b-735b-be23-dbe511944dc8
            port: SUCCESS
    results:
      SUCCESS:
        2108ea7c-491b-735b-be23-dbe511944dc8:
          x: 436
          y: 165

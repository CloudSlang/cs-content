#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################

namespace: io.cloudslang.twilio.sms
flow:
  name: test_retrieve
  inputs:
    - from_num:
        default: ${get_sp('io.cloudslang.twilio.sms.recipient_phone_number')}
  workflow:
    - retrieve_last_sms:
        do:
          io.cloudslang.twilio.sms.retrieve_last_sms:
            - account_sid: ${get_sp('io.cloudslang.twilio.sms.account_sid')}
            - auth_token: ${get_sp('io.cloudslang.twilio.sms.auth_token')}
            - to_num: ${from_num}
            - from_num: ${get_sp('io.cloudslang.twilio.sms.twilio_phone_number')}
            - proxy_host: ${get_sp('io.cloudslang.twilio.sms.proxy_host')}
            - proxy_port: ${get_sp('io.cloudslang.twilio.sms.proxy_port')}
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
          - NO_SMS: NO_SMS
  results:
    - FAILURE
    - SUCCESS
    - NO_SMS

# (c) Copyright 2017 EntIT Software LLC, a Micro Focus company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
# System property file for Twilio SMS
#
# io.cloudslang.twilio.sms.account_sid: for example: BC1288daaced544d342cf6e6576a6df805
# io.cloudslang.twilio.sms.auth_token: for example: da925f4d81b5d498340da20367a939d7
# io.cloudslang.twilio.sms.twilio_phone_number: Twilio phone number
# io.cloudslang.twilio.sms.recipient_phone_number: recipient phone number
# io.cloudslang.twilio.sms.proxy_host: Proxy hostname
# io.cloudslang.twilio.sms.proxy_port: Proxy port
# io.cloudslang.twilio.sms.proxy_username: Proxy username
# io.cloudslang.twilio.sms.proxy_password: Proxy password
#
########################################################################################################################

namespace: io.cloudslang.twilio.sms

properties:
  - account_sid: '<account_sid>'
  - auth_token:
      value: '<auth_token>'
      sensitive: true
  - twilio_phone_number: '<+twilio_phone_number>'
  - recipient_phone_number: '<+recipient_phone_number>'
  - proxy_host: '<proxy_host>'
  - proxy_port: '<proxy_port>'

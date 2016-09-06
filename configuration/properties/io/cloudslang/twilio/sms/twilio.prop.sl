namespace: 'io.cloudslang.twilio.sms'
properties:
  - account-sid: '<account-sid>' #for example: BC1288daaced544d342cf6e6576a6df805
  - auth-token:
      value: '<auth-token>' #for example: da925f4d81b5d498340da20367a939d7
      sensitive: true
  - twilio-phone-number: '<+twilio-number>'
  - recipient-phone-number: '<+approved-number>'
#  - proxy-host: '<host>'
#  - proxy_port: '<port>'

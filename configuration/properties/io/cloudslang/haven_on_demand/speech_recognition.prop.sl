# (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# System property file for Haven OnDemand speech recognition properties file
#
# io.cloudslang.haven_on_demand.api_key: Haven on Demand user API key
# io.cloudslang.haven_on_demand.speech_api: speech API URL
# io.cloudslang.haven_on_demand.file: file path
# io.cloudslang.haven_on_demand.speech_result_api: speech result API URL
# io.cloudslang.haven_on_demand.hostname: SMTP hostname
# io.cloudslang.haven_on_demand.port: SMTP port
# io.cloudslang.haven_on_demand.from: sender email address
# io.cloudslang.haven_on_demand.to: recipient email address
#
####################################################

namespace: io.cloudslang.haven_on_demand

properties:
  - api_key: <apikey>
  - speech_api: "https://api.havenondemand.com/1/api/async/recognizespeech/v1"
  - file: <file>
  - speech_result_api: "https://api.havenondemand.com/1/job/result/"
  - hostname: <hostname>
  - port: <port>
  - from: <from>
  - to: <to>

# (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: offsets the given date/time by a number of seconds
#! @input date: the date to offset
#!              Valid value: 'July 1, 2016 2:32:09 PM EEST'
#! @input offset: the number of seconds to offset the date/time with
#!                Valid values: 'number_of_seconds'
#!                Example: '20'
#! @input locale_lang: optional - the locale language
#!                    Example: 'en'
#! @input locale_country: optional - the locale country
#!                       Example: 'US'
#! @output result: offset date/time by the given number of seconds, exception otherwise
#!                 Example: 'July 1, 2016 2:32:29 PM EEST'
#! @result SUCCESS: the date/time was shifted properly
#! @result FAILURE: failed to offset the date/time
#!!#
####################################################

namespace: io.cloudslang.base.datetime

operation:
  name: offset_time_by

  inputs:
    - date
    - offset
    - locale_lang:
        required: false
    - localeLang:
        default: ${get("locale_lang", "en")}
        private: true
    - locale_country:
        required: false
    - localeCountry:
        default: ${get("locale_country", "US")}
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-date-time:0.0.3'
    class_name: io.cloudslang.content.datetime.actions.OffsetTimeBy
    method_name: execute

  outputs:
    - result: ${returnResult}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE
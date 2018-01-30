# (c) Copyright 2017 EntIT Software LLC, a Micro Focus company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Offsets the given date/time by a number of seconds.
#!
#! @input date: The date to offset.
#!              Valid value: 'July 1, 2016 2:32:09 PM EEST'
#! @input offset: The number of seconds to offset the date/time with.
#!                Valid value: 'number_of_seconds'
#!                Example: '20'
#! @input locale_lang: Optional - The locale language.
#!                     Example: 'en'
#! @input locale_country: Optional - The locale country.
#!                        Example: 'US'
#!
#! @output output: Offset date/time by the given number of seconds, exception otherwise.
#!                 Example: 'July 1, 2016 2:32:29 PM EEST'
#! @output return_code: 0 if success, -1 if failure.
#! @output exception: An exception in case of failure.
#!
#! @result SUCCESS: The date/time was shifted properly.
#! @result FAILURE: Failed to offset the date/time.
#!!#
########################################################################################################################

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
        required: false
        private: true
    - locale_country:
        required: false
    - localeCountry:
        default: ${get("locale_country", "US")}
        required: false
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-date-time:0.0.6'
    class_name: io.cloudslang.content.datetime.actions.OffsetTimeBy
    method_name: execute

  outputs:
    - output: ${returnResult}
    - return_code: ${returnCode}
    - exception

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE
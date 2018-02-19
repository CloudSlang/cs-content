# (c) Copyright 2017 EntIT Software LLC, a Micro Focus company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Retrieves the current date and time according to the given locale.
#!
#! @input locale_lang: Optional - The locale language.
#! @input locale_country: Optional - The locale country.
#! @input timezone: Optional - The timezone you want the current datetime to be.
#!                  Examples: 'GMT', 'GMT+1', 'PST'
#!                  Default: 'GMT'
#! @input date_format: Optional - The format of the output date/time.The Default date/time format is from the Java
#!                     environment (which is dependent on the OS date/time format).
#!                     Example: 'dd-M-yyyy HH:mm:ss'
#!
#! @output output: Contains the current date and time according to the given locale, exception otherwise.
#!                        Example: 'July 1, 2016 2:32:09 PM EEST'
#! @output return_code: 0 if success, -1 if failure.
#! @output exception: An exception in case of failure.
#!
#! @result SUCCESS: The current date/time was obtained successfully.
#! @result FAILURE: Failed to obtain the current date/time.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.datetime

operation:
  name: get_time

  inputs:
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
    - timezone:
        required: false
        default: 'GMT'
    - date_format:
        required: false
    - dateFormat:
        default: ${get("date_format", "")}
        required: false
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-date-time:0.0.6'
    class_name: io.cloudslang.content.datetime.actions.GetCurrentDateTime
    method_name: execute

  outputs:
    - output: ${returnResult}
    - return_code: ${returnCode}
    - exception

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE
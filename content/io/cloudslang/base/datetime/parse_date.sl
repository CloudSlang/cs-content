# (c) Copyright 2017 EntIT Software LLC, a Micro Focus company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Parse the given date/time and convert it to an output format.
#!
#! @input date: The date/time to parse.
#!              Example:  "2001-07-04T12:08:56.235+0700"
#! @input date_format: Optional - The format of the date/time.
#!                     Example: "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
#! @input date_locale_lang: Optional - The locale language.
#!                          Example: 'en'
#! @input date_locale_country: Optional - The locale country.
#!                             Example: 'US'
#! @input out_format: Optional - The output format.
#!                    Example: "yyyy-MM-dd"
#! @input out_locale_lang: Optional - The output locale language.
#!                         Example: 'fr'
#! @input out_locale_country: Optional - The output locale country.
#!                            Example: 'FR'
#!
#! @output output: The new date/time after if parsing was successful, exception otherwise.
#! @output return_code: 0 if success, -1 if failure.
#! @output exception: An exception in case of failure.
#!
#! @result SUCCESS: The date/time was parsed properly.
#! @result FAILURE: Failed to parse the date/time.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.datetime

operation:
  name: parse_date

  inputs:
    - date
    - date_format:
        required: false
    - dateFormat:
        default: ${get("date_format", "")}
        required: false
        private: true
    - date_locale_lang:
        required: false
    - dateLocaleLang:
        default: ${get("date_locale_lang", "en")}
        required: false
        private: true
    - date_locale_country:
        required: false
    - dateLocaleCountry:
        default: ${get("date_locale_country", "US")}
        required: false
        private: true
    - out_format:
        required: false
    - outFormat:
        default: ${get("out_format", "")}
        required: false
        private: true
    - out_locale_lang:
        required: false
    - outLocaleLang:
        default: ${get("out_locale_lang", "en")}
        required: false
        private: true
    - out_locale_country:
        required: false
    - outLocaleCountry:
        default: ${get("out_locale_country", "US")}
        required: false
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-date-time:0.0.6'
    class_name: io.cloudslang.content.datetime.actions.ParseDate
    method_name: execute

  outputs:
    - output: ${returnResult}
    - return_code: ${returnCode}
    - exception

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE
# (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: parse the given date/time and convert it to an output format
#! @input date: the date/time to parse
#!              Example:  "2001-07-04T12:08:56.235+0700"
#! @input date_format: optional - the format of the date/time
#!                     Example: "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
#! @input date_locale_lang: optional - the locale language
#!                        Example: 'en'
#! @input date_locale_country: optional - the locale country
#!                           Example: 'US'
#! @input out_format: optional - the output format
#!                    Example: "yyyy-MM-dd"
#! @input out_locale_lang: optional - the output locale language
#!                         Example: 'fr'
#! @input out_locale_country: optional - the output locale country
#!                            Example: 'FR'
#! @output result: the new date/time after if parsing was successful, exception otherwise
#! @result SUCCESS: the date/time was parsed properly
#! @result FAILURE: failed to parse the date/time
#!!#
####################################################

namespace: io.cloudslang.base.datetime

operation:
  name: parse_date

  inputs:
    - date
    - date_format:
        required: false
    - dateFormat:
        default: ${get("date_format", "")}
        private: true
        required: false
    - date_locale_lang:
        required: false
    - dateLocaleLang:
        default: ${get("date_locale_lang", "en")}
        private: true
    - date_locale_country:
        required: false
    - dateLocaleCountry:
        default: ${get("date_locale_country", "US")}
        private: true
    - out_format:
        required: false
    - outFormat:
        default: ${get("out_format", "")}
        private: true
        required: false
    - out_locale_lang:
        required: false
    - outLocaleLang:
        default: ${get("out_locale_lang", "en")}
        private: true
    - out_locale_country:
        required: false
    - outLocaleCountry:
        default: ${get("out_locale_country", "US")}
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-date-time:0.0.3'
    class_name: io.cloudslang.content.datetime.actions.ParseDate
    method_name: execute

  outputs:
    - result: ${returnResult}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE
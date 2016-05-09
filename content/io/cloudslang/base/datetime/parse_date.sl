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
#! @input dateFormat: the format of the date/time
#! @input dateLocaleLang: the locale language
#! @input dateLocaleCountry: the locale country
#! @input outFormat: the output format
#! @input outLocaleLang: the output locale language
#! @input outLocaleCountry: the output locale country
#! @result SUCCESS: the date/time was parsed properly
#! @result FAILURE: failed to parse the date/time
#!!#
####################################################

namespace: io.cloudslang.base.datetime

operation:
  name: parse_date

  inputs:
    - date:
        required: true
    - dateFormat:
        required: false
        default: ${get("date_format", "")}
    - dateLocaleLang:
        required: false
        default: ${get("date_locale_lang", "en")}
    - dateLocaleCountry:
        required: false
        default: ${get("date_locale_country", "US")}
    - outFormat:
        required: false
        default: ${get("out_format", "")}
    - outLocaleLang:
        required: false
        default: ${get("out_locale_lang", "en")}
    - outLocaleCountry:
        required: false
        default: ${get("out_locale_country", "US")}

  action:
    java_action:
      className: io.cloudslang.content.datetime.actions.ParseDate
      methodName: execute

  outputs:
    - result: ${returnResult}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE

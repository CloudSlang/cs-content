# (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: gets the current date and time according to the given locale
#! @input locale_lang: the locale language
#! @input locale_country: the locale country
#! @output return_result: contains the current date and time according to the given locale, exception otherwise
#! @result SUCCESS: the current date/time was obtained successfully
#! @result FAILURE: failed to obtain the current date/time
#!!#
####################################################

namespace: io.cloudslang.base.datetime

operation:
  name: get_time

  inputs:
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
    class_name: io.cloudslang.content.datetime.actions.GetCurrentDateTime
    method_name: execute

  outputs:
    - return_result: ${returnResult}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE
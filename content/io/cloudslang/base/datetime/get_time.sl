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
#! @input localeLang: the locale language
#! @input localeCountry: the locale country
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
        private: true
        default: ${get("locale_lang", "en")} 
    - locale_country:
        required: false
    - localeCountry:
        private: true
        default: ${get("locale_country", "US")}

  action:
    java_action:
      className: io.cloudslang.content.datetime.actions.GetCurrentDateTime
      methodName: execute

  outputs:
    - result: ${returnResult}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE

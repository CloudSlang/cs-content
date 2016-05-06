# (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
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
#! @input offset: the number of seconds to offset the date/time with
#! @input localeLang: the locale language
#! @input localeCountry: the locale country
#! @result SUCCESS: the date/time was offsetted properly
#! @result FAILURE: failed to offset the date/time
#!!#
####################################################

namespace: io.cloudslang.base.datetime

operation:
  name: offset_time_by

  inputs:
    - date
    - offset
    - localeLang
    - localeCountry

  action:
    java_action:
      className: io.cloudslang.content.datetime.actions.OffsetTimeBy
      methodName: execute

  outputs:
    - result: ${returnResult}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE

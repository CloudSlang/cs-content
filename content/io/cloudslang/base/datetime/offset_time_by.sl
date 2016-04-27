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
      methodName: OffsetTimeBy
  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE

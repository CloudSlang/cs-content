namespace: io.cloudslang.base.datetime

operation:
  name: parse_date

  inputs:
    - date
    - dateFormat
    - dateLocaleLang
    - dateLocaleCountry
    - outFormat
    - outLocaleLang
    - outLocaleCountry

  action:
    java_action:
      className: io.cloudslang.content.datetime.actions.ParseDate
      methodName: execute

  outputs:
    - result: ${returnResult}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE

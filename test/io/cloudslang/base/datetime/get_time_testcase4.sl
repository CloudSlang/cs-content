namespace: io.cloudslang.base.datetime

flow:
  name: get_time_testcase4

  workflow:
    - start_test:
        do:
          print:
            - text: "GetCurrentDateTime: localeLang=unix, localeCountry=DK"
    - execute_test:
        do:
          get_time:
            - localeLang: "unix"
            - localeCountry: "DK"
        publish:
            - returnStr: ${result}
    - print_result:
        do:
          print:
           - text: "${'GetCurrentDateTime:' + returnStr}"

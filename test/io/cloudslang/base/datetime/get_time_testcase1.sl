namespace: io.cloudslang.base.datetime

flow:
  name: get_time_testcase1

  workflow:
    - start_test:
        do:
          print:
            - text: "GetCurrentDateTime: localeLang=fr, localeCountry=FR"
    - execute_test:
        do:
          get_time:
            - localeLang: "fr"
            - localeCountry: "FR"
        publish:
            - returnStr: ${result}
    - print_result:
        do:
          print:
           - text: "${'GetCurrentDateTime:' + returnStr}"

namespace: io.cloudslang.base.datetime

flow:
  name: get_time_testcase3

  workflow:
    - start_test:
        do:
          print:
            - text: "GetCurrentDateTime: localeLang=da, localeCountry=null"
    - execute_test:
        do:
          get_time:
            - localeLang: "da"
            - localeCountry: ""
        publish:
            - returnStr: ${result}
    - print_result:
        do:
          print:
           - text: "${'GetCurrentDateTime:' + returnStr}"

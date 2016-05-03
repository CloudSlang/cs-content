namespace: io.cloudslang.base.datetime

flow:
  name: get_time_testcase2

  workflow:
    - start_test:
        do:
          print:
            - text: "GetCurrentDateTime: localeLang=null, localeCountry=DK"
    - execute_test:
        do:
          get_time:
            - localeLang: ""
            - localeCountry: "DK"
        publish:
            - returnStr: ${result}
    - print_result:
        do:
          print:
           - text: "${'GetCurrentDateTime:' + returnStr}"

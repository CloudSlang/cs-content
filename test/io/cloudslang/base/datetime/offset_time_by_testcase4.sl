namespace: io.cloudslang.base.datetime

flow:
  name: offset_time_by_testcase4

  workflow:
    - start_test:
        do:
          print:
            - text: "OffsetTimeBy: date=<April 26, 2016 1:32:20 PM EEST>, offset=5, localeLang=null, localeCountry=US"
    - execute_test:
        do:
          offset_time_by:
            - date: "April 26, 2016 1:32:20 PM EEST"
            - offset: "5"
            - localeLang: ""
            - localeCountry: "US"
        publish:
            - returnStr: ${result}
    - print_result:
        do:
          print:
           - text: "${'OffsetTimeBy:' + returnStr}"

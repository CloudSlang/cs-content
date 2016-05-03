namespace: io.cloudslang.base.datetime

flow:
  name: offset_time_by_testcase3

  workflow:
    - start_test:
        do:
          print:
            - text: "OffsetTimeBy: date=<1000>, offset=5, localeLang=unix, localeCountry=US"
    - execute_test:
        do:
          offset_time_by:
            - date: "1000"
            - offset: "5"
            - localeLang: "unix"
            - localeCountry: "US"
        publish:
            - returnStr: ${result}
    - print_result:
        do:
          print:
           - text: "${'OffsetTimeBy:' + returnStr}"

namespace: io.cloudslang.base.datetime

flow:
  name: offset_time_by_testcase2

  workflow:
    - start_test:
        do:
          print:
            - text: "OffsetTimeBy: date=<26 de abril de 2016 13:32:20 EEST>, offset=5, localeLang=es, localeCountry=SP"
    - execute_test:
        do:
          offset_time_by:
            - date: "26 de abril de 2016 13:32:20 EEST"
            - offset: "5"
            - localeLang: "es"
            - localeCountry: "SP"
        publish:
            - returnStr: ${result}
    - print_result:
        do:
          print:
           - text: "${'OffsetTimeBy:' + returnStr}"

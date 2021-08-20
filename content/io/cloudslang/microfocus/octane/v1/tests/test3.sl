namespace: io.cloudslang.microfocus.octane.v1.tests
flow:
  name: test3
  workflow:
    - authentication_test:
        do:
          io.cloudslang.microfocus.octane.v1.authentication.authentication_test: []
        publish:
          - cookie
        navigate:
          - SUCCESS: get_entities_1
          - FAILURE: on_failure
    - get_entities_1:
        do:
          io.cloudslang.microfocus.octane.v1.entity.get_entities_1:
            - cookie: '${cookie}'
        publish:
          - id_list
        navigate:
          - SUCCESS: get_all_defects1
          - FAILURE: on_failure
    - get_all_defects1:
        do:
          io.cloudslang.microfocus.octane.v1.defects.get_all_defects1:
            - cookie: '${cookie}'
        publish:
          - id_list
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_all_defects1:
        x: 700
        'y': 150
        navigate:
          d667d872-d848-5067-8090-f5f97420c875:
            targetId: 707a2a0d-5ae6-df96-3972-cad8dea825f3
            port: SUCCESS
      get_entities_1:
        x: 400
        'y': 150
      authentication_test:
        x: 143
        'y': 140
    results:
      SUCCESS:
        707a2a0d-5ae6-df96-3972-cad8dea825f3:
          x: 1000
          'y': 150

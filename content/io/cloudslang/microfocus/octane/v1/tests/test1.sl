namespace: io.cloudslang.microfocus.octane.v1.tests
flow:
  name: test1
  workflow:
    - authentication_test:
        do:
          io.cloudslang.microfocus.octane.v1.authentication.authentication_test: []
        publish:
          - cookie
        navigate:
          - SUCCESS: get_entity_1
          - FAILURE: on_failure
    - get_entity_1:
        do:
          io.cloudslang.microfocus.octane.v1.entity.get_entity_1:
            - cookie: '${cookie}'
            - auth_type: basic
            - entity_id: '1001'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      authentication_test:
        x: 219
        'y': 376
      get_entity_1:
        x: 379
        'y': 227
        navigate:
          35562978-e02b-b80e-e6e1-d395ac71c4dc:
            targetId: 30c25ffa-8e6c-ad32-82a7-bfdc571edeb8
            port: SUCCESS
    results:
      SUCCESS:
        30c25ffa-8e6c-ad32-82a7-bfdc571edeb8:
          x: 649
          'y': 205

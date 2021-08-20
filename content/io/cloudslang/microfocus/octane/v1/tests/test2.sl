namespace: io.cloudslang.microfocus.octane.v1.tests
flow:
  name: test2
  workflow:
    - authentication_test:
        do:
          io.cloudslang.microfocus.octane.v1.authentication.authentication_test: []
        publish:
          - cookie
        navigate:
          - SUCCESS: create_entity1
          - FAILURE: on_failure
    - create_entity1:
        do:
          io.cloudslang.microfocus.octane.v1.entity.create_entity1:
            - url: 'http://mydtbld0220.swinfra.net:11127'
            - cookie: '${cookie}'
            - shared_space_id: '1001'
            - workspace_id: '1003'
        publish:
          - entity_id
        navigate:
          - SUCCESS: delete_entity_1
          - FAILURE: on_failure
    - delete_entity_1:
        do:
          io.cloudslang.microfocus.octane.v1.entity.delete_entity_1:
            - input_entity: features
            - cookie: '${cookie}'
            - entity_id: '${entity_id}'
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
        x: 149
        'y': 154
      create_entity1:
        x: 400
        'y': 150
      delete_entity_1:
        x: 700
        'y': 150
        navigate:
          617b5f38-48d5-916e-90b7-6b6e2fb65d41:
            targetId: 9d1e2ab3-bfbc-3f5b-d16c-82094b04ac38
            port: SUCCESS
    results:
      SUCCESS:
        9d1e2ab3-bfbc-3f5b-d16c-82094b04ac38:
          x: 1000
          'y': 150

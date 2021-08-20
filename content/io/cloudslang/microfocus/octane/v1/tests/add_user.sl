namespace: io.cloudslang.microfocus.octane.v1.tests
flow:
  name: add_user
  workflow:
    - authentication_test:
        do:
          io.cloudslang.microfocus.octane.v1.authentication.authentication_test: []
        publish:
          - cookie
        navigate:
          - SUCCESS: add_user_to_shared_space_test
          - FAILURE: on_failure
    - add_user_to_shared_space_test:
        do:
          io.cloudslang.microfocus.octane.v1.user.add_user_to_shared_space_test:
            - email_new_user: teo@dora
            - password_new_user:
                value: Welcome1
                sensitive: true
            - last_name: teo@dora
            - first_name: teo@dora
            - header: '${cookie}'
        navigate:
          - SUCCESS: get_all_users_test
          - FAILURE: on_failure
    - get_all_users_test:
        do:
          io.cloudslang.microfocus.octane.v1.user.get_all_users_test:
            - header: '${cookie}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      authentication_test:
        x: 100
        'y': 150
      add_user_to_shared_space_test:
        x: 400
        'y': 150
      get_all_users_test:
        x: 700
        'y': 150
        navigate:
          e2d23dfa-797a-870c-237f-2690d076993a:
            targetId: b1fca982-e36d-0614-9479-4816c422be28
            port: SUCCESS
    results:
      SUCCESS:
        b1fca982-e36d-0614-9479-4816c422be28:
          x: 1000
          'y': 150

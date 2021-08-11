namespace: io.cloudslang.microfocus.octane.v1.authentication
flow:
  name: sign_out
  inputs:
    - url: 'http://mydtbld0220.swinfra.net:11127'
  workflow:
    - http_client_post:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${url + '/authentication/sign_out'}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      http_client_post:
        x: 38
        'y': 96
        navigate:
          2da80710-1925-858e-e0d5-9028a6400836:
            targetId: 055ae08d-d944-fc11-80ef-c0884b456340
            port: SUCCESS
    results:
      SUCCESS:
        055ae08d-d944-fc11-80ef-c0884b456340:
          x: 313
          'y': 94.4000244140625

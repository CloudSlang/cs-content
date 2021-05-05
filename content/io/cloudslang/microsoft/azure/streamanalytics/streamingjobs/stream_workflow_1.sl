namespace: io.cloudslang.microsoft.azure.streamanalytics.streamingjobs
flow:
  name: stream_workflow_1
  inputs:
    - tenant_id: 6002e264-31f7-43d3-a51e-9ed1ba9ca689
    - client_id: eee76a2b-c83a-48ac-951d-dbf87e166d77
    - client_secret: '6Fwaa]gehvLH_]m5Dmak7jjoGNnEr9p/'
    - subscription_id: d20eaed0-0b36-44eb-acff-7ae3f080cd9a
    - location: East US
    - resource_group_name: TARGDND
    - job_name: cypherworkflow
    - stream_job_input_name: cypherinput
    - stream_job_output_name: cypheroutput
    - account_name: testing
    - account_key: testing==
    - proxy_host:
        default: web-proxy.in.softwaregrp.net
        required: false
    - proxy_username:
        required: false
    - proxy_port:
        default: '8080'
        required: false
    - proxy_password:
        required: false
    - resource:
        required: false
    - source_type:
        required: false
    - trust_all_roots:
        required: false
    - x_509_hostname_verifier:
        required: false
    - trust_keystore:
        required: false
    - trust_password:
        required: false
    - api_version:
        required: false
    - sku_name:
        required: false
    - events_out_of_order_policy:
        required: false
    - output_error_policy:
        required: false
    - tags:
        required: false
    - events_late_arrival_max_delay_in_seconds:
        required: false
    - compatibility_level:
        required: false
    - data_locale:
        required: false
    - events_out_of_order_max_delay_in_seconds:
        required: false
    - output_start_mode:
        required: false
    - output_start_time:
        required: false
  workflow:
    - get_auth_token_using_web_api:
        do:
          io.cloudslang.microsoft.azure.authorization.get_auth_token_using_web_api:
            - tenant_id: '${tenant_id}'
            - client_id: '${client_id}'
            - client_secret:
                value: '${client_secret}'
                sensitive: true
            - resource: '${resource}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password:
                value: '${trust_password}'
                sensitive: true
        publish:
          - auth_token
        navigate:
          - SUCCESS: create_streaming_job
          - FAILURE: FAILURE
    - create_streaming_job:
        do:
          io.cloudslang.microsoft.azure.streamanalytics.streamingjobs.create_streaming_job:
            - auth_token:
                value: '${auth_token}'
                sensitive: true
            - subscription_id: '${subscription_id}'
            - location: '${location}'
            - resource_group_name: '${resource_group_name}'
            - job_name: '${job_name}'
            - api_version: '${api_version}'
            - sku_name: '${sku_name}'
            - events_out_of_order_policy: '${events_out_of_order_policy}'
            - output_error_policy: '${output_error_policy}'
            - events_out_of_order_max_delay_in_seconds: '${events_out_of_order_max_delay_in_seconds}'
            - events_late_arrival_max_delay_in_seconds: '${events_late_arrival_max_delay_in_seconds}'
            - data_locale: '${data_locale}'
            - compatibility_level:
                value: '${compatibility_level}'
                sensitive: true
            - tags: '${tags}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password:
                value: '${trust_password}'
                sensitive: true
        publish:
          - job_id
          - job_state
        navigate:
          - SUCCESS: start_streaming_job
          - FAILURE: FAILURE
    - start_streaming_job:
        do:
          io.cloudslang.microsoft.azure.streamanalytics.streamingjobs.start_streaming_job:
            - auth_token:
                value: '${auth_token}'
                sensitive: true
            - subscription_id: '${subscription_id}'
            - resource_group_name: '${resource_group_name}'
            - job_name: '${job_name}'
            - api_version: '${api_version}'
            - output_start_mode: '${output_start_mode}'
            - output_start_time: '${output_start_time}'
            - proxy_host: proxy
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password:
                value: '${trust_password}'
                sensitive: true
        publish:
          - status_code
        navigate:
          - SUCCESS: create_streaming_job_input
          - FAILURE: on_failure
    - create_streaming_job_input:
        do:
          io.cloudslang.microsoft.azure.streamanalytics.inputs.create_streaming_job_input:
            - job_name: '${job_name}'
            - auth_token:
                value: '${auth_token}'
                sensitive: true
            - stream_job_input_name: '${stream_job_input_name}'
            - resource_group_name: '${resource_group_name}'
            - subscription_id: '${subscription_id}'
            - account_name: '${account_name}'
            - account_key: '${account_key}'
            - source_type: '${source_type}'
            - api_version: '${api_version}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password:
                value: '${trust_password}'
                sensitive: true
        publish:
          - input_name
        navigate:
          - SUCCESS: create_streaming_job_output
          - FAILURE: FAILURE
    - create_streaming_job_output:
        do:
          io.cloudslang.microsoft.azure.streamanalytics.outputs.create_streaming_job_output:
            - job_name: '${job_name}'
            - auth_token:
                value: '${auth_token}'
                sensitive: true
            - stream_job_output_name: '${stream_job_output_name}'
            - resource_group_name: '${resource_group_name}'
            - subscription_id: '${subscription_id}'
            - account_name: '${account_name}'
            - account_key: '${account_key}'
            - api_version: '${api_version}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password:
                value: '${trust_password}'
                sensitive: true
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_auth_token_using_web_api:
        x: 100
        'y': 84
        navigate:
          e53cd53d-c795-15f8-ab59-289344853f1c:
            targetId: 9a8818a8-d428-d00c-9a9e-299f67fdece1
            port: FAILURE
      create_streaming_job:
        x: 263
        'y': 90
        navigate:
          c2677b1f-7336-61bd-f4dc-0aae869f981a:
            targetId: 9a8818a8-d428-d00c-9a9e-299f67fdece1
            port: FAILURE
      create_streaming_job_output:
        x: 820
        'y': 255
        navigate:
          6989a010-3d48-c7bf-2180-af3cd0ef339b:
            targetId: 4c6e429e-bcd7-301a-6bfb-0a895b6966db
            port: SUCCESS
          135e6b16-8d35-55aa-d806-47e5eb1bcfa3:
            targetId: 9a8818a8-d428-d00c-9a9e-299f67fdece1
            port: FAILURE
      start_streaming_job:
        x: 595
        'y': 100
      create_streaming_job_input:
        x: 802
        'y': 98
        navigate:
          b2de654f-0743-d2c4-8168-bf399cc04034:
            targetId: 9a8818a8-d428-d00c-9a9e-299f67fdece1
            port: FAILURE
    results:
      FAILURE:
        9a8818a8-d428-d00c-9a9e-299f67fdece1:
          x: 177
          'y': 428
      SUCCESS:
        4c6e429e-bcd7-301a-6bfb-0a895b6966db:
          x: 727
          'y': 445


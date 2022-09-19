namespace: io.cloudslang.hashicorp.terraform.automation_content.resourcesync.subflows
flow:
  name: get_resource_offering_id
  inputs:
    - x_auth_token
    - host
    - tenant_id
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
    - worker_group:
        required: false
  workflow:
    - get_ro_id:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${'https://'+host+'/dnd/api/v1/'+tenant_id+'/resource/offering/'}"
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - trust_all_roots: "${get_sp('io.cloudslang.microfocus.content.trust_all_roots')}"
            - x_509_hostname_verifier: "${get_sp('io.cloudslang.microfocus.content.x_509_hostname_verifier')}"
            - trust_keystore: "${get_sp('io.cloudslang.microfocus.content.trust_keystore')}"
            - trust_password:
                value: "${get_sp('io.cloudslang.microfocus.content.trust_password')}"
                sensitive: true
            - headers: "${'content-type: application/json\\n'+'Accept: application/json\\n'+'X-Auth-Token:'+x_auth_token}"
            - worker_group: '${worker_group}'
        publish:
          - ro_list: '${return_result}'
        navigate:
          - SUCCESS: get_ro_id_python
          - FAILURE: on_failure
    - get_ro_id_value:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - striped_ro_id: '${ro_id.split("/resource/offering/")[1]}'
        publish:
          - striped_ro_id
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - get_ro_id_python:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.hashicorp.terraform.automation_content.resourcesync.subflows.get_ro_id_python:
            - ro_list: '${ro_list}'
        publish:
          - ro_id: '${ro_id}'
        navigate:
          - SUCCESS: get_ro_id_value
  outputs:
    - striped_ro_id
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_ro_id:
        x: 80
        'y': 120
      get_ro_id_value:
        x: 360
        'y': 120
        navigate:
          c7ded12a-68fc-d9a0-38d0-91594b4516f7:
            targetId: 67de1986-7692-b9c6-2f94-31425296446f
            port: SUCCESS
      get_ro_id_python:
        x: 200
        'y': 120
    results:
      SUCCESS:
        67de1986-7692-b9c6-2f94-31425296446f:
          x: 600
          'y': 120

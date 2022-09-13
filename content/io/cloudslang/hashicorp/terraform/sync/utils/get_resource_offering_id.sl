namespace: io.cloudslang.hashicorp.terraform.sync.utils
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
  workflow:
    - get_ro_id:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${'https://'+host+'/dnd/api/v1/'+tenant_id+'/resource/offering/'}"
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
            - headers: "${'content-type: application/json\\n'+'Accept: application/json\\n'+'X-Auth-Token:'+x_auth_token}"
        publish:
          - ro_list: '${return_result}'
        navigate:
          - SUCCESS: get_ro_id_python
          - FAILURE: on_failure
    - do_nothing:
        do:
          io.cloudslang.base.utils.do_nothing:
            - striped_ro_id: '${ro_id.split("/resource/offering/")[1]}'
        publish:
          - striped_ro_id
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - get_ro_id_python:
        do:
          io.cloudslang.hashicorp.terraform.sync.utils.get_ro_id_python:
            - ro_list: '${ro_list}'
        publish:
          - ro_id: '${ro_id}'
        navigate:
          - SUCCESS: do_nothing
  outputs:
    - striped_ro_id: '${striped_ro_id}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_ro_id:
        x: 80
        'y': 120
      do_nothing:
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

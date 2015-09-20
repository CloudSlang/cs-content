namespace: io.cloudslang.openshift

imports:
  openshift: io.cloudslang.openshift
  utils: io.cloudslang.base.utils
  print: io.cloudslang.base.print

flow:
  name: create_new_app_flow
  inputs:
    - cartridgeName
    - applicationName
    - scale
    - gear_size
    - host
    - username
    - password
    - domain
  workflow:
    - createapp:
        do:
          openshift.create_new_app:
            - cartridgeName
            - applicationName
            - scale
            - gear_size
            - host
            - username
            - password
            - domain
        publish:
          - return_result
          - error_message
          - response_body: return_result

    - convert_to_json:
        do:
          utils.convert_to_json:
            - json_as_string: response_body
        publish:
          - json_result

    - print_json:
        do:
          print.print_text:
            - text: json_result['data']['id']

    - scaleupapp:
        do:
          openshift.scale_up_app:
            - applicationId: json_result['data']['id']
            - host
            - username
            - password
        publish:
          - return_result
          - error_message

    - stopapp:
        do:
          openshift.stop_app:
            - applicationId: json_result['data']['id']
            - host
            - username
            - password
        publish:
          - return_result
          - error_message

    - startapp:
        do:
          openshift.start_app:
            - applicationId: json_result['data']['id']
            - host
            - username
            - password
        publish:
          - return_result
          - error_message

    - restartapp:
        do:
          openshift.restart_app:
            - applicationId: json_result['data']['id']
            - host
            - username
            - password
        publish:
          - return_result
          - error_message

    - deleteapp:
        do:
          openshift.delete_app:
            - applicationId: json_result['data']['id']
            - host
            - username
            - password
            - domain
        publish:
          - return_result
          - error_message
          - response_body: return_result

  outputs:
    - return_result
    - error_message
  results:
    - SUCCESS
    - FAILURE


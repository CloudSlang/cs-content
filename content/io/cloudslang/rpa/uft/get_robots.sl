########################################################################################################################
#!!
#! @description: This flow returns the existing robots in a provided path.
#!
#! @input host: The host where UFT and robots (UFT scenarios) are located.
#! @input port: The WinRM port of the provided host. Default: https: 5986 http: 5985
#! @input protocol: The WinRM protocol.
#! @input username: The username for the WinRM connection.
#! @input password: The password for the WinRM connection.
#! @input robots_path: The path where the robots(UFT scenarios) are located.
#! @input iterator: Used for development purposes.
#!!#
########################################################################################################################
namespace: uft
flow:
  name: get_robots
  inputs:
    - host
    - port:
        required: false
    - protocol:
        required: false
    - username:
        required: false
    - password:
        required: false
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
    - robots_path
    - iterator:
        default: '0'
        private: true
  workflow:
    - get_folders:
        do:
          io.cloudslang.base.powershell.powershell_script:
            - host: '${host}'
            - port: '${port}'
            - protocol: '${protocol}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - script: "${'(Get-ChildItem -Path \"'+ robots_path +'\" -Directory).Name -join \",\"'}"
        publish:
          - exception
          - return_code
          - stderr
          - script_exit_code
          - folders: "${return_result.replace('\\n',',')}"
        navigate:
          - SUCCESS: length
          - FAILURE: on_failure
    - string_equals:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${test_file_exists}'
            - second_string: 'True'
        navigate:
          - SUCCESS: append
          - FAILURE: add_numbers
    - test_file_exists:
        do:
          io.cloudslang.base.powershell.powershell_script:
            - host: '${host}'
            - port: '${port}'
            - protocol: '${protocol}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - script: "${'Test-Path \"' + robots_path.rstrip(\\\\) + \"\\\\\" + folder_to_check + '\\\\Test.tsp\"'}"
        publish:
          - exception
          - return_code
          - stderr
          - script_exit_code
          - test_file_exists: "${return_result.replace('\\n',',')}"
        navigate:
          - SUCCESS: string_equals
          - FAILURE: on_failure
    - length:
        do:
          io.cloudslang.base.lists.length:
            - list: '${folders}'
        publish:
          - list_length: '${return_result}'
        navigate:
          - SUCCESS: is_done
          - FAILURE: on_failure
    - is_done:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${iterator}'
            - second_string: '${list_length}'
        navigate:
          - SUCCESS: default_if_empty
          - FAILURE: get_by_index
    - add_numbers:
        do:
          io.cloudslang.base.math.add_numbers:
            - value1: '${iterator}'
            - value2: '1'
        publish:
          - iterator: '${result}'
        navigate:
          - SUCCESS: is_done
          - FAILURE: on_failure
    - append:
        do:
          io.cloudslang.base.strings.append:
            - origin_string: "${get('robots_list', '')}"
            - text: "${folder_to_check + ','}"
        publish:
          - robots_list: '${new_string}'
        navigate:
          - SUCCESS: add_numbers
    - get_by_index:
        do:
          io.cloudslang.base.lists.get_by_index:
            - list: '${folders}'
            - delimiter: ','
            - index: '${iterator}'
        publish:
          - folder_to_check: '${return_result}'
        navigate:
          - SUCCESS: test_file_exists
          - FAILURE: on_failure
    - default_if_empty:
        do:
          io.cloudslang.base.utils.default_if_empty:
            - initial_value: "${get('robots_list', '')}"
            - default_value: No robots founded in the provided path.
        publish:
          - robots_list: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - robots: '${robots_list.rstrip(",")}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      length:
        x: 250
        y: 77
      default_if_empty:
        x: 637
        y: 80
        navigate:
          0579a2e1-65b5-64bc-6afb-87ae9d3dcfbb:
            targetId: 023c90fc-05ed-adf3-eb3c-da02c1f4333a
            port: SUCCESS
      add_numbers:
        x: 251
        y: 256
      string_equals:
        x: 289
        y: 416
      test_file_exists:
        x: 428
        y: 422
      get_by_index:
        x: 424
        y: 250
      is_done:
        x: 462
        y: 62
      append:
        x: 80
        y: 429
      get_folders:
        x: 53
        y: 80
    results:
      SUCCESS:
        023c90fc-05ed-adf3-eb3c-da02c1f4333a:
          x: 849
          y: 83

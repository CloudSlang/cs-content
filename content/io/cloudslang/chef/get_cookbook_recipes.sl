#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Gets a JSON STDOUT of the cookbook's recipes.
#! @input cookbook_name: cookbook name
#! @input cookbook_version: cookbook version
#! @input knife_host: IP of server with configured knife accessable via SSH, can be main Chef server
#! @input knife_username: SSH username to access server with knife
#! @input knife_privkey: optional - path to local SSH keyfile for accessing server with knife
#! @input knife_password: optional - password to access server with knife
#! @input knife_config: optional - location of knife.rb config file
#! @output knife_result: filtered output of knife command
#! @output raw_result: full STDOUT
#! @output standard_err: any STDERR
#! @result SUCCESS: command executed successfully
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.chef

imports:
  chef: io.cloudslang.chef

flow:
  name: get_cookbook_recipes
  inputs:
    - cookbook_name
    - cookbook_version
    - knife_host
    - knife_username
    - knife_privkey:
        required: false
    - knife_password:
        required: false
        sensitive: true
    - knife_config:
        required: false

  workflow:
    - get_cookbook_recipes:
        do:
          chef.knife_command:
            - knife_cmd: ${'cookbook show ' + cookbook_name + ' ' + cookbook_version + ' recipes -F JSON'}
            - knife_host
            - knife_username
            - knife_password
            - knife_privkey
            - knife_config
        publish:
          - raw_result
          - standard_err
          - knife_result

  outputs:
    - knife_result: ${knife_result}
    - raw_result
    - standard_err: ${standard_err}

#   (c) Copyright 2015 Liran Tal
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
namespace: io.cloudslang.git

imports:
  git: io.cloudslang.git

flow:
  name: test_git_flow
  inputs:
    - host: localhost
    - port: "49153"
    - username: root
    - password: screencast
    - repository: "'https://github.com/CloudSlang/cloud-slang-content.git'"
    - repository_localdir: "'/tmp/cloud-slang-content'"
    - remote: "'origin'"
    - branch: "'master'"
  workflow:
    - clone_a_git_repository:
        do:
          git.git_clone_repository:
            - host: localhost
            - port: "49153"
            - username: root
            - password: screencast
            - git_repository: repository
            - git_repository_localdir: repository_localdir
        navigate:
          SUCCESS: checkout_git_branch
          FAILURE: CLONEFAILURE

    - checkout_git_branch:
        do:
          git.git_checkout_branch:
            - host: localhost
            - port: port
            - username: superman
            - password: superman
            - git_pull_remote: remote
            - git_branch: branch
            - git_repository_localdir: repository_localdir
        navigate:
          SUCCESS: SUCCESS
          FAILURE: CHECKOUTFAILURE
        publish:
          - standard_out

  outputs:
    - standard_out

  results:
    - SUCCESS
    - CLONEFAILURE
    - CHECKOUTFAILURE


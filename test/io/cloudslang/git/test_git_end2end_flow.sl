# (c) Copyright 2015 Tusa Mihai
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#  This flow performs a end to end scenario and will:
#    - clone an existing git repository;
#    - checkout a branch;
#    - write to a file that will be committed;
#    - add the file for local commit;
#    - commit the file;
#    - push the file to git;
#    - clone again the repository;
#    - checkout a branch to verify if the newly committed file exists;
#    - read the file;
#    - cleanup repositories;
#
#  Prerequisites: install the "fhist" package on linux machine in order to use "fcomp" command.
#
#  Inputs:
#    - host - hostname or IP address
#    - port - optional - port number for running the command
#    - username - username to connect as
#    - password - optional - password of user
#    - private_key_file - optional - the path to the private key file
#    - sudo_user - optional - true or false, whether the command should execute using sudo - Default: false
#    - git_repository - the URL for cloning a git repository from
#    - git_pull_remote - optional - if git_pull is set to true then specify the remote branch to pull from - Default: origin
#    - git_branch - the git branch to checkout to
#    - git_repository_localdir - target directory the git repository will be cloned to - Default: /tmp/repo.git
#    - file_name - the name of the file - if the file doesn't exist then will be created
#    - text - optional - text to write to the file
#    - git_add_files - optional - the files that has to be added/staged - Default: "'*'"
#    - git_commit_files - optional - the files that has to be committed - Default: "'-a'"
#    - git_commit_message - optional - the message for the commit - Default: "''"
#    - git_push_branch - the branch you want to push - Default: master
#    - git_push_remote - the remote you want to push to - Default: origin
#    - user - the user to be added to sudoers group
#    - second_git_repository_localdir - test target directory where the git repository will be cloned to
#    - new_path - path to the secondary local repository to be cleaned up
#
#  Results:
#    SUCCESS: the whole scenario was successfully completed
#    CLONE_FAILURE: an error when trying to clone a git repository
#    CHECKOUT_FAILURE: an error when trying to checkout a git repository
#    WRITE_IO_ERROR: an error when text could not be written to the file
#    ADD_FAILURE: an error when trying to add files
#    COMMIT_FAILURE: an error occur when trying to commit
#    PUSH_FAILURE: an error occur when trying to commit
#    ADD_TO_SUDOERS_FAILURE: an error when trying to add a user to sudoers group
#    SECOND_CLONE_FAILURE: an error when trying to clone a git repository
#    SECOND_CHECKOUT_FAILURE: an error when trying to checkout a git repository
#    COMPARE_IO_ERROR: an error when either one of the files to compare could not be read
#    COMPARE_FAILURE: the compared files are not identical
#
####################################################

namespace: io.cloudslang.git

imports:
  git: io.cloudslang.git
  ssh: io.cloudslang.base.remote_command_execution.ssh
  strings: io.cloudslang.base.strings
  files: io.cloudslang.base.files
  linux: io.cloudslang.base.os.linux

flow:
  name: test_git_end2end_flow
  inputs:
    - host
    - port:
        required: false
    - username
    - password:
        required: false
    - private_key_file:
        required: false
    - sudo_user:
        default: false
        required: false
    - git_repository:
        required: true
    - git_pull_remote:
        default: "'origin'"
        required: false
    - git_branch:
        required: true
    - git_repository_localdir:
        default: "'/tmp/repo.git'"
        required: true
    - file_name:
        required: true
    - text:
        required: false
    - git_add_files:
        required: false
    - git_commit_files:
        required: false
    - git_commit_message:
        required: false
    - git_push_branch:
        default: "'master'"
        required: true
    - git_push_remote:
        default: "'origin'"
        required: true
    - user:
        required: true
    - root_password:
        required: true
    - second_git_repository_localdir:
        default: "'/tmp/repo.git'"
        required: true
    - new_path:
        required: false

  workflow:
    - clone_a_git_repository:
        do:
          git.git_clone_repository:
            - host
            - port
            - username
            - password
            - git_repository
            - git_repository_localdir
        navigate:
          SUCCESS: checkout_git_branch
          FAILURE: CLONE_FAILURE

    - checkout_git_branch:
        do:
          git.git_checkout_branch:
            - host
            - port
            - username
            - password
            - git_pull_remote
            - git_branch
            - git_repository_localdir
        navigate:
          SUCCESS: write_in_file_to_be_committed
          FAILURE: CHECKOUT_FAILURE
        publish:
          - standard_out

    - write_in_file_to_be_committed:
        do:
          ssh.ssh_flow:
            - host
            - port
            - username
            - password
            - private_key_file:
                required: false
            - command: "'cd ' + git_repository_localdir + ' && echo ' + text + ' >> ' + file_name"
        navigate:
          SUCCESS: add_files_to_stage_area
          FAILURE: WRITE_IO_ERROR

    - add_files_to_stage_area:
        do:
          git.git_add:
            - host
            - port
            - username
            - password
            - private_key_file:
                required: false
            - sudo_user
            - git_repository_localdir
            - git_add_files
        navigate:
          SUCCESS: commit_staged_files
          FAILURE: ADD_FAILURE

    - commit_staged_files:
        do:
          git.git_commit:
            - host
            - port
            - username
            - password
            - sudo_user
            - private_key_file:
                required: false
            - git_repository_localdir
            - git_commit_files
            - git_commit_message
        navigate:
          SUCCESS: git_push
          FAILURE: COMMIT_FAILURE

    - git_push:
        do:
          git.git_push:
            - host
            - port
            - username
            - password
            - sudo_user:
                default: false
                overridable: false
            - private_key_file:
                required: false
            - git_repository_localdir
            - git_push_branch
            - git_push_remote
        navigate:
          SUCCESS: add_user_to_sudoers_list
          FAILURE: PUSH_FAILURE

    - add_user_to_sudoers_list:
        do:
          linux.add_user_to_sudoers_list:
            - host
            - port
            - username:
                default: "'root'"
                overridable: false
            - password:
                default: root_password
                overridable: false
            - sudo_user:
                default: false
                overridable: false
            - private_key_file:
                required: false
            - user:
                required: true
        navigate:
          SUCCESS: second_clone_a_git_repository
          FAILURE: ADD_TO_SUDOERS_FAILURE

    - second_clone_a_git_repository:
        do:
          git.git_clone_repository:
            - host
            - port
            - username
            - password
            - git_repository
            - git_repository_localdir:
                default: second_git_repository_localdir
                overridable: false
        navigate:
          SUCCESS: second_checkout_git_branch
          FAILURE: SECOND_CLONE_FAILURE

    - second_checkout_git_branch:
        do:
          git.git_checkout_branch:
            - host
            - port
            - username
            - password
            - git_pull_remote
            - git_branch
            - git_repository_localdir:
                default: second_git_repository_localdir
                overridable: false
        navigate:
          SUCCESS: compare_files
          FAILURE: SECOND_CHECKOUT_FAILURE
        publish:
          - standard_out

    - compare_files:
        do:
          ssh.ssh_flow:
            - host
            - port
            - username
            - password
            - private_key_file:
                required: false
            - sudo_command: "'echo ' + password + ' | sudo -S ' if bool(sudo_user) else ''"
            - command: "sudo_command + 'cd ' + second_git_repository_localdir + ' && fcomp ' + file_name + ' ' + git_repository_localdir + '/' + file_name"
        navigate:
          SUCCESS: check_result
          FAILURE: COMPARE_IO_ERROR
        publish:
          - standard_err
          - standard_out
          - command

    - check_result:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: standard_out
            - string_to_find: "'are identical'"
        navigate:
          SUCCESS: git_cleanup_first_repository
          FAILURE: COMPARE_FAILURE

    - git_cleanup_first_repository:
        do:
          git.git_cleanup_local_repository:
            - host
            - port
            - username
            - password
            - private_key_file:
                required: false
            - git_repository_localdir
            - change_path:
                default: false
                overridable: false
            - new_path:
                default: "''"
                overridable: false
        navigate:
          SUCCESS: git_cleanup_second_repository
          FAILURE: FIRST_CLEANUP_FAILURE
        publish:
          - standard_out

    - git_cleanup_second_repository:
        do:
          git.git_cleanup_local_repository:
            - host
            - port
            - username
            - password
            - private_key_file:
                required: false
            - git_repository_localdir:
                default: second_git_repository_localdir
                overridable: false
            - change_path:
                default: true
                overridable: false
            - new_path:
                default: second_git_repository_localdir
                overridable: false
        publish:
          - standard_out

  outputs:
    - standard_out

  results:
    - SUCCESS
    - CLONE_FAILURE
    - CHECKOUT_FAILURE
    - WRITE_IO_ERROR
    - ADD_FAILURE
    - COMMIT_FAILURE
    - PUSH_FAILURE
    - ADD_TO_SUDOERS_FAILURE
    - SECOND_CLONE_FAILURE
    - SECOND_CHECKOUT_FAILURE
    - COMPARE_IO_ERROR
    - COMPARE_FAILURE
    - FIRST_CLEANUP_FAILURE
    - FAILURE
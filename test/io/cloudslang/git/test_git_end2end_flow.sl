#   (c) Copyright 2019 EntIT Software LLC, a Micro Focus company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
########################################################################################################################
#!!
#! @description: This flow performs a end to end scenario and will:
#!               - clone an existing git repository;
#!               - checkout a branch;
#!               - write to a file that will be committed;
#!               - add the file for local commit;
#!               - commit the file;
#!               - push the file to git;
#!               - clone again the repository;
#!               - checkout a branch to verify if the newly committed file exists;
#!               - read the file;
#!               - cleanup repositories;
#! @prerequisites: install the "fhist" package on linux machine in order to use "fcomp" command.
#! @input host: hostname or IP address
#! @input port: Optional - port number for running the command
#! @input username: username to connect as
#! @input password: Optional - password of user
#! @input private_key_file: Optional - the path to the private key file
#! @input sudo_user: Optional - true or false, whether the command should execute using sudo - Default: false
#! @input git_repository: The URL for cloning a git repository from
#! @input git_pull_remote: Optional - if git_pull is set to true then specify the remote branch to pull from - Default: origin
#! @input git_branch: The git branch to checkout to
#! @input git_repository_localdir: target directory the git repository will be cloned to - Default: /tmp/repo.git
#! @input file_name: The name of the file - if the file doesn't exist then will be created
#! @input text: Optional - text to write to the file
#! @input git_add_files: Optional - the files that has to be added/staged - Default: "*"
#! @input git_commit_files: Optional - the files that has to be committed - Default: "-a"
#! @input git_commit_message: Optional - the message for the commit
#! @input git_push_branch: The branch you want to push - Default: master
#! @input git_push_remote: The remote you want to push to - Default: origin
#! @input user: The user to be added to sudoers group
#! @input second_git_repository_localdir: test target directory where the git repository will be cloned to
#! @input new_path: path to the secondary local repository to be cleaned up
#! @result SUCCESS: The whole scenario was successfully completed
#! @result CLONE_FAILURE: An error when trying to clone a git repository
#! @result CHECKOUT_FAILURE: An error when trying to checkout a git repository
#! @result WRITE_IO_ERROR: An error when text could not be written to the file
#! @result ADD_FAILURE: An error when trying to add files
#! @result COMMIT_FAILURE: An error occur when trying to commit
#! @result PUSH_FAILURE: An error occur when trying to commit
#! @result ADD_TO_SUDOERS_FAILURE: An error when trying to add a user to sudoers group
#! @result SECOND_CLONE_FAILURE: An error when trying to clone a git repository
#! @result SECOND_CHECKOUT_FAILURE: An error when trying to checkout a git repository
#! @result COMPARE_IO_ERROR: An error when either one of the files to compare could not be read
#! @result COMPARE_FAILURE: The compared files are not identical
#!!#
####################################################

namespace: io.cloudslang.git

imports:
  git: io.cloudslang.git
  ssh: io.cloudslang.base.ssh
  strings: io.cloudslang.base.strings
  files: io.cloudslang.base.filesystem
  linux: io.cloudslang.base.os.linux.users

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
        default: 'false'
        required: false
    - git_repository:
        required: true
    - git_pull_remote:
        default: "origin"
        required: false
    - git_branch:
        required: true
    - git_repository_localdir:
        default: "/tmp/repo.git"
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
        default: "master"
        required: true
    - git_push_remote:
        default: "origin"
        required: true
    - user:
        required: true
    - root_password:
        required: true
    - second_git_repository_localdir:
        default: "/tmp/repo.git"
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
            - private_key_file
            - git_repository
            - git_repository_localdir
        navigate:
          - SUCCESS: checkout_git_branch
          - FAILURE: CLONE_FAILURE

    - checkout_git_branch:
        do:
          git.git_checkout_branch:
            - host
            - port
            - username
            - password
            - private_key_file
            - git_pull_remote
            - git_branch
            - git_repository_localdir
        navigate:
          - SUCCESS: write_in_file_to_be_committed
          - FAILURE: CHECKOUT_FAILURE
        publish:
          - standard_out

    - write_in_file_to_be_committed:
        do:
          ssh.ssh_flow:
            - host
            - port
            - username
            - password
            - private_key_file
            - command: ${ 'cd ' + git_repository_localdir + ' && echo ' + text + ' >> ' + file_name }
        navigate:
          - SUCCESS: add_files_to_stage_area
          - FAILURE: WRITE_IO_ERROR

    - add_files_to_stage_area:
        do:
          git.git_add:
            - host
            - port
            - username
            - password
            - private_key_file
            - sudo_user
            - git_repository_localdir
            - git_add_files
        navigate:
          - SUCCESS: commit_staged_files
          - FAILURE: ADD_FAILURE

    - commit_staged_files:
        do:
          git.git_commit:
            - host
            - port
            - username
            - password
            - sudo_user
            - private_key_file
            - git_repository_localdir
            - git_commit_files
            - git_commit_message
        navigate:
          - SUCCESS: git_push
          - FAILURE: COMMIT_FAILURE

    - git_push:
        do:
          git.git_push:
            - host
            - port
            - username
            - password
            - sudo_user: 'false'
            - private_key_file
            - git_repository_localdir
            - git_push_branch
            - git_push_remote
        navigate:
          - SUCCESS: add_user_to_sudoers_list
          - FAILURE: PUSH_FAILURE

    - add_user_to_sudoers_list:
        do:
          linux.add_user_to_sudoers_list:
            - host
            - port
            - username: "root"
            - password: ${ root_password }
            - sudo_user: 'false'
            - private_key_file
            - user
        navigate:
          - SUCCESS: second_clone_a_git_repository
          - FAILURE: ADD_TO_SUDOERS_FAILURE

    - second_clone_a_git_repository:
        do:
          git.git_clone_repository:
            - host
            - port
            - username
            - password
            - private_key_file
            - git_repository
            - git_repository_localdir: ${ second_git_repository_localdir }
        navigate:
          - SUCCESS: second_checkout_git_branch
          - FAILURE: SECOND_CLONE_FAILURE

    - second_checkout_git_branch:
        do:
          git.git_checkout_branch:
            - host
            - port
            - username
            - password
            - private_key_file
            - git_pull_remote
            - git_branch
            - git_repository_localdir: ${ second_git_repository_localdir }
        navigate:
          - SUCCESS: compare_files
          - FAILURE: SECOND_CHECKOUT_FAILURE
        publish:
          - standard_out

    - compare_files:
        do:
          ssh.ssh_flow:
            - host
            - port
            - username
            - password
            - private_key_file
            - sudo_command: ${ 'echo ' + password + ' | sudo -S ' if bool(sudo_user) else '' }
            - command: ${ sudo_command + 'cd ' + second_git_repository_localdir + ' && fcomp ' + file_name + ' ' + git_repository_localdir + '/' + file_name }
        navigate:
          - SUCCESS: check_result
          - FAILURE: COMPARE_IO_ERROR
        publish:
          - standard_err
          - standard_out
          - command

    - check_result:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${ standard_out }
            - string_to_find: "are identical"
        navigate:
          - SUCCESS: git_cleanup_first_repository
          - FAILURE: COMPARE_FAILURE

    - git_cleanup_first_repository:
        do:
          git.git_cleanup_local_repository:
            - host
            - port
            - username
            - password
            - private_key_file
            - git_repository_localdir
            - change_path: "false"
            - new_path: ""
        navigate:
          - SUCCESS: git_cleanup_second_repository
          - FAILURE: FIRST_CLEANUP_FAILURE
        publish:
          - standard_out

    - git_cleanup_second_repository:
        do:
          git.git_cleanup_local_repository:
            - host
            - port
            - username
            - password
            - private_key_file
            - git_repository_localdir: ${ second_git_repository_localdir }
            - change_path: 'true'
            - new_path: ${ second_git_repository_localdir }
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

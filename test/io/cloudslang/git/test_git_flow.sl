#   (c) Copyright 2022 Micro Focus, L.P.
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
namespace: io.cloudslang.git

imports:
  git: io.cloudslang.git
  ssh: io.cloudslang.base.ssh

flow:
  name: test_git_flow

  inputs:
    - host
    - port
    - username
    - password
    - git_repository
    - git_fetch_remote
    - git_repository_localdir
    - git_pull_remote
    - git_merge_branch
    - git_branch
    - git_reset_target
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
          - SUCCESS: checkout_git_branch
          - FAILURE: CLONEFAILURE

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
          - SUCCESS: fetch_git_branch
          - FAILURE: CHECKOUTFAILURE
        publish:
          - standard_out

    - fetch_git_branch:
        do:
          git.git_fetch:
            - host
            - port
            - username
            - password
            - git_fetch_remote
            - git_repository_localdir
        navigate:
          - SUCCESS: merge_git_branch
          - FAILURE: FETCHFAILURE
        publish:
          - standard_out

    - merge_git_branch:
        do:
          git.git_merge:
            - host
            - port
            - username
            - password
            - git_merge_branch
            - git_repository_localdir
        navigate:
          - SUCCESS: reset_git_branch
          - FAILURE: MERGEFAILURE
        publish:
          - standard_out

    - reset_git_branch:
        do:
          git.git_reset:
            - host
            - port
            - username
            - password
            - git_reset_target
            - git_repository_localdir
        navigate:
          - SUCCESS: git_cleanup
          - FAILURE: RESETFAILURE
        publish:
          - standard_out

    - git_cleanup:
        do:
          ssh.ssh_flow:
            - host
            - port
            - command: ${ 'rm -r ' + git_repository_localdir }
            - username
            - password
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: CLEANUPFAILURE
        publish:
          - standard_out

  outputs:
    - standard_out

  results:
    - SUCCESS
    - CLONEFAILURE
    - CHECKOUTFAILURE
    - CLEANUPFAILURE
    - MERGEFAILURE
    - RESETFAILURE
    - FETCHFAILURE

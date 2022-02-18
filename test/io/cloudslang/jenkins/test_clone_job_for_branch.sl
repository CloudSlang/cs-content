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

namespace: io.cloudslang.jenkins

imports:
  jenkins: io.cloudslang.jenkins
  utils: io.cloudslang.base.utils

flow:
  name: test_clone_job_for_branch

  inputs:
    - host
    - port:
        required: false
    - config_xml
    - job_name:
        default: "job1"
        private: true
    - jenkins_port:
        default: "49165"
        private: true

  workflow:
    - create_jenkins_job:
        do:
          jenkins.create_job:
            - url: "${ 'http://' + host + ':' + jenkins_port }"
            - job_name
            - config_xml
        navigate:
          - SUCCESS: build_jenkins_job
          - FAILURE: FAIL_TO_CREATE_JOB
    - build_jenkins_job:
        do:
          jenkins.invoke_job:
            - url: "${ 'http://' + host + ':' + jenkins_port }"
            - job_name
        navigate:
          - SUCCESS: wait
          - FAILURE: FAIL_TO_CREATE_JOB
    - wait:
        do:
          utils.sleep:
            - seconds: '10'
        navigate:
          - SUCCESS: get_last_buildnumber
          - FAILURE: FAIL_TO_GET_BUILDNUMBER

    - get_last_buildnumber:
        do:
          jenkins.get_last_buildnumber:
            - url: "${ 'http://' + host + ':' + jenkins_port }"
            - job_name
        publish:
          - last_buildnumber
        navigate:
          - SUCCESS: clone_job
          - FAILURE: FAIL_TO_GET_BUILDNUMBER

    - clone_job:
        do:
          jenkins.clone_job_for_branch:
            - url: "${ 'http://' + host + ':' + jenkins_port }"
            - jnks_job_name: "job1"
            - jnks_new_job_name: "job2"
            - new_scm_url: "123"
            - delete_job_if_existing: "true"
            - email_host: "host"
            - email_port: "25"
            - email_sender: "email@hp.com"
            - email_recipient: "email@hp.com"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAIL_TO_CLONE_JOB
  outputs:
    - last_buildnumber
  results:
    - SUCCESS
    - FAIL_TO_CLONE_JOB
    - FAIL_TO_CREATE_JOB
    - FAIL_TO_GET_BUILDNUMBER

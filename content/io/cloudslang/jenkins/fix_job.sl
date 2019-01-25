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
#! @description: "Fixes" following issue in a Jenkins job by disabling and enabling the job.
#!               After copying a job, the job cannot be directly triggered from the Jenkins UI because the "Build now"
#!               link is missing.
#!
#! @input url: The URL to Jenkins
#! @input job_name: The name of the job to fix
#!
#! @result SUCCESS: Jenkins job successfully enabled/disabled and fixed
#! @result FAILURE: There was an error while trying to enable/disable the Jenkins job in an attempt to fix it
#!!#
########################################################################################################################

namespace: io.cloudslang.jenkins

imports:
  jenkins: io.cloudslang.jenkins

flow:
  name: fix_job

  inputs:
    - url
    - job_name

  workflow:

    - disable_job:
        do:
          jenkins.disable_job:
            - url
            - job_name

    - enable_job:
        do:
          jenkins.enable_job:
            - url
            - job_name

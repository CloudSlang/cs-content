#   Copyright 2023 Open Text
#   This program and the accompanying materials
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
#! @description: Creates a JSON object with the given inputs.
#!
#! @input terraform_version: The version of Terraform to use for this workspace. Upon creating a workspace, the latest
#!                           version is selected unless otherwise specified (e.g. "0.11.1").
#!                           Default: '1.2.0'
#! @input workspace_description: A description of the workspace to be created.
#!                               Optional
#! @input working_directory: A relative path that Terraform will execute within. This defaults to the root of your
#!                           repository and is typically set to a subdirectory matching the environment when multiple
#!                           environments exist within the same repository.
#!                           Optional
#! @input trigger_prefixes: List of repository-root-relative paths which should be tracked for changes, in addition to
#!                          the working directory.
#!                          Optional
#! @input vcs_repo_id: A reference to your VCS repository in the format :org/:repo where :org and :repo refer to the
#!                     organization and repository in your VCS provider.
#!                     Optional
#! @input oauth_token_id: The VCS Connection (OAuth Connection + Token) to use. This ID can be obtained from the
#!                        oauth-tokens endpoint.
#!                        Optional
#! @input vcs_branch_name: The repository branch that Terraform will execute from. If omitted or submitted as an empty
#!                         string, this defaults to the repository's default branch (e.g. master) .
#!                         Optional
#! @input ingress_submodules: Whether submodules should be fetched when cloning the VCS repository.
#!                            Optional
#!
#! @output optional_property_json: Optional property JSON.
#!!#
########################################################################################################################

namespace: io.cloudslang.hashicorp.terraform.utils

operation:
  name: create_optional_property_json
  inputs:
    - terraform_version:
        required: true
    - workspace_description:
        required: false
    - working_directory:
        required: false
    - trigger_prefixes:
        required: false
    - vcs_repo_id:
        required: false
    - oauth_token_id:
        required: false
    - vcs_branch_name:
        required: false
    - ingress_submodules:
        required: false
  python_action:
    use_jython: false
    script: "# do not remove the execute function\ndef execute(terraform_version,workspace_description,working_directory,trigger_prefixes,vcs_repo_id,oauth_token_id,vcs_branch_name,ingress_submodules):\n    optional_property_json = '\\\"terraform_version\\\": \\\"'+terraform_version+'\\\"'\n    if workspace_description:\n        optional_property_json = optional_property_json + ',\\\"description\\\": \\\"'+workspace_description+'\\\"'\n    if working_directory:\n        optional_property_json = optional_property_json + ',\\\"working_directory\\\": \\\"'+working_directory+'\\\"'\n    if trigger_prefixes:\n        optional_property_json = optional_property_json + ',\\\"trigger_prefixes\\\": \\\"'+trigger_prefixes+'\\\"'\n    if vcs_repo_id and oauth_token_id:\n        if vcs_branch_name:\n            optional_property_json = optional_property_json + ',\\\"vcs-repo\\\": {\\\"identifier\\\":\\\"'+vcs_repo_id+'\\\",\\\"oauth-token-id\\\":\\\"'+oauth_token_id+'\\\",\\\"branch\\\":\\\"'+vcs_branch_name+'\\\",\\\"ingress_submodules\\\":'+ingress_submodules+'}'\n        else:\n            optional_property_json = optional_property_json + ',\\\"vcs-repo\\\": {\\\"identifier\\\":\\\"'+vcs_repo_id+'\\\",\\\"oauth-token-id\\\":\\\"'+oauth_token_id+'\\\",\\\"default-branch\\\":true,\\\"ingress_submodules\\\":'+ingress_submodules+'}'\n    return{\"optional_property_json\":optional_property_json}"
  outputs:
    - optional_property_json
  results:
    - SUCCESS

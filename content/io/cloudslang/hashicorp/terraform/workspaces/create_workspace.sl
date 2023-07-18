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
#! @description: Creates a workspace which represent running infrastructure managed by Terraform.
#!
#! @input auth_token: The authorization token for terraform.
#! @input organization_name: The name of the organization.
#! @input workspace_name: The name of the workspace, which can only include letters, numbers, -, and _. This will be
#!                        used as an identifier and must be unique in the organization.
#!                        Optional
#! @input workspace_description: A description of the workspace to be created.
#!                               Optional
#! @input auto_apply: Whether to automatically apply changes when a Terraform plan is successful, with some
#!                    exceptions.
#!                    Default: 'false'
#!                    Optional
#! @input file_triggers_enabled: Whether to filter runs based on the changed files in a VCS push. If enabled, the
#!                               working-directory and trigger-prefixes describe a set of paths which must contain
#!                               changes for a VCS push to trigger a run. If disabled, any push will trigger a run.
#!                               Default: 'true'
#!                               Optional
#! @input working_directory: A relative path that Terraform will execute within. This defaults to the root of your
#!                           repository and is typically set to a subdirectory matching the environment when multiple
#!                           environments exist within the same repository.
#!                           Optional
#! @input trigger_prefixes: List of repository-root-relative paths which should be tracked for changes, in addition to
#!                          the working directory.
#!                          Optional
#! @input queue_all_runs: Whether runs should be queued immediately after workspace creation. When set to false, runs
#!                        triggered by a VCS change will not be queued until at least one run is manually
#!                        queued.
#!                        Default: 'false'
#!                        Optional
#! @input speculative_enabled: Whether this workspace allows speculative plans. Setting this to false prevents Terraform
#!                             Cloud from running plans on pull requests, which can improve security if the VCS
#!                             repository is public or includes untrusted contributors.
#!                               Default: 'true'
#!                             Optional
#! @input ingress_submodules: Whether submodules should be fetched when cloning the VCS repository.
#!                            Default: 'false'
#!                            Optional
#! @input vcs_repo_id: A reference to your VCS repository in the format :org/:repo where :org and :repo refer to the
#!                     organization and repository in your VCS provider.
#!                     Optional
#! @input vcs_branch_name: The repository branch that Terraform will execute from. If omitted or submitted as an empty
#!                         string, this defaults to the repository's default branch (e.g. master) .
#!                         Optional
#! @input oauth_token_id: The VCS Connection (OAuth Connection + Token) to use. This ID can be obtained from the
#!                        oauth-tokens endpoint.
#!                        Optional
#! @input terraform_version: The version of Terraform to use for this workspace. Upon creating a workspace, the latest
#!                           version is selected unless otherwise specified (e.g. "0.11.1").
#!                           Default: '0.12.1'
#!                           Optional
#! @input request_body: The request body of the workspace.
#!                      Optional
#! @input proxy_host: Proxy server used to access the Terraform service.
#!                    Optional
#! @input proxy_port: Proxy server port used to access the Terraform service.
#!                    Default: '8080'
#!                    Optional
#! @input proxy_username: Proxy server user name.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the proxy_username input value.
#!                        Optional
#! @input trust_all_roots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no
#!                         trusted certification authority issued it.
#!                         Default: 'false'
#!                         Optional
#! @input x_509_hostname_verifier: Specifies the way the server hostname must match a domain name in the subject's
#!                                 Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to
#!                                 "allow_all" to skip any checking. For the value "browser_compatible" the hostname
#!                                 verifier works the same way as Curl and Firefox. The hostname must match either the
#!                                 first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of
#!                                 the subject-alts. The only difference between "browser_compatible" and "strict" is
#!                                 that a wildcard (such as "*.foo.com") with "browser_compatible" matches all
#!                                 subdomains, including "a.b.foo.com".
#!                                 Default: 'strict'
#!                                 Optional
#! @input trust_keystore: The pathname of the Java TrustStore file. This contains certificates from other parties that
#!                        you expect to communicate with, or from Certificate Authorities that you trust to identify
#!                        other parties.  If the protocol (specified by the 'url') is not 'https' or if trustAllRoots is
#!                        'true' this input is ignored. Format: Java KeyStore (JKS)
#!                        Optional
#! @input trust_password: The password associated with the TrustStore file. If trustAllRoots is false and trustKeystore
#!                        is empty, trustPassword default will be supplied.
#!                        Optional
#! @input connect_timeout: The time to wait for a connection to be established, in seconds. A timeout value of '0'
#!                         represents an infinite timeout.
#!                         Default: '10000'
#!                         Optional
#! @input socket_timeout: The timeout for waiting for data (a maximum period inactivity between two consecutive data
#!                        packets), in seconds. A socketTimeout value of '0' represents an infinite timeout.
#!                        Optional
#! @input keep_alive: Specifies whether to create a shared connection that will be used in subsequent calls. If
#!                    keepAlive is false, the already open connection will be used and after execution it will close it.
#!                    Default: 'true'
#!                    Optional
#! @input connections_max_per_route: The maximum limit of connections on a per route basis.
#!                                   Default: '2'
#!                                   Optional
#! @input connections_max_total: The maximum limit of connections in total.
#!                               Default: '20'
#!                               Optional
#! @input response_character_set: The character encoding to be used for the HTTP response. If responseCharacterSet is
#!                                empty, the charset from the 'Content-Type' HTTP response header will be used. If
#!                                responseCharacterSet is empty and the charset from the HTTP response Content-Type
#!                                header is empty, the default value will be used. You should not use this for
#!                                method=HEAD or OPTIONS.
#!                                Default: 'UTF-8'
#!                                Optional
#!
#! @output return_result: If successful, returns the complete API response. In case of an error this output will contain
#!                        the error message.
#! @output exception: An error message in case there was an error while executing the request.
#! @output status_code: The HTTP status code for Terraform API request.
#! @output workspace_id: The Id of created workspace
#!
#! @result SUCCESS: The request is successfully executed.
#! @result FAILURE: There was an error while executing the request.
#!!#
########################################################################################################################

namespace: io.cloudslang.hashicorp.terraform.workspaces

operation: 
  name: create_workspace
  
  inputs:
    - auth_token:
        sensitive: true
    - authToken:
        default: ${get('auth_token', '')}
        private: true
        sensitive: true
    - organization_name
    - organizationName: 
        default: ${get('organization_name', '')}  
        private: true 
    - workspace_name:
        required: false
    - workspaceName:
        default: ${get('workspace_name', '')}
        required: false
        private: true 
    - workspace_description:  
        required: false  
    - workspaceDescription: 
        default: ${get('workspace_description', '')}  
        required: false 
        private: true 
    - auto_apply:  
        required: false  
    - autoApply: 
        default: ${get('auto_apply', '')}  
        required: false 
        private: true 
    - file_triggers_enabled:  
        required: false  
    - fileTriggersEnabled: 
        default: ${get('file_triggers_enabled', '')}  
        required: false 
        private: true 
    - working_directory:  
        required: false  
    - workingDirectory: 
        default: ${get('working_directory', '')}  
        required: false 
        private: true 
    - trigger_prefixes:  
        required: false  
    - triggerPrefixes: 
        default: ${get('trigger_prefixes', '')}  
        required: false 
        private: true 
    - queue_all_runs:  
        required: false  
    - queueAllRuns: 
        default: ${get('queue_all_runs', '')}  
        required: false 
        private: true 
    - speculative_enabled:  
        required: false  
    - speculativeEnabled: 
        default: ${get('speculative_enabled', '')}  
        required: false 
        private: true 
    - ingress_submodules:  
        required: false  
    - ingressSubmodules: 
        default: ${get('ingress_submodules', '')}  
        required: false 
        private: true 
    - vcs_repo_id:  
        required: false  
    - vcsRepoId: 
        default: ${get('vcs_repo_id', '')}  
        required: false 
        private: true 
    - vcs_branch_name:  
        required: false  
    - vcsBranchName: 
        default: ${get('vcs_branch_name', '')}  
        required: false 
        private: true 
    - oauth_token_id:  
        required: false  
    - oauthTokenId: 
        default: ${get('oauth_token_id', '')}  
        required: false 
        private: true 
    - terraform_version:  
        required: false  
    - terraformVersion: 
        default: ${get('terraform_version', '')}  
        required: false 
        private: true 
    - request_body:  
        required: false  
    - requestBody: 
        default: ${get('request_body', '')}  
        required: false 
        private: true  
    - proxy_host:  
        required: false  
    - proxyHost: 
        default: ${get('proxy_host', '')}  
        required: false 
        private: true 
    - proxy_port:  
        required: false  
    - proxyPort: 
        default: ${get('proxy_port', '')}  
        required: false 
        private: true 
    - proxy_username:  
        required: false  
    - proxyUsername: 
        default: ${get('proxy_username', '')}  
        required: false 
        private: true 
    - proxy_password:  
        required: false  
        sensitive: true
    - proxyPassword: 
        default: ${get('proxy_password', '')}  
        required: false 
        private: true 
        sensitive: true
    - trust_all_roots:  
        required: false  
    - trustAllRoots: 
        default: ${get('trust_all_roots', 'false')}
        required: false 
        private: true 
    - x_509_hostname_verifier:  
        required: false  
    - x509HostnameVerifier: 
        default: ${get('x_509_hostname_verifier', 'strict')}
        required: false 
        private: true 
    - trust_keystore:  
        required: false  
    - trustKeystore: 
        default: ${get('trust_keystore', '')}  
        required: false 
        private: true 
    - trust_password:  
        required: false  
        sensitive: true
    - trustPassword: 
        default: ${get('trust_password', '')}  
        required: false 
        private: true 
        sensitive: true
    - connect_timeout:  
        required: false  
    - connectTimeout: 
        default: ${get('connect_timeout', '')}  
        required: false 
        private: true 
    - socket_timeout:  
        required: false  
    - socketTimeout: 
        default: ${get('socket_timeout', '')}  
        required: false 
        private: true
    - keep_alive:  
        required: false  
    - keepAlive: 
        default: ${get('keep_alive', '')}  
        required: false 
        private: true 
    - connections_max_per_route:  
        required: false  
    - connectionsMaxPerRoute: 
        default: ${get('connections_max_per_route', '')}  
        required: false 
        private: true 
    - connections_max_total:  
        required: false  
    - connectionsMaxTotal: 
        default: ${get('connections_max_total', '')}  
        required: false 
        private: true 
    - response_character_set:  
        required: false  
    - responseCharacterSet: 
        default: ${get('response_character_set', '')}  
        required: false 
        private: true 
    
  java_action: 
    gav: 'io.cloudslang.content:cs-hashicorp-terraform:1.0.9'
    class_name: 'io.cloudslang.content.hashicorp.terraform.actions.workspaces.CreateWorkspace'
    method_name: 'execute'
  
  outputs:
    - return_result: ${get('returnResult', '')} 
    - exception: ${get('exception', '')} 
    - status_code: ${get('statusCode', '')} 
    - workspace_id: ${get('workspaceId', '')} 
  
  results:
    - SUCCESS: ${returnCode=='0'} 
    - FAILURE

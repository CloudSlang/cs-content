#   (c) Copyright 2021 Micro Focus, L.P.
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
#! @input tenant_id: The tenantId value used to control who can sign into the application.
#! @input client_id: The Application ID assigned to your app when you registered it with Azure AD.
#! @input client_secret: The application secret that you created in the app registration portal for your app.
#! @input subscription_id: Specifies the unique identifier of Azure subscription.
#! @input location: The Resource location.
#! @input job_name: The name of the streaming job
#! @input resource_group_name: The name of the resource group that contains the resource. You can obtain this value from
#!                             the Azure Resource Manager API or the portal.
#! @input stream_job_input_name: The name of the streaming job input.
#! @input storage_account_name_for_input: Provide the existing storage account name.
#! @input account_key_for_storage_input: Access keys to authenticate your applications when making requests to this
#!                                       Azure storage account.
#! @input stream_job_output_name: The name of the streaming job output.
#! @input container_name_stream_input: creates a new container under the specified account if not exists.
#! @input container_name_stream_output: creates a new container under the specified account if not exists.
#! @input storage_account_name_for_output: Provide the existing storage account name.
#! @input account_key_for_storage_output: Access keys to authenticate your applications when making requests to this
#!                                        Azure storage account.
#! @input transformation_name: The name of the transformation.
#! @input query: Specifies the query that will be run in the streaming job.
#! @input expand: The $expand OData query parameter. This is a comma-separated list of additional streaming job
#!                properties to include in the response, beyond the default set returned when this parameter is absent.
#!                The default set is all streaming job properties other than 'inputs', 'transformation', 'outputs', and
#!                'functions'.
#!                "Example: inputs, outputs, transformation, functions.
#! @input streaming_units: Specifies the number of streaming units that the streaming job uses.
#! @input output_start_time: Value is either an ISO-8601 formatted time stamp that indicates the starting point of the
#!                           output event stream, or null to indicate that the output event stream will start whenever
#!                           the streaming job is started. This property must have a value if outputStartMode is
#!                           set to CustomTime.
#! @input output_error_policy: The output_error_policy Indicates the policy to apply to events that arrive at the output
#!                             and cannot be written to the external storage due to being malformed (missing column
#!                             values, column values of wrong type or size).
#!                             Valid Values: Drop, Stop
#!                             Default: Stop
#! @input events_late_arrival_max_delay_in_seconds: The maximum tolerable delay in seconds where events arriving late
#!                                                  could be included. Supported range is -1 to 1814399
#!                                                  (20.23:59:59 days) and -1 is used to specify wait indefinitely.
#!                                                  If the property is absent, it is interpreted to have a value of -1.
#!                                                  Default: 5 .
#! @input output_start_mode: Value may be JobStartTime, CustomTime, or LastOutputEventTime to indicate whether the
#!                           starting point of the output event stream should start whenever the job is started,
#!                           start at a custom user time stamp specified via the outputStartTime property, or
#!                           start from the last event output time.
#!                           Valid Values: CustomTime, JobStartTime,
#!                           LastOutputEventTime.
#!                           Default: JobStartTime.
#! @input sku_name: The name of the SKU. Describes the SKU of the streaming job.
#!                  Default: Standard .
#! @input resource: Resource URl for which the Authentication Token is intended.
#!                  Default: 'https://management.azure.com/';.
#! @input api_version: The client Api Version.
#!                     Default: 2016-03-01.
#! @input events_out_of_order_policy: The events_out_of_order_policy Indicates the policy to apply to events that
#!                                    arrive out of order in the input event stream.
#!                                    Valid Values: Drop, Adjust
#!                                    Default: Adjust.
#! @input tags: The Resource tags.
#!              Example: {"key1": "value1"} .
#! @input compatibility_level: Controls certain runtime behaviors of the streaming job.
#!                             Default: 1.0 .
#! @input data_locale: The data locale of the stream analytics job. Value should be the name of a supported.
#!                     Default: en-US.
#! @input events_out_of_order_max_delay_in_seconds: The maximum tolerable delay in seconds where out-of-order events can
#!                                                  be adjusted to be back in order.
#!                                                  Default: 0 .
#! @input proxy_host: Proxy server used to access the Azure service.
#! @input proxy_port: Proxy server port used to access the Azure service.
#!                    Default: '8080' .
#! @input proxy_username: Proxy server user name.
#! @input proxy_password: Proxy server password associated with the proxy_username input value.
#! @input trust_all_roots: Specifies whether to enable weak security over SSL/TSL.A certificate is trusted even if no
#!                         trusted certification authority issued it.
#!                         Default: 'false';
#! @input x_509_hostname_verifier: Specifies the way the server hostname must match a domain name in the subject's
#!                                 Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to
#!                                 "allow_all" to skip any checking. For the value "browser_compatible" the hostname
#!                                 verifier works the same way as Curl and Firefox. The hostname must match either the
#!                                 first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of
#!                                 the subject-alts. The only difference between "browser_compatible" and "strict" is
#!                                 that a wildcard (such as "*.foo.com") with "browser_compatible" matches all
#!                                 subdomains, including "a.b.foo.com".
#!                                 Default: 'strict'.
#! @input trust_keystore: The pathname of the Java TrustStore file. This contains certificates from other parties that
#!                        you expect to communicate with, or from Certificate Authorities that you trust to identify
#!                        other parties.  If the protocol (specified by the 'url') is not 'https' or if trustAllRoots
#!                        is 'true' this input is ignored. Format: Java KeyStore (JKS).
#! @input trust_password: The password associated with the TrustStore file. If trustAllRoots is false and trustKeystore
#!                        is empty, trustPassword default will be supplied.
#!
#! @output streaming_job_name: The name of the streaming job.
#! @output streamjob_input_name: The name of the streaming job input.
#! @output streamjob_output_name: The name of the streaming job output.
#!
#! @result SUCCESS: The request was successfully executed.
#! @result FAILURE: There was an error while executing the request.
#!!#
########################################################################################################################
namespace: io.cloudslang.microsoft.azure.streamanalytics
flow:
  name: create_stream_analytics_job_blob_storage
  inputs:
    - tenant_id
    - client_id
    - client_secret:
        sensitive: true
    - subscription_id
    - location
    - job_name
    - resource_group_name
    - stream_job_input_name
    - storage_account_name_for_input
    - account_key_for_storage_input
    - stream_job_output_name
    - container_name_stream_input
    - container_name_stream_output
    - storage_account_name_for_output
    - account_key_for_storage_output
    - transformation_name
    - query
    - expand:
        required: false
    - streaming_units:
        default: '1'
        required: false
    - output_start_time:
        required: false
    - output_error_policy:
        default: Stop
        required: false
    - events_late_arrival_max_delay_in_seconds:
        default: '5'
        required: false
    - output_start_mode:
        default: JobStartTime
        required: false
    - sku_name:
        default: Standard
        required: false
    - resource:
        required: false
    - api_version:
        default: '2016-03-01'
        required: false
    - events_out_of_order_policy:
        default: Adjust
        required: false
    - tags:
        required: false
    - compatibility_level:
        default: '1.0'
        required: false
    - data_locale:
        default: en-US
        required: false
    - events_out_of_order_max_delay_in_seconds:
        default: '0'
        required: false
    - proxy_host:
        required: false
    - proxy_port:
        default: '8080'
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
    - trust_all_roots:
        default: 'false'
        required: false
    - x_509_hostname_verifier:
        default: strict
        required: false
    - trust_keystore:
        required: false
    - trust_password:
        required: false
        sensitive: true
  workflow:
    - get_auth_token_using_web_api:
        do:
          io.cloudslang.microsoft.azure.authorization.get_auth_token_using_web_api:
            - tenant_id: '${tenant_id}'
            - client_id: '${client_id}'
            - client_secret:
                value: '${client_secret}'
                sensitive: true
            - resource: '${resource}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password:
                value: '${trust_password}'
                sensitive: true
        publish:
          - auth_token
        navigate:
          - SUCCESS: create_streaming_job
          - FAILURE: on_failure
    - create_streaming_job:
        do:
          io.cloudslang.microsoft.azure.streamanalytics.streamingjobs.create_streaming_job:
            - auth_token:
                value: '${auth_token}'
                sensitive: true
            - subscription_id: '${subscription_id}'
            - location: '${location}'
            - resource_group_name: '${resource_group_name}'
            - job_name: '${job_name}'
            - api_version: '${api_version}'
            - sku_name: '${sku_name}'
            - events_out_of_order_policy: '${events_out_of_order_policy}'
            - output_error_policy: '${output_error_policy}'
            - events_out_of_order_max_delay_in_seconds: '${events_out_of_order_max_delay_in_seconds}'
            - events_late_arrival_max_delay_in_seconds: '${events_late_arrival_max_delay_in_seconds}'
            - data_locale: '${data_locale}'
            - compatibility_level:
                value: '${compatibility_level}'
                sensitive: true
            - tags: '${tags}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password:
                value: '${trust_password}'
                sensitive: true
        publish:
          - job_id
          - job_state
          - job_name
        navigate:
          - SUCCESS: create_streaming_job_input
          - FAILURE: on_failure
    - get_streaming_job:
        do:
          io.cloudslang.microsoft.azure.streamanalytics.streamingjobs.get_streaming_job:
            - auth_token:
                value: '${auth_token}'
                sensitive: true
            - subscription_id: '${subscription_id}'
            - resource_group_name: '${resource_group_name}'
            - job_name: '${job_name}'
            - expand: '${expand}'
            - api_version: '${api_version}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password:
                value: '${trust_password}'
                sensitive: true
        publish:
          - provisioning_state
          - job_id
          - job_status: '${job_state}'
        navigate:
          - SUCCESS: check_the_status
          - FAILURE: on_failure
    - start_streaming_job:
        do:
          io.cloudslang.microsoft.azure.streamanalytics.streamingjobs.start_streaming_job:
            - auth_token:
                value: '${auth_token}'
                sensitive: true
            - subscription_id: '${subscription_id}'
            - resource_group_name: '${resource_group_name}'
            - job_name: '${job_name}'
            - api_version: '${api_version}'
            - output_start_mode: '${output_start_mode}'
            - output_start_time: '${output_start_time}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password:
                value: '${trust_password}'
                sensitive: true
        publish:
          - status_code
        navigate:
          - SUCCESS: wait_for_streaming_job_status
          - FAILURE: on_failure
    - create_streaming_job_output:
        do:
          io.cloudslang.microsoft.azure.streamanalytics.outputs.create_streaming_job_output:
            - job_name: '${job_name}'
            - auth_token:
                value: '${auth_token}'
                sensitive: true
            - stream_job_output_name: '${stream_job_output_name}'
            - resource_group_name: '${resource_group_name}'
            - subscription_id: '${subscription_id}'
            - account_name: '${storage_account_name_for_output}'
            - account_key: '${account_key_for_storage_output}'
            - container_name_stream_output: '${container_name_stream_output}'
            - container_name: '${container_name}'
            - api_version: '${api_version}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password:
                value: '${trust_password}'
                sensitive: true
        navigate:
          - SUCCESS: create_transformation
          - FAILURE: on_failure
    - wait_for_streaming_job_status:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '30'
        navigate:
          - SUCCESS: get_streaming_job
          - FAILURE: on_failure
    - check_the_status:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${job_status}'
            - second_string: Running
            - ignore_case: 'true'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: counter_for_get_the_status
    - create_streaming_job_input:
        do:
          io.cloudslang.microsoft.azure.streamanalytics.inputs.create_streaming_job_input:
            - job_name: '${job_name}'
            - auth_token:
                value: '${auth_token}'
                sensitive: true
            - stream_job_input_name: '${stream_job_input_name}'
            - resource_group_name: '${resource_group_name}'
            - subscription_id: '${subscription_id}'
            - account_name: '${storage_account_name_for_input}'
            - account_key: '${account_key_for_storage_input}'
            - container_name_stream_input: '${container_name_stream_input}'
            - container_name: '${container_name}'
            - api_version: '${api_version}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password:
                value: '${trust_password}'
                sensitive: true
        publish:
          - input_name
        navigate:
          - SUCCESS: create_streaming_job_output
          - FAILURE: on_failure
    - create_transformation:
        do:
          io.cloudslang.microsoft.azure.streamanalytics.transformations.create_transformation:
            - auth_token:
                value: '${auth_token}'
                sensitive: true
            - subscription_id: '${subscription_id}'
            - location: '${location}'
            - resource_group_name: '${resource_group_name}'
            - job_name: '${job_name}'
            - transformation_name: '${transformation_name}'
            - query: '${query}'
            - streaming_units: '${streaming_units}'
            - api_version: '${api_version}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password:
                value: '${trust_password}'
                sensitive: true
        navigate:
          - SUCCESS: start_streaming_job
          - FAILURE: on_failure
    - counter_for_get_the_status:
        do:
          io.cloudslang.microsoft.azure.utils.counter:
            - from: '1'
            - to: '80'
            - increment_by: '1'
            - reset: 'false'
        navigate:
          - HAS_MORE: wait_for_streaming_job_status
          - NO_MORE: FAILURE
          - FAILURE: on_failure
  outputs:
    - streaming_job_name: '${job_name}'
    - streamjob_input_name: '${stream_job_input_name}'
    - streamjob_output_name: '${stream_job_output_name}'
  results:
    - SUCCESS
    - FAILURE



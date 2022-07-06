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
#!!
#! @description: Describes all the images present.
#!
#! @input provider_sap: AWS endpoint as described here: https://docs.aws.amazon.com/general/latest/gr/rande.htmlDefault: 'https://ec2.amazonaws.com'.
#! @input access_key_id: The Amazon Access Key ID.
#! @input access_key: The Amazon Secret Access Key that corresponds to the Amazon Access Key ID.
#! @input proxy_host: Optional - Proxy server used to connect to Amazon API. If empty no proxy will be used.
#! @input proxy_port: Optional - Proxy server port. You must either specify values for both proxyHost and proxyPort
#! @input proxy_username: Optional - Proxy server user name.
#! @input proxy_password: Optional - Proxy server password associated with the proxyUsername input value.
#! @input worker_group: Optional - A worker group is a logical collection of workers. A worker may belong to more thanone group simultaneously.Default: 'RAS_Operator_Path'
#!
#! @output images_xml: Returns image details in xml form.
#!!#
########################################################################################################################
namespace: io.cloudslang.amazon.aws.ec2
flow:
  name: aws_describe_images
  inputs:
    - provider_sap:
        default: 'https://ec2.amazonaws.com'
        required: true
    - access_key_id
    - access_key:
        sensitive: true
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
    - worker_group:
        default: RAS_Operator_Path
        required: false
  workflow:
    - describe_images_in_region:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.amazon.aws.ec2.images.describe_images_in_region:
            - endpoint: '${provider_sap}'
            - identity: '${access_key_id}'
            - credential:
                value: '${access_key}'
                sensitive: true
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - query_params: 'Filter.2.Value=ebs&Action=DescribeImages&Filter.3.Value=machine&Filter.2.Name=root-device-type&Filter.4.Value=available&Owner.1=self&Owner.2=amazon&Filter.3.Name=image-type&Version=2016-04-01&Filter.4.Name=state&ExecutableBy.1=all'
        publish:
          - return_result
        navigate:
          - SUCCESS: convert_xml_to_json
          - FAILURE: on_failure
    - convert_xml_to_json:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.xml.convert_xml_to_json:
            - xml: '${return_result}'
        publish:
          - describe_images: '${return_result}'
        navigate:
          - SUCCESS: create_describe_images_xml
          - FAILURE: on_failure
    - create_describe_images_xml:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.amazon.aws.ec2.images.create_describe_images_xml:
            - json_data: '${describe_images}'
        publish:
          - describe_images_xml: '${describe_images_list}'
        navigate:
          - SUCCESS: SUCCESS
  outputs:
    - images_xml: '${describe_images_xml}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      do_nothing:
        x: 40
        'y': 80
      convert_xml_to_json:
        x: 160
        'y': 80
      create_describe_images_xml:
        x: 280
        'y': 80
        navigate:
          c7010960-424b-2b0a-4f44-6f210007c627:
            targetId: 7e810305-25a8-baf3-d65f-f2e50862e778
            port: SUCCESS
    results:
      SUCCESS:
        7e810305-25a8-baf3-d65f-f2e50862e778:
          x: 400
          'y': 80


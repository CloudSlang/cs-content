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
    - do_nothing:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - xml: '<?xml version="1.0" encoding="UTF-8"?><DescribeImagesResponse>    <imagesSet>        <item>            <imageId>ami-0ac701befd84cfa2f</imageId>            <imageLocation>amazon/Windows_Server-2019-English-Full-EKS_Optimized-1.21-2022.04.14</imageLocation>            <imageState>available</imageState>            <imageOwnerId>801119661308</imageOwnerId>            <creationDate>2022-04-14T23:13:30.000Z</creationDate>            <isPublic>true</isPublic>            <architecture>x86_64</architecture>            <imageType>machine</imageType>            <platform>windows</platform>            <sriovNetSupport>simple</sriovNetSupport>            <imageOwnerAlias>amazon</imageOwnerAlias>            <name>Windows_Server-2019-English-Full-EKS_Optimized-1.21-2022.04.14</name>            <description>Microsoft Windows Server 2019 Core optimized for EKS and provided by Amazon</description>            <rootDeviceType>ebs</rootDeviceType>            <rootDeviceName>/dev/sda1</rootDeviceName>            <blockDeviceMapping>                <item>                    <deviceName>/dev/sda1</deviceName>                    <ebs>                        <snapshotId>snap-061511f5b2ae6da8c</snapshotId>                        <volumeSize>50</volumeSize>                        <deleteOnTermination>true</deleteOnTermination>                        <volumeType>gp2</volumeType>                        <encrypted>false</encrypted>                    </ebs>                </item>                <item>                    <deviceName>xvdca</deviceName>                    <virtualName>ephemeral0</virtualName>                </item>                <item>                    <deviceName>xvdcb</deviceName>                    <virtualName>ephemeral1</virtualName>                </item>                <item>                    <deviceName>xvdcc</deviceName>                    <virtualName>ephemeral2</virtualName>                </item>                <item>                    <deviceName>xvdcd</deviceName>                    <virtualName>ephemeral3</virtualName>                </item>                <item>                    <deviceName>xvdce</deviceName>                    <virtualName>ephemeral4</virtualName>                </item>                <item>                    <deviceName>xvdcf</deviceName>                    <virtualName>ephemeral5</virtualName>                </item>                <item>                    <deviceName>xvdcg</deviceName>                    <virtualName>ephemeral6</virtualName>                </item>                <item>                    <deviceName>xvdch</deviceName>                    <virtualName>ephemeral7</virtualName>                </item>                <item>                    <deviceName>xvdci</deviceName>                    <virtualName>ephemeral8</virtualName>                </item>                <item>                    <deviceName>xvdcj</deviceName>                    <virtualName>ephemeral9</virtualName>                </item>                <item>                    <deviceName>xvdck</deviceName>                    <virtualName>ephemeral10</virtualName>                </item>                <item>                    <deviceName>xvdcl</deviceName>                    <virtualName>ephemeral11</virtualName>                </item>                <item>                    <deviceName>xvdcm</deviceName>                    <virtualName>ephemeral12</virtualName>                </item>                <item>                    <deviceName>xvdcn</deviceName>                    <virtualName>ephemeral13</virtualName>                </item>                <item>                    <deviceName>xvdco</deviceName>                    <virtualName>ephemeral14</virtualName>                </item>                <item>                    <deviceName>xvdcp</deviceName>                    <virtualName>ephemeral15</virtualName>                </item>                <item>                    <deviceName>xvdcq</deviceName>                    <virtualName>ephemeral16</virtualName>                </item>                <item>                    <deviceName>xvdcr</deviceName>                    <virtualName>ephemeral17</virtualName>                </item>                <item>                    <deviceName>xvdcs</deviceName>                    <virtualName>ephemeral18</virtualName>                </item>                <item>                    <deviceName>xvdct</deviceName>                    <virtualName>ephemeral19</virtualName>                </item>                <item>                    <deviceName>xvdcu</deviceName>                    <virtualName>ephemeral20</virtualName>                </item>                <item>                    <deviceName>xvdcv</deviceName>                    <virtualName>ephemeral21</virtualName>                </item>                <item>                    <deviceName>xvdcw</deviceName>                    <virtualName>ephemeral22</virtualName>                </item>                <item>                    <deviceName>xvdcx</deviceName>                    <virtualName>ephemeral23</virtualName>                </item>                <item>                    <deviceName>xvdcy</deviceName>                    <virtualName>ephemeral24</virtualName>                </item>                <item>                    <deviceName>xvdcz</deviceName>                    <virtualName>ephemeral25</virtualName>                </item>            </blockDeviceMapping>            <virtualizationType>hvm</virtualizationType>            <hypervisor>xen</hypervisor>            <enaSupport>true</enaSupport>        </item>        <item>            <imageId>ami-06819667dd8c7bc4f</imageId>            <imageLocation>aws-marketplace/Aurora_4apr2019-5998006d-1803-4c78-bc24-39fdbf7985f5-ami-023b9a8a067bd1412.4</imageLocation>            <imageState>available</imageState>            <imageOwnerId>679593333241</imageOwnerId>            <creationDate>2019-04-04T18:34:17.000Z</creationDate>            <isPublic>true</isPublic>            <productCodes>                <item>                    <productCode>5ay784rzdc8caonwd01xzioz9</productCode>                    <type>marketplace</type>                </item>            </productCodes>            <architecture>x86_64</architecture>            <imageType>machine</imageType>            <platform>windows</platform>            <sriovNetSupport>simple</sriovNetSupport>            <imageOwnerAlias>aws-marketplace</imageOwnerAlias>            <name>Aurora_4apr2019-5998006d-1803-4c78-bc24-39fdbf7985f5-ami-023b9a8a067bd1412.4</name>            <description>Aurora AMI for AWS Marketplace</description>            <rootDeviceType>ebs</rootDeviceType>            <rootDeviceName>/dev/sda1</rootDeviceName>            <blockDeviceMapping>                <item>                    <deviceName>/dev/sda1</deviceName>                    <ebs>                        <snapshotId>snap-0257fc335ef1afd63</snapshotId>                        <volumeSize>40</volumeSize>                        <deleteOnTermination>true</deleteOnTermination>                        <volumeType>gp2</volumeType>                        <encrypted>false</encrypted>                    </ebs>                </item>            </blockDeviceMapping>            <virtualizationType>hvm</virtualizationType>            <hypervisor>xen</hypervisor>            <enaSupport>true</enaSupport>        </item>        <item>            <imageId>ami-0ac72004b85a9e513</imageId>            <imageLocation>172840064832/buildkite-stack-windows-2019-05-22T05-35-35Z-us-west-2</imageLocation>            <imageState>available</imageState>            <imageOwnerId>172840064832</imageOwnerId>            <creationDate>2019-05-22T06:14:10.000Z</creationDate>            <isPublic>true</isPublic>            <architecture>x86_64</architecture>            <imageType>machine</imageType>            <platform>linux</platform>            <sriovNetSupport>simple</sriovNetSupport>            <name>buildkite-stack-windows-2019-05-22T05-35-35Z-us-west-2</name>            <description>Buildkite Elastic Stack (Windows Server 2019 w/ docker)</description>            <rootDeviceType>ebs</rootDeviceType>            <rootDeviceName>/dev/sda1</rootDeviceName>            <blockDeviceMapping>                <item>                    <deviceName>/dev/sda1</deviceName>                    <ebs>                        <snapshotId>snap-0a345b45c6b2f0c8f</snapshotId>                        <volumeSize>30</volumeSize>                        <deleteOnTermination>true</deleteOnTermination>                        <volumeType>gp2</volumeType>                        <encrypted>false</encrypted>                    </ebs>                </item>                <item>                    <deviceName>xvdca</deviceName>                    <virtualName>ephemeral0</virtualName>                </item>                <item>                    <deviceName>xvdcb</deviceName>                    <virtualName>ephemeral1</virtualName>                </item>                <item>                    <deviceName>xvdcc</deviceName>                    <virtualName>ephemeral2</virtualName>                </item>                <item>                    <deviceName>xvdcd</deviceName>                    <virtualName>ephemeral3</virtualName>                </item>                <item>                    <deviceName>xvdce</deviceName>                    <virtualName>ephemeral4</virtualName>                </item>                <item>                    <deviceName>xvdcf</deviceName>                    <virtualName>ephemeral5</virtualName>                </item>                <item>                    <deviceName>xvdcg</deviceName>                    <virtualName>ephemeral6</virtualName>                </item>                <item>                    <deviceName>xvdch</deviceName>                    <virtualName>ephemeral7</virtualName>                </item>                <item>                    <deviceName>xvdci</deviceName>                    <virtualName>ephemeral8</virtualName>                </item>                <item>                    <deviceName>xvdcj</deviceName>                    <virtualName>ephemeral9</virtualName>                </item>                <item>                    <deviceName>xvdck</deviceName>                    <virtualName>ephemeral10</virtualName>                </item>                <item>                    <deviceName>xvdcl</deviceName>                    <virtualName>ephemeral11</virtualName>                </item>                <item>                    <deviceName>xvdcm</deviceName>                    <virtualName>ephemeral12</virtualName>                </item>                <item>                    <deviceName>xvdcn</deviceName>                    <virtualName>ephemeral13</virtualName>                </item>                <item>                    <deviceName>xvdco</deviceName>                    <virtualName>ephemeral14</virtualName>                </item>                <item>                    <deviceName>xvdcp</deviceName>                    <virtualName>ephemeral15</virtualName>                </item>                <item>                    <deviceName>xvdcq</deviceName>                    <virtualName>ephemeral16</virtualName>                </item>                <item>                    <deviceName>xvdcr</deviceName>                    <virtualName>ephemeral17</virtualName>                </item>                <item>                    <deviceName>xvdcs</deviceName>                    <virtualName>ephemeral18</virtualName>                </item>                <item>                    <deviceName>xvdct</deviceName>                    <virtualName>ephemeral19</virtualName>                </item>                <item>                    <deviceName>xvdcu</deviceName>                    <virtualName>ephemeral20</virtualName>                </item>                <item>                    <deviceName>xvdcv</deviceName>                    <virtualName>ephemeral21</virtualName>                </item>                <item>                    <deviceName>xvdcw</deviceName>                    <virtualName>ephemeral22</virtualName>                </item>                <item>                    <deviceName>xvdcx</deviceName>                    <virtualName>ephemeral23</virtualName>                </item>                <item>                    <deviceName>xvdcy</deviceName>                    <virtualName>ephemeral24</virtualName>                </item>                <item>                    <deviceName>xvdcz</deviceName>                    <virtualName>ephemeral25</virtualName>                </item>            </blockDeviceMapping>            <virtualizationType>hvm</virtualizationType>            <hypervisor>xen</hypervisor>            <enaSupport>true</enaSupport>        </item>    </imagesSet></DescribeImagesResponse>'
        publish:
          - return_result: '${xml}'
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
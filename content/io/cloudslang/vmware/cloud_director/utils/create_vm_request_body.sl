#   Copyright 2024 Open Text
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
#! @description: The python operation to form the request body for create virtual machine flow.
#!
#! @input vm_name: The name of the virtual machine.
#! @input vm_template_id: The Id of the virtual machine template.
#! @input vm_template_href: The href value of the virtual machine.
#! @input vm_template_name: The name of the virtual machine template.
#! @input network_name: The name of the network.
#! @input ip_address_allocation_mode: The mode of IP allocation. Valid values are 'POOL', 'MANUAL' and 'DHCP'.
#! @input network_adapter_type: The type of network adapter. Valid values 'VMXNET3', 'E1000' and 'E1000E' and etc
#! @input computer_name: The name of the computer.
#! @input vm_description: The description of the virtual machine.
#! @input storage_profile: The href of the storage profile to be associated with vApp.
#! @input ip_address: The value of IP Address in case of manual assignment of IP.
#!
#! @output return_result: The request body for create vm flow.
#!
#! @result SUCCESS: Formed the request body for create vm successfully.
#!!#
########################################################################################################################
namespace: io.cloudslang.vmware.cloud_director.utils
operation:
  name: create_vm_request_body
  inputs:
    - vm_name
    - vm_template_id
    - vm_template_href
    - vm_template_name
    - network_name
    - ip_address_allocation_mode
    - network_adapter_type
    - computer_name:
        required: true
    - vm_description:
        required: false
    - storage_profile:
        required: false
    - ip_address:
        required: false
  python_action:
    use_jython: false
    script: "def execute(vm_name,vm_description,vm_template_id,vm_template_href,vm_template_name,network_name,ip_address_allocation_mode,ip_address,network_adapter_type,computer_name,storage_profile):\r\n    return_result = '<root:InstantiateVmTemplateParams xmlns:root=\"http://www.vmware.com/vcloud/v1.5\" xmlns:ns0=\"http://schemas.dmtf.org/ovf/envelope/1\" name=\"'+vm_name+'\" powerOn=\"true\"><root:Description>'+vm_description+'</root:Description><root:SourcedVmTemplateItem><root:Source href=\"'+vm_template_href+'\" id=\"'+vm_template_id+'\" name=\"'+vm_template_name+'\" type=\"application/vnd.vmware.vcloud.vm+xml\"/><root:VmTemplateInstantiationParams><root:NetworkConnectionSection><ns0:Info/><root:PrimaryNetworkConnectionIndex>0</root:PrimaryNetworkConnectionIndex><root:NetworkConnection network=\"'+network_name+'\"><root:NetworkConnectionIndex>0</root:NetworkConnectionIndex>'\r\n    if(ip_address_allocation_mode == \"MANUAL\" and ip_address != '') :\r\n        return_result += '<root:IpAddress>'+ip_address+'</root:IpAddress>'\r\n    return_result += '<root:IsConnected>true</root:IsConnected><root:IpAddressAllocationMode>'+ip_address_allocation_mode+'</root:IpAddressAllocationMode><root:NetworkAdapterType>'+network_adapter_type+'</root:NetworkAdapterType></root:NetworkConnection></root:NetworkConnectionSection><root:GuestCustomizationSection><ns0:Info>Specifies Guest OS Customization Settings</ns0:Info><root:Enabled>true</root:Enabled><root:ChangeSid>false</root:ChangeSid><root:JoinDomainEnabled>false</root:JoinDomainEnabled><root:UseOrgSettings>false</root:UseOrgSettings><root:AdminPasswordEnabled>false</root:AdminPasswordEnabled><root:AdminPasswordAuto>false</root:AdminPasswordAuto><root:AdminAutoLogonEnabled>false</root:AdminAutoLogonEnabled><root:AdminAutoLogonCount>0</root:AdminAutoLogonCount><root:ResetPasswordRequired>false</root:ResetPasswordRequired><root:ComputerName>'+computer_name+'</root:ComputerName></root:GuestCustomizationSection></root:VmTemplateInstantiationParams>'\r\n    if(storage_profile != '') :\r\n        return_result += '<root:StorageProfile href=\"'+storage_profile+'\" type=\"application/vnd.vmware.vcloud.vdcStorageProfile+xml\"/>'\r\n    return_result += '</root:SourcedVmTemplateItem><root:AllEULAsAccepted>true</root:AllEULAsAccepted></root:InstantiateVmTemplateParams>'\r\n    return{\"return_result\":return_result}"
  outputs:
    - return_result
  results:
    - SUCCESS


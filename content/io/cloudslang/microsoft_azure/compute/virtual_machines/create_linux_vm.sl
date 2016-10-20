#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Performs an HTTP request to create a linux virtual machine
#!
#! @input subscription_id: Azure subscription ID
#! @input auth_token: Azure authorization Bearer token
#! @input api_version: The API version used to create calls to Azure
#!                     Default: '2015-06-15'
#! @input resource_group_name: Azure resource group name
#! @input resource_group_name: Azure resource group name
#! @input vm_name: Specifies the name of the virtual machine. This name should be unique within the resource group.
#! @input nic_name: Name of the network interface card
#! @input location: Specifies the supported Azure location where the virtual machine should be created.
#!                  This can be different from the location of the resource group.
#! @input vm_size: Specifies the size of the virtual machine.
#! @input publisher: Specifies the publisher of the image.
#! @input sku: Specifies the SKU of the image used to create the virtual machine.
#! @input offer: Specifies the offer of the image used to create the virtual machine.
#! @input storage_account: Azure storage account
#! @input data_disk_name: Name of the data disk where the virtual machine will be installed
#! @input osdisk_name: Specifies information about the operating system disk used by the virtual machine.
#! @input vm_template: Virtual machine template. Either uses the default value or one given by the user in a json format.
#! @input availability_set_name: Specifies information about the availability set that the virtual machine
#!                               should be assigned to. Virtual machines specified in the same availability set
#!                               are allocated to different nodes to maximize availability.
#! @input vm_username: Specifies the name of the administrator account.
#!                        Windows-only restriction: Cannot end in "."
#!                        Disallowed values: "administrator", "admin", "user", "user1", "test", "user2", "test1",
#!                        "user3", "admin1", "1", "123", "a", "actuser", "adm", "admin2", "aspnet", "backup", "console",
#!                        "david", "guest", "john", "owner", "root", "server", "sql", "support", "support_388945a0",
#!                        "sys", "test2", "test3", "user4", "user5".
#! @input vm_password: Specifies the password of the administrator account.
#!                        Minimum-length (Windows): 8 characters
#!                        Minimum-length (Linux): 6 characters
#!                        Max-length (Windows): 123 characters
#!                        Max-length (Linux): 72 characters
#!                        Complexity requirements: 3 out of 4 conditions below need to be fulfilled
#!                        Has lower characters
#!                        Has upper characters
#!                        Has a digit
#!                        Has a special character (Regex match [\W_])
#!                        Disallowed values: "abc@123", "P@$$w0rd", "P@ssw0rd", "P@ssword123", "Pa$$word", "pass@word1",
#!                        "Password!", "Password1", "Password22", "iloveyou!"
#! @input proxy_host: optional - proxy server used to access the web site
#! @input proxy_port: optional - proxy server port - Default: '8080'
#! @input proxy_username: optional - username used when connecting to the proxy
#! @input proxy_password: optional - proxy server password associated with the <proxy_username> input value
#! @input trust_keystore: optional - the pathname of the Java TrustStore file. This contains certificates from
#!                        other parties that you expect to communicate with, or from Certificate Authorities that
#!                        you trust to identify other parties.  If the protocol (specified by the 'url') is not
#!                       'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Default value: ..JAVA_HOME/java/lib/security/cacerts
#!                        Format: Java KeyStore (JKS)
#! @input trust_password: optional - the password associated with the Trusttore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#!                        Default: ''
#! @input trust_all_roots: optional - specifies whether to enable weak security over SSL - Default: false
#! @input x_509_hostname_verifier: optional - specifies the way the server hostname must match a domain name in
#!                                 the subject's Common Name (CN) or subjectAltName field of the X.509 certificate
#!                                 Valid: 'strict', 'browser_compatible', 'allow_all' - Default: 'allow_all'
#!                                 Default: 'strict'
#!
#! @output output: json response with information about the virtual machine instance
#! @output status_code: 201 if request completed successfully, others in case something went wrong
#! @output error_message: Error message in case something went wrong
#!
#! @result SUCCESS: Linux virtual machine created successfully.
#! @result FAILURE: There was an error while trying to create the virtual machine.
#!!#
########################################################################################################################

namespace: io.cloudslang.microsoft_azure.compute.virtual_machines

imports:
  strings: io.cloudslang.base.strings
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json

flow:
  name: create_linux_vm

  inputs:
    - subscription_id
    - publisher
    - auth_token
    - sku
    - offer
    - resource_group_name
    - vm_name
    - nic_name
    - location
    - vm_username
    - vm_password
    - vm_size
    - availability_set_name
    - storage_account
    - vm_template:
        required: false
        default: >
             ${'{"id":"/subscriptions/' + subscription_id + '/resourceGroups/' + resource_group_name +
             '/providers/Microsoft.Compute/virtualMachines/' + vm_name + '","name":"' + vm_name +
             '","type":"Microsoft.Compute/virtualMachines","location":"' + location +
             '","properties":{"availabilitySet":{"id":"/subscriptions/' + subscription_id + '/resourceGroups/' +
             resource_group_name + '/providers/Microsoft.Compute/availabilitySets/' + availability_set_name +
             '"},"hardwareProfile":{"vmSize":"' + vm_size + '"},"storageProfile":{"imageReference":{"publisher":"' +
             publisher + '","offer":"' + offer + '","sku":"' + sku + '","version":"latest"},"osDisk":{"name":"' +
             vm_name + 'osDisk","vhd":{"uri":"http://' + storage_account + '.blob.core.windows.net/vhds/' +
             vm_name + 'osDisk.vhd"},"caching":"ReadWrite","createOption":"FromImage"}},"osProfile":{"computerName":"' +
             vm_name + '","adminUsername":"' + vm_username + '","adminPassword":"' + vm_password +
             '"},"networkProfile":{"networkInterfaces":[{"id":"/subscriptions/' + subscription_id +
             '/resourceGroups/' + resource_group_name + '/providers/Microsoft.Network/networkInterfaces/' +
             nic_name + '"}]}}}'}
    - api_version:
        required: false
        default: '2015-06-15'
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - proxy_port:
        default: "8080"
        required: false
    - proxy_host:
        required: false
    - trust_all_roots:
        default: "false"
        required: false
    - x_509_hostname_verifier:
        default: "strict"
        required: false
    - trust_keystore:
        required: false
    - trust_password:
        default: ''
        required: false
        sensitive: true

  workflow:
    - create_linux_machine:
        do:
          http.http_client_put:
            - url: >
                ${'https://management.azure.com/subscriptions/' + subscription_id + '/resourceGroups/' +
                resource_group_name + '/providers/Microsoft.Compute/virtualMachines/' + vm_name +
                '?validating=false&api-version=' + api_version}
            - body: ${vm_template}
            - headers: "${'Authorization: ' + auth_token}"
            - auth_type: 'anonymous'
            - preemptive_auth: 'true'
            - content_type: 'application/json'
            - request_character_set: 'UTF-8'
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - trust_all_roots
            - x_509_hostname_verifier
            - trust_keystore
            - trust_password
        publish:
          - output: ${return_result}
          - status_code
        navigate:
          - SUCCESS: check_error_status
          - FAILURE: check_error_status

    - check_error_status:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: '400,401,404'
            - string_to_find: ${status_code}
        navigate:
          - SUCCESS: retrieve_error
          - FAILURE: retrieve_success

    - retrieve_error:
        do:
          json.get_value:
            - json_input: ${output}
            - json_path: 'error,message'
        publish:
          - error_message: ${return_result}
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: retrieve_success

    - retrieve_success:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: '200,201,202'
            - string_to_find: ${status_code}
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE

  outputs:
    - output
    - status_code
    - error_message

  results:
    - SUCCESS
    - FAILURE

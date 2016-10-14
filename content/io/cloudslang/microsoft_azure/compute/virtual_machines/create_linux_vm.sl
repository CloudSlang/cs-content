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
#! @input resource_group_name: Azure resource group name
#! @input username: Username needed to log in to Azure
#! @input password: Password needed to log in to Azure
#! @input auth_token: Azure authorization Bearer token
#! @input preemptive_auth: optional - if 'true' authentication info will be sent in the first request, otherwise a request
#!                         with no authentication info will be made and if server responds with 401 and a header
#!                         like WWW-Authenticate: Basic realm="myRealm" only then will the authentication info
#!                         will be sent - Default: true
#! @input vm_name: virtual machine name
#! @input url: url to the Azure resource
#! @input auth_type: optional - authentication type
#!                   Default: "anonymous"
#! @input resource_group_name: Azure resource group name
#! @input vm_name: Specifies the name of the virtual machine. This name should be unique within the resource group.\
#! @input nic_name: Name of the network interface card
#! @input location: Specifies the supported Azure location where the virtual machine should be created.
#!                  This can be different from the location of the resource group.
#! @input admin_username: Specifies the name of the administrator account.
#!                        Windows-only restriction: Cannot end in "."
#!                        Disallowed values: "administrator", "admin", "user", "user1", "test", "user2", "test1",
#!                        "user3", "admin1", "1", "123", "a", "actuser", "adm", "admin2", "aspnet", "backup", "console",
#!                        "david", "guest", "john", "owner", "root", "server", "sql", "support", "support_388945a0",
#!                        "sys", "test2", "test3", "user4", "user5".
#! @input admin_password: Specifies the password of the administrator account.
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
#! @input vm_size: Specifies the size of the virtual machine.
#! @input publisher: Specifies the publisher of the image.
#! @input sku: Specifies the SKU of the image used to create the virtual machine.
#! @input offer: Specifies the offer of the image used to create the virtual machine.
#! @input storage_account: Azure storage account
#! @input data_disk_name: Name of the data disk where the virtual machine will be installed
#! @input osdisk_name: Specifies information about the operating system disk used by the virtual machine.
#! @input availability_set_name: Specifies information about the availability set that the virtual machine
#!                               should be assigned to. Virtual machines specified in the same availability set
#!                               are allocated to different nodes to maximize availability.
#! @input content_type: optional - content type that should be set in the request header, representing the MIME-type
#!                      of the data in the message body
#!                      Default: "application/json; charset=utf-8"
#! @input trust_keystore: optional - the pathname of the Java TrustStore file. This contains certificates from other parties
#!                        that you expect to communicate with, or from Certificate Authorities that you trust to
#!                        identify other parties.  If the protocol (specified by the 'url') is not 'https' or if
#!                        trust_all_roots is 'true' this input is ignored.
#!                        Default value: ..JAVA_HOME/java/lib/security/cacerts
#!                        Format: Java KeyStore (JKS)
#! @input trust_password: optional - the password associated with the Trusttore file. If trust_all_roots is false and trust_keystore is empty,
#!                        trustPassword default will be supplied.
#!                        Default value: ''
#! @input keystore: optional - the pathname of the Java KeyStore file. You only need this if the server requires client authentication.
#!                  If the protocol (specified by the 'url') is not 'https' or if trustAllRoots is 'true' this input is ignored.
#!                  Default value: ..JAVA_HOME/java/lib/security/cacerts
#!                  Format: Java KeyStore (JKS)
#! @input keystore_password: optional - the password associated with the KeyStore file. If trust_all_roots is false and keystore
#!                           is empty, keystore_password default will be supplied.
#!                           Default value: ''
#! @input trust_all_roots: optional - specifies whether to enable weak security over SSL - Default: true
#! @input x_509_hostname_verifier: optional - specifies the way the server hostname must match a domain name in the subject's
#!                                 Common Name (CN) or subjectAltName field of the X.509 certificate
#!                                 Valid: 'strict', 'browser_compatible', 'allow_all' - Default: 'allow_all'
#!                                 Default: 'strict'
#! @input connect_timeout: optional - time in seconds to wait for a connection to be established - Default: '0' (infinite)
#! @input socket_timeout: optional - time in seconds to wait for data to be retrieved - Default: '0' (infinite)
#! @input proxy_host: optional - proxy server used to access the web site
#! @input proxy_port: optional - proxy server port - Default: '8080'
#! @input proxy_username: optional - username used when connecting to the proxy
#! @input proxy_password: optional - proxy server password associated with the <proxy_username> input value
#! @input connections_max_per_route: optional - maximum limit of connections on a per route basis - Default: '50'
#! @input connections_max_total: optional - maximum limit of connections in total - Default: '500'
#! @input response_character_set: optional - character encoding to be used for the HTTP response - Default: 'ISO-8859-1'
#! @input use_cookies: optional - specifies whether to enable cookie tracking or not - Default: true
#! @input keep_alive: optional - specifies whether to create a shared connection that will be used in subsequent calls
#!                    Default: true
#! @input request_character_set: optional - character encoding to be used for the HTTP request - Default: 'UTF-8'
#! @input chunked_request_entity: optional - data is sent in a series of 'chunks' - Valid: true/false
#!                                Default: "false"
#!
#! @output output: json response with information about the virtual machine instance
#! @output status_code: If a VM is not found the error message will be populated with a response, empty otherwise
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
  auth: io.cloudslang.microsoft_azure.utility

flow:
  name: create_linux_vm

  inputs:
    - subscription_id
    - publisher
    - sku
    - offer
    - resource_group_name
    - vm_name
    - nic_name
    - location
    - admin_username
    - admin_password
    - vm_size
    - storage_account:
        default: ''
        required: false
    - data_disk_name:
        required: false
    - osdisk_name:
        default: ''
        required: false
    - availability_set_name:
        default: 'potato'
        required: false
    - auth_type:
        default: 'anonymous'
        required: false
    - username:
        required: false
    - password:
        required: false
    - preemptive_auth:
        default: 'true'
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
        default: 'strict'
        required: false
    - trust_keystore:
        required: false
    - trust_password:
        required: false
    - keystore:
        required: false
    - keystore_password:
        required: false
    - use_cookies:
        default: 'true'
        required: false
    - keep_alive:
        default: 'true'
        required: false
    - connections_max_per_route:
        default: '20'
        required: false
    - connections_max_total:
        default: '200'
        required: false
    - content_type:
        default: 'application/json'
        required: false
    - request_character_set:
        default: 'UTF-8'
        required: false

  workflow:
    - get_auth_token:
        do:
          auth.get_auth_token:
        publish:
          - auth_token
        navigate:
          - SUCCESS: create_linux_machine
          - FAILURE: FAILURE

    - create_linux_machine:
        do:
          http.http_client_put:
            - url: ${'https://management.azure.com/subscriptions/' + subscription_id + '/resourceGroups/' + resource_group_name + '/providers/Microsoft.Compute/virtualMachines/' + vm_name + '?validating=false&api-version=2015-06-15'}
            - body: >
                ${'{"id":"/subscriptions/' + subscription_id + '/resourceGroups/' + resource_group_name + '/providers/Microsoft.Compute/virtualMachines/' + vm_name + '","name":"' + vm_name + '","type":"Microsoft.Compute/virtualMachines","location":"' + location + '","tags":{"department":"cslteam"},"properties":{"availabilitySet":{"id":"/subscriptions/' + subscription_id + '/resourceGroups/' + resource_group_name + '/providers/Microsoft.Compute/availabilitySets/' + availability_set_name + '"},"hardwareProfile":{"vmSize":"' + vm_size + '"},"storageProfile":{"imageReference":{"publisher":"' + publisher + '","offer":"' + offer + '","sku":"' + sku + '","version":"latest"},"osDisk":{"name":"' + vm_name + '}osDisk","vhd":{"uri":"http://' + storage_account + '.blob.core.windows.net/vhds/' + vm_name + 'osDisk.vhd"},"caching":"ReadWrite","createOption":"FromImage"},"dataDisks":[{"name":"' + vm_name + 'dataDisk","diskSizeGB":"1","lun":0,"vhd":{"uri":"http://' + storage_account + '.blob.core.windows.net/vhds/' + vm_name + 'dataDisk.vhd"},"createOption":"Empty"}]},"osProfile":{"computerName":"' + vm_name + '","adminUsername":"' + admin_username + '","adminPassword":"' + admin_password + '"},"networkProfile":{"networkInterfaces":[{"id":"/subscriptions/' + subscription_id + '/resourceGroups/' + resource_group_name + '/providers/Microsoft.Network/networkInterfaces/' + nic_name + '"}]}}}'}
            - headers: "${'Authorization: Bearer ' + auth_token}"
            - auth_type
            - username
            - password
            - preemptive_auth
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - trust_all_roots
            - x509_hostname_verifier
            - trust_keystore
            - trust_password
            - keystore
            - keystore_password
            - use_cookies
            - keep_alive
            - connections_max_per_route
            - connections_max_total
            - content_type
            - request_character_set
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
          strings.string_equals:
            - first_string: ${status_code}
            - second_string: '201'
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

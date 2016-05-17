# (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: lists the configured networks
#! @result SUCCESS: the list of networks was obtained successfully
#! @result FAILURE: failed to obtain the list of networks
#!!#
####################################################
namespace: io.cloudslang.cloud.openstack.network

operation:
  name: list_networks

  inputs:
    - token
    - host
    - port
    - protocol
    - username
    - password
    - proxyHost
    - proxyPort
    - proxyUsername
    - proxyPassword
    - trustAllRoots
    - x509HostnameVerifier
    - trustKeystore
    - trustPassword
    - keystore
    - keystorePassword
    - connectTimeout
    - socketTimeout
    - requestBody

  action:
    java_action:
      className: io.cloudslang.content.openstack.actions.ListNetworks
      methodName: execute

  outputs:
    - result: ${returnResult}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE

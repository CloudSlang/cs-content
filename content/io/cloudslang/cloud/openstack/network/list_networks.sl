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
    - token:
        required: true
    - host:
        required: true
    - port:
        required: false
    - protocol:
        required: false
    - username:
        required: false
    - password:
        required: false

    - proxy_host:
        required: false
    - proxyHost:
        private: true
        default: ${get("proxy_host", "")}

    - proxy_port:
        required: false
    - proxyPort:
        private: true
        default: ${get("proxy_port", "")}

    - proxy_username:
        required: false
    - proxyUsername:
        private: true
        default: ${get("proxy_username", "")}

    - proxy_password:
        required: false
    - proxyPassword:
        private: true
        default: ${get("proxy_password", "")}

    - trust_all_roots:
        required: false
    - trustAllRoots:
        private: true
        default: ${get("trust_all_roots", "true")}

    - x509_hostname_verifier:
        required: false
    - x509HostnameVerifier:
        private: true
        default: ${get("x509_hostname_verifier", "")}

    - trust_keystore:
        required: false
    - trustKeystore:
        private: true
        default: ${get("trust_keystore", "")}

    - trust_password:
        required: false
    - trustPassword:
        private: true
        default: ${get("trust_password", "")}

    - keystore

    - keystore_password:
        required: false
    - keystorePassword:
        private: true
        default: ${get("keystore_password", "")}

    - connect_timeout:
        required: false
    - connectTimeout:
        private: true
        default: ${get("connect_timeout", "")}

    - socket_timeout:
        required: false
    - socketTimeout:
        private: true
        default: ${get("socket_timeout", "")}

    - request_body:
        required: false
    - requestBody:
        private: true
        default: ${get("request_body", "")}

  java_action:
    class_name: io.cloudslang.content.openstack.actions.ListNetworks
    method_name: execute

  outputs:
    - result: ${returnResult}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE

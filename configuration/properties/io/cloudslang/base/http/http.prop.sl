# (c) Copyright 2017 EntIT Software LLC, a Micro Focus company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
# System property file for http operations
#
# io.cloudslang.base.http.trust_keystore: The pathname of the Java TrustStore file
# io.cloudslang.base.http.trust_password: The password associated with the TrustStore file
# io.cloudslang.base.http.keystore: The pathname of the Java KeyStore file
# io.cloudslang.base.http.keystore_password: The password associated with the KeyStore file
#
########################################################################################################################

namespace: io.cloudslang.base.http

properties:
  - trust_keystore: ''
  - trust_password:
      value: 'changeit'
      sensitive: true
  - keystore: ''
  - keystore_password:
      value: 'changeit'
      sensitive: true

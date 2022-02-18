#   (c) Copyright 2022 Micro Focus, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
# System property file for Operations Orchestration operations.
#
# io.cloudslang.operations_orchestration.trust_keystore: The pathname of the Java TrustStore file.
# io.cloudslang.operations_orchestration.trust_password: The password associated with the TrustStore file.
# io.cloudslang.operations_orchestration.keystore: The pathname of the Java KeyStore file.
# io.cloudslang.operations_orchestration.keystore_password: The password associated with the KeyStore file.
#
########################################################################################################################

namespace: io.cloudslang.operations_orchestration

properties:
  - trust_keystore: ''
  - trust_password:
      value: ''
      sensitive: true
  - keystore: ''
  - keystore_password:
      value: ''
      sensitive: true

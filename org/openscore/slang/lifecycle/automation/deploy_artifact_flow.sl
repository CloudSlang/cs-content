#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   This flow will deploy an artifact to Artifactory
#
#   Inputs:
#       - host - machine host
#       - computerPort - the computer port
#       - group - the group of the artifact
#       - version - the version of the artifact
#       - repository - the repository name
#       - filePath - the artifact path
#   Outputs:
#       - returnResult - response of the last operation that was executed
#       - errorMessage - error message of the operation that failed
#
####################################################

namespace: org.openscore.slang.lifecycle.automation

imports:
  automation: org.openscore.slang.lifecycle.automation

flow:
  name: deploy_artifact_flow
  inputs:
    - host
    - computerPort
    - group
    - artifact
    - version
    - repository
    - filePath
  workflow:
    httpPostToArtifactory:
      do:
        automation.deploy_artifact:
          - group
          - artifact
          - version
          - repository
          - filePath
      publish:
        - returnResult
        - error
  outputs:
    - returnResult
    - errorMessage

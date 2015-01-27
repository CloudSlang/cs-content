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
        automation.http_client_post:
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

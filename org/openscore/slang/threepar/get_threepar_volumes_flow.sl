# (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# This flow performs a provisioning check on a 3PAR server.
#
# Inputs:
# - host- The 3PAR server host
# - port3Par - The port used for connecting to the 3PAR host
# - username - The username of the 3PAR user
# - password - The password associated with the 3PAR user
# - volumeName - The 3PAR volume
# - proxyHost - The proxy host used for connecting to the 3PAR host
# - proxyPort - The proxy port associated with the proxy host
# - emailServerHostname - The email server that will perform the email send task
# - emailServerPort - The email server port
# - emailTo - The recipient of the email sent by the flow

# Outputs:
# - returnResult - response of the operation
# - errorMessage: - errorMessage of the 3PAR operation
# Results:
# - SUCCESS - operation succeeded
# - FAILURE - otherwise
####################################################

namespace: org.openscore.slang.threepar
imports:
 threepar_content: org.openscore.slang.threepar
flow:
  name: get_threepar_volumes_flow
  inputs:
    - host
    - port3Par      
    - username
    - password
    - volumeName
    - proxyPort
    - proxyHost
    - text:
        required: false
    - emailServerHostname
    - emailServerPort
    - emailTo
  workflow:
    get_session_key:
      do:
        threepar_content.get_sessionKey:
          - host
          - port3Par
          - username
          - password
          - proxyHost
          - proxyPort
      publish:
        - sessionKey
        - errorMessage
      navigate:
        FAILURE: FAILURE
        SUCCESS: get_threepar_volumes   
    get_threepar_volumes:
      do:
        threepar_content.get_threepar_volumes:
          - host
          - port3Par
          - sessionKey
          - proxyHost
          - proxyPort
      publish:
        - returnResult
        - errorMessage
      navigate:
        FAILURE: FAILURE
        SUCCESS: get_threepar_volume_details
    get_threepar_volume_details:
      do:
        threepar_content.get_threepar_volume_details:
          - host
          - port3Par
          - sessionKey
          - volumeName
          - proxyHost
          - proxyPort
      publish:
        - returnResultDetails
        - errorMessage
      navigate:
        FAILURE: FAILURE
        SUCCESS: print        
    print:
      do:
        threepar_content.print:
          - text: '"SessionKey : " + sessionKey + "\n\nVolume Details : \n\n" + returnResultDetails'
    send_mail:
      do:
        threepar_content.send_mail:
          - hostname: 'emailServerHostname'
          - port: 'emailServerPort'
          - htmlEmail: "'false'"
          - from: "'ooc@hp.com'"
          - to: 'emailTo'
          - subject: "'3 PAR Provisioning status'"
          - body: "'Sent by Score\\n\\n\\n 3Par Volume Details : ' + volumeName + '\\n\\n' + returnResultDetails + '\\n\\n\\n All volumes: \\n\\n' + returnResult"
      publish: 
        - returnResult    
      navigate:
        SUCCESS: printEmail
        FAILURE: printEmail
    printEmail:
      do:
        threepar_content.print:
          - text: 'returnResult'
      navigate:
        SUCCESS: SUCCESS
        FAILURE: FAILURE
  outputs:
    - returnResult
    - errorMessage
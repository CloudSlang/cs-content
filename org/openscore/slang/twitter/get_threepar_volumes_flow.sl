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
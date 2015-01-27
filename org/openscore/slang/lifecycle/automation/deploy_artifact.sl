namespace: org.openscore.slang.lifecycle.automation

operations:
   - http_client_post:
         inputs:
           - host:
              default: "'16.22.65.27'"
              required: false
           - computerPort:
              default: "'8081'"
              required: false
           - group:
              default: "'petClinic'"
              required: false
           - version:
              default: "'1'"
              required: false
           - artifact:
              default: "'bla'"
              required: false
           - repository:
              default: "'/artifactory/simple/ext-release-local/'"
              required: false
           - filePath:
              default: "'somePath'"
              required: false
           - url:
              default: "'http://' + host + ':' + computerPort + '/artifactory/simple/ext-release-local/' + artifact + '/' + group + '/' + version + '/' + group + '-' + version + '.war'"
              override: true
           - body: # the filePath is harcoded, needs to be investigated to find an elegant solution to send the file path as parameter
              default: >
                open('C:/Users/utiud/Documents/My Received Files/petClinic.war', 'rb').read()
              override: true
           - contentType:
              default: "'application/octet-stream'"
              override: true
           - username:
              default: "'admin'"
              required: false
           - password:
              default: "'password'"
              required: false
           - method:
              default: "'put'"
              override: true
         action:
           java_action:
             className: org.openscore.content.httpclient.HttpClientAction
             methodName: execute
         outputs:
           - returnResult
           - statusCode: statusCode
           - errorMessage: returnResult if statusCode != '202' else ''
         results:
           - SUCCESS : statusCode == '201'
           - FAILURE

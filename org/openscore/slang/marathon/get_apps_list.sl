#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   get marathon apps list
#
#   Inputs:
#       - marathon_host - marathon agent host
#       - marathon_port - optional - marathon agent port (defualt 8080)
#       - cmd - optional - Filter apps to only those whose commands contain cmd. Default: ""
#       - embed - optional - Embeds nested resources that match the supplied path. Default: none. Possible values:
#                           "apps.tasks". Apps' tasks are not embedded in the response by default.
#                            "apps.failures". Apps' last failures are not embedded in the response by default.
#   Outputs:
#       - response - response of the operation as json
#       - decoded - response of the operation as string
#       - returnResult - error or success
#       - returnCode - if returnCode is equal to -1 then there was an error
#       - errorMessage: returnResult if returnCode is equal to -1 or statusCode different than 200
#   Results:
#       - SUCCESS - operation succeeded (returnCode != '-1' and statusCode == '200')
#       - FAILURE - otherwise
####################################################

namespace: org.openscore.slang.marathon

operation:
      name: get_apps_list
      inputs:
        - marathon_host
        - marathon_port:
            default: "'8080'"
            required: false
        - cmd:
            default: "''"
            required: false
        - embed:
            default: "'none'"
            required: false
        - url:
            default: "'http://'+ marathon_host + ':' + marathon_port +'/v2/apps?embed='+embed"
            overridable: false
      action:
        python_script: |
          try:
            import urllib2
            import json
            if cmd!='':
              url=url+'&cmd='+cmd
            response = urllib2.urlopen(url).read()
            decoded = json.loads(response)
            returnCode = '0'
            returnResult = 'success'
          except:
            returnCode = '-1'
            returnResult = 'error'
      outputs:
        - response
        - decoded
        - returnCode
        - returnResult
        - errorMessage: returnResult if returnCode == '-1' else ''
      results:
        - SUCCESS: returnCode == '0'
        - FAILURE
#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0

##################################################################################################################################################
#   This operation creates a custom Dockerfile on a remote machine.
#   e.g.
#       FROM tomcat:8.0
#       ADD https://tomcat.apache.org/tomcat-6.0-doc/appdev/sample/sample.war /usr/local/tomcat/webapps/
#
#   Inputs:
#       - image_name - Docker base image name that is used in the Dockerfile
#       - version - Docker base image version(tag) that is used in the Dockerfile
#       - artifact_uri - URI to a war file that is used in the Dockerfile
#       - host - Docker machine host
#       - port - Docker machine port
#       - username - Docker machine username
#       - password - Docker machine password
#       - workdir - working directory on the Docker machine; the Dockerfile will be created here
#
#   Results:
#       - SUCCESS - the action returnCode is 0 (executed without exceptions) and the STDERR of the machine contains no errors
#       - FAILURE
##################################################################################################################################################

namespace: org.openscore.slang.lifecycle.automation

operations:
  - create_dockerfile:
        inputs:
            - image_name
            - version
            - artifact_uri
            - host
            - port:
                default: "'22'"
            - username
            - password
            - workdir
            - privateKeyFile:
                default: "''"
                override: true
            - arguments:
                default: "''"
                override: true
            - command:
                default: >
                    "mkdir " + workdir
                    + "; cd " + workdir
                    + "; echo 'FROM " + image_name + ":" + version + "' > Dockerfile"
                    + "; echo 'ADD " + artifact_uri + " /usr/local/tomcat/webapps/' >> Dockerfile"
                override: true
            - characterSet:
                default: "'UTF-8'"
                override: true
            - pty:
                default: "'false'"
                override: true
            - timeout:
                default: "'90000'"
                override: true
            - closeSession:
                default: "'false'"
                override: true
        action:
          java_action:
              className: org.openscore.content.ssh.actions.SSHShellCommandAction
              methodName: runSshShellCommand
        results:
          - SUCCESS: returnCode == '0' and (not 'Error' in STDERR)
          - FAILURE

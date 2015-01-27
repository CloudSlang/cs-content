#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0

##################################################################################################################################################
#   This operation creates a custom Dockerfile on a remote machine
##################################################################################################################################################

namespace: org.openscore.slang.lifecycle.automation

operations:
  - create_dockerfile:
        inputs:
            - image_name:
                default: "'tomcat'"
            - version:
                default: "'8.0'"
            - artifact_uri
            - host
            - port:
                default: "'22'"
            - username
            - password
            - workdir
            - privateKeyFile:
                default: "''"
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
            - pty:
                default: "'false'"
            - timeout:
                default: "'90000'"
            - closeSession:
                default: "'false'"
        action:
          java_action:
              className: org.openscore.content.ssh.actions.SSHShellCommandAction
              methodName: runSshShellCommand
        results:
          - SUCCESS: 1==1
          - FAILURE

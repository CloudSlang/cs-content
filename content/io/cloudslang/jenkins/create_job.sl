#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Creates a Jenkins job
#
# Prerequisites: jenkinsapi Python module
#
# Inputs:
#   - url - URL to Jenkins
#   - job_name - name of job to create
# Outputs:
#   - result_message - operation results
# Results:
#   - SUCCESS - return code is 0
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.jenkins

operation:
  name: create_job
  inputs:
    - url
    - job_name
  action:
    python_script: |
      try:
        from jenkinsapi.jenkins import Jenkins
        j = Jenkins(url, '', '')
        jobs = j.jobs

        CONFIG_XML = '''<?xml version="1.0" encoding="UTF-8"?>
        <project>
          <actions/>
          <description/>
          <keepDependencies>false</keepDependencies>
          <properties/>
          <scm class="hudson.scm.SubversionSCM" plugin="subversion@1.54">
            <locations>
              <hudson.scm.SubversionSCM_-ModuleLocation>
                <remote/>
                <local>.</local>
                <depthOption>infinity</depthOption>
                <ignoreExternalsOption>false</ignoreExternalsOption>
              </hudson.scm.SubversionSCM_-ModuleLocation>
            </locations>
            <excludedRegions/>
            <includedRegions/>
            <excludedUsers/>
            <excludedRevprop/>
            <excludedCommitMessages/>
            <workspaceUpdater class="hudson.scm.subversion.UpdateUpdater"/>
            <ignoreDirPropChanges>false</ignoreDirPropChanges>
            <filterChangelog>false</filterChangelog>
          </scm>
          <canRoam>true</canRoam>
          <disabled>false</disabled>
          <blockBuildWhenDownstreamBuilding>false</blockBuildWhenDownstreamBuilding>
          <blockBuildWhenUpstreamBuilding>false</blockBuildWhenUpstreamBuilding>
          <triggers/>
          <concurrentBuild>false</concurrentBuild>
          <builders/>
          <publishers/>
          <buildWrappers/>
        </project>'''

        job = jobs.create(job_name, CONFIG_XML)
        return_code = '0'
        result_message = 'Success'
      except:
        import sys
        print "Unexpected error:", sys.exc_info()[0]
        return_code = '-1'
        result_message = 'Error while creating job: ' + job_name

  outputs:
    - result_message

  results:
    - SUCCESS: return_code == '0'
    - FAILURE

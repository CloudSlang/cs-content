
namespace: org.openscore.slang.jenkins

operations:
  - modify_scm_url:
      inputs:
        - url
        - job_name
        - new_scm_url
      action:
        python_script: |
          try:
            from jenkinsapi.jenkins import Jenkins
            j = Jenkins(url, '', '')
            
            job = j.get_job(job_name)
            job.modify_scm_url(new_scm_url)
            
            returnCode = '0'
            returnResult = 'Success'
          except:
            import sys
            returnCode = '-1'
            returnResult = 'Error while modifying scm url for job: ' + job_name + ' to ' + new_scm_url

      outputs:
        - last_buildnumber
        - returnResult

      results:
        - SUCCESS: returnCode == '0'
        - FAILURE

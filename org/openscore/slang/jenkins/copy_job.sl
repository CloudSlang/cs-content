
namespace: org.openscore.slang.jenkins

operations:
  - copy_job:
      inputs:
        - url
        - job_name
        - new_job_name
      action:
        python_script: |
          try:
            from jenkinsapi.jenkins import Jenkins
            j = Jenkins(url, '', '')
            
            jobs = j.jobs
            jobs.copy(job_name, new_job_name)
            
            returnCode = '0'
            returnResult = 'Success'
          except:
            import sys
            returnCode = '-1'
            returnResult = 'Error while copying job: ' + job_name + ' to ' + new_job_name

      outputs:
        - last_buildnumber
        - returnResult

      results:
        - SUCCESS: returnCode == '0'
        - FAILURE

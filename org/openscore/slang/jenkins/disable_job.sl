
namespace: org.openscore.slang.jenkins

operations:
  - disable_job:
      inputs:
        - url
        - job_name
      action:
        python_script: |
          try:
            from jenkinsapi.jenkins import Jenkins
            j = Jenkins(url, '', '')
            
            job = j.get_job(job_name)
            job.disable()
            
            returnCode = '0'
            returnResult = 'Success'
          except:
            import sys
            returnCode = '-1'
            returnResult = 'Error while disabling job: ' + job_name

      outputs:
        - last_buildnumber
        - returnResult

      results:
        - SUCCESS: returnCode == '0'
        - FAILURE

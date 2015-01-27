
namespace: org.openscore.slang.jenkins

operations:
  - delete_job:
      inputs:
        - url
        - job_name
      action:
        python_script: |
          try:
            from jenkinsapi.jenkins import Jenkins
            j = Jenkins(url, '', '')
            
            j.delete_job(job_name)            
            
            returnCode = '0'
            returnResult = 'Success'
          except:
            import sys
            returnCode = '-1'
            returnResult = 'Error deleting job: ' + job_name

      outputs:
        - exists
        - returnResult

      results:
        - SUCCESS: returnCode == '0'
        - FAILURE

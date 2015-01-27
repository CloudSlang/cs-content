
namespace: org.openscore.slang.jenkins

operations:
  - check_job_exists:
      inputs:
        - url
        - job_name
        - expected_status
      action:
        python_script: |
          try:
            from jenkinsapi.jenkins import Jenkins
            j = Jenkins(url, '', '')
            
            exists = j.has_job(job_name)
            expected_status2 = expected_status in ['true', 'True', 'TRUE']
            
            returnCode = '0'
            returnResult = 'Success'
            
            result = ''
            if (exists == True) and (expected_status2 == True):
              result = 'EXISTS_EXPECTED'
            elif (exists == True) and (expected_status2 == False):
              result = 'EXISTS_UNEXPECTED'
            else: 
              result = 'NOT_EXISTS'
            
          except:
            import sys
            returnCode = '-1'
            returnResult = 'Error checking job\'s existance: ' + job_name
            result = 'FAILURE'

      outputs:
        - exists
        - returnResult
        - result

      results:
        - EXISTS_EXPECTED: result == 'EXISTS_EXPECTED'
        - EXISTS_UNEXPECTED: result == 'EXISTS_UNEXPECTED'
        - NOT_EXISTS: result == 'NOT_EXISTS'
        - FAILURE: result == 'FAILURE'

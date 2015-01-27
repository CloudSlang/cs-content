
namespace: org.openscore.slang.jenkins

operations:
  - get_last_buildnumber:
      inputs:
        - url
        - job_name
      action:
        python_script: |
          try:
            from jenkinsapi.jenkins import Jenkins
            j = Jenkins(url, '', '')
            
            job = j.get_job(job_name)
            last_buildnumber = job.get_last_buildnumber()
            returnCode = '0'
            returnResult = 'Success'
          except:
            returnCode = '-1'
            returnResult = 'Error while obtaining last build number for job: ' + job_name

      outputs:
        - last_buildnumber
        - returnResult

      results:
        - SUCCESS: returnCode == '0'
        - FAILURE

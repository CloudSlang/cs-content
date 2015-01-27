namespace: org.openscore.slang.jenkins

imports:
  jenkins_ops: org.openscore.slang.jenkins

flow:
  name: fix_job
  inputs:
    - url
    - job_name

  workflow:

    disable_job:
      do:
        jenkins_ops.disable_job:
          - url: url
          - job_name: job_name

    enable_job:
      do:
        jenkins_ops.enable_job:
          - url: url
          - job_name: job_name


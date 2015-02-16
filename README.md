slang-content
=============


Sample arguments:

run --f c:/Work/hackaton/slang-content/org/openscore/slang/jenkins/clone_job_for_branch.sl --cp c:/Work/hackaton/slang-content/org/openscore/slang/base/mail,c:/Work/hackaton/slang-content/org/openscore/slang/jenkins --i url=http://localhost:8090,jnks_job_name=trunk-project1,jnks_new_job_name=branch-project1,new_scm_url=http://localhost:8080/svn/hackaton-repo/branches/test-branch,delete_job_if_existing=false,email_host=smtp-host,email_port=25,email_sender=sample-address@host.com,email_recipient=sample-address@host.com

Argument to add to slang.bat: -Dpython.path=<path-to-folder-containing-jenkinsapi-python-module-and-dependencies>


$ ./test.sh 
Waiting for Jenkins to be up...
Jenkins is up!
Raw response from Jenkins API:
{"_class":"hudson.model.Hudson","jobs":[{"_class":"com.cloudbees.hudson.plugins.folder.Folder","name":"ea-software","url":"http://ip172-18-0-111-csr4fjq91nsg00cjuog0-8080.direct.labs.play-with-docker.com/job/ea-software/","jobs":[{"_class":"com.cloudbees.hudson.plugins.folder.Folder"}]}]}
Raw response from Jenkins API:
{"_class":"com.cloudbees.hudson.plugins.folder.Folder","jobs":[{"_class":"com.cloudbees.hudson.plugins.folder.Folder","name":"jte-tests","url":"http://ip172-18-0-111-csr4fjq91nsg00cjuog0-8080.direct.labs.play-with-docker.com/job/ea-software/job/jte-tests/","jobs":[{"_class":"org.jenkinsci.plugins.workflow.multibranch.WorkflowMultiBranchProject"},{"_class":"org.jenkinsci.plugins.workflow.multibranch.WorkflowMultiBranchProject"}]}]}
Raw response from Jenkins API:
{"_class":"com.cloudbees.hudson.plugins.folder.Folder","jobs":[{"_class":"org.jenkinsci.plugins.workflow.multibranch.WorkflowMultiBranchProject","name":"multi-branch","url":"http://ip172-18-0-111-csr4fjq91nsg00cjuog0-8080.direct.labs.play-with-docker.com/job/ea-software/job/jte-tests/job/multi-branch/","jobs":[]},{"_class":"org.jenkinsci.plugins.workflow.multibranch.WorkflowMultiBranchProject","name":"test-job-01","url":"http://ip172-18-0-111-csr4fjq91nsg00cjuog0-8080.direct.labs.play-with-docker.com/job/ea-software/job/jte-tests/job/test-job-01/","jobs":[]}]}
./test.sh: line 63: update_multibranch_job_configs: command not found
http://ip172-18-0-111-csr4fjq91nsg00cjuog0-8080.direct.labs.play-with-docker.com/job/ea-software/job/jte-tests/
./test.sh: line 63: update_multibranch_job_configs: command not found
http://ip172-18-0-111-csr4fjq91nsg00cjuog0-8080.direct.labs.play-with-docker.com/job/ea-software/job/jte-tests/
./test.sh: line 63: update_multibranch_job_configs: command not found


# response-02
$ ./test.sh 
Waiting for Jenkins to be up...
Jenkins is up!
Raw response from Jenkins API:
{"_class":"hudson.model.Hudson","jobs":[{"_class":"com.cloudbees.hudson.plugins.folder.Folder","name":"ea-software","url":"http://ip172-18-0-111-csr4fjq91nsg00cjuog0-8080.direct.labs.play-with-docker.com/job/ea-software/","jobs":[{"_class":"com.cloudbees.hudson.plugins.folder.Folder"}]}]}
Raw response from Jenkins API:
{"_class":"com.cloudbees.hudson.plugins.folder.Folder","jobs":[{"_class":"com.cloudbees.hudson.plugins.folder.Folder","name":"jte-tests","url":"http://ip172-18-0-111-csr4fjq91nsg00cjuog0-8080.direct.labs.play-with-docker.com/job/ea-software/job/jte-tests/","jobs":[{"_class":"org.jenkinsci.plugins.workflow.multibranch.WorkflowMultiBranchProject"},{"_class":"org.jenkinsci.plugins.workflow.multibranch.WorkflowMultiBranchProject"}]}]}
Raw response from Jenkins API:
{"_class":"com.cloudbees.hudson.plugins.folder.Folder","jobs":[{"_class":"org.jenkinsci.plugins.workflow.multibranch.WorkflowMultiBranchProject","name":"multi-branch","url":"http://ip172-18-0-111-csr4fjq91nsg00cjuog0-8080.direct.labs.play-with-docker.com/job/ea-software/job/jte-tests/job/multi-branch/","jobs":[{"_class":"org.jenkinsci.plugins.workflow.job.WorkflowJob"},{"_class":"org.jenkinsci.plugins.workflow.job.WorkflowJob"},{"_class":"org.jenkinsci.plugins.workflow.job.WorkflowJob"}]},{"_class":"org.jenkinsci.plugins.workflow.multibranch.WorkflowMultiBranchProject","name":"test-job-01","url":"http://ip172-18-0-111-csr4fjq91nsg00cjuog0-8080.direct.labs.play-with-docker.com/job/ea-software/job/jte-tests/job/test-job-01/","jobs":[]}]}
Updating configuration for multibranch jobs:
Print URL: http://ip172-18-0-111-csr4fjq91nsg00cjuog0-8080.direct.labs.play-with-docker.com/job/ea-software/job/jte-tests/job/multi-branch/ \n
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=ISO-8859-1"/>
<title>Error 403 No valid crumb was included in the request</title>
</head>
<body><h2>HTTP ERROR 403 No valid crumb was included in the request</h2>
<table>
<tr><th>URI:</th><td>/job/ea-software/job/jte-tests/job/multi-branch//config.xml</td></tr>
<tr><th>STATUS:</th><td>403</td></tr>
<tr><th>MESSAGE:</th><td>No valid crumb was included in the request</td></tr>
<tr><th>SERVLET:</th><td>Stapler</td></tr>
</table>
<hr/><a href="https://jetty.org/">Powered by Jetty:// 12.0.14</a><hr/>

</body>
</html>
Print URL: http://ip172-18-0-111-csr4fjq91nsg00cjuog0-8080.direct.labs.play-with-docker.com/job/ea-software/job/jte-tests/job/test-job-01/ \n
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=ISO-8859-1"/>
<title>Error 403 No valid crumb was included in the request</title>
</head>
<body><h2>HTTP ERROR 403 No valid crumb was included in the request</h2>
<table>
<tr><th>URI:</th><td>/job/ea-software/job/jte-tests/job/test-job-01//config.xml</td></tr>
<tr><th>STATUS:</th><td>403</td></tr>
<tr><th>MESSAGE:</th><td>No valid crumb was included in the request</td></tr>
<tr><th>SERVLET:</th><td>Stapler</td></tr>
</table>
<hr/><a href="https://jetty.org/">Powered by Jetty:// 12.0.14</a><hr/>

</body>
</html>
http://ip172-18-0-111-csr4fjq91nsg00cjuog0-8080.direct.labs.play-with-docker.com/job/ea-software/job/jte-tests/
Updating configuration for multibranch jobs:
http://ip172-18-0-111-csr4fjq91nsg00cjuog0-8080.direct.labs.play-with-docker.com/job/ea-software/job/jte-tests/
Updating configuration for multibranch jobs:
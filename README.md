# Tracr - Air Quality API Challenge

## Challenge - Part 1
### Solution Explained
To automate the deployment of the Air Quality API into AWS, a Jenkins pipeline job was created.  This job requires a single input of the server IP address and once started it will:
* Download the repo from Github (currently using a public repo but a private one should be used normally).
* Build and tests the API using the provided command.
* Zip the repo content and upload it to a S3 bucket using the AWS CLI.
* SSH onto the server to download the zip (using AWS CLI) and then deploy the new version of the API.

By using a Jenkinsfile checked into the same repo as the API, allows the developers to maintain/update job.

#### Known Gotchas
This solution isn't prefect, as it has the following gotchas:
* First build to a new server will fail because the required scripts aren't present.
* The server will need AWS CLI installed and be configured with the correct credentials. 

### Possible Improvements
To further improve this solution the following could be done:
* A dropdown list of servers to deploy could be used as a build parameter - e.g. using AWS CLI get a list of servers within a specific zone.
* Add another build parameter to allow the creation of an additional server - e.g. using terraform to create an additional instance.
* The instance is pre-configured with the required AWS credentials and scripts - this could be done using SaltStack or Ansible.


## Challenge - Part 2
### Infrastructure
Please see image [infrastructure.PNG](infrastructure.PNG) for the proposed production infrastructure.  Either a Blue/Green or Canary release process could be used on this setup.
Below are details of each component used in the infrastructure:
* tyk.io API Gateway is used to managing the user access to the API as well as the API itself. tyk.io provides:
  * API Key validation i.e. additional security to validate the user is allowed to access the API.
  * API quotas and rate limiting i.e. limit the number of calls within a time period as well as overall day or weekly usage allowance.
  * API Versioning - if a change is implemented that breaks the current API (e.g. endpoint structure is changed) then the API should be versioned to allow users to update their requests to the new format when ready.
* Route53 used to direct traffic to a specific ALB.
* EC2 instances are non-public i.e. only the ALB can access them as they are in a private subnet.
  * Traffic from ALB to instances could also be sent over HTTPS for additional security.
  * NAT Gateways are placed in all zones for high availability of outbound traffic.
* RDS Postges DB is used enabled with Multi AZ enabled and daily backups.
  * Production DB snapshots could be applied to pre-production environment before each release and/or deployment.

Note: API request from user should be sent over HTTPS for additional security.

### Continuous Delivery
The proposed Continuous Delivery pipeline for the Air Quality API would as follows:
1. Developer commits code to repo which triggers the job.
   1. Jenkins pipeline Jenkinsfile to be used to allow developers to continue to maintain/update the process.
2. Job checkouts code.
3. Code is built/compiled.
4. Docker-compose is started to run unit tests.
   1. Unit test results stored in SonarQube to track progress plus show overall code quality.
5. AMI is created
6. AMI is applied to pre-production environment.
   1. DB scripts are applied using Liquibase.
7. Automated smoke and load tests are ran on pre-production.
8. Jenkins job waits for approval to push to production environment.
   1. QA engineers may need to run some manual tests before go-live.
9. On approval AMI is applied to production.
   1. DB scripts are applied using Liquibase.
   2. Route53 is update to switch traffic to new version of the API.

### Tools
The following tools could be introduced to help maintain the CD pipeline and overall infrastructure:
* Liquibase - Used for DB versioning and automating the execution of DB scripts.
* Packer - Used for creating AMIs.
* Datadog - Provides server health monitoring, log monitoring and APM
  * APM is very useful for debugging issues and viewing application and DB performance - this feature should be enabled on pre-production as well.
  * PagerDuty could also be integrated for alerting (e.g. for application issues etc).
* Terraform - Used for building and maintaining AWS environment.

### Areas for discussion
* Should pipeline include regression testing? I.e. should previous code base/current live be tested with latest DB changes?
* Which deployment process should be used e.g. Blue/Green or Canary or Rolling?
  ** Suggested is Blue/Green or Canary deployment as rolling back to a previous version can be easily done.
* Should multiple regions be used? I.e. Using Route53 traffic could be directed to a specific regions by using geo routing (e.g. EU traffic goes to EU-West-1 environment and USA traffic goes to US-West-1)
  * Datadog can help with this by detailing where the traffic is coming from and response times etc.
* Should the environment be auto-scaling?
  * Datadog will help by profiling server load etc.

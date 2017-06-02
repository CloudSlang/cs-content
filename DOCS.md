#Content

The **cloud-slang-content** repository contains ready-made CloudSlang flows,
operations and tests for many common tasks as well as content that integrates
with several other systems.

Note: This repository may contain some beta content. Beta content is not verified
or tested by the CloudSlang team. Beta content is named with the `beta_` prefix.
The community is encouraged to assist in setting up testing environments for the
beta content.  

The following is an overview of what is included in the ready-made content:

+ **cloudslang**
  + **amazon:**
    + **aws:** [Amazon Web Services (AWS)](https://aws.amazon.com/) is a collection of remote computing services that make up a cloud-computing platform. This folder contains content for images, instances, network, regions, snapshots, tags and volumes.
  + **base:** This folder contains general purpose content.
    + **cmd:** Local shell command content, such as: run command.
    + **comparisons:** Comparison content, such as: equals and less than percentage.
    + **datetime:** This folder contains a variety of helper operations that are useful for manipulating dates and times.
    + **filesystem:** File management and manipulations, such as: read/write, copy/move/delete, and zip/unzip.
    + **http:** Http REST calls, such as: GET, POST, DELETE, PUT, TRACE, PATCH.
    + **json:** This folder contains operations for manipulating Javascript objects, or more precisely, string values that are contain objects in the JSON format (JavaScript Object Notation).  JSON is a simple format that can represent simple values, arrays, and objects in a human-readable format that is very similar to what is used elsewhere in Operations Orchestration, with the added benefit that Javascript scriptlets can handle them as true structured objects.
    + **lists:** This folder contains a set of operations for list manipulation.
    + **mail:** The operations allow email to be sent using the send mail protocol. It also allows emails to be retrieved via either POP3 or IMAP.
    + **maps:** Maps related content, such as: get keys and values.
    + **math:** Numeric operations, such as: add, divide, multiply, round and subtract numbers.
    + **network:** Network related actions, such as: ping and wait port open.
    + **os:** Content for working with operating systems, such as: determining the OS, checking disk space and validating SSH access.
    + **powershell:** The operation in this folder executes a PowerShell script on a remote host (in order to use this operation, there are some prerequisites (see powershell_script)).
    + **print:** Printing text.
    + **python:** The operation in this folder runs a python script provided through an inline script or the canonical path to the python file.
    + **remote_file_transfer:** The operations in this folder can be used to transfer files from one machine to another.
    + **ssh:** The operations interact with SSH Servers in a variety of ways.
    + **strings:** String actions and manipulations, such as: match, replace, occurrence counter.
    + **utils:** Utility actions, such as: base64 encoder and decoder, is true, uuid generator and sleep.
    + **xml:** Utility Operations for the manipulation of XML data.
  + **chef:** [Chef](https://www.chef.io/) is a systems and cloud infrastructure automation framework for deploying servers and applications to any physical, virtual, or cloud location. This folder contains content for bootstrapping nodes, adding/removing rules and/or recipes, and deleting nodes.
  + **ci:**
    + **circleci:** [CircleCI](http://www.circleci.com) related content.
  + **consul:** [Consul](https://consul.io/) has multiple components, but as a whole, it is a tool for discovering and configuring services in your infrastructure. This folder contains content for interacting with Consul, such as dealing with endpoints and the key/value store.
  + **coreos:** [CoreOS](https://coreos.com/) is a Linux distribution that has been rearchitected to provide features needed to run modern infrastructure stacks. This folder contains content for interacting with a CoreOS cluster.
  + **digital_ocean:**
    + **v2:** [DigitalOcean](https://www.digitalocean.com/) is a cloud infrastructure provider focused on simplifying web infrastructure for software developers. This folder contains content for dealing with droplets, such as: create, list and delete.
  + **docker:** [Docker](https://www.docker.com/) is an open platform for developers and sysadmins to build, ship, and run distributed applications.
  + **git:** [Git](https://git-scm.com/) is a distributed version control system. This folder contains content for interacting with Git.
  + **google:**
    + **authentication** Contains the authentication operation that can be used for other Google Compute integrations.
    + **compute:** 
      + **compute_engine** [Google - Compute Engine](https://cloud.google.com/compute/) delivers virtual machines running in Google's innovative data centers and worldwide fiber network. Compute Engine's tooling and workflow support enable scaling from single instances to global, load-balanced cloud computing.
  + **hashicorp**
    + **vault** [Hashicorp - Vault](https://www.vaultproject.io/) secures, stores, and tightly controls access to tokens, passwords, certificates, API keys, and other secrets in modern computing. Vault handles leasing, key revocation, key rolling, and auditing. Through a unified API, users can access an encrypted Key/Value store and network encryption-as-a-service, or generate AWS IAM/STS credentials, SQL/NoSQL databases, X.509 certificates, SSH credentials, and more.
  + **heroku:** [Heroku](https://www.heroku.com/) is a cloud platform based on a managed container system for deploying and running modern apps. This folder contains content for dealing with accounts, applications, domains, regions and more.
    + **cadvisor:** [cAdvisor](https://github.com/google/cadvisor) provides container users an understanding of the resource usage and performance characteristics of their running containers. This folder contains content for querying cAdvisor to get usage information of Docker containers and to possibly act on the received responses.
    + **containers:** In Docker terminology, a container is a read-write layer, plus the information about its Parent Image and some additional information like its unique id, networking configuration, and resource limits. This folder contains content for working with Docker containers, such as: start, stop and delete.
    + **images:** In Docker terminology, an image is a read-only layer. This folder contains content for working with and maintaining Docker images, such as: pulling, listing, and deleting images.
    + **maintenance:** This folder contains content for maintaining a clean Docker environment, such as: retrieving and acting upon the status of MySQL and Linux checks.
    + **monitoring:** Content that check, report etc. the status of certain containers such as MySQL container.
    + **swarm:** [Swarm](https://www.docker.com/docker-swarm) provides native clustering capabilities to turn a group of Docker engines into a single, virtual Docker Engine. This folder contains content for interacting with a Swarm cluster.
    + **utils:** Utility content that pertains to Docker.
  + **jenkins:** [Jenkins](http://jenkins-ci.org/) is an application that monitors executions of repeated jobs, such as building a software project or jobs run by cron. This folder contains content for working with Jenkins jobs, such as: enable,  disable, copy and delete.
  + **marathon:** [Marathon](https://mesosphere.github.io/marathon/) is cluster-wide init and control system for services in cgroups or Docker containers. This folder contains content for working with apps, such as: creating, deleting, updating and listing.
  + **microsoft:**
    + **azure:** [Microsoft Azure](https://azure.microsoft.com/en-us/) is a growing collection of integrated cloud services—analytics, computing, database, mobile, networking, storage, and web—for moving faster, achieving more, and saving money.
  + **new_relic:**
    + **servers:** [New Relic](https://newrelic.com/) Infrastructure delivers real-time health metrics correlated with recent configuration changes, so you can quickly resolve issues, scale rapidly, and deploy intelligently.
  + **openshift:** [OpenShift](https://www.openshift.com/) is a cloud application development and hosting platform that automates the provisioning, management and scaling of applications. This folder contains content for dealing with applications and cartridges.
  + **openstack:** [OpenStack](https://www.openstack.org/) is a cloud operating system that controls large pools of compute, storage, and networking resources throughout a datacenter.This folder contains content for working with servers, such as: create, delete, authenticate and check.
  + **stackato:** [Stackato](http://docs.stackato.com) is Platform-as-a-Service that can run on your own data center using the hypervisor of your choice, or on a cloud hosting provider. This folder contains content for dealing with Stackato, such as: applications, services and spaces.
  + **twilio:**
    + **sms:** [Twilio SMS](http://www.twilio.com) is an SMS sending and receiving online service.
  + **vmware:**
    + **vcenter**: [VMware vCenter Server](http://www.vmware.com/products/vcenter-server/) is a virtualization platform which simplifies IT by separating applications and operating systems (OSs) from the underlying hardware. This folder contains content for dealing with virtual machines, such as create, power on/off, update and delete.

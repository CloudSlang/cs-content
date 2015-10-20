#Content

The **cloud-slang-content** repository contains ready-made CloudSlang flows and operations for many common tasks as well as content that integrates with several other systems.

The following is an overview of what is included in the ready-made content:

+ **cloudslang**
  + **base:** This folder contains general purpose content.
    + **cmd:** Shell command content.
    + **comparisons:** Comparison content.
    + **files:** File management and manipulations, such as: read/write, copy/move/delete, and zip/unzip.
    + **json:** JSON related content.
    + **lists:** List manipulation.
    + **mail:** Email related content. 
    + **math:** Numeric operations. 
    + **network:** Network related actions, such as: pinging and performing REST calls. 
    + **os** Content for working with operating systems, such as determining the OS, checking disk space and validating SSH access. 
    + **print:** Printing text.
    + **remote_command_execution**
      + **remote_file_transfer:** Remote file transfer related content. 
      + **ssh:** SSH command related content.
    + **strings:** String actions and manipulations, such as: match, replace, occurrence counter. 
    + **utils:** Utility actions, such as: random number generator, sleep, uuid generator.         
  + **chef:** [Chef](https://www.chef.io/) is a systems and cloud infrastructure automation framework for deploying servers and applications to any physical, virtual, or cloud location. This folder contains content for bootstrapping nodes, adding/removing rules and/or recipes, and deleting nodes. 
  + **consul:** [Consul](https://consul.io/) has multiple components, but as a whole, it is a tool for discovering and configuring services in your infrastructure. This folder contains content for interacting with Consul, such as dealing with endpoints and the key/value store.
  + **coreos:** [CoreOS](https://coreos.com/) is a Linux distribution that has been rearchitected to provide features needed to run modern infrastructure stacks. This folder contains content for interacting with a CoreOS cluster.
  + **cloud_provider:** Content related to cloud providers.
    + **amazon_aws:** [Amazon Web Services (AWS)](https://aws.amazon.com/) is a collection of remote computing services that make up a cloud-computing platform. This folder contains content for starting, stopping and listing servers.
    + **digital_ocean/v2:** [DigitalOcean](https://www.digitalocean.com/) is a cloud infrastructure provider focused on simplifying web infrastructure for software developers. This folder contains content for dealing with droplets, such as: create, list and delete.
    + **hp_cloud:** [HP Helion Public Cloud](http://www.hpcloud.com/) is a transparent, enterprise-grade public cloud based on OpenStack technology. This folder contains content for dealing with servers, such as: creating, retrieving details and deleting.
  + **docker:** [Docker](https://www.docker.com/) is an open platform for developers and sysadmins to build, ship, and run distributed applications.
    + **cadvisor:** [cAdvisor](https://github.com/google/cadvisor) provides container users an understanding of the resource usage and performance characteristics of their running containers. This folder contains content for querying cAdvisor to get usage information of Docker containers and to possibly act on the received responses.
    + **containers:** In Docker terminology, a container is a read-write layer, plus the information about its Parent Image and some additional information like its unique id, networking configuration, and resource limits. This folder contains content for working with Docker containers, such as: start, stop and delete.
    + **images:** In Docker terminology, an image is a read-only layer. This folder contains content for working with and maintaining Docker images, such as: pulling, listing, and deleting images.
    + **maintenance:** This folder contains content for maintaining a clean Docker environment, such as: retrieving and acting upon the status of MySQL and Linux checks.
    + **monitoring:** Content that check, report etc. the status of certain containers such as MySQL container.
    + **swarm:** [Swarm](https://www.docker.com/docker-swarm) provides native clustering capabilities to turn a group of Docker engines into a single, virtual Docker Engine. This folder contains content for interacting with a Swarm cluster.
    + **utils:** Utility content that pertains to Docker.
  + **git:** [Git](https://git-scm.com/) is a distributed version control system. This folder contains content for interacting with Git.
  + **jenkins:** [Jenkins](http://jenkins-ci.org/) is an application that monitors executions of repeated jobs, such as building a software project or jobs run by cron. This folder contains content for working with Jenkins jobs, such as: enable,  disable, copy and delete.
  + **marathon:** [Marathon](https://mesosphere.github.io/marathon/) is cluster-wide init and control system for services in cgroups or Docker containers. This folder contains content for working with apps, such as: creating, deleting, updating and listing.
  + **openstack:** [OpenStack](https://www.openstack.org/) is a cloud operating system that controls large pools of compute, storage, and networking resources throughout a datacenter.This folder contains content for working with servers, such as: create, delete, authenticate and check.  
  + **paas:** Content related to Platforms as a Service
    + **openshift:** OpenShift is a cloud application development and hosting platform that automates the provisioning, management and scaling of applications. This folder contains content for dealing with applications and cartridges. 

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
  + **base:** This folder contains general purpose content.
    + **cmd:** Shell command content.
    + **comparisons:** Comparison content.
    + **files:** File management and manipulations, such as: read/write, copy/move/delete, and zip/unzip.
    + **json:** JSON related content.
    + **lists:** List manipulation.
    + **mail:** Email related content.
    + **math:** Numeric operations.
    + **network:** Network related actions, such as: pinging and performing REST calls.
    + **os:** Content for working with operating systems, such as determining the OS, checking disk space and validating SSH access.
    + **powershell:** PowerShell related content.
    + **print:** Printing text.
    + **remote_command_execution:**
      + **remote_file_transfer:** Remote file transfer related content.
      + **ssh:** SSH command related content.
    + **strings:** String actions and manipulations, such as: match, replace, occurrence counter.
    + **utils:** Utility actions, such as: random number generator, sleep, uuid generator.         
  + **chef:** [Chef](https://www.chef.io/) is a systems and cloud infrastructure automation framework for deploying servers and applications to any physical, virtual, or cloud location. This folder contains content for bootstrapping nodes, adding/removing rules and/or recipes, and deleting nodes.
  + **cloud:**
    + **amazon_aws:** [Amazon Web Services (AWS)](https://aws.amazon.com/) is a collection of remote computing services that make up a cloud-computing platform. This folder contains content for starting, stopping and listing servers.
    + **digital_ocean/v2:** [DigitalOcean](https://www.digitalocean.com/) is a cloud infrastructure provider focused on simplifying web infrastructure for software developers. This folder contains content for dealing with droplets, such as: create, list and delete.
    + **google:**
      + **gke:** Note: this folder contains **beta** content. [Google Container Engine](https://cloud.google.com/container-engine/) is a cluster manager and orchestration system for running Docker containers. This folder contains content for dealing with clusters, such as: create, list and delete.
    + **heroku:** [Heroku](https://www.heroku.com/) is a cloud platform based on a managed container system for deploying and running modern apps. This folder contains content for dealing with accounts, applications, domains, regions and more.
    + **hp_cloud:** [HP Helion Public Cloud](http://www.hpcloud.com/) is a transparent, enterprise-grade public cloud based on OpenStack technology. This folder contains content for dealing with servers, such as: creating, retrieving details and deleting.
    + **hp_cloud:** [HP Helion Public Cloud](http://www.hpcloud.com/) is a transparent, enterprise-grade public cloud based on OpenStack technology. This folder contains content for dealing with servers, such as: creating, retrieving details and deleting.
    + **openshift:** [OpenShift](https://www.openshift.com/) is a cloud application development and hosting platform that automates the provisioning, management and scaling of applications. This folder contains content for dealing with applications and cartridges.
    + **openstack:** [OpenStack](https://www.openstack.org/) is a cloud operating system that controls large pools of compute, storage, and networking resources throughout a datacenter.This folder contains content for working with servers, such as: create, delete, authenticate and check.  
    + **stackato:** [Stackato](http://docs.stackato.com) is Platform-as-a-Service that can run on your own data center using the hypervisor of your choice, or on a cloud hosting provider. This folder contains content for dealing with Stackato, such as: applications, services and spaces.  
  + **consul:** [Consul](https://consul.io/) has multiple components, but as a whole, it is a tool for discovering and configuring services in your infrastructure. This folder contains content for interacting with Consul, such as dealing with endpoints and the key/value store.
  + **coreos:** [CoreOS](https://coreos.com/) is a Linux distribution that has been rearchitected to provide features needed to run modern infrastructure stacks. This folder contains content for interacting with a CoreOS cluster.
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
  + **operations_orchestration:** [Operations Orchestration](http://www.hp.com/go/oo) is an IT process automation solution designed to increase automation adoption in a traditional data center and hybrid cloud environment. This folder contains content for packaging CloudSlang flows as Operations Orchestration content packs.
  + **virtualization:**
    + **vmware**: [VMware vSphere](http://www.vmware.com/products/vsphere/) is a virtualization platform which simplifies IT by separating applications and operating systems (OSs) from the underlying hardware. This folder contains content for dealing with virtual machines, such as create, power on/off, update and delete.

<a href="https://cloudslang.io/">
    <img src="https://i.imgur.com/ihI560V.png" alt="CloudSlang logo" title="CloudSlang" align="right" height="60"/>
</a>

CloudSlang Content
==================

Community: [Issues](https://github.com/CloudSlang/cs-content/issues) | [Pull Requests](https://github.com/CloudSlang/cs-content/pulls) | [Chat (Gitter/Matrix)](https://app.gitter.im/#/room/#CloudSlang_cs-content:gitter.im)

CloudSlang is a [YAML](http://yaml.org) based language for writing human-readable workflows for the Cloud Slang Orchestration Engine (Score). This repository includes CloudSlang flows and operations.

[![Build Status](https://travis-ci.com/CloudSlang/cs-content.svg?branch=master)](https://travis-ci.com/CloudSlang/cs-content)

Click [here](DOCS.md) for an overview of all the currently supported integrations.

## Repository Structure and Integration Catalog (WS_2_0)

### Project Structure

The repository is organized around reusable CloudSlang content and matching tests:

- [content/io/cloudslang/](content/io/cloudslang/): Main integration content (operations and flows) grouped by vendor/platform.
- [configuration/properties/io/cloudslang/](configuration/properties/io/cloudslang/): Provider and integration property files used by content packs.
- [test/io/cloudslang/](test/io/cloudslang/): Test suites aligned with integration content.
- [python-lib/](python-lib/): Optional Python dependencies used by selected operations.
- [ci-env/](ci-env/): CI container and execution helper scripts.

### Integration Inventory by Vendor and Industry

The table below reflects all 36 top-level integrations present in [content/io/cloudslang/](content/io/cloudslang/) and links to their specific subfolders.

Note: Vendor logos are externally hosted badges used for identification only. All trademarks and logos are the property of their respective owners.

| Logo | Integration | Repository Subfolder Links | Vendor / Platform | Industry / Domain | Short Summary |
|---|---|---|---|---|---|
| ![ABBYY](https://img.shields.io/badge/-ABBYY-222222) | [abbyy](content/io/cloudslang/abbyy/) | [cloud](content/io/cloudslang/abbyy/cloud/) | ABBYY | Intelligent Document Processing (IDP) / OCR | Automates document and image text extraction workflows via cloud OCR processing operations. |
| ![Alibaba](https://img.shields.io/badge/-Alibaba%20Cloud-FF6A00?logo=alibabacloud&logoColor=white) | [alibaba](content/io/cloudslang/alibaba/) | [ecs](content/io/cloudslang/alibaba/ecs/) | Alibaba Cloud (ECS) | Cloud Infrastructure (IaaS) | Manages ECS lifecycle tasks such as instance deployment, IP allocation, and state checks. |
| ![AWS](https://img.shields.io/badge/-AWS-232F3E?logo=amazonaws&logoColor=white) | [amazon](content/io/cloudslang/amazon/) | [aws](content/io/cloudslang/amazon/aws/) | Amazon Web Services (AWS) | Cloud Infrastructure (IaaS) | Provides AWS-focused automation for compute and related resource provisioning patterns. |
| ![Atlassian](https://img.shields.io/badge/-Atlassian-0052CC?logo=atlassian&logoColor=white) | [atlassian](content/io/cloudslang/atlassian/) | [jira](content/io/cloudslang/atlassian/jira/) | Atlassian Jira | IT Service Management / Work Management | Automates Jira user and group administration and related directory management tasks. |
| ![CloudSlang](https://img.shields.io/badge/-CloudSlang-444444) | [base](content/io/cloudslang/base/) | [active_directory](content/io/cloudslang/base/active_directory/), [cmd](content/io/cloudslang/base/cmd/), [comparisons](content/io/cloudslang/base/comparisons/), [database](content/io/cloudslang/base/database/), [datetime](content/io/cloudslang/base/datetime/), [examples](content/io/cloudslang/base/examples/), [excel](content/io/cloudslang/base/excel/), [filesystem](content/io/cloudslang/base/filesystem/), [http](content/io/cloudslang/base/http/), [json](content/io/cloudslang/base/json/), [lists](content/io/cloudslang/base/lists/), [mail](content/io/cloudslang/base/mail/), [maps](content/io/cloudslang/base/maps/), [math](content/io/cloudslang/base/math/), [network](content/io/cloudslang/base/network/), [os](content/io/cloudslang/base/os/), [powershell](content/io/cloudslang/base/powershell/), [print](content/io/cloudslang/base/print/), [python](content/io/cloudslang/base/python/), [remote_file_transfer](content/io/cloudslang/base/remote_file_transfer/), [samples](content/io/cloudslang/base/samples/), [ssh](content/io/cloudslang/base/ssh/), [strings](content/io/cloudslang/base/strings/), [utils](content/io/cloudslang/base/utils/), [winrm](content/io/cloudslang/base/winrm/), [xml](content/io/cloudslang/base/xml/) | CloudSlang Base Library | Core Automation Utilities | Includes generic reusable operations for OS, files, HTTP, JSON, XML, strings, remoting, and scripting. |
| ![Chef](https://img.shields.io/badge/-Chef-F09820?logo=chef&logoColor=white) | [chef](content/io/cloudslang/chef/) | [chef](content/io/cloudslang/chef/) | Chef | Configuration Management / DevOps | Automates Chef node, cookbook, role, and run-list administration tasks. |
| ![CircleCI](https://img.shields.io/badge/-CircleCI-343434?logo=circleci&logoColor=white) | [ci](content/io/cloudslang/ci/) | [circleci](content/io/cloudslang/ci/circleci/) | CircleCI | Continuous Integration | Provides CircleCI build and branch failure query operations for CI monitoring workflows. |
| ![Consul](https://img.shields.io/badge/-Consul-F24C53?logo=consul&logoColor=white) | [consul](content/io/cloudslang/consul/) | [consul](content/io/cloudslang/consul/) | HashiCorp Consul | Service Discovery / Infrastructure Operations | Automates KV operations, endpoint registration, and service catalog interactions. |
| ![CoreOS](https://img.shields.io/badge/-CoreOS-5E6AD2) | [coreos](content/io/cloudslang/coreos/) | [coreos](content/io/cloudslang/coreos/) | CoreOS | Container Host / Infrastructure Platform | Provides cluster-level utility flows for machine discovery and maintenance scenarios. |
| ![Couchbase](https://img.shields.io/badge/-Couchbase-EA2328?logo=couchbase&logoColor=white) | [couchbase](content/io/cloudslang/couchbase/) | [buckets](content/io/cloudslang/couchbase/buckets/), [cluster](content/io/cloudslang/couchbase/cluster/), [nodes](content/io/cloudslang/couchbase/nodes/), [views](content/io/cloudslang/couchbase/views/) | Couchbase Server | NoSQL Database | Automates bucket, node, cluster, and view management in Couchbase environments. |
| ![CyberArk](https://img.shields.io/badge/-CyberArk-2E3A59) | [cyberark](content/io/cloudslang/cyberark/) | [privileged_access_manager](content/io/cloudslang/cyberark/privileged_access_manager/) | CyberArk Privileged Access Manager | Cybersecurity / Privileged Access Management | Handles privileged account onboarding, retrieval, and password lifecycle operations. |
| ![DigitalOcean](https://img.shields.io/badge/-DigitalOcean-0080FF?logo=digitalocean&logoColor=white) | [digital_ocean](content/io/cloudslang/digital_ocean/) | [v2](content/io/cloudslang/digital_ocean/v2/) | DigitalOcean | Cloud Infrastructure (IaaS) | Automates droplet creation, lookup, deletion, and lifecycle validation. |
| ![Docker](https://img.shields.io/badge/-Docker-2496ED?logo=docker&logoColor=white) | [docker](content/io/cloudslang/docker/) | [cadvisor](content/io/cloudslang/docker/cadvisor/), [containers](content/io/cloudslang/docker/containers/), [examples](content/io/cloudslang/docker/examples/), [images](content/io/cloudslang/docker/images/), [maintenance](content/io/cloudslang/docker/maintenance/), [monitoring](content/io/cloudslang/docker/monitoring/), [runc](content/io/cloudslang/docker/runc/), [swarm](content/io/cloudslang/docker/swarm/), [utils](content/io/cloudslang/docker/utils/) | Docker | Container Platform / DevOps | Includes container, image, swarm, runtime, and monitoring automation for Docker environments. |
| ![Git](https://img.shields.io/badge/-Git-F05032?logo=git&logoColor=white) | [git](content/io/cloudslang/git/) | [git](content/io/cloudslang/git/) | Git | Source Control / Developer Tooling | Automates common Git actions such as clone, checkout, add, commit, and cleanup tasks. |
| ![Google Cloud](https://img.shields.io/badge/-Google%20Cloud-4285F4?logo=googlecloud&logoColor=white) | [google](content/io/cloudslang/google/) | [authentication](content/io/cloudslang/google/authentication/), [compute](content/io/cloudslang/google/compute/), [compute_v2](content/io/cloudslang/google/compute_v2/), [databases](content/io/cloudslang/google/databases/), [storage](content/io/cloudslang/google/storage/) | Google Cloud | Cloud Infrastructure and Data Services | Provides auth, compute, storage, and database-oriented automation across Google cloud APIs. |
| ![HashiCorp](https://img.shields.io/badge/-HashiCorp-000000?logo=hashicorp&logoColor=white) | [hashicorp](content/io/cloudslang/hashicorp/) | [terraform](content/io/cloudslang/hashicorp/terraform/), [vault](content/io/cloudslang/hashicorp/vault/) | HashiCorp (Terraform, Vault) | Infrastructure as Code / Secrets Management | Includes Terraform helper workflows and Vault-related secure secret handling patterns. |
| ![Haven OnDemand](https://img.shields.io/badge/-Haven%20OnDemand-444444) | [haven_on_demand](content/io/cloudslang/haven_on_demand/) | [examples](content/io/cloudslang/haven_on_demand/examples/), [format_conversion](content/io/cloudslang/haven_on_demand/format_conversion/), [search](content/io/cloudslang/haven_on_demand/search/), [speech_recognition](content/io/cloudslang/haven_on_demand/speech_recognition/), [text_analysis](content/io/cloudslang/haven_on_demand/text_analysis/), [unstructured_text_indexing](content/io/cloudslang/haven_on_demand/unstructured_text_indexing/), [utils](content/io/cloudslang/haven_on_demand/utils/) | Haven OnDemand | AI / Text Analytics and Search | Supports indexing, search, speech, and text analysis automations for unstructured content. |
| ![Heroku](https://img.shields.io/badge/-Heroku-430098?logo=heroku&logoColor=white) | [heroku](content/io/cloudslang/heroku/) | [account](content/io/cloudslang/heroku/account/), [addons](content/io/cloudslang/heroku/addons/), [applications](content/io/cloudslang/heroku/applications/), [builds](content/io/cloudslang/heroku/builds/), [collaborators](content/io/cloudslang/heroku/collaborators/), [configvars](content/io/cloudslang/heroku/configvars/), [domains](content/io/cloudslang/heroku/domains/), [keys](content/io/cloudslang/heroku/keys/), [regions](content/io/cloudslang/heroku/regions/) | Heroku | Platform as a Service (PaaS) | Automates account, app, build, addon, domain, key, and region operations for Heroku apps. |
| ![ServiceNow](https://img.shields.io/badge/-ServiceNow-1DB954?logo=servicenow&logoColor=white) | [itsm](content/io/cloudslang/itsm/) | [service_now](content/io/cloudslang/itsm/service_now/) | ServiceNow | IT Service Management (ITSM) | Automates generic ServiceNow record operations (create, read, delete) for IT workflows. |
| ![Jenkins](https://img.shields.io/badge/-Jenkins-D24939?logo=jenkins&logoColor=white) | [jenkins](content/io/cloudslang/jenkins/) | [jenkins](content/io/cloudslang/jenkins/) | Jenkins | Continuous Integration and Delivery (CI/CD) | Provides job lifecycle automations including create, copy, enable/disable, and delete. |
| ![Kubernetes](https://img.shields.io/badge/-Kubernetes-326CE5?logo=kubernetes&logoColor=white) | [kubernetes](content/io/cloudslang/kubernetes/) | [deployments](content/io/cloudslang/kubernetes/deployments/), [endpoints](content/io/cloudslang/kubernetes/endpoints/), [namespaces](content/io/cloudslang/kubernetes/namespaces/), [nodes](content/io/cloudslang/kubernetes/nodes/), [pods](content/io/cloudslang/kubernetes/pods/), [replication_controllers](content/io/cloudslang/kubernetes/replication_controllers/), [samples](content/io/cloudslang/kubernetes/samples/), [services](content/io/cloudslang/kubernetes/services/) | Kubernetes | Container Orchestration / Cloud Native | Automates namespace, pod, deployment, service, endpoint, and node-level Kubernetes operations. |
| ![Marathon](https://img.shields.io/badge/-Marathon-3D5A80) | [marathon](content/io/cloudslang/marathon/) | [marathon](content/io/cloudslang/marathon/) | Marathon | Container Orchestration (Mesos) | Supports app deployment, update, listing, and task-level controls in Marathon clusters. |
| ![Maven](https://img.shields.io/badge/-Maven-C71A36?logo=apachemaven&logoColor=white) | [maven](content/io/cloudslang/maven/) | [maven](content/io/cloudslang/maven/) | Apache Maven Ecosystem | Artifact and Dependency Management | Adds lookup operations for artifact version discovery in Maven repositories. |
| ![Micro Focus](https://img.shields.io/badge/-Micro%20Focus-333333) | [microfocus](content/io/cloudslang/microfocus/) | [dca](content/io/cloudslang/microfocus/dca/), [hcm](content/io/cloudslang/microfocus/hcm/), [octane](content/io/cloudslang/microfocus/octane/), [ucmdb](content/io/cloudslang/microfocus/ucmdb/), [uft](content/io/cloudslang/microfocus/uft/) | Micro Focus (DCA, HCM, Octane, UCMDB, UFT) | Enterprise IT Operations and QA | Provides enterprise automation flows spanning deployment, testing, and CMDB-style integrations. |
| ![Microsoft](https://img.shields.io/badge/-Microsoft-5E5E5E?logo=microsoft&logoColor=white) | [microsoft](content/io/cloudslang/microsoft/) | [azure](content/io/cloudslang/microsoft/azure/), [office365](content/io/cloudslang/microsoft/office365/), [sharepoint](content/io/cloudslang/microsoft/sharepoint/) | Microsoft (Azure, Office 365, SharePoint) | Cloud and Productivity Platform | Automates Azure and Microsoft SaaS administration including licensing and collaboration services. |
| ![New Relic](https://img.shields.io/badge/-New%20Relic-1CE783?logo=newrelic&logoColor=white) | [new_relic](content/io/cloudslang/new_relic/) | [servers](content/io/cloudslang/new_relic/servers/) | New Relic | Observability / Infrastructure Monitoring | Retrieves server metrics, inventory, and monitoring state for operational visibility workflows. |
| ![Nutanix](https://img.shields.io/badge/-Nutanix-024DA1?logo=nutanix&logoColor=white) | [nutanix](content/io/cloudslang/nutanix/) | [prism](content/io/cloudslang/nutanix/prism/) | Nutanix Prism | Hyperconverged Infrastructure (HCI) / Virtualization | Automates VM deployment and network/storage attachment operations in Nutanix environments. |
| ![OpenShift](https://img.shields.io/badge/-OpenShift-EE0000?logo=redhatopenshift&logoColor=white) | [openshift](content/io/cloudslang/openshift/) | [applications](content/io/cloudslang/openshift/applications/), [cartridges](content/io/cloudslang/openshift/cartridges/) | OpenShift | Container Platform (PaaS/Kubernetes) | Provides application and cartridge lifecycle automation for OpenShift-based deployments. |
| ![OpenStack](https://img.shields.io/badge/-OpenStack-ED1944?logo=openstack&logoColor=white) | [openstack](content/io/cloudslang/openstack/) | [blockstorage](content/io/cloudslang/openstack/blockstorage/), [flavors](content/io/cloudslang/openstack/flavors/), [images](content/io/cloudslang/openstack/images/), [keypairs](content/io/cloudslang/openstack/keypairs/), [servers](content/io/cloudslang/openstack/servers/), [utils](content/io/cloudslang/openstack/utils/) | OpenStack | Private Cloud Infrastructure (IaaS) | Supports compute, image, flavor, keypair, and block storage automation for OpenStack clouds. |
| ![Oracle](https://img.shields.io/badge/-Oracle-F80000?logo=oracle&logoColor=white) | [oracle](content/io/cloudslang/oracle/) | [oci](content/io/cloudslang/oracle/oci/) | Oracle Cloud Infrastructure (OCI) | Cloud Infrastructure (IaaS) | Automates OCI instance deployment and VNIC/volume attachment lifecycle actions. |
| ![PostgreSQL](https://img.shields.io/badge/-PostgreSQL-4169E1?logo=postgresql&logoColor=white) | [postgresql](content/io/cloudslang/postgresql/) | [common](content/io/cloudslang/postgresql/common/), [linux](content/io/cloudslang/postgresql/linux/), [windows](content/io/cloudslang/postgresql/windows/) | PostgreSQL | Relational Database Operations | Provides DB command/query and configuration operations for Linux and Windows PostgreSQL hosts. |
| ![Red Hat](https://img.shields.io/badge/-Red%20Hat-EE0000?logo=redhat&logoColor=white) | [redhat](content/io/cloudslang/redhat/) | [ansible](content/io/cloudslang/redhat/ansible/), [openshift](content/io/cloudslang/redhat/openshift/) | Red Hat (Ansible, OpenShift) | Automation Platform / Container Platform | Delivers automation for Ansible credentials and OpenShift deployment workflows. |
| ![Stackato](https://img.shields.io/badge/-Stackato-444444) | [stackato](content/io/cloudslang/stackato/) | [applications](content/io/cloudslang/stackato/applications/), [services](content/io/cloudslang/stackato/services/), [spaces](content/io/cloudslang/stackato/spaces/), [users](content/io/cloudslang/stackato/users/), [utils](content/io/cloudslang/stackato/utils/) | Stackato | Platform as a Service (PaaS) | Automates Stackato applications, services, users, spaces, and platform utility tasks. |
| ![Tesseract](https://img.shields.io/badge/-Tesseract-5A6AB1) | [tesseract](content/io/cloudslang/tesseract/) | [ocr](content/io/cloudslang/tesseract/ocr/) | Tesseract OCR | OCR / Document Intelligence | Extracts text from images and PDFs with setup and OCR execution helpers. |
| ![Twilio](https://img.shields.io/badge/-Twilio-F22F46?logo=twilio&logoColor=white) | [twilio](content/io/cloudslang/twilio/) | [sms](content/io/cloudslang/twilio/sms/) | Twilio SMS | Communications / Messaging | Automates outbound SMS flows and inbound response retrieval patterns. |
| ![VMware](https://img.shields.io/badge/-VMware-607078?logo=vmware&logoColor=white) | [vmware](content/io/cloudslang/vmware/) | [cloud_director](content/io/cloudslang/vmware/cloud_director/), [vcenter](content/io/cloudslang/vmware/vcenter/) | VMware (vCenter, Cloud Director) | Virtualization and Private Cloud | Provides VM and catalog/template automation across VMware vCenter and Cloud Director APIs. |

#### Getting started:

###### Pre-Requisite: Java JRE >= 17

1. Download the CloudSlang CLI file named cslang-cli-with-content:
    + [Stable release](https://github.com/CloudSlang/cloud-slang/releases/latest)
    + [Latest snapshot](https://github.com/CloudSlang/cloud-slang/releases/)
2. Extract it.
3. Go to the folder [cslang/bin/](https://github.com/CloudSlang/cloud-slang/tree/master/cloudslang-cli/target/cslang/bin) in your extracted CLI package.
4. Run the executable :
  - For Windows : `cslang.bat`
  - For Linux : `bash cslang`
5. Run a simple example print text flow from [content/io/cloudslang/base/print/print_text.sl](content/io/cloudslang/base/print/print_text.sl): `run --f ../content/io/cloudslang/base/print/print_text.sl --i text=first_flow --cp ../content/`

Command line arguments in the above example:

Argument|Description
---|---
--f | Location of the flow to run.
--i | Arguments the flow takes as input, for multiple arguments use a comma delimited list (e.g. `var1=value1,var2=value2`).
--cp | Classpath for the location of the content. Required when content imports other content.


**Note:** Some of the content is dependent on external python modules. If you are using the CLI to run your flows, you can import external modules by doing one of the following:

+ Installing packages into the [python-lib](python-lib/) folder
+ Editing the executable file

**Installing packages into the python-lib folder:**

Prerequisites: Python and pip (use the version compatible with your CloudSlang runtime/Jython setup).

You can download Python from [here](https://www.python.org/). If your Python installation does not include pip, see the pip [documentation](https://pip.pypa.io/en/latest/installing.html) for installation instructions.

1. Edit [python-lib/requirements.txt](python-lib/requirements.txt), in the [python-lib](python-lib/) folder found at the same level as the CLI `bin` folder.
2. Enter the Python package and all its dependencies in the requirements file.
	+ See the **pip** [documentation](https://pip.pypa.io/en/latest/user_guide.html#requirements-files) for information on how to format the requirements file.
3.  Run the following command from inside the [python-lib](python-lib/) folder:
    ```bash
    pip install -r requirements.txt -t .
    ```
    **Note:** If your machine is behind a proxy you will need to specify the proxy using pip's `--proxy` flag.

**Note:** If you have defined a `JYTHONPATH` environment variable, you will need to add the [python-lib](python-lib/) folder path to its value.

**Editing the executable file**

1. Open the executable found in the **bin** folder for editing.
2. Change the `Dpython.path` key's value to the desired path.

#### Documentation :

All documentation is available on the [CloudSlang website](http://www.cloudslang.io/#/docs).

#### Get Involved

Read our contributing guide [here](CONTRIBUTING.md).

Contact us [here](mailto:support@cloudslang.io).

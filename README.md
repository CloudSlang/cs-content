slang-content
=============

Slang is a YAML based language for writing human-readable workflows for score. This project includes slang flows and operations.

[![Build Status](https://travis-ci.org/openscore/slang-content.svg)](https://travis-ci.org/openscore/slang-content)


#### Getting started:

###### Pre-Requisite: Java JRE >= 7

1. Download the slang zip from [here](https://github.com/openscore/score-language/releases/download/slang-CLI-v0.2.1/score-lang-cli.zip).
2. Unzip it.
3. Go to the folder /slang/bin/
4. Run the executable :
  - For Windows : slang.bat 
  - For Linux : bash slang
5. Run a flow: slang>run --f c:/.../your_flow.sl --i input1=root,input2=25 --cp c:/.../dependencies/

**note**

Some of the content is dependent on external python modules.
You can import them by doing the following:

1. Create a JYTHONPATH environment variable.
2. Add desired modules' paths to the JYTHONPATH variable, separating them by colons (:) on Unix and semicolons (;) on Windows.
Or check out the [docs](http://openscore.io/#/docs) for other methods


#### Documentation :

All documentation is available on the [openscore website](http://www.openscore.io/#/docs).

#### Get Involved

Contact us at [here](mailto:support@openscore.io).

#slang-content

##Run SLANG content
To run SLANG content, install the SLANG CLI. For the full documentation see the [openscore](http://www.openscore.io/#/docs) website.

###Download and Run Pre-built CLI

1. Go to the **score** [website](/#/) and scroll to the **Getting Started** section.
2. Click **Download an use slang CLI tool**.
3. Click **Download latest version**. 
4. Locate the downloaded file and unzip the archive.  
    The decompressed file contains:
    + a folder called **slang** with the CLI tool and its necessary dependencies.
    + some other folders with sample flows.
5. Navigate to the folder `slang\bin\`.
6. Start the CLI by running `slang.bat`.

###Download, Build and Run CLI

1. Git clone (or GitHub fork and then clone) the [source code](https://github.com/openscore/score-language).
2. Using the Command Prompt, navigate to the project root directory.
3. Build the project by running `mvn clean install`.
4. After the build finishes, navigate to the `score-language\score-lang-cli\target\slang\bin` folder.
5. Start the CLI by running `slang.bat`.

###Use the CLI

####Run a Flow
To run a flow located at `c:/.../your_flow.sl`, enter the following at the `slang>` prompt:
```bash
slang>run --f c:/.../your_flow.sl
```

If the flow takes in input parameters, use the `--i` flag and a comma-separated list of key=value pairs:
```bash
slang>run --f c:/.../your_flow.sl --i input1=root,input2=25
```
If the flow requires dependencies from another location, use the `--cp` flag: 
```bash
slang>run --f c:/.../your_flow.sl --i input1=root,input2=25 --cp c:/.../yaml/
```

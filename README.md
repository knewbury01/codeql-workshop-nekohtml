# CodeQL workshop - Investigating CVE-2022-24839

We will be investigating [CVE-2022-24839](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2022-24839) in this workshop.

### Setup:

Using [CLI version 2.9.0](https://github.com/github/codeql-cli-binaries/releases/tag/v2.9.0) and CodeQL [lib version 2.9.0](https://github.com/github/codeql/releases/tag/codeql-cli%2Fv2.9.0).

If you are on OSX, after downloading the CLI and library, you will need to clear the extra attributes set on the zips using the following: `xattr -c *.zip`

### Database creation:

For our May 25th session, please download the pre-made databases from [here](https://drive.google.com/drive/folders/1ceuNW7g\
xj9IJxX7qJEV1-FKrKJ3Dyauu?usp=sharing).

##### alternate database creation:

Locally build using:
  * obtain the application that we will be querying, [nekohtml](https://github.com/sparklemotion/nekohtml)
  * the following buildstep requires ant to be installed
  * make a databases directory: `mkdir databases`
  * checkout the [versions of the application right before the patch](https://github.com/sparklemotion/nekohtml/commit/https://github.com/sparklemotion/nekohtml/commit/6fe9b53bc289d0e90d684c0f4a8e9f2b19f3460f), and [the commit where the patch was applied](https://github.com/sparklemotion/nekohtml/commit/a800fce3b079def130ed42a408ff1d09f89e773d), then for each of those commits:
    * run `./makedb.sh`

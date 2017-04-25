# EMR scripts

## Update Spark.Jl julia binding

This script can update the Julia Spark binding on any EMR cluster that already has Julia installed.

### Requirements

1. A preconfigured AWS client
1. Environment variables SPARKJL_REPO and SPARKJL_BRANCH (if they are different from *JohnAdders* and *shared*, respectively)
1. The [jq utility](https://stedolan.github.io/jq/download/) available on the PATH
1. SSH configuration, as described below

#### Configure SSH

Create or modify the ~/.ssh/config file, by adding the following code block. Specify the correct IdentityFile.

```yaml
Host *.compute.amazonaws.com
    User hadoop
    IdentityFile ~/.ssh/your-pem-file.pem
    UserKnownHostsFile /dev/null
    StrictHostKeyChecking No

```

### Usage

```bash
update-sparkjl-binding.sh <emr-cluster-id>
```

If you don't specify an emr-cluster-id, the script will ask you to enter one.


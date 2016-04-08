# bosh-init
Deploy a Micro BOSH using the new bosh-init CLI

Export AWS variables create ~/.aws.local

    #!/bin/bash
    export ELASTIC_IP=
    export ACCESS_KEY_ID=
    export SECRET_ACCESS_KEY=
    export SUBNET_ID=

Create manifest and create the deployment

    spurce ~/.aws.local
    create_manifest
    bosh-init deploy bosh.yml

Target Bosh Director

    bosh target $ELASTIC_IP

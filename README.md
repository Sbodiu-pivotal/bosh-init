# bosh-init
Deploy a Micro BOSH using the new bosh-init CLI

    aws iam upload-server-certificate --server-certificate-name concourse \
        --certificate-body file://my-certificate.pem --private-key file://my-private-key.pem
        
Export AWS variables create ~/.aws.local

    #!/bin/bash
    export ELASTIC_IP=
    export ACCESS_KEY_ID=
    export SECRET_ACCESS_KEY=
    export SUBNET_ID=

Create manifest and create the deployment

    source ~/.aws.local
    ./create_manifest.sh
    bosh-init deploy bosh.yml

Target Bosh Director

    bosh target $ELASTIC_IP
    bosh upload stemcell https://bosh.io/d/stemcells/bosh-aws-xen-hvm-ubuntu-trusty-go_agent?v=3012 --skip-if-exists

Creat concourse manifest

    POSTGRES_ROLE=admin POSTGRES_PASSWORD=admin CONCOURSE_PASSWORD=admin CONCOURSE_USER=admin CONCOURS_URL=https://ci.apj.pivotal ./create_concourse_manifest.sh

Bosh deploy concourse

    bosh deployment concourse.yml
    bosh deploy
    

## Deploy Bind9 DNS Server

Installing Bind9 (DNS Server) is a breeze on Ubuntu. Three packages will need to be installed: bind9, dnsutils, and bind9-doc.

    sudo apt-get install bind9 dnsutils bind9-doc

bind9:  The DNS service.
dnsutils:  A set of tools such as dig which can be helpful for testing and trouble shooting. 
bind9-doc:  Local info pages with information about bind and its configuration options. This is optional but recommended.


### Basic Bind Configuration

The next step is to configure the forwards addresses for bind. This tell bind where to look if it doesn't know the IP address of a domain. In this example we will use [Google's Public DNS](https://developers.google.com/speed/public-dns) servers for the forward DNS servers. Google's DNS servers are fast, free, and have easy to remember IP addresses.

    sudo nano /etc/bind/named.conf.options

Delete the // in front of:

    // forwarders {
    //      0.0.0.0;
    // };
 
Since we are using Google's Public DNS servers, we will want to replace 0.0.0.0 with Google's DNS server IPs 8.8.8.8 and 8.8.4.4 . Your config file should look:

    forwarders {
        8.8.8.8;
        8.8.4.4;
    };
 
The next step is to edit /etc/bind/named.conf.local. This file holds information on what zones to load when Bind9 is started.
We will setup two zones files to load, the Forward and Reverse zones. In this example we will setup an internal domain with tne name `apj.pivotal`. 

When looking at our IP address the part we care about is the first three sets of octets (numbers). Then we just reverse them.  So If my IP address is 192.168.1.100 my reverse lookup zone would be 1.168.192.in-addr.arpa. 

Most home networks will have a 192.168.1.X or 192.168.0.X type of IP address. In my case I have a 192.168.96.X IP address network.

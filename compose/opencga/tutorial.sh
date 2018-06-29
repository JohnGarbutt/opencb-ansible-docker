#!/bin/bash

# Bootstrap with tutorial data
# http://docs.opencb.org/display/opencga/Getting+Started+in+5+minutes

set -eux

# let the system startup
sleep 5

cd /opt/opencga/sessions
mkdir tutorial_scratch
cd tutorial_scratch

# this needs to run before daemon times out and fails to start up
echo Install catalog
/opt/opencga/bin/opencga-admin.sh catalog install --algorithm HS256 --secret-key $SECRET_KEY

sleep 5

echo Create test user
/opt/opencga/bin/opencga-admin.sh users create -u test --email test@example.com --name Test --user-password test -p <<< $ADMIN_PASSWORD

/opt/opencga/bin/opencga.sh users login -u test -p <<< test
cat  ~/.opencga/session.json

echo Create project and sudy

/opt/opencga/bin/opencga.sh projects create -a reference_grch37 -n "Reference studies GRCh37" --organism-scientific-name "Homo sapiens" --organism-assembly "GRCh37"
/opt/opencga/bin/opencga.sh studies create -a 1kG_phase3 -n "1000 Genomes Project - Phase 3" --project reference_grch37

echo Download and link variant file

wget ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chr22.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz
/opt/opencga/bin/opencga.sh files link -i ALL.chr22.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz -s 1kG_phase3

echo Transform, load, annotate and calculate stats

/opt/opencga/bin/opencga.sh variant index --file ALL.chr22.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz --calculate-stats --annotate -o outDir

echo Example check stats

/opt/opencga/bin/opencga.sh jobs search -s 1kG_phase3

echo Query the data

/opt/opencga/bin/opencga.sh users login -u test -p <<< test
cat  ~/.opencga/session.json
/opt/opencga/bin/opencga-analysis.sh variant query --study 1kG_phase3 --region 22:16052853-16054112

echo Complete

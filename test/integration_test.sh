#!/bin/bash

INPUT_DIR=/tmp/spool/slurm/hash.
OUTPUT_DIR=/tmp/output



function makejobfiles
{
    JOBID=$1
    JOBDIR=${INPUT_DIR}0/job.$JOBID

    echo $JOBDIR

    mkdir -p $JOBDIR

    cat > $JOBDIR/environment << EOF
JOBID=$JOBID
EOF

    cat > $JOBDIR/script << EOF
#!/bin/bash
# This is the script for job $JOBID
echo "Hello"
EOF

}
echo "Starting job_archive"

../job_archive -i $INPUT_DIR -o $OUTPUT_DIR -s > output.log 2>&1 &
jobpid=$!

sleep 1

for ((i=1; i < 1000; i++));
do
    makejobfiles $i
done
find ${INPUT_DIR}0 -maxdepth 1 -name job.* -type d -print0 | xargs -0 rm -rf


sleep 1
job1=`makejobfiles 2000`
rm -rf $job1

sleep 1
makejobfiles 3000

sleep 1000
kill -TERM $jobpid
wait

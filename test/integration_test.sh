#!/bin/bash

INPUT_DIR=/tmp/spool/slurm/hash.
OUTPUT_DIR=/tmp/output
TESTDIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"
SRCDIR=$TESTDIR/..

set -e

function makejobfiles
{
    JOBID=$1
    JOBDIR=${INPUT_DIR}0/job.$JOBID

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

$SRCDIR/job_archive -i $INPUT_DIR -o $OUTPUT_DIR -s > output.log 2>&1 &
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

exitcode=1
for ((i=0; i < 10; i++));
do
    filecount=$(find /tmp/output -name 3000.savescript | wc -l)
    if [ $filecount = 1 ];
    then
        exitcode=0
        break
    fi
    sleep 1
done

kill -TERM $jobpid
wait $jobpid

exit $exitcode


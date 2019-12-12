JOBID=$(wget -q -O - https://ci.appveyor.com/api/projects/Jackett/jackett/build/0.12.1171 \
    | jq -r '.build.jobs[] | select(.osType == "Ubuntu") | .jobId')
wget https://ci.appveyor.com/api/buildjobs/${JOBID}/artifacts/Jackett.Binaries.LinuxAMDx64.tar.gz -P /tmp

for i in gitlab-hopper.dotmesh.io gitlab-jogger.dotmesh.io gitlab-runner.dotmesh.io gitlab-swimmer.dotmesh.io
do
    echo "Deploying cleanup-old-test-resources.sh and cronjob to $i..."
    SSH_TARGET=gitlab-runner@$i
    scp cleanup-old-test-resources.sh $SSH_TARGET:cleanup-old-test-resources.sh
    ssh $SSH_TARGET 'sudo crontab -' <<EOF
# Please don't hand-edit this crontab, use citools/deploy-cleanup-script-to-runners.sh to keep
# all the runners in sync (and if that annoys you, then install chef/puppet/etc to manage them properly)

@daily rm -f /etc/zfs/zpool.cache && reboot -f
@reboot rm -rf /dotmesh-test-pools
* * * * * (/home/gitlab-runner/cleanup-old-test-resources.sh 2>&1 | ts) >> /home/gitlab-runner/cleanup-old-test-resources.log
EOF
done

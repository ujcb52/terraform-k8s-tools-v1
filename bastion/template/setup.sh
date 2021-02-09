#!/usr/bin/env bash

# Log everything we do.
set -x
exec > /var/log/user-data.log 2>&1

hostname "${HOSTNAME}"

rm -rf /etc/motd
cat <<EOF > /etc/motd
#########################################################
#
# 지금 접속하신 서버는 "" 에서 관리하고 있으며
# 모든 로그는 원격지 로그 서버에 저장되고 있습니다
# 비인가자의 경우 접속을 해지하여 주시기 바랍니다
#
#########################################################

>> ${HOSTNAME} <<

EOF

sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config

# runuser -l ec2-user -c "curl -sL https://repo-ce.s3.ap-northeast-2.amazonaws.com/tools.sh | bash"


#!/usr/bin/env bash

# Copyright:: Copyright (c) 2016 Been Kyung-yoon (http://www.php79.com/)
# License:: The MIT License (MIT)

STACK_ROOT=$( dirname $( cd "$( dirname "$0" )" && pwd ) )
source "${STACK_ROOT}/includes/function.inc.sh"

title "yum 업데이트, EPEL 저장소 설치, 시간 자동 동기화를 진행합니다."

yum makecache
yum -y --exclude=kernel* update
yum_install epel-release yum-utils ntp

if [ $OS = "centos7" ]; then
  systemctl enable ntpd
  systemctl start ntpd
else
  chkconfig ntpd on
  service ntpd start
fi

ntpdate -u kr.pool.ntp.org 0.centos.pool.ntp.org pool.ntp.org

if [ ${?} != "0" ]; then
  outputError "Warning) 시간 자동 동기화가 실패하였습니다.\n  ntpdate -u kr.pool.ntp.org 0.centos.pool.ntp.org pool.ntp.org"
  exit 0  # 실패시에도 설치 계속 진행
fi

#!/bin/bash
#note: install by gui
DIR=$(cd "$(dirname "$0")";pwd)
#OS_VER=$(lsb_release -i --short)
#OS_NUM=$(lsb_release -r --short |awk -F. '{print $1}')

function check_err(){
    if [ $? -eq 0 ];then
        echo "成功..." >> ${DIR}/install.log
    else
        echo "失败..." >> ${DIR}/install.log && exit 1
    fi
}
function print_log(){
    if [ "$1" == "-n" ];then
        echo -n "$2" >> ${DIR}/install.log
    else
        echo "$1" >> ${DIR}/install.log
    fi
}
#install
function install() {
    print_log "开始安装google-chrome...`date '+%Y-%m-%d %H:%M:%S'`"
    print_log "创建repo文件..."
cat > /etc/yum.repos.d/google-chrome.repo <<EOF
[google-chrome]
name=google-chrome
baseurl=https://dl.google.com/linux/chrome/rpm/stable/x86_64
enabled=1
gpgcheck=1
gpgkey=https://dl.google.com/linux/linux_signing_key.pub
EOF
    print_log -n "创建repo文件..."
    google-chrome --version || yum install -y google-chrome-stable
    check_err
    print_log -n "下载chromedriver..."
    chrome_version=$(google-chrome --version |awk '{print $NF}')
    chromedriver_version=`https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/${chrome_version}/linux64/chromedriver-linux64.zip`
    [ -f chromedriver_linux64.zip ] && rm -rf chromedriver_linux64.zip
    wget --no-check-certificate ${chromedriver_version}
    check_err
    [ -f /usr/bin/chromedriver ] && rm -rf /usr/bin/chromedriver
    unzip chromedriver_linux64.zip && mv chromedriver /usr/bin/ && chmode +x /usr/bin/chromedriver
    print_log -n "检查google-chrome-stable..."
    google-chrome-stable --version
    check_err
    print_log -n "检查chromedriver..."
    chromedriver --version
    check_err
}

# install
install

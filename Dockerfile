# centos:chat
#
# VERSION               1.0.0
 
FROM centos
MAINTAINER peter.peng "451127509@qq.com"

#supervisor
RUN yum -y update && \
	ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
	/bin/echo -e "LANG=\"en_US.UTF-8\"" > /etc/default/local && \
	yum -y install python-setuptools && \
	easy_install supervisor && \
	echo_supervisord_conf > /etc/supervisord.conf && \
	/bin/echo '[include]' >> /etc/supervisord.conf  && \	
	/bin/echo 'files = supervisord.d/*.conf' >> /etc/supervisord.conf  && \	
	mkdir -p /etc/supervisor/ && \
	mkdir -p /etc/python-wafer/
	
COPY python-wafer.conf /etc/supervisord.d/
COPY python-wafer /etc/python-wafer/

RUN yum -y install epel-release && \
	yum -y install python-pip && \
	pip install --upgrade pip && \	
	pip install -r /etc/python-wafer/requirements.txt

VOLUME [ \
  "/etc/python-wafer/logs"]
  
EXPOSE 8080 9090 8888
#CMD supervisord -c /etc/supervisord.conf
#CMD ["/usr/bin/supervisord","-c","/etc/supervisord.conf"]
ENTRYPOINT ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"] 

# ---------------------- 参考资料 -----------------------------
# docker容器内通过supervisor来守护进程
# https://blog.csdn.net/weiguang1017/article/details/77493142
# Docker中使用supervisor管理开机自启动（redis && sshd）
# https://blog.csdn.net/lsziri/article/details/69396525
# 使用supervisor部署tornado(python3)
# https://blog.csdn.net/qq_35556064/article/details/81210090
# centos7修改系统编码为"en_US.UTF-8"
# https://blog.csdn.net/Suubyy/article/details/78365993?locationNum=8&fps=1
# CentOS7修改时区的正确姿势
# https://blog.csdn.net/yin138/article/details/52765089
# 进程管理supervisor的简单说明
# https://www.cnblogs.com/zhoujinyi/p/6073705.html
#
# 构建image镜像
# docker build -t idu/chat:1.0 .
#
# 启动container后台运行提供Chat服务
# docker run -d -p 8080:8080 -p 9091:9090 --name chat -t idu/chat:1.0
#
# 操作记录
# docker exec -i -u root -t chat /bin/bash
# supervisord -c /etc/supervisord.conf
# supervisorctl
# supervisor> status    # 查看程序状态
# supervisor> stop tornadoes:*   # 关闭 tornadoes组 程序
# supervisor> start tornadoes:*  # 启动 tornadoes组 程序
# supervisor> restart tornadoes:*    # 重启 tornadoes组 程序
# supervisor> update    ＃ 重启配置文件修改过的程序
FROM centos:7
RUN yum install -y \
    gcc-c++ \
    make \
    rpm-build \
    git

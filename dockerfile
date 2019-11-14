FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04

LABEL maintainer="jyz4872@163.com"
ENV LANG C.UTF-8

COPY root/ /root
RUN echo "nameserver 8.8.8.8" >> /etc/resolv.conf && \
    mv /etc/apt/sources.list /etc/apt/sources.list.bak && \

    echo "deb http://mirrors.aliyun.com/ubuntu/ xenial main restricted universe multiverse" >>/etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted universe multiverse" >>/etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted universe multiverse" >>/etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/ubuntu/ xenial-proposed main restricted universe multiverse" >>/etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse" >>/etc/apt/sources.list && \
    echo "deb-src http://mirrors.aliyun.com/ubuntu/ xenial main restricted universe multiverse" >>/etc/apt/sources.list && \
    echo "deb-src http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted universe multiverse" >>/etc/apt/sources.list && \
    echo "deb-src http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted universe multiverse" >>/etc/apt/sources.list && \
    echo "deb-src http://mirrors.aliyun.com/ubuntu/ xenial-proposed main restricted universe multiverse" >>/etc/apt/sources.list && \
    echo "deb-src http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse" >>/etc/apt/sources.list


RUN APT_INSTALL="apt-get install -y --no-install-recommends" && \
    PIP_INSTALL="python3 -m pip --no-cache-dir install --upgrade" && \

    rm -rf /var/lib/apt/lists/* \
           /etc/apt/sources.list.d/cuda.list \
           /etc/apt/sources.list.d/nvidia-ml.list && \

    apt-get update && \

# ==================================================================
# tools
# ------------------------------------------------------------------

    DEBIAN_FRONTEND=noninteractive $APT_INSTALL \
        build-essential \
        apt-utils \
        ca-certificates \
        wget \
        git \
        vim \
        libssl-dev \
        curl \
        unzip \
        unrar \
        libsm6 \
        libxext6 \
        libxrender-dev \
        libglib2.0-0 \
        && \

    cd ~/cmake && \
    ./bootstrap && \
    make -j"$(nproc)" install && \
# ==================================================================
# python
# ------------------------------------------------------------------

    DEBIAN_FRONTEND=noninteractive $APT_INSTALL \
        software-properties-common \
        && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
        DEBIAN_FRONTEND=noninteractive $APT_INSTALL \
        python3.6 \
        python3.6-dev \
        python3-distutils-extra \
        python3-venv python3-setuptools \
        protobuf-compiler python-pil python-lxml python-tk \
        && \
    ln -s /usr/bin/python3.6 /usr/local/bin/python3 && \
    ln -s /usr/bin/python3.6 /usr/local/bin/python && \
    cd /root/pip-19.3.1 && \    
    python setup.py install && \
    pip install /root/numpy-1.16.5-cp36-cp36m-manylinux1_x86_64.whl && \
    pip install /root/scipy-1.2.2-cp36-cp36m-manylinux1_x86_64.whl && \
    pip install /root/opencv_python-4.1.1.26-cp36-cp36m-manylinux1_x86_64.whl && \
    pip install /matplotlib==3.1.1 -i https://mirrors.aliyun.com/pypi/simple/ && \
    pip install /root/Pillow-6.2.0-cp36-cp36m-manylinux1_x86_64.whl && \
    pip install /root/Cython-0.29.13-cp36-cp36m-manylinux1_x86_64.whl && \

# ==================================================================
# tensorflow
# ------------------------------------------------------------------

    pip install tensorflow-gpu==1.14.0 -i https://mirrors.aliyun.com/pypi/simple/ && \
# ==================================================================
# config & cleanup
# ------------------------------------------------------------------

    ldconfig && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* ~/*

VOLUME /safety_helmet_inference

EXPOSE 6006


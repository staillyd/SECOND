# From https://github.com/ufoym/deepo/blob/master/docker/Dockerfile.pytorch-py36-cu90

# ==================================================================
# module list
# ------------------------------------------------------------------
# python        3.6    (apt)
# pytorch       latest (pip)
# ==================================================================

FROM nvidia/cuda:10.2-cudnn7-devel-ubuntu16.04
RUN APT_INSTALL="apt-get install -y --no-install-recommends" && \
    PIP_INSTALL="python -m pip --no-cache-dir install --upgrade" && \
    GIT_CLONE="git clone --depth 10" && \
    rm -rf /var/lib/apt/lists/* \
           /etc/apt/sources.list.d/cuda.list \
           /etc/apt/sources.list.d/nvidia-ml.list \
           /etc/apt/sources.list && \
    echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial main restricted universe multiverse\n\
        deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-updates main restricted universe multiverse\n\
        deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-backports main restricted universe multiverse\n\
        deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-security main restricted universe multiverse"\
        >>/etc/apt/sources.list &&\
    apt-get update && \
# ==================================================================
# tools
# ------------------------------------------------------------------
    DEBIAN_FRONTEND=noninteractive $APT_INSTALL \
        build-essential \
        ca-certificates \
        gcc \
        g++ \
        cmake \
        wget \
        git \
        vim \
        fish \
        libsparsehash-dev \
        && \
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
        && \
    wget -O ~/get-pip.py \
        https://bootstrap.pypa.io/get-pip.py && \
    python3.6 ~/get-pip.py && \
    ln -s /usr/bin/python3.6 /usr/local/bin/python3 && \
    ln -s /usr/bin/python3.6 /usr/local/bin/python && \
    python3 -m pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple &&\
    # python3 -m pip config set global.index-url http://pypi.douban.com/simple/ &&\
    # python3 -m pip config set global.trusted-host pypi.douban.com &&\
    $PIP_INSTALL \
        setuptools \
        && \
    $PIP_INSTALL \
        numpy==1.17.4 \
        scipy \
        matplotlib \
        Cython \
        && \
# ==================================================================
# pytorch
# ------------------------------------------------------------------
    $PIP_INSTALL \
        pip install torch==1.7.1 torchvision==0.8.2 torchaudio==0.7.2 &&\
# ==================================================================
# config & cleanup
# ------------------------------------------------------------------
    ldconfig && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* ~/*

RUN PIP_INSTALL="python -m pip --no-cache-dir install --upgrade" && \
    $PIP_INSTALL \
        shapely fire pybind11 tensorboardX protobuf \
        scikit-image numba pillow opencv-python

# WORKDIR /root
# RUN wget https://dl.bintray.com/boostorg/release/1.68.0/source/boost_1_68_0.tar.gz
# RUN tar xzvf boost_1_68_0.tar.gz
# RUN cp -r ./boost_1_68_0/boost /usr/include
# RUN rm -rf ./boost_1_68_0
# RUN rm -rf ./boost_1_68_0.tar.gz
# RUN git clone https://github.com/traveller59/second.pytorch.git --depth 10
# RUN git clone https://github.com/traveller59/SparseConvNet.git --depth 10
# RUN cd ./SparseConvNet && python setup.py install && cd .. && rm -rf SparseConvNet
ENV NUMBAPRO_CUDA_DRIVER=/usr/lib/x86_64-linux-gnu/libcuda.so
ENV NUMBAPRO_NVVM=/usr/local/cuda/nvvm/lib64/libnvvm.so
ENV NUMBAPRO_LIBDEVICE=/usr/local/cuda/nvvm/libdevice
# ENV PYTHONPATH=/root/second.pytorch

# VOLUME ["/root/data"]
# VOLUME ["/root/model"]
# WORKDIR /root/second.pytorch/second

CMD ["/bin/bash"]

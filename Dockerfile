FROM continuumio/miniconda3:4.10.3

# conda won't work without bash
SHELL [ "/bin/bash", "-c" ]

# ** Download guide **
# SNPE:           https://developer.qualcomm.com/software/qualcomm-neural-processing-sdk
# (or, directly)  https://developer.qualcomm.com/qfile/68747/snpe-1.53.2.zip
# Boost:          https://boostorg.jfrog.io/ui/native/main/release/1.77.0/source/

ENV BOOST_VERSION=boost_1_77_0

COPY ${BOOST_VERSION}.tar.gz /tmp/
COPY Makefile.caffe.config /tmp

RUN set -ex \
    \
    && echo "Installing development packages" \
    \
    && apt-get -qq update \
    && apt-get install -qq -y \
        git \
        build-essential \
        libprotobuf-dev \
        protobuf-compiler \
        cmake \
        libgflags-dev \
        libgoogle-glog-dev \
        libopenblas-dev \
        libhdf5-dev \
        zip \
        unzip \
    \
    && source ~/.bashrc \
    && conda create -n snpe python=3.6 -y \
    && conda activate snpe \
    \
    && echo "Install pip requirements" \
    \
    && pip3 install \
        numpy \
        scikit-image \
        protobuf \
        pyyaml \
        onnx \
        onnx-simplifier \
        tensorflow \
        tensorboard \
    \
    && mkdir /workspace \
    \    
    && echo "Build boost (automatically installs Boost.Python)" \
    \
    && cd /opt \
    && tar xzf /tmp/${BOOST_VERSION}.tar.gz && rm /tmp/${BOOST_VERSION}.tar.gz \
    && cd ${BOOST_VERSION} \
    && ./bootstrap.sh --with-python=/opt/conda/envs/snpe/bin/python --with-python-version=3.6 --with-python-root=/opt/conda/envs/snpe/lib/python3.6 \
    && ./b2 install --without-mpi --without-graph_parallel \
    && cd .. \
    && rm -rf ${BOOST_VERSION} \
    \
    && echo "Build caffe" \
    \
    && cd /opt \
    && mkdir caffe-build \
    && cd caffe-build \
    && git clone https://github.com/BVLC/caffe.git . \
    && git checkout 18b09e807a6e146750d84e89a961ba8e678830b4 \
    && cp /tmp/Makefile.caffe.config Makefile.config \
    && rm /tmp/Makefile.caffe.config \
    && make distribute -j$(nproc) \
    \
    && echo "Copy required caffe python libraries" \
    \
    && cd /opt/caffe-build \
    && cp -R distribute /opt/caffe \
    && cd /opt \
    && rm -rf caffe-build \
    \
    && echo "Cleanup" \
    \
    && cd /opt \
    && apt-mark manual libgflags2.2 libgoogle-glog0v5 libhdf5-103 libopenblas-base libprotobuf17 libprotoc17 \
    && apt-get autoremove --purge -y \
        build-essential \
        libprotobuf-dev \
        protobuf-compiler \
        cmake \
        libgflags-dev \
        libgoogle-glog-dev \
        libopenblas-dev \
        libhdf5-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists

# Prepare SNPE toolkits
ENV SNPE_ROOT=/snpe
ENV CAFFE_ROOT=/opt/caffe/python
ENV CAFFE_LIBRARY_PATH=/opt/caffe/lib
ENV TENSORFLOW_ROOT=/opt/conda/envs/snpe/lib/python3.6/site-packages/tensorflow

WORKDIR /workspace
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
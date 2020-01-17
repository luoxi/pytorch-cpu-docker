FROM ubuntu:18.04
ENV LANG C.UTF-8
RUN APT_INSTALL="apt-get install -y --no-install-recommends" && \
  PIP_INSTALL="python -m pip --no-cache-dir install --upgrade" && \
  GIT_CLONE="git clone --depth 10" && \

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
  libpq-dev \
  postgresql-client \
  && \

  $GIT_CLONE https://github.com/Kitware/CMake ~/cmake && \
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
  python3.7 \
  python3.7-dev \
  python3-distutils-extra \
  && \
  wget -O ~/get-pip.py \
  https://bootstrap.pypa.io/get-pip.py && \
  python3.7 ~/get-pip.py && \
  ln -s /usr/bin/python3.7 /usr/local/bin/python3 && \
  ln -s /usr/bin/python3.7 /usr/local/bin/python && \
  $PIP_INSTALL \
  setuptools \
  && \
  $PIP_INSTALL \
  numpy==1.17.4 \
  scipy \
  pandas \
  cloudpickle \
  scikit-image>=0.14.2 \
  scikit-learn \
  matplotlib==3.1.2 \
  Cython \
  tqdm \
  && \

  # ==================================================================
  # pytorch
  # ------------------------------------------------------------------

  $PIP_INSTALL \
  future \
  protobuf \
  enum34 \
  pyyaml \
  typing \
  torch==1.3.1 \
  torchvision==0.4.2 \
  segmentation-models-pytorch==0.1.0 \
  opencv-python-headless==4.1.2.30 \
  && \

  # ==================================================================
  # django
  # ------------------------------------------------------------------

  $PIP_INSTALL \
  Django==3.0.2 \
  gunicorn==20.0.4 \
  psycopg2==2.8.4 \
  Pillow==6.2.1 \
  boto3==1.11.4 \
  django-storages==1.8 \
  && \


  # ==================================================================
  # config & cleanup
  # ------------------------------------------------------------------

  ldconfig && \
  apt-get clean && \
  apt-get autoremove && \
  rm -rf /var/lib/apt/lists/* /tmp/* ~/*

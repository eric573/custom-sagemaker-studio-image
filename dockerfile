FROM python:3.10

ARG NB_USER="sagemaker-user"
ARG NB_UID="1000"
ARG NB_GID="100"

RUN \
    apt-get update && \
    apt-get install -y wget bzip2 ca-certificates && \
    apt-get install -y sudo && \
    useradd -m -s /bin/bash -N -u $NB_UID $NB_USER && \
    chmod g+w /etc/passwd && \
    echo "${NB_USER}    ALL=(ALL)    NOPASSWD:    ALL" >> /etc/sudoers && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /home/sagemaker-user
COPY requirements.txt ./
COPY startup-script.sh ./
RUN pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
RUN pip install --no-cache-dir -r ./requirements.txt
RUN pip install ipykernel && python -m ipykernel install --sys-prefix

ENV SHELL=/bin/bash

USER $NB_UID 
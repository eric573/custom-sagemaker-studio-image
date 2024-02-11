FROM ubuntu:18.04

# Eric: Add the next 3 lines to resolve this error
# ResourceNotFoundError: SageMaker is unable to launch the app using the image [XXX]. Ensure that the UID/GID provided in the AppImageConfig matches the default UID/GID defined in the image.
ARG NB_USER="sagemaker-user"
ARG NB_UID="1000"
ARG NB_GID="100"

RUN apt-get update && apt-get install -y wget bzip2 ca-certificates \
    && apt-get clean \
    && apt-get install -y sudo \
    && rm -rf /var/lib/apt/lists/*

# Eric: Added next 4 lines to 
RUN \
    useradd -m -s /bin/bash -N -u $NB_UID $NB_USER && \
    chmod g+w /etc/passwd && \
    echo "${NB_USER}    ALL=(ALL)    NOPASSWD:    ALL" >> /etc/sudoers && \
    rm -rf /var/lib/apt/lists/*


# Break down the commands for better error isolation
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
RUN /bin/bash ~/miniconda.sh -b -p /opt/conda
RUN rm ~/miniconda.sh
# Added
RUN /opt/conda/bin/conda --version 
RUN /opt/conda/bin/conda update -n base -c defaults conda
RUN /opt/conda/bin/conda clean -tipy
RUN ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh
RUN echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc
RUN echo "conda activate base" >> ~/.bashrc

ENV PATH /opt/conda/bin:$PATH

RUN conda --version

RUN apt-get update && apt-get install -y git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Eric: This line is added to ensure we build a kernel for Jupyternotebook
RUN pip install ipykernel && \
        python -m ipykernel install --sys-prefix

# Clone the specified Git repositor
RUN git clone https://github.com/clovaai/donut.git

USER $NB_UID
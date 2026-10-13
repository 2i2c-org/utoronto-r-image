FROM rocker/binder:latest@sha256:fb78d0c4bcfc9ece1f8ea22ef87fdcf82874b087ec94eedbab5e02667f570b75
USER root

COPY apt.txt /tmp/apt.txt
RUN apt-get update && \
    # Ignore comments in packages
    grep '^\s*[^#]\+' /tmp/apt.txt | xargs apt-get -y install

USER ${NB_USER}

COPY install.r /tmp/install.r
RUN Rscript /tmp/install.r

# Install Python dependencies
COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Set working directory so Jupyter knows where to start
WORKDIR /home/rstudio

# Set SHELL so Jupyter launches /bin/bash, not /bin/sh
# /bin/sh doesn't have a lot of interactive features (like tab complete or functional arrow keys)
# that people have come to expect.
ENV SHELL=/bin/bash

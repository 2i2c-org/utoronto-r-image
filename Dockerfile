FROM rocker/binder:latest@sha256:9c1bb3dc842755c4ac57b6e5ab78dd353c0f4790bdcd7d1f780b6dff38435d9a
USER root

COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache -r /tmp/requirements.txt

RUN apt-get update && apt-get -y install \
    texlive-latex-recommended \
    texlive-pictures

USER ${NB_USER}

# Install learnr and other requested packages in https://2i2c.freshdesk.com/a/tickets/741
# mosaic installed per https://2i2c.freshdesk.com/a/tickets/973
RUN install2.r --skipinstalled \
    --repos https://p3m.dev/cran/__linux__/noble/2025-07-29 \
    learnr \
    XLConnect \
    ggvis \
    dygraphs \
    DT \
    networkD3 \
    threeJS \
    lme4 \
    randomForest \
    multcomp \
    vcd \
    glmnet \
    caret \
    ggmap \
    quantmod \
    mosaic \
    tensorflow \
    keras3 \
    && rm -rf /tmp/downloaded_packages

# Set working directory so Jupyter knows where to start
WORKDIR /home/rstudio

# Set SHELL so Jupyter launches /bin/bash, not /bin/sh
# /bin/sh doesn't have a lot of interactive features (like tab complete or functional arrow keys)
# that people have come to expect.
ENV SHELL=/bin/bash

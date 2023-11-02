FROM rocker/binder:4.3.1

USER root

# Install python packages as root, since that's what is done upstream
# This may change soon https://github.com/rocker-org/rocker-versioned2/issues/670
COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache -r /tmp/requirements.txt

USER ${NB_USER}

# Install learnr and other requested packages in https://2i2c.freshdesk.com/a/tickets/741
# mosaic installed per https://2i2c.freshdesk.com/a/tickets/973
RUN install2.r --skipinstalled \
    learnr \
    XLConnect \
    ggvis \
    dygraphs \
    DT \
    network3D \
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
    && rm -rf /tmp/downloaded_packages

# Set working directory so Jupyter knows where to start
WORKDIR /home/rstudio

# Set SHELL so Jupyter launches /bin/bash, not /bin/sh
# /bin/sh doesn't have a lot of interactive features (like tab complete or functional arrow keys)
# that people have come to expect.
ENV SHELL=/bin/bash

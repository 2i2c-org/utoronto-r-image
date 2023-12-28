FROM rocker/binder:4.3.2

# Needed until https://github.com/rocker-org/rocker-versioned2/pull/740 is
# merged
ENV VIRTUAL_ENV=/opt/venv
ENV PATH=${VIRTUAL_ENV}/bin:${PATH}

COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache -r /tmp/requirements.txt

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

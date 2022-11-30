FROM rocker/geospatial:4.2.2

# Install conda here, to match what repo2docker does
ENV CONDA_DIR=/srv/conda

# Add our conda environment to PATH, so python, mamba and other tools are found in $PATH
ENV PATH ${CONDA_DIR}/bin:${PATH}

# RStudio doesn't actually inherit the ENV set in Dockerfiles, so we
# have to explicitly set it in Renviron.site
RUN echo "PATH=${PATH}" >> /usr/local/lib/R/etc/Renviron.site

# The terminal inside RStudio doesn't read from Renviron.site, but does read
# from /etc/profile - so we rexport here.
RUN echo "export PATH=${PATH}" >> /etc/profile

# Install a specific version of mambaforge in ${CONDA_DIR}
# Pick latest version from https://github.com/conda-forge/miniforge/releases
ENV MAMBAFORGE_VERSION=22.9.0-2
RUN echo "Installing Mambaforge..." \
    && curl -sSL "https://github.com/conda-forge/miniforge/releases/download/${MAMBAFORGE_VERSION}/Mambaforge-${MAMBAFORGE_VERSION}-Linux-$(uname -m).sh" > installer.sh \
    && /bin/bash installer.sh -u -b -p ${CONDA_DIR} \
    && rm installer.sh \
    && mamba clean -afy \
    # After installing the packages, we cleanup some unnecessary files
    # to try reduce image size - see https://jcristharif.com/conda-docker-tips.html
    && find ${CONDA_DIR} -follow -type f -name '*.a' -delete \
    && find ${CONDA_DIR} -follow -type f -name '*.pyc' -delete

COPY environment.yml /tmp/environment.yml

RUN mamba env update -p ${CONDA_DIR} -f /tmp/environment.yml \
    && mamba clean -afy \
    && find ${CONDA_DIR} -follow -type f -name '*.a' -delete \
    && find ${CONDA_DIR} -follow -type f -name '*.pyc' -delete

# Install IRKernel
RUN install2.r --skipinstalled IRkernel \
    && rm -rf /tmp/downloaded_packages

RUN r -e "IRkernel::installspec(prefix='${CONDA_DIR}')"

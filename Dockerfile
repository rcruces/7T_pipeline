# Use an official Python runtime as a parent image
FROM python:3.8-slim

# Set environment variable for dcm2niix
ENV PATH="/opt/dcm2niix-v1.0.20190902/bin:$PATH"

# Install dependencies and dcm2niix
RUN apt-get update -qq \
    && apt-get install -y -q --no-install-recommends \
           cmake \
           g++ \
           gcc \
           git \
           make \
           pigz \
           zlib1g-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && git clone https://github.com/rordenlab/dcm2niix /tmp/dcm2niix \
    && cd /tmp/dcm2niix \
    && git fetch --tags \
    && git checkout v1.0.20190902 \
    && mkdir /tmp/dcm2niix/build \
    && cd /tmp/dcm2niix/build \
    && cmake  -DCMAKE_INSTALL_PREFIX:PATH=/opt/dcm2niix-v1.0.20190902 .. \
    && make \
    && make install \
    && rm -rf /tmp/dcm2niix

# Install Python package
RUN pip install bids_validator

# Set the working directory
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Run the application
CMD ["functions/mpn_dcm2bids.py"]
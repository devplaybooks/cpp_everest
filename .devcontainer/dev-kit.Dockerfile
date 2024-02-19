FROM mcr.microsoft.com/devcontainers/cpp:dev-debian

RUN apt-get update \
  && apt-get install --no-install-recommends -y \
    clang-tidy \
    python3-pip \
    lcov

# additional packages
RUN apt-get install --no-install-recommends -y \
        # required by some everest libraries
        libboost-all-dev \
        # required by libocpp
        libsqlite3-dev \
        libssl-dev \
        # required by everest-framework
        nodejs \
        libnode-dev \
        npm \
        # required by packet sniffer module
        pkg-config \
        libpcap-dev \
        # required by RiseV2G
        maven \
        # required by pybind11
        python3-dev \
        # required for cryptography
        libffi-dev \
        rust-all \
        # required by gcovr
        libxml2-dev \
        libxslt1-dev

# clean up apt
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/*


RUN rm -f /usr/lib/python3.11/EXTERNALLY-MANAGED

RUN python3 -m pip install \
    environs>=9.5.0 \
    pydantic==1.* \
    psutil>=5.9.1 \
    cryptography>=3.4.6 \
    aiofile>=3.7.4 \
    py4j>=0.10.9.5 \
    netifaces>=0.11.0 \
    python-dateutil>=2.8.2 \
    gcovr==5.0

# install ev-cli
RUN python3 -m pip install git+https://github.com/EVerest/everest-utils@4a5ce956722929325cef3c2d73a8919c6d2e4013#subdirectory=ev-dev-tools

# install everest-testing
RUN python3 -m pip install git+https://github.com/EVerest/everest-utils@v0.1.6#subdirectory=everest-testing

# install edm
RUN python3 -m pip install git+https://github.com/EVerest/everest-dev-environment@v0.5.5#subdirectory=dependency_manager

# install everest-cmake
ARG EVEREST_CMAKE_PATH=/usr/lib/cmake/everest-cmake

RUN git clone https://github.com/EVerest/everest-cmake.git $EVEREST_CMAKE_PATH

RUN ( \
    cd $EVEREST_CMAKE_PATH \
    git checkout 329f8db \
    rm -r .git \
    )

ENV CMAKE_GENERATOR=Ninja
ENV CMAKE_EXPORT_COMPILE_COMMANDS=ON

# Add ./bin to PATH
ENV PATH="./bin:${PATH}"

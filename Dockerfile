FROM ubuntu:20.04

# Set the working directory
USER root
WORKDIR /root

COPY ENTRYPOINT.sh /

# Install required packages
RUN DEBIAN_FRONTEND=noninteractive apt-get -qq update && \
    DEBIAN_FRONTEND=noninteractive apt-get -qq install \
    dnsutils \
    tcpdump \
    vim \
    git \
    net-tools \
    iputils-ping \
    ifupdown \
    hostapd \
    bridge-utils \
    iptables \
    sudo \
    python3 \
    curl \
    gettext \
    gcc \
    iproute2 \
    libssl-dev \
    libdbus-1-dev \
    libidn11-dev \
    libnetfilter-conntrack-dev \
    mininet \
    netfilter-persistent \
    nettle-dev \
    openvswitch-switch \
    openvswitch-testcontroller \
    x11-xserver-utils \
    xterm \
    && rm -rf /var/lib/apt/lists/* \
    && touch /etc/network/interfaces \
    && chmod +x /ENTRYPOINT.sh

# Copy the necessary files into the image
COPY cargo.* ./ \
    dora dora/ \
    *.txt dora/ \
    dora_config.yaml dora/

# Set up environment variables
ENV CARGO_HOME=/usr/local/cargo
ENV PATH=$CARGO_HOME/bin:$PATH

# Install the sqlx-cli tool and run database migrations for Dora
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh \
    -s -- -y; \
    cargo install sqlx-cli; \
    cd dora; \
    sqlx database create; \
    sqlx migrate run;

# Build the Dora binary and set it as the command to run when the container starts
RUN cd dora; \
    cargo build --release; \
    cp target/release/dora .; \
    chmod +x dora; \
    cd ../ \
    git clone https://github.com/mininet/mininet

EXPOSE 6633 6653 6640

ENTRYPOINT ["/ENTRYPOINT.sh"]

CMD ["./dora"]
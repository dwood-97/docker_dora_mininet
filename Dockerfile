FROM rust:1.66.0-buster

# Set the working directory
WORKDIR /app

# Copy the necessary files into the image
COPY cargo.* ./ \
    dora dora/ \
    *.txt dora/ \
    dora_config.yaml dora/

# Install required packages
RUN apt-get -qq update; \
    apt-get -qq install \
    hostapd \
    bridge-utils \
    iptables \
    sudo \
    gettext \
    libdbus-1-dev \
    libidn11-dev \
    libnetfilter-conntrack-dev \
    nettle-dev \
    netfilter-persistent;

# Set up the AP and configure network routing
USER root
RUN mv dora/ap_config.txt /etc/hostapd/hostapd.conf; \
    cat dora/dhcpc_config.txt >> /etc/dhcpcd.conf; \
    echo "net.ipv4.ip_forward=1\nnet.ipv6.conf.all.forwarding=1" >> /etc/sysctl.d/99-sysctl.conf; \
    iptables -t nat -N MASQUERADE; \
    iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE; \
    netfilter-persistent save;

# Install the sqlx-cli tool and run database migrations for Dora
RUN cargo install sqlx-cli; \
    cd dora; \
    sqlx database create; \
    sqlx migrate run;

# Build the Dora binary and set it as the command to run when the container starts
RUN cd dora; \
    cargo build --release; \
    cp target/release/dora .; \
    chmod +x dora;

CMD ["./dora"]

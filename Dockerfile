FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    wget curl git build-essential pkg-config \
    libssl-dev libudev-dev python3 python3-pip \
    neofetch vim nano \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js 20
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

# Install Yarn
RUN npm install -g yarn

# Install Rust 1.90.0 (require 1.89+ minimum)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain 1.90.0
ENV PATH="/root/.cargo/bin:${PATH}"

# Install Solana CLI 1.18.22
RUN sh -c "$(curl -sSfL https://release.solana.com/v1.18.22/install)"
ENV PATH="/root/.local/share/solana/install/active_release/bin:${PATH}"

# Install Anchor 0.32.1
RUN cargo install --git https://github.com/coral-xyz/anchor anchor-cli --tag v0.32.1 --locked --force

# Install ttyd for web terminal
RUN wget -qO /bin/ttyd https://github.com/tsl0922/ttyd/releases/download/1.7.3/ttyd.x86_64 && \
    chmod +x /bin/ttyd

# Setup bashrc
RUN echo "neofetch" >> /root/.bashrc && \
    echo "echo 'Dev Environment'" >> /root/.bashrc && \
    echo "echo 'Rust: \$(rustc --version)'" >> /root/.bashrc && \
    echo "echo 'Solana: \$(solana --version)'" >> /root/.bashrc && \
    echo "echo 'Anchor: \$(anchor --version)'" >> /root/.bashrc

EXPOSE $PORT

CMD ["/bin/bash", "-c", "/bin/ttyd -p $PORT -c $USERNAME:$PASSWORD /bin/bash"]

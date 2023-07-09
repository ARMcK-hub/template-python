
FROM armck/python-base:latest

LABEL   deployable="false" \
        decription="This is the development version of the WEF application container. \
                    It includes the application and required development tools."

# ----- Environment Setup -----

# Set Workspace directory
ARG WORKSPACE=/workspaces/template-python
ENV WORKSPACE=${WORKSPACE}

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# ----- Primary Installs -----
# uses tmp install directory to keep from caching install downloads

RUN mkdir /tmp/dockerinstall \
    && cd /tmp/dockerinstall \
    # Installs
    # Supporting Packages
    && apt-get update && apt-get -y install  \
        ca-certificates \
        curl \
        gnupg \
        software-properties-common \
        wget \
    # Azure CLI Keys and Registry
    && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main"  > /etc/apt/sources.list.d/azure-cli.list \
    # Terraform Keys & Registry
    && wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list \
    # Docker Keys & Registry - For Terraform ContainerApp Deployments
    && install -m 0755 -d /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
    && echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    # Primary Installs
    && apt-get update && apt-get -y install \
        azure-cli \
        terraform \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-buildx-plugin \
        docker-compose-plugin \
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/dockerinstall

COPY poetry.lock pyproject.toml ${WORKSPACE}/
RUN cd $WORKSPACE && poetry install --no-root

# ----- Workspace Prep -----
WORKDIR ${WORKSPACE}

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog

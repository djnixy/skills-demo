FROM ubuntu:noble

SHELL ["/bin/bash", "-xo", "pipefail", "-c"]

# Generate locale C.UTF-8 for postgres and general locale data
ENV LANG=en_US.UTF-8

# Retrieve the target architecture to install the correct wkhtmltopdf package
ARG TARGETARCH

# Install some deps, lessc and less-plugin-clean-css, and wkhtmltopdf

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        dirmngr \
        fonts-noto-cjk \
        gnupg \
        libssl-dev \
        node-less \
        npm \
        python3-magic \
        python3-num2words \
        python3-odf \
        python3-pdfminer \
        python3-pip \
        python3-phonenumbers \
        python3-pyldap \
        python3-qrcode \
        python3-renderpm \
        python3-setuptools \
        python3-slugify \
        python3-vobject \
        python3-watchdog \
        python3-xlrd \
        python3-xlwt \
        xz-utils && \
    WKHTMLTOPDF_ARCH=amd64 && WKHTMLTOPDF_SHA=4f723b2691ad8638a9df960e0421d346d7315083e3583a334f33362280ddba15 \
    && curl --proto "=https" -o wkhtmltox.deb -sSL "https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-3/wkhtmltox_0.12.6.1-3.jammy_${WKHTMLTOPDF_ARCH}.deb" \
    && echo "${WKHTMLTOPDF_SHA}  wkhtmltox.deb" | sha256sum -c - \
    && apt-get install -y --no-install-recommends ./wkhtmltox.deb \
    && rm -rf /var/lib/apt/lists/* wkhtmltox.deb

# install latest postgresql-client
RUN echo 'deb https://apt.postgresql.org/pub/repos/apt/ noble-pgdg main' > /etc/apt/sources.list.d/pgdg.list \
    && GNUPGHOME="$(mktemp -d)" \
    && export GNUPGHOME \
    && repokey='B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8' \
    && gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "${repokey}" \
    && gpg --batch --armor --export "${repokey}" > /etc/apt/trusted.gpg.d/pgdg.gpg.asc \
    && gpgconf --kill all \
    && rm -rf "$GNUPGHOME" \
    && apt-get update  \
    && apt-get install --no-install-recommends -y postgresql-client \
    && rm -f /etc/apt/sources.list.d/pgdg.list \
    && rm -rf /var/lib/apt/lists/*

# Add odoo user and group
RUN groupadd -g 102 odoo \
    && useradd -u 102 -g 102 -m -d /var/lib/odoo -s /bin/bash odoo

# Install rtlcss (on Debian buster)
RUN npm install -g --ignore-scripts rtlcss@4.3.0

# Install Odoo
ENV ODOO_VERSION=19.0
ARG ODOO_RELEASE=latest
ARG ODOO_SHA=c30bb80fc9ea2a9b7bc2c719dbaf5efa311cb66b72d11fa94cf29071c67fd444
RUN curl --proto "=https" -o odoo.deb -sSL "https://nightly.odoo.com/${ODOO_VERSION}/nightly/deb/odoo_${ODOO_VERSION}.${ODOO_RELEASE}_all.deb" \
    && echo "${ODOO_SHA} odoo.deb" | sha256sum -c - \
    && apt-get update \
    && apt-get -y install --no-install-recommends ./odoo.deb \
    && rm -rf /var/lib/apt/lists/* odoo.deb

COPY ./requirements-custom.txt /tmp/requirements-custom.txt
# COPY ./requirements.txt /tmp/requirements.txt

# Install the dependencies from the requirements file
RUN pip install --no-cache-dir --only-binary=:all: --break-system-packages --ignore-installed typing-extensions -r /tmp/requirements-custom.txt \
    && rm -rf /tmp/requirements-custom.txt
    
# Copy entrypoint script and Odoo configuration file
COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh
COPY ./odoo.conf.tpl /etc/odoo/

# Set permissions and Mount /var/lib/odoo to allow restoring filestore and /mnt/extra-addons for users addons
RUN chown -R odoo /etc/odoo \
    && mkdir -p /mnt/extra-addons /var/lib/odoo \
    && chown -R odoo /mnt/extra-addons /var/lib/odoo
VOLUME ["/var/lib/odoo", "/mnt/extra-addons"]

# Expose Odoo services
EXPOSE 8069 8071 8072

# Set the default config file
ENV ODOO_RC=/etc/odoo/odoo.conf

COPY wait-for-psql.py /usr/local/bin/wait-for-psql.py
RUN chmod +x /usr/local/bin/wait-for-psql.py

# Set default user when running the container
USER odoo

ENTRYPOINT ["/entrypoint.sh"]
CMD ["odoo"]
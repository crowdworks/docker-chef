FROM ruby:2.3.3-slim

ENV GEMFILE_DIR /var/opt/gemfile
ENV APP_DIR /var/opt/app

RUN set -x && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
      build-essential \
      locales task-japanese \
      git \
      ssh \
      curl && \
    rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

# localeの設定
RUN echo 'ja_JP.UTF-8 UTF-8' >> /etc/locale.gen && \
    locale-gen && \
    update-locale LANG=ja_JP.UTF-8

ENV LC_ALL ja_JP.UTF-8
ENV LC_CTYPE ja_JP.UTF-8
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP.UTF-8

RUN useradd -m -s /bin/bash chef && \
    mkdir -p ${APP_DIR} && \
    mkdir -p ${GEMFILE_DIR} && \
    chown chef:chef ${GEMFILE_DIR} $BUNDLE_APP_CONFIG ${APP_DIR}

ADD Gemfile ${GEMFILE_DIR}/
ADD Gemfile.lock ${GEMFILE_DIR}/

WORKDIR ${GEMFILE_DIR}
USER chef

RUN set -x && \
    bundle install

COPY entrypoint.sh /var/opt/gemfile/

WORKDIR ${APP_DIR}

ENTRYPOINT ["/var/opt/gemfile/entrypoint.sh"]
CMD ["/bin/bash"]

FROM centos:7.9.2009

ENV KERL_REPO=https://github.com/kerl/kerl.git \
    KERL_TAG=2.5.1  \
    OTP_VERSION=23.3.4.16 \
    ELIXIR_REPO=https://github.com/elixir-lang/elixir.git \
    ELIXIR_TAG=v1.13.4

ADD besociety/local_build /tmp/ejabberd/

WORKDIR /tmp/

## Update system and install libraries.
RUN yum update -y \
&& yum install -y epel-release \
&& yum install -y https://packages.endpointdev.com/rhel/7/os/x86_64/endpoint-repo.x86_64.rpm \
&& yum -y install git curl wget openssl dnf libyaml-devel glibc-devel pam-devel rsync sudo \
&& yum -y install openssl-devel python3 unixODBC-devel ncurses-devel gcc gcc-c++ zlib-devel libxslt fop  \
&& yum -y install expat-devel make automake autoconf \
&& yum -y reinstall glibc-common \
&& localedef -i en_US -f UTF-8 en_US.UTF-8 \
&& localedef -c -i en_US -f UTF-8 en_US.UTF-8 \
&& localedef -c -f UTF-8 -i en_US en_US.UTF-8 \
&& export LC_ALL=en_US.UTF-8 \
&& git clone --branch ${KERL_TAG} ${KERL_REPO} \
&& cd kerl \
&& chmod a+x kerl \
&& mv kerl /usr/bin \
&& kerl update releases \
&& kerl build ${OTP_VERSION} ${OTP_VERSION} \
&& kerl install ${OTP_VERSION} /opt/erlang/${OTP_VERSION} \
&& echo ". /opt/erlang/${OTP_VERSION}/activate" >> /etc/bashrc \
&& export PATH=/opt/erlang/${OTP_VERSION}/bin:${PATH} \
&& git clone --branch ${ELIXIR_TAG} ${ELIXIR_REPO} \
&& cd elixir \
&& make clean compile \
&& cp -dfr /tmp/kerl/elixir /opt/ \
&& echo "export PATH=/opt/elixir/bin:${PATH}" > /etc/profile \
&& export PATH=/opt/elixir/bin:${PATH} \
&& groupadd ejabberd \
&& useradd ejabberd -g ejabberd -G ejabberd,root \
&& cd /tmp/ejabberd \
&& ./autogen.sh \
&& ./configure --with-rebar=rebar3 -enable-new-sql-schema --enable-debug --enable-pgsql --enable-redis --enable-tools --enable-user=ejabberd --enable-group=ejabberd \
&& make clean \
&& make rel \
&& mkdir -p /usr/lib/ejabberd/ \
&& rsync -achrvz --delete /tmp/ejabberd/_build/prod/rel/ejabberd/ /usr/lib/ejabberd/ \
&& chown -R ejabberd:ejabberd /usr/lib/ejabberd/ \
&& yes | cp conf/ejabberd.yml /usr/lib/ejabberd/conf/ \
&& rm -dfr /tmp/kerl \
&& rm -dfr /tmp/ejabberd

VOLUME ["/usr/lib/ejabberd/conf/","/usr/lib/ejabberd/lib/","/usr/lib/ejabberd/log/"]

WORKDIR /usr/lib/ejabberd/

EXPOSE 5222 5223 5280 5443

CMD ["/usr/lib/ejabberd/bin/ejabberdctl", "foreground"]
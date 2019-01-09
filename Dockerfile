FROM amazonlinux:2.0.20181114

ARG version
ARG target_version
ARG target_version_minor

RUN yum -y update
RUN yum -y install \
  fuse-devel \
  gmp-devel \
  libcurl-devel \
  m4 \
  make \
  ocaml \
  ocaml-camlp4-devel \
  ocamldoc \
  openssl-devel \
  rpm-build \
  sqlite-devel \
  which \
  zlib-devel
RUN curl -L https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh | sh

RUN mkdir /app
WORKDIR /app

RUN curl -LO https://github.com/astrada/google-drive-ocamlfuse/archive/v$target_version.tar.gz
RUN tar xzf v$target_version.tar.gz

WORKDIR /app/google-drive-ocamlfuse-$target_version
RUN opam init --disable-sandboxing
RUN opam update
RUN opam config set-global os-distribution centos
RUN opam install -y depext
RUN opam depext -v -d google-drive-ocamlfuse
RUN opam install -y google-drive-ocamlfuse --destdir /dest/usr

RUN mkdir -p /root/rpmbuild/{SOURCES,SPECS}
WORKDIR /root/rpmbuild
ADD rpm.spec SPECS
RUN sed -i "s,{{VERSION}},$version," SPECS/rpm.spec >/dev/null
RUN sed -i "s,{{SOURCE0}},https://github.com/astrada/google-drive-ocamlfuse/archive/v$target_version.tar.gz," SPECS/rpm.spec >/dev/null
RUN find /dest -type f | sed 's,^/dest,,' >> SPECS/rpm.spec
RUN find /dest -type l | sed 's,^/dest,,' >> SPECS/rpm.spec
RUN rpmbuild -bb SPECS/rpm.spec
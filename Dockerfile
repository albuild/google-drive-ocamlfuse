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

# RUN yum -y install \
#   gcc \
#   gcc-c++ \
#   m4 \
#   make \
#   ncurses-devel \
#   ocaml \
#   ocaml-camlp4-devel \
#   ocamldoc \
#   opam \
#   rpm-build
# RUN amazon-linux-extras install -y epel
# RUN yum -y install \
#   gettext-devel \
#   gtk3-devel \
#   meson \
#   python3 \
#   rpm-build \
#   vala
# RUN curl -O http://dl.fedoraproject.org/pub/fedora/linux/releases/29/Everything/x86_64/os/Packages/g/granite-5.1.0-1.fc29.x86_64.rpm
# RUN yum -y install granite-5.1.0-1.fc29.x86_64.rpm
# RUN curl -O http://dl.fedoraproject.org/pub/fedora/linux/releases/29/Everything/x86_64/os/Packages/g/granite-devel-5.1.0-1.fc29.x86_64.rpm
# RUN yum -y install granite-devel-5.1.0-1.fc29.x86_64.rpm

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

# RUN mkdir -p /dest/opt/albuild-google-drive-ocamlfuse/$version
# WORKDIR /dest/opt/albuild-google-drive-ocamlfuse/$version
# RUN mkdir bin
# RUN mkdir lib
# RUN mv /dest/usr/bin/com.github.donadigo.google-drive-ocamlfuse bin
# RUN cp /usr/lib64/libgranite.so.5 lib
# RUN cp /usr/lib64/libgee-0.8.so.2 lib
# ADD com.github.donadigo.google-drive-ocamlfuse /dest/usr/bin
# RUN sed -i "s,{{VERSION}},$version," /dest/usr/bin/com.github.donadigo.google-drive-ocamlfuse >/dev/null
# RUN sed -i "s,Exec=com\.github\.donadigo\.google-drive-ocamlfuse,Exec=env XDG_MENU_PREFIX=mate- com.github.donadigo.google-drive-ocamlfuse," /dest/usr/share/applications/com.github.donadigo.google-drive-ocamlfuse.desktop >/dev/null

RUN mkdir -p /root/rpmbuild/{SOURCES,SPECS}
WORKDIR /root/rpmbuild
ADD rpm.spec SPECS
RUN sed -i "s,{{VERSION}},$version," SPECS/rpm.spec >/dev/null
RUN sed -i "s,{{SOURCE0}},https://github.com/astrada/google-drive-ocamlfuse/archive/v$target_version.tar.gz," SPECS/rpm.spec >/dev/null
RUN find /dest -type f | sed 's,^/dest,,' >> SPECS/rpm.spec
RUN find /dest -type l | sed 's,^/dest,,' >> SPECS/rpm.spec
RUN rpmbuild -bb SPECS/rpm.spec
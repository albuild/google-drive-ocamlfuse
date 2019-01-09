Summary: Yet another unofficial google-drive-ocamlfuse package for Amazon Linux 2
Name: albuild-google-drive-ocamlfuse
Version: {{VERSION}}
Release: 1%{?dist}
Group: Applications/File
License: BSD-3-Clause
Source0: {{SOURCE0}}
URL: https://github.com/albuild/google-drive-ocamlfuse
BuildArch: x86_64
AutoReqProv: no

%description
Yet another unofficial google-drive-ocamlfuse package for Amazon Linux 2.

%install
cp -r /dest/* %{buildroot}/

%clean
rm -rf %{buildroot}

%files

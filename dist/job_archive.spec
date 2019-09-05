Name: job_archive
Version: 1.0.0
Release: 1%{?dist}
Summary: Tool to archive jobs scripts from the Slrum resource manager.

Group: Applications/Archiving
License: GPLv3
URL: https://github.com/nauhpc/job_archive
Source: %{name}-%{version}.tar.gz

BuildRequires: gcc-c++
BuildRequires: coreutils
BuildRequires: make
BuildRequires: systemd

%description

%prep
%setup -q

%build
make

%install
make install BIN_DIR=%{buildroot}%{_sbindir} SYSTEMD_UNIT_DIR=%{buildroot}%{_unitdir} SYSCONF_DIR=%{buildroot}%{_sysconfdir}/sysconfig INIT_TYPE=systemd

%post
/bin/systemctl daemon-reload > /dev/null 2>&1 || :
/bin/systemctl enable jobarchive.service > /dev/null 2>&1 || :

%preun
if [ $1 == 0 ]; then
	/bin/systemctl stop jobarchive.service > /dev/null 2>&1 || :
	/bin/systemctl disable jobarchive.service > /dev/null 2>&1 || :
fi

%postun
/bin/systemctl daemon-reload > /dev/null 2>&1 || :

%files
%{_sbindir}/job_archive
%{_unitdir}/jobarchive.service
%config %{_sysconfdir}/sysconfig/jobarchive.conf

%changelog


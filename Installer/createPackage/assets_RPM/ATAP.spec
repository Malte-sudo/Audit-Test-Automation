Name: AuditTAP
Version: <version>
Release: 1%{?dist}
Summary: creates compliance reports compared to international security standards and hardening guidelines
BuildArch: noarch

License: BSD 3-Clause License
Source0: %{name}-%{version}.tar.gz

Requires: powershell >= 5.1

%description
FBPro Audit Test Automation Package allows you to create compliance reports for your systems. The resulting HTML-reports provide a transparent overview of your devices' security configuration compared to international security standards and hardening guides.

%prep
%setup -q   # tarball extraction

%install
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT/opt/microsoft/powershell/7/Modules
cp -r -t $RPM_BUILD_ROOT/opt/microsoft/powershell/7/Modules ATAPAuditor
cp -r -t $RPM_BUILD_ROOT/opt/microsoft/powershell/7/Modules ATAPHtmlReport

%clean
rm -rf $RPM_BUILD_ROOT

%files
/opt/microsoft/powershell/7/Modules/ATAPAuditor/
/opt/microsoft/powershell/7/Modules/ATAPHtmlReport/

%changelog
* <date> FBPro GmbH <team@fb-pro.com> - <version>
- <message>
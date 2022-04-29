# 
# spec file for paint, paint
# 

Name:       harbour-paint

%{!?qtc_qmake:%define qtc_qmake %qmake}
%{!?qtc_qmake5:%define qtc_qmake5 %qmake5}
%{!?qtc_make:%define qtc_make make}
%{?qtc_builddir:%define _builddir %qtc_builddir}
Summary:    Paint
Version:    0.8.2
Release:    1
Group:      Qt/Qt
License:    MIT
URL:        https://github.com/kimmoli/paint
Source0:    %{name}-%{version}.tar.bz2
Requires:   sailfishsilica-qt5 >= 0.10.9
Requires:   qt5-qtdeclarative-import-sensors
BuildRequires:  pkgconfig(sailfishapp) >= 1.0.2
BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  pkgconfig(Qt5Quick)
BuildRequires:  qt5-qttools-linguist
BuildRequires:  desktop-file-utils

%description
Really simple native drawing application

%if "%{?vendor}" == "chum"
PackageName: Paint
Type: desktop-application
Categories:
 - Graphics
DeveloperName: Kimmo Lindholm
Custom:
 - Repo: https://github.com/kimmoli/paint
Icon: https://raw.githubusercontent.com/kimmoli/paint/master/appicons/256x256/apps/harbour-paint.png
Screenshots:
Url:
  Donation:
%endif

%prep
%setup -q -n %{name}-%{version}

%build

%qtc_qmake5 SPECVERSION=%{version}

%qtc_make %{?_smp_mflags}

%install
rm -rf %{buildroot}

%qmake5_install

desktop-file-install --delete-original       \
  --dir %{buildroot}%{_datadir}/applications             \
   %{buildroot}%{_datadir}/applications/*.desktop

%files
%defattr(-,root,root,-)
%{_bindir}
%{_datadir}/%{name}
%{_datadir}/applications/%{name}.desktop
%{_datadir}/%{name}/qml
%{_datadir}/icons/hicolor/

# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils need-gcc-version

RESTRICT="nomirror"
DESCRIPTION="C++ class library of common digital signal processing functions."
HOMEPAGE="http://libdsp.sf.net"
SRC_URI="mirror://sourceforge/${PN}/${PN}-src-${PV}.tar.gz
		doc? ( mirror://sourceforge/${PN}/${PN}-doc-html.tar.gz )"

LICENSE="GPL-2"
SLOT="0"

# -amd64, -sparc: 4.9.2-r1 - uses x86 assembly
KEYWORDS="x86 -amd64 -sparc"
IUSE="doc"
DEPEND=""

S=${WORKDIR}/${PN}-src-${PV}

src_unpack() {
	need_gcc "3.4"

	unpack ${A}
	cd ${S}
	# fixes some Makefile weirdness
	epatch ${FILESDIR}/Makefile.patch

	# use our CFLAGS/CXXFLAGS instead
	sed -e "s:^CFLAGS.*:CFLAGS = ${CFLAGS}:" -i libDSP/Makefile
	sed -e "s:^CXXFLAGS.*:CXXFLAGS = ${CXXFLAGS}:" -i DynThreads/Makefile

	# use our PREFIX too
	sed -e "s:^PREFIX.*:PREFIX = ${D}/usr:" -i Inlines/Makefile
	sed -e "s:^PREFIX.*:PREFIX = ${D}/usr:" -i libDSP/Makefile
	sed -e "s:^PREFIX.*:PREFIX = ${D}/usr:" -i DynThreads/Makefile

	# libtool only supports the --tag option from v1.5 onwards
	if ! has_version ">=sys-devel/libtool-1.5.0"; then
		sed -e "s/^LIBTOOL = libtool --tag=CXX/LIBTOOL = libtool/" -i libDSP/Makefile
	fi
}

src_compile() {
	cd ${S}/DynThreads
	emake || die "DynThreads make failed!"

	cd ${S}/libDSP
	emake || die "libDSP make failed!"
}

src_install() {

	mkdir -p ${D}/usr/include
	cd ${S}/Inlines
	make install || die "Inlines install failed!"

	cd ${S}/DynThreads
	make install || die "DynThreads install failed!"

	cd ${S}/libDSP
	make install || die "libDSP install failed!"

	if use doc; then
		dohtml ${WORKDIR}/${PN}-doc-html/*
		docinto samples
		dodoc ${S}/libDSP/work/*
	fi
}

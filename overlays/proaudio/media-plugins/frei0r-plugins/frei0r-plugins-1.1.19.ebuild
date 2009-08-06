# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

RESTRICT="mirror"
DESCRIPTION=""
HOMEPAGE=""
SRC_URI="http://frei0r.kexbox.org/download/source/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="dev-util/scons"
RDEPEND=""

src_unpack(){
	unpack "${A}"
	# use our CFLAGS/CXXCLFAGS
	cat << EOF >> "${S}/plugins/SConstruct"
import os
env.Append(CFLAGS = os.environ['CFLAGS'])
env.Append(CXXFLAGS = os.environ['CXXFLAGS'])
print env.Dump('CCFLAGS')
EOF

}
src_compile(){
	inst_path="/usr/lib/frei0r-1/"
	dodir "${inst_path}"
	cd plugins
	scons CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" instdir="${D}${inst_path}" || die "scons failed"
}

src_install(){
	cd plugins
	dodir "${inst_path}"
	scons instdir="${D}${inst_path}" install || die "scons failed"
}

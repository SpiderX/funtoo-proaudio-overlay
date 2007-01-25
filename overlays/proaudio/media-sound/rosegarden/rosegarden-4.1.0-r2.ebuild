# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/rosegarden/rosegarden-4.1.0-r1.ebuild,v 1.6 2005/07/13 13:52:06 swegener Exp $

inherit kde eutils flag-o-matic

IUSE="arts jack dssi"

MY_PV="${PV/_rc*/}"
MY_PV="${MY_PV/./-}"
MY_P="${PN}-${MY_PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="MIDI and audio sequencer and notation editor."
HOMEPAGE="http://www.rosegardenmusic.com/"
SRC_URI="mirror://sourceforge/rosegarden/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"

DEPEND="arts? ( || ( kde-base/kdemultimedia-arts kde-base/kdemultimedia ) )
	!arts? ( media-libs/alsa-lib
		jack? ( media-sound/jack-audio-connection-kit )
		>=media-libs/ladspa-sdk-1.0
		>=media-libs/ladspa-cmt-1.14 )
		dssi? ( >=media-libs/dssi-0.9 )
		!media-sound/rosegarden-cvs"
need-kde 3

pkg_setup() {
	echo
	if use arts ; then
		einfo "aRts support enabled"
		ewarn "ALSA support disabled, USE=-arts enables ALSA"
		built_with_use kde-base/arts jack && einfo "aRts was built with Jack support" \
					|| ewarn "aRts wasn't built with Jack support"
	else
		einfo "ALSA support enabled"
		use jack && einfo "Jack support enabled" || ewarn "Jack support disabled"
	fi
	echo
}

src_unpack() {
	kde_src_unpack
	epatch ${FILESDIR}/${PV}-dssi.patch
	epatch ${FILESDIR}/rosegarden-colour.patch
}

src_compile() {
	strip-flags -fvisibility-inlines-hidden
	use arts && myconf="`use_with dssi`" || myconf="$(use_with jack) --with-ladspa `use_with dssi`"
	kde_src_compile
}

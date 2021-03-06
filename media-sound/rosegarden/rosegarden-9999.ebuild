# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

AUTOTOOLS_AUTORECONF="1"
AUTOTOOLS_IN_SOURCE_BUILD="1"
inherit autotools-utils exteutils subversion

DESCRIPTION="MIDI and audio sequencer and notation editor."
HOMEPAGE="http://www.rosegardenmusic.com/"
SRC_URI=""

ESVN_REPO_URI="http://svn.code.sf.net/p/${PN}/code/trunk/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug dssi export gnome kde lilypond lirc"

RDEPEND="dev-qt/qtcore
	dev-qt/qtgui
	>=media-libs/alsa-lib-1.0
	>=media-libs/ladspa-cmt-1.14
	>=media-libs/ladspa-sdk-1.1
	>=media-libs/liblo-0.23[threads(+)]
	media-libs/liblrdf
	>=media-libs/libsamplerate-0.1.4
	>=media-sound/jack-audio-connection-kit-0.109
	sci-libs/fftw:3.0
	x11-misc/makedepend
	x11-libs/libXtst
	|| ( x11-libs/libX11 virtual/x11 )
	dssi? ( >=media-libs/dssi-0.9 )
	export? (
		|| ( kde-base/kdialog kde-base/kdebase )
		dev-perl/XML-Twig
		>=media-libs/libsndfile-1.0.16 )
	lilypond? (
		>=media-sound/lilypond-2.6.0
		|| (
			kde? ( kde-base/okular )
			gnome? ( app-text/evince )
			app-text/acroread ) )
	lirc? ( >=app-misc/lirc-0.8 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}/${PN}-12.12.25-debug.patch" )

pkg_setup(){
	if ! use export && \
		! ( has_all-pkg "media-libs/libsndfile dev-perl/XML-Twig" && \
		has_any-pkg "kde-base/kdialog kde-base/kdebase" ) ;then
		ewarn "you won't be able to use the rosegarden-project-package-manager"
		ewarn "please emerge with USE=\"export\""
	fi

	if ! use lilypond && ! ( has_version "media-sound/lilypond" && has_any-pkg "app-text/acroread kde-base/okular app-text/evince" ) ;then
		ewarn "lilypond preview won't work."
		ewarn "If you want this feature please remerge USE=\"lilypond\""
	fi
}

src_prepare() {
	subversion_src_prepare
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		--with-qtdir="${EPREFIX}"/usr/
		--with-qtlibdir="${EPREFIX}"/usr/$(get_libdir)/qt4
		$(use_enable debug)
	)
	autotools-utils_src_configure
}

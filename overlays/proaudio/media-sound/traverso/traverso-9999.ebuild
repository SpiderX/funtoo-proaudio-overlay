# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils qt4 cmake-utils cvs

DESCRIPTION="Professional Audio Tools for GNU/Linux"
HOMEPAGE="http://traverso-daw.org/"

ECVS_SERVER="cvs.savannah.nongnu.org:/sources/traverso"
ECVS_MODULE="traverso"

IUSE="alsa jack lv2 mad sse"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS=""

RDEPEND="$(qt4_min_version 4.2.3)
	alsa? ( media-libs/alsa-lib )
	jack? ( media-sound/jack-audio-connection-kit )
	>=media-libs/libsndfile-1.0.12
	media-libs/libsamplerate
	>=sci-libs/fftw-3
	lv2? ( dev-libs/rasqal dev-libs/redland media-libs/slv2 )
	mad? ( media-libs/libmad media-sound/lame )
	media-libs/libogg
	media-libs/libvorbis
	media-sound/wavpack"
	# Note: wavpack and vorbis are not configurable at this point

DEPEND="${RDEPEND}
	>=dev-util/cmake-2.4.3"

src_compile() {
	local mycmakeargs=""
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_want jack JACK)
		$(cmake-utils_use_want alsa ALSA)
		$(cmake-utils_use_want lv2 LV2)
		$(cmake-utils_use_want mad MP3_DECODE)
		$(cmake-utils_use_want mad MP3_ENCODE)"

	use lv2 && mycmakeargs="${mycmakeargs} -DUSE_SYSTEM_SLV2_LIBRARY=ON"
	
	CMAKE_IN_SOURCE_BUILD=1
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	dodoc AUTHORS ChangeLog README

	doicon resources/freedesktop/icons/128x128/apps/${PN}.png
	make_desktop_entry ${PN} Traverso ${PN} "AudioVideo;Audio;"
}

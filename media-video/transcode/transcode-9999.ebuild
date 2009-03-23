# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/transcode/transcode-1.0.2-r1.ebuild,v 1.6 2006/01/10 11:18:29 flameeyes Exp $

inherit flag-o-matic multilib autotools mercurial

DESCRIPTION="video stream processing tool"
HOMEPAGE="http://www.transcoding.org"
EHG_REPO_URI="http://hg.berlios.de/repos/tcforge"
S="${WORKDIR}/${EHG_REPO_URI##*/}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="
X 3dnow a52 aac dv dvdread mp3 truetype imagemagick jpeg lzo mjpeg mmx
network ogg vorbis quicktime sdl sse sse2 theora v4l2 xvid xml postproc x264
alsa oss
"

RDEPEND="
	a52? ( >=media-libs/a52dec-0.7.4 )
	dv? ( >=media-libs/libdv-0.99 )
	dvdread? ( >=media-libs/libdvdread-0.9.0 )
	xvid? ( >=media-libs/xvid-1.0.2 )
	x264? ( || ( media-libs/x264 media-libs/x264-svn ) )
	mjpeg? ( >=media-video/mjpegtools-1.6.2-r3 )
	lzo? ( >=dev-libs/lzo-2 )
	imagemagick? ( >=media-gfx/imagemagick-5.5.6.0 )
	media-libs/libexif
	mp3? ( >=media-sound/lame-3.93 )
	aac? ( media-libs/faac )
	sdl? ( media-libs/libsdl )
	quicktime? ( >=media-libs/libquicktime-0.9.3 )
	vorbis? ( media-libs/libvorbis )
	ogg? ( media-libs/libogg )
	theora? ( media-libs/libtheora )
	jpeg? ( media-libs/jpeg )
	truetype? ( >=media-libs/freetype-2 )
	>=media-video/ffmpeg-0.4.9_p20050226-r3
	>=media-libs/libmpeg2-0.4.0b
	virtual/libiconv
	xml? ( dev-libs/libxml2 )
	X? ( x11-libs/libXaw x11-libs/libXv )
	alsa? ( media-libs/alsa-lib )
"
DEPEND="
	${RDEPEND}
	v4l2? ( >=virtual/os-headers-2.6.11 )
"

src_unpack() {
	mercurial_src_unpack
	cd ${S}
	epatch "${FILESDIR}"/${PN}-*.diff
	eautoreconf || die
}

src_compile() {
	append-flags -DDCT_YUV_PRECISION=1
	filter-flags -momit-leaf-frame-pointer
	econf \
		$(use_enable mmx) \
		$(use_enable 3dnow) \
		$(use_enable sse) \
		$(use_enable sse2) \
		$(use_enable truetype freetype2) \
		$(use_enable v4l2 v4l) \
		$(use_enable alsa) \
		$(use_enable oss) \
		$(use_enable xvid) \
		$(use_enable x264) \
		$(use_enable mp3 lame) \
		$(use_enable aac faac) \
		$(use_enable ogg) \
		$(use_enable vorbis) \
		$(use_enable theora) \
		$(use_enable dvdread libdvdread) \
		$(use_enable dv libdv) \
		$(use_enable quicktime libquicktime) \
		$(use_enable lzo) \
		$(use_enable a52) \
		$(use_enable xml libxml2) \
		$(use_enable mjpeg mjpegtools) \
		$(use_enable sdl) \
		$(use_enable imagemagick) \
		$(use_enable jpeg libjpeg) \
		$(use_with X x) \
		$(use_enable postproc libpostproc) \
		--with-mod-path=/usr/$(get_libdir)/transcode \
		--with-lzo-includes=/usr/include/lzo \
		--docdir=/usr/share/doc/${PF} \
		|| die

	emake all || die
}

src_install () {
	emake DESTDIR="${D}" install || die
	prepalldocs
	dodoc AUTHORS README TODO
}

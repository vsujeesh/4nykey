# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/fltk/fltk-1.1.7.ebuild,v 1.10 2006/08/09 19:49:08 jer Exp $

inherit subversion autotools flag-o-matic

DESCRIPTION="C++ user interface toolkit for X and OpenGL."
HOMEPAGE="http://www.fltk.org"
ESVN_REPO_URI="http://svn.easysw.com/public/fltk/fltk/trunk"
ESVN_PATCHES="fltk2-*.diff"
ESVN_BOOTSTRAP="eautoreconf"

KEYWORDS="~x86"
LICENSE="FLTK LGPL-2"
SLOT="2"
IUSE="noxft opengl debug cairo threads jpeg zlib png xinerama doc verbose-build"

RDEPEND="
	x11-libs/libXext
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libXt
	xinerama? ( x11-libs/libXinerama )
	!noxft? ( virtual/xft )
	zlib? ( sys-libs/zlib )
	png? ( media-libs/libpng )
	jpeg? ( media-libs/jpeg )
	opengl? ( virtual/opengl )
	cairo? ( x11-libs/cairo )
"
DEPEND="
	${DEPEND}
	x11-proto/xextproto
	xinerama? ( x11-proto/xineramaproto )
	doc? ( app-doc/doxygen )
"

src_unpack() {
	subversion_src_unpack
	use !opengl && epatch "${FILESDIR}"/nogl.diff
	use verbose-build && epatch "${FILESDIR}"/verbose-build.diff
}

src_compile() {
	append-flags -fno-strict-aliasing

	CPPFLAGS="${CPPFLAGS} -DFLTK_DOCDIR=\"/usr/share/doc/${PF}\"" \
	econf \
		--enable-shared \
		$(use_enable debug) \
		$(use_enable !noxft xft) \
		$(use_enable opengl gl) \
		$(use_enable cairo) \
		$(use_enable threads) \
		$(use_enable jpeg) \
		$(use_enable zlib) \
		$(use_enable png) \
		$(use_enable xinerama) \
		|| die "Configuration Failed"

	emake || die "Parallel Make Failed"
	use doc && make -C documentation
}

src_install() {
	einstall STRIP="/bin/true" || die "Installation Failed"
	if use doc; then
		emake -C documentation install || die
		dohtml documentation/html
	fi
	dodoc CHANGES CREDITS README* TODO
}
# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit wxwidgets subversion autotools flag-o-matic

AT_M4DIR="m4"
DESCRIPTION="A crossplatform BitTorrent client"
HOMEPAGE="http://sourceforge.net/projects/bitswash"
ESVN_REPO_URI="https://bitswash.svn.sourceforge.net/svnroot/bitswash/trunk"
ESVN_PATCHES="${PN}-*.diff"
ESVN_BOOTSTRAP="eautoreconf"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="libtorrent"

RDEPEND="
	>=x11-libs/wxGTK-2.8
	dev-libs/boost
	dev-libs/openssl
	libtorrent? ( >=net-libs/rb_libtorrent-0.13 )
"
DEPEND="
	${RDEPEND}
	dev-util/pkgconfig
"

src_compile() {
	local _rb=shipped
	if use libtorrent; then
		append-cppflags $(pkg-config --silence-errors libtorrent --cflags)
		_rb=system
	fi

	WX_GTK_VER=2.8
	need-wxwidgets unicode

	econf \
		--with-wx-config=${WX_CONFIG} \
		--with-libtorrent=${_rb} \
		|| die

	emake || die
}

src_install() {
	einstall || die
	dodoc AUTHORS
}

# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit gnome2

DESCRIPTION="Subtitle Editor is a GTK+2 tool to edit subtitles for GNU/Linux"
HOMEPAGE="http://home.gna.org/subtitleeditor"
SRC_URI="http://download.gna.org/${PN}/${PV%.*}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="debug nls opengl"

RDEPEND="
	>=dev-cpp/gtkmm-2.14
	>=app-text/enchant-1.4
	dev-cpp/gstreamermm
	media-libs/gst-plugins-good
	media-plugins/gst-plugins-pango
	app-text/iso-codes
	opengl? ( dev-cpp/gtkglextmm )
"
DEPEND="
	${RDEPEND}
"

DOCS="AUTHORS ChangeLog NEWS README TODO"
G2CONF="
	$(use_enable debug)
	$(use_enable nls)
	$(use_enable opengl gl)
"

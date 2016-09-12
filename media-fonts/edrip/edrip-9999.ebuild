# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit python-any-r1
if [[ ${PV} == *9999* ]]; then
	SRC_URI="mirror://gcarchive/${PN}/source-archive.zip -> ${P}.zip"
	S="${WORKDIR}/${PN}/trunk"
	DEPEND="
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			media-gfx/fontforge[python,${PYTHON_USEDEP}]
			media-gfx/xgridfit[${PYTHON_USEDEP}]
		')
	"
	REQUIRED_USE="!binary"
else
	SRC_URI="
	binary? (
		ftp://ftp.dvo.ru/pub/Font/${PN}/${PN}-ttf-r${PV}.tar.xz
		mirror://gcarchive/${PN}/${PN}-ttf-r${PV}.tar.xz
	)
	!binary? (
		ftp://ftp.dvo.ru/pub/Font/${PN}/${PN}-src-r${PV}.tar.xz
	)
	"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}"
fi
inherit font

DESCRIPTION="A contrast sans-serif font based on the Teams font"
HOMEPAGE="http://code.google.com/p/edrip"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="+binary"

FONT_SUFFIX="ttf"
DOCS=( FontLog.txt README )
RESTRICT="primaryuri"

pkg_setup() {
	use binary || python-any-r1_pkg_setup
	font_pkg_setup
}

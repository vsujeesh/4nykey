# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

MY_PN="xdxf_${PN}"
PYTHON_COMPAT=( python2_7 )
inherit python-single-r1 cmake-utils
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/soshial/${MY_PN}.git"
else
	inherit vcs-snapshot
	MY_PV="c31bb9f"
	SRC_URI="
		mirror://githubcl/soshial/${MY_PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi


DESCRIPTION="A converter between many dictionary formats"
HOMEPAGE="http://xdxf.sf.net"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
PATCHES=( "${FILESDIR}"/${PN}-gcc43.diff )
DOCS=( AUTHORS CHANGELOG README.md TODO )

DEPEND="
	sys-libs/zlib
	>=dev-libs/glib-2.6.0
	dev-libs/expat
"
RDEPEND="
	${DEPEND}
	${PYTHON_DEPS}
"

src_install() {
	cmake-utils_src_install
	python_optimize "${D}"usr/lib/makedict-codecs
}

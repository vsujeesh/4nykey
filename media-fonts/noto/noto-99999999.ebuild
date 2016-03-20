# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

CHECKREQS_DISK_BUILD="30"
use cjk && CHECKREQS_DISK_BUILD="$((CHECKREQS_DISK_BUILD+930))"
use emoji && CHECKREQS_DISK_BUILD="$((CHECKREQS_DISK_BUILD+60))"
use fontmake && CHECKREQS_DISK_BUILD="$((CHECKREQS_DISK_BUILD+960))"
CHECKREQS_DISK_BUILD="${CHECKREQS_DISK_BUILD}M"
MY_PV="bdf7562"
MY_CJK="${PN}-cjk-1.004"
MY_EMJ="${PN}-emoji-91ef95d"
MY_SRC="${PN}-source-2f579b0"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlei18n/noto-fonts"
else
	inherit vcs-snapshot
	SRC_URI="
		mirror://githubcl/googlei18n/${PN}-fonts/tar.gz/${MY_PV}
		-> ${P}.tar.gz
		cjk? (
		mirror://githubcl/googlei18n/${MY_CJK%-*}/tar.gz/v${MY_CJK##*-}
		-> ${MY_CJK}.tar.gz
		)
		emoji? (
		mirror://githubcl/googlei18n/${MY_EMJ%-*}/tar.gz/${MY_EMJ##*-}
		-> ${MY_EMJ}.tar.gz
		)
		fontmake? (
		mirror://githubcl/googlei18n/${MY_SRC%-*}/tar.gz/${MY_SRC##*-}
		-> ${MY_SRC}.tar.gz
		)
	"
	RESTRICT="primaryuri"
	#KEYWORDS="~amd64 ~x86"
fi
inherit check-reqs multiprocessing font

DESCRIPTION="A font family that aims to support all the world's languages"
HOMEPAGE="http://www.google.com/get/noto"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="cjk emoji fontmake zopfli"

DEPEND="
	emoji? ( 
		dev-python/nototools
		media-gfx/pngquant
		media-gfx/imagemagick
		zopfli? ( app-arch/zopfli )
		!zopfli? ( media-gfx/optipng )
		x11-libs/cairo
	)
	fontmake? ( dev-python/fontmake )
"
RDEPEND="!media-fonts/notofonts"

FONT_SUFFIX="ttf"
DOCS="*.md"
if use cjk || use fontmake; then
	FONT_SUFFIX="${FONT_SUFFIX} otf"
fi

src_unpack() {
	if [[ -z ${PV%%*9999} ]]; then
		git-r3_src_unpack
		use cjk && \
		EGIT_CHECKOUT_DIR="${MY_CJK}" \
		EGIT_REPO_URI="https://github.com/googlei18n/${MY_CJK%-*}.git" \
			git-r3_src_unpack
		use emoji && \
		EGIT_CHECKOUT_DIR="${MY_EMJ}" \
		EGIT_REPO_URI="https://github.com/googlei18n/${MY_EMJ%-*}.git" \
			git-r3_src_unpack
		use fontmake && \
		EGIT_CHECKOUT_DIR="${MY_SRC}" \
		EGIT_REPO_URI="https://github.com/googlei18n/${MY_SRC%-*}.git" \
			git-r3_src_unpack
	else
		vcs-snapshot_src_unpack
	fi
}

src_prepare() {
	mv unhinted/Noto*.ttf "${S}"/
	mv hinted/Noto*.ttf "${S}"/
	use cjk && mv "${WORKDIR}"/${MY_CJK}/NotoSans[JKST]*.otf "${S}"/
	use emoji && mv "${WORKDIR}"/${MY_EMJ}/fonts/Noto*.ttf "${S}"/
}

src_compile() {
	if use fontmake; then
		cd "${WORKDIR}"/${MY_SRC}
		multijob_init
		local g
		for g in src/*.glyphs src/*/*.plist; do
			multijob_child_init source ./build.sh build_one "${g}" || die
		done
		multijob_finish
		mv master_[ot]tf/*.[ot]tf "${S}"/
	fi
	if use emoji; then
		addpredict /dev/dri
		cd "${WORKDIR}"/${MY_EMJ}
		emake PNGQUANT=/usr/bin/pngquant $(usex zopfli '' 'MISSING_ZOPFLI=1')
		mv NotoColorEmoji.ttf "${S}"/
	fi
}
# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# Original source: https://github.com/pixlra/pixlra-gentoo-overlay

EAPI=7

inherit eutils cmake-utils qmake-utils xdg

DESCRIPTION="A QT5-based editor for the TikZ language"
HOMEPAGE="http://www.hackenberger.at/blog/ktikz-editor-for-the-tikz-language"
SRC_URI="https://github.com/fhackenberger/${PN}/archive/${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="5"
KEYWORDS="~amd64"
IUSE="kde +doc -debug"

DEPEND="
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		dev-qt/qtprintsupport:5
		app-text/poppler[qt5]
		doc? ( dev-qt/qthelp:5 )
		kde? (
			kde-frameworks/kxmlgui
			kde-frameworks/ktexteditor
			kde-frameworks/kparts
			kde-frameworks/kiconthemes
		)
		virtual/latex-base
		dev-texlive/texlive-latexextra
		dev-tex/pgf
"
RDEPEND="${DEPEND}
	!media-gfx/ktikz:4
"
BDEPEND=""

src_prepare() {
		# correct the qcollectiongenerator binary
		sed -ie 's%#QCOLLECTIONGENERATORCOMMAND = qcollectiongenerator%QCOLLECTIONGENERATORCOMMAND = /usr/lib64/qt5/bin/qcollectiongenerator%g' qmake/qtikzconfig.pri || die
		eapply_user
}

src_configure() {
		if use kde; then
			cmake-utils_src_configure
		else
			KDECONFIG="CONFIG-=usekde"
			eqmake5 qtikz.pro "CONFIG+=nostrip" "$KDECONFIG"
		fi
}

src_compile() {
		if use !doc; then
			comment_add_subdirectory doc
		fi
		if use kde; then
			cmake-utils_src_compile
		else
			emake
		fi
}

src_install() {
		if use kde; then
			cmake-utils_src_install
		else
			emake INSTALL_ROOT="${D}" install
		fi
}

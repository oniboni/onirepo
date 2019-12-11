# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop

DESCRIPTION="The hackable text editor"
HOMEPAGE="https://atom.io"
SRC_URI="https://go.microsoft.com/fwlink/?LinkID=620884 -> ${PN}_x86_64-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="binary"

QA_PREBUILT="*"

DEPEND=""
RDEPEND="
	${DEPEND}
	dev-vcs/git
	"
BDEPEND=""

EXTRACT_FOLDER_NAME="VSCode-linux-x64"

S="${WORKDIR}/${EXTRACT_FOLDER_NAME}/"
INSTALL_DIR="/opt/"

src_unpack() {
	unpack ${A}
}

src_install() {
	# mv package contents to install target
	dodir ${INSTALL_DIR}

	mv "${S}" "${ED}${INSTALL_DIR}" || die

	# create link
	dodir /usr/bin/
	dosym "${INSTALL_DIR}/${PN}/bin/code" /usr/bin/${PN}

	# create desktop enty
	doicon "${INSTALL_DIR}resources/app/resources/linux/code.png"
	make_desktop_entry ${PN} "VSCode" "code"
}


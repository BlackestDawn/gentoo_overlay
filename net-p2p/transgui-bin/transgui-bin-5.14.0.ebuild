# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit xdg-utils

DESCRIPTION="Transmission Remote GUI is feature rich cross platform front-end to remotely control Transmission daemon via its RPC protocol. It is faster and has more functionality than builtin Transmission web interface."
HOMEPAGE="https://github.com/transmission-remote-gui/transgui"
SRC_URI="amd64? ( https://github.com/transmission-remote-gui/transgui/releases/download/v${PV}/transgui-${PV}-x86_64-Linux.txz )
		x86? ( https://github.com/transmission-remote-gui/transgui/releases/download/v${PV}/transgui-${PV}-i686-Linux.txz )"

RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"

DOC="LICENSE README.md history.txt"

src_install() {
dobin transgui

#insinto /usr/share/icons/hicolor/48x48/apps
doicon  doicon -s 48 icons/hicolor/48x48/transgui.png

domenu "${FILESDIR}/trangui.desktop"
}

# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Transmission Remote GUI is feature rich cross platform front-end to remotely control Transmission daemon via its RPC protocol. It is faster and has more functionality than builtin Transmission web interface."
HOMEPAGE="https://github.com/transmission-remote-gui/transgui"
SRC_URI="https://github.com/transmission-remote-gui/transgui/archive/v${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
		>=dev-lang/lazarus-1.6.0
		>=dev-lang/fpc-2.6.2"
RDEPEND="${DEPEND}"

src_prepare() {
	lazbuild -T --lazarusdir=/usr/share/lazarus transgui.lpr
	true;
}


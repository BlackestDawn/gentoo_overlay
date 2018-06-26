# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils user systemd

SRC_URI="https://github.com/Jackett/Jackett/releases/download/v${PV}/Jackett.Binaries.Mono.tar.gz -> ${P}.tar.gz"

DESCRIPTION="Jackett works as a proxy for torrent indexers and provides search capability for them by implementing the Torznab and TorrentPotato APIs."
HOMEPAGE="http://www.radarr.video"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RDEPEND="
	>=dev-lang/mono-4.6.0
	media-video/mediainfo 
	dev-db/sqlite"
MY_PN="Jackett"
S=${WORKDIR}/${PN}

src_unpack() {
    unpack ${A}
    mv ${MY_PN} ${PN}
}

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/jackett ${PN}
}

src_install() {
	newconfd "${FILESDIR}/${PN}.conf" ${PN}
	newinitd "${FILESDIR}/${PN}.init" ${PN}

	keepdir /var/lib/${PN}
	fowners -R ${PN}:${PN} /var/lib/${PN}

	insinto /etc/${PN}
	insopts -m0660 -o ${PN} -g ${PN}

	insinto /etc/logrotate.d
	insopts -m0644 -o root -g root
	newins "${FILESDIR}/${PN}.logrotate" ${PN}
	
	insinto "/usr/share/"
	doins -r "${S}"

	systemd_dounit "${FILESDIR}/jackett.service"
	systemd_newunit "${FILESDIR}/jackett.service" "${PN}@.service"
}

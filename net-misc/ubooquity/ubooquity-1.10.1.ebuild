# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit java-utils-2 user

DESCRIPTION="Java-based server tools to make book and comoc collections available to other devices."
HOMEPAGE="http://vaemendis.net/ubooquity/"

MY_PN="Ubooquity"
SRC_URI="http://vaemendis.net/ubooquity/downloads/${MY_PN}-${PV}.zip"
#https://downloads.sourceforge.net/project/${PN}/${PN}/${MY_PN}_${PV}/${MY_PN}_${PV}-portable.tar.xz"

_USERNAME="ubooquity"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror bindist strip"
IUSE=""

DEPEND=""
RDEPEND="|| ( dev-java/oracle-jdk-bin:1.8[javafx] dev-java/oracle-jre-bin:1.8[javafx] )"

S="${WORKDIR}"

pkg_setup() {
    enewgroup ${_USERNAME}
    enewuser ${_USERNAME} -1 /bin/bash /var/lib/${PN} "${_USERNAME}"
}

src_install() {
	java-pkg_dojar "${MY_PN}.jar"
	exeopts -m755
	exeinto "/usr/bin"
	newexe "${FILESDIR}/${PN}.sh" "${PN}"

	# Make sure the logging directory is created
	local LOGGING_DIR="/var/log/ubooquity"
	dodir "${LOGGING_DIR}"
	chown "${_USERNAME}":"${_USERNAME}" "${ED%/}/${LOGGING_DIR}" || die

	# Install the OpenRC init/conf files
	newinitd "${FILESDIR}/${PN}-init" "${PN}"
    newconfd "${FILESDIR}/${PN}-conf" "${PN}"

	# Install systemd service file
#	local INIT_NAME="${PN}.service"
#	local INIT="${FILESDIR}/systemd/${INIT_NAME}"
#	systemd_newunit "${INIT}" "${INIT_NAME}"
}

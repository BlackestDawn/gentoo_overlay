# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

## All credits go to Scott Alfter, I have simply modified his sickrage ebuild! (https://gitlab.com/salfter/portage/tree/master/net-nntp/sickrage)

EAPI=5

PYTHON_COMPAT=( python2_6 python2_7 )

EGIT_REPO_URI="https://github.com/pymedusa/Medusa.git"

inherit eutils user git-2 python-any-r1

DESCRIPTION="Medusa - Automatic Video Library Manager for TV Shows"
HOMEPAGE="http://sickrage.github.io/"

LICENSE="GPL-3" # only
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libressl"

DEPEND="${PTYHON_DEPS}"
RDEPEND="
	media-video/mediainfo
	dev-python/cryptography
	dev-python/pyopenssl
	libressl? ( dev-libs/libressl )
"

pkg_setup() {
	python-any-r1_pkg_setup

	# Create medusa group
	enewgroup ${PN}
	# Create medusa user, put in medusa  group
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_install() {
	dodoc readme.md

	newconfd "${FILESDIR}/${PN}.conf" ${PN}
	newinitd "${FILESDIR}/${PN}.init" ${PN}

	# Location of log and data files
	keepdir /var/${PN}
	fowners -R ${PN}:${PN} /var/${PN}

	keepdir /var/{${PN}/{cache,download},log/${PN}}
	fowners -R ${PN}:${PN} /var/{${PN}/{cache,download},log/${PN}}

	insinto /etc/${PN}
	insopts -m0660 -o ${PN} -g ${PN}
    doins "${FILESDIR}/config.ini"

	# Rotation of log files
	insinto /etc/logrotate.d
	insopts -m0644 -o root -g root
	newins "${FILESDIR}/${PN}.logrotate" ${PN}

	# weird stuff ;-)
	last_commit=$(git rev-parse HEAD)
	echo ${last_commit} > version.txt

	insinto /usr/share/${PN}
	#doins -r .build .github dredd lib medusa runscripts static tests views vue .checkignore .editorconfig .gitattributes .gitignore .travis.yml SickBeard.py package.json pytest.ini setup.py start.py tox.ini yarn.lock
	doins -r .build .github dredd lib medusa runscripts static tests views vue .editorconfig .gitattributes .gitignore .travis.yml SickBeard.py package.json pytest.ini setup.py start.py tox.ini yarn.lock

	fowners -R ${PN}:${PN} /usr/share/${PN}
}

pkg_postinst() {

	# we need to remove .git which old ebuild installed
	if [[ -d "/usr/share/${PN}/.git" ]] ; then
	   ewarn "stale files from previous ebuild detected"
	   ewarn "/usr/share/${PN}/.git removed."
	   ewarn "To ensure proper operation, you should unmerge package and remove directory /usr/share/${PN} and then emerge package again"
	   ewarn "Sorry for the inconvenience"
	   rm -Rf "/usr/share/${PN}/.git"
	fi

	elog "Medusa has been installed with data directories in /var/${PN}"
	elog
	elog "New user/group ${PN}/${PN} has been created"
	elog
	elog "Config file is located at /etc/${PN}/config.ini"
	elog
	elog "Please configure /etc/conf.d/${PN} before starting as daemon!"
	elog
	elog "Start with ${ROOT}etc/init.d/${PN} start"
	elog "Visit http://<host ip>:8081 to configure Medusa"
	elog "Default web username/password : medusa/secret"
	elog
}

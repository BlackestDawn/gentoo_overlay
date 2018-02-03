# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 webapp

DESCRIPTION="A HTPC/Homelab Services Organizer"
HOMEPAGE="https://github.com/causefx/Organizr"
EGIT_REPO_URI="https://github.com/causefx/Organizr.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND="virtual/httpd-php
		dev-lang/php"
RDEPEND="${DEPEND}"

S="${WORKDIR}/Organizr"

src_install() {
	webapp_src_preinst

	dodoc CODE_OF_CONDUCT.md README* LICENSE
	rm CODE_OF_CONDUCT.md COPYING README* LICENSE .gitignore .travis.yml || die

	insinto "${MY_HTDOCSDIR}"
	doins -r .
	#newins phpsysinfo.ini{.new,}

	#webapp_configfile "${MY_HTDOCSDIR}"/phpsysinfo.ini
	webapp_src_install
}


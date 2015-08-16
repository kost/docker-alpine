FROM gliderlabs/alpine
MAINTAINER kost - https://github.com/kost

ENV RT_VERSION 4.2.12
# https://download.bestpractical.com/pub/rt/release/rt-4.2.12.tar.gz

RUN apk --update add openssl mysql-client postgresql-client fcgi lighttpd perl perl-lwp-protocol-https perl-dbd-pg perl-dbd-mysql perl-dbd-sqlite perl-cgi-psgi perl-cgi perl-fcgi perl-term-readkey perl-xml-rss perl-crypt-ssleay perl-crypt-eksblowfish perl-crypt-x509 perl-html-mason-psgihandler perl-fcgi-procmanager perl-mime-types perl-list-moreutils perl-json perl-html-quoted perl-html-scrubber perl-email-address perl-text-password-pronounceable perl-email-address-list perl-html-formattext-withlinks-andtables perl-html-rewriteattributes perl-text-wikiformat perl-text-quoted perl-datetime-format-natural perl-date-extract perl-data-guid perl-data-ical perl-string-shellquote perl-convert-color perl-dbix-searchbuilder perl-file-which perl-css-squish perl-tree-simple perl-plack perl-log-dispatch perl-module-versions-report perl-symbol-global-name perl-devel-globaldestruction perl-parallel-prefork perl-cgi-emulate-psgi perl-text-template perl-net-cidr perl-apache-session perl-locale-maketext-lexicon perl-locale-maketext-fuzzy perl-regexp-common-net-cidr perl-module-refresh perl-date-manip perl-regexp-ipv6 perl-text-wrapper perl-universal-require perl-role-basic perl-convert-binhex perl-test-sharedfork perl-test-tcp perl-server-starter perl-starlet make gnupg gcc perl-dev libc-dev && \
    rm -f /var/cache/apk/* && \
    wget -O /tmp/rt-$RT_VERSION.tar.gz https://download.bestpractical.com/pub/rt/release/rt-$RT_VERSION.tar.gz && \
    tar -xvz -C /tmp -f /tmp/rt-$RT_VERSION.tar.gz && \
    cd /tmp/rt-$RT_VERSION && \
    (echo y;echo o conf prerequisites_policy follow;echo o conf commit)|cpan && \
    cpan -f GnuPG::Interface && \
    ./configure --with-web-user=lighttpd --with-web-group=lighttpd && \
    make fixdeps && \
    make install && \
    cd / && rm -rf /tmp/rt-$RT_VERSION rt-$RT_VERSION.tar.gz && \
    echo "Success"

ADD scripts/run.sh /scripts/run.sh
ADD config/mod_fastcgi.conf /etc/lighttpd/
ADD config/lighttpd.conf /etc/lighttpd/
RUN mkdir /scripts/pre-exec.d && \
mkdir /scripts/pre-init.d && \
mkdir /scripts/pre-initdb.d && \
mkdir /scripts/post-initdb.d && \
chmod -R 755 /scripts

EXPOSE 80

ENTRYPOINT ["/scripts/run.sh"]
# ENTRYPOINT ["/bin/sh"]


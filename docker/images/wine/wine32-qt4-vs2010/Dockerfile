FROM wine32-vs2010

ADD install.sh /tmp/install.sh
ADD posix_fix.patch /tmp/posix_fix.patch
RUN chmod +x /tmp/install.sh
RUN /tmp/install.sh

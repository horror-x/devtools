FROM debian:wheezy

ADD install.sh /tmp/install.sh
ADD vars.reg /tmp/vars.reg
ADD patches /tmp/patches
RUN chmod +x /tmp/install.sh
RUN /tmp/install.sh
ENV WINEPREFIX /opt/win32
ENV WINEARCH win32
ENV WINEDLLOVERRIDES mscoree,mshtml=n
ENV WINEDEBUG fixme-all,err-ole,err-rpc

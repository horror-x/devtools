FROM wine32-devtools

ADD vs_vars.reg /tmp/vs_vars.reg
ADD install.sh /tmp/install.sh
RUN chmod +x /tmp/install.sh
RUN /tmp/install.sh

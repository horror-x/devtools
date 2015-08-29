# Qt5 (Visual Studio 2010)
Image with Qt5 build under Visual Studio 2010.

### Configure
./configure [arg | arg=value | arg value]

### Arguments
##### \-\-minor-version <version>
Minor version to build. For example - 5 or 5.0. By default latest stable at last configure script change time (see QT5_MINOR_VERSION in ./configure).

##### \-\-init-repository-args <args>
Arguments passed to ./init-repository. Default is not defined.

##### \-\-configure-args <args>
Additional arguments passed to ./configure

Default arguments with openssl:
```batch
configure -platform win32-msvc2010 -opensource -confirm-license -openssl-linked -I Z:\\opt\\openssl\\include -L Z:\\opt\\openssl\\lib -l User32 -l Gdi32 OPENSSL_LIBS="-lssleay32 -llibeay32" %ADDITIONAL_ARGS%
```

Default arguments without openssl (\-\-no-openssl):
```batch
configure -platform win32-msvc2010 -opensource -confirm-license %ADDITIONAL_ARGS% 
```

Example:
```batch
# ./configure \
        --init-repository-args="--no-webkit --module-subset=qtbase,qtxmlpatterns,qtscript,qtwinextras" \
        --configure-args="-release -static -nomake examples -opengl desktop -skip multimedia -skip webengine -skip webchannel -skip sensors -skip svg -no-angle"
# docker build --tag=wine32-qt5 .
```

##### \-\-no-openssl
Don't build openssl.

##### \-\-with-http-module
Build deprecated in Qt4 and removed in Qt5 http module (recommended to use QNetworkAccessManager instead).

##### \-\-function-level-linkning
Use function-level linking (/Gy msvc compiler flag). Very usefull to minimize target binary size when used static Qt build (target should be linked with /OPT:REF flag).

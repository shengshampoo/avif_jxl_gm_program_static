#! /bin/bash

set -e

WORKSPACE=/tmp/workspace


# libde265
cd $WORKSPACE
git clone https://github.com/strukturag/libde265.git
cd libde265
mkdir build0
cd build0
cmake -G Ninja -DCMAKE_INSTALL_PREFIX=/usr -DENABLE_ENCODER=ON -DENABLE_ENCODER=OFF -DCMAKE_BUILD_TYPE=MinSizeRel -DBUILD_SHARED_LIBS=OFF -DCMAKE_EXE_LINKER_FLAGS="-static --static -no-pie -s" ..
sed -i 's@libSDL2-2.0.so.0.3200.8@libSDL2.a@g' ./build.ninja
ninja
ninja install

# libheif
cd $WORKSPACE
git clone https://github.com/strukturag/libheif.git
cd libheif
mkdir build0
cd build0
cmake -G Ninja -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=MinSizeRel -DBUILD_SHARED_LIBS=OFF -DCMAKE_EXE_LINKER_FLAGS="-static --static -no-pie -s" \
 -DJPEG_LIBRARY_RELEASE=/usr/lib/libjpeg.a -DZLIB_LIBRARY_RELEASE=/usr/lib/libz.a -DLIBSHARPYUV_LIBRARY=/usr/lib/libsharpyuv.a -DPNG_LIBRARY_RELEASE=/usr/lib/libpng.a ..
sed -i 's@libtiff.a@libtiff.a /usr/lib/libzstd.a /usr/lib/libdeflate.a /usr/lib/libz.a /usr/lib/libwebp.a /usr/lib/libjpeg.a /usr/lib/libpng.a /usr/lib/liblzma.a /usr/lib/libsharpyuv.a@g' ./build.ninja
sed -i 's@libSDL2-2.0.so.0.3200.8@libSDL2.a@g' ./build.ninja
ninja
ninja install

# brotli
cd $WORKSPACE
git clone https://github.com/google/brotli.git
cd brotli
mkdir build
cd build
cmake -G Ninja -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=MinSizeRel -DBUILD_SHARED_LIBS=OFF ..
ninja
ninja install

# gperftools
cd $WORKSPACE
git clone https://github.com/gperftools/gperftools.git
cd gperftools
./autogen.sh
LDFLAGS="-static --static -no-pie -s" ./configure --prefix=/usr
make
make install

# graphicsmagick
cd $WORKSPACE
aq=$(curl -sL https://sourceforge.net/projects/graphicsmagick/best_release.json | jq -r '.platform_releases.linux.filename' | sed 's/.*\///' | sed 's/.tar.*$//')
curl -sL $(curl -sL https://sourceforge.net/projects/graphicsmagick/best_release.json | jq -r '.platform_releases.linux.url' | sed 's/?.*$//') | tar xv --xz
cd $aq
sed -i '30391s@-gt 0@-gt 20@' ./configure
sed -i '31162s@-gt 0@-gt 20@' ./configure
sed -i '24868s@-gt 0@-gt 20@' ./configure
sed -i '24811s@no@yes@' ./configure
LDFLAGS="-static --static -no-pie -s -lde265 -lbrotlienc -lbrotlidec -lbrotlicommon -lavif -laom -lgav1 -ldav1d -lSvtAv1Enc -lrav1e -lyuv -ldeflate -lz" ./configure --prefix=/usr/local/graphicsmagickmm --without-x --with-tcmalloc 
make
make install


cd /usr/local
tar vcJf ./graphicsmagickmm.tar.xz graphicsmagickmm
mv ./graphicsmagickmm.tar.xz /work/artifact/

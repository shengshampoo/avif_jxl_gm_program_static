#! /bin/bash

set -e

WORKSPACE=/tmp/workspace
mkdir -p $WORKSPACE

# libxml
cd $WORKSPACE
aa=2.13.8 
curl -sL https://gitlab.gnome.org/GNOME/libxml2/-/archive/v$aa/libxml2-v$aa.tar.bz2 | tar xv --bzip2
cd libxml2-v$aa
sh autogen.sh
LDFLAGS="-static --static -no-pie -s" ./configure --prefix=/usr --enable-static --disable-shared
make
make install

# libyuv
cd $WORKSPACE
git clone https://chromium.googlesource.com/libyuv/libyuv.git
cd libyuv
mkdir build
cd build
cmake -G Ninja -DCMAKE_INSTALL_PREFIX="/usr" -DCMAKE_BUILD_TYPE="Release" -DCMAKE_BUILD_TYPE=MinSizeRel -DBUILD_SHARED_LIBS=OFF -DCMAKE_EXE_LINKER_FLAGS="-static --static -no-pie -s" ..
ninja
ninja install

# abseil-cpp
cd $WORKSPACE
git clone https://github.com/abseil/abseil-cpp.git
cd abseil-cpp
mkdir build0
cd build0
cmake -G Ninja -DCMAKE_INSTALL_PREFIX=/usr -DABSL_BUILD_TESTING=OFF -DABSL_USE_GOOGLETEST_HEAD=ON -DCMAKE_CXX_STANDARD=17 -DCMAKE_BUILD_TYPE=MinSizeRel -DBUILD_SHARED_LIBS=OFF -DCMAKE_EXE_LINKER_FLAGS="-static --static -no-pie -s" ..
ninja
ninja install

# dav1d
cd $WORKSPACE
git clone https://code.videolan.org/videolan/dav1d.git
cd dav1d
mkdir build
cd build
meson ..
meson configure --prefix=/usr -Ddefault_library=both -Dbuildtype=release
ninja
ninja install

# libgav1
cd $WORKSPACE
git clone https://chromium.googlesource.com/codecs/libgav1.git
cd libgav1
git clone https://github.com/abseil/abseil-cpp.git ./third_party/abseil-cpp
git clone https://github.com/google/googletest.git ./third_party/googletest
sed -i '/.*CXX_STANDARD 11)$/s/11/17/' ./CMakeLists.txt
mkdir build0
cd build0
cmake -G Ninja -DCMAKE_INSTALL_PREFIX=/usr -DLIBGAV1_THREADPOOL_USE_STD_MUTEX=1 \
  -DLIBGAV1_ENABLE_TESTS=0 -DCMAKE_BUILD_TYPE=MinSizeRel -DBUILD_SHARED_LIBS=OFF \
  -DCMAKE_EXE_LINKER_FLAGS="-static --static -no-pie -s" -DCMAKE_CXX_STANDARD=17 ..
ninja
ninja install

# aom
cd $WORKSPACE
git clone https://aomedia.googlesource.com/aom.git
cd aom
curl -sL https://gitlab.alpinelinux.org/alpine/aports/-/raw/master/main/aom/posix-implicit.patch | patch -p1
mkdir build0
cd build0
cmake -G Ninja -DCMAKE_INSTALL_PREFIX=/usr -DENABLE_CCACHE=0 -DENABLE_DOCS=OFF -D_POSIX_C_SOURCE=200112L -DCMAKE_BUILD_TYPE=MinSizeRel -DBUILD_SHARED_LIBS=OFF -DCMAKE_EXE_LINKER_FLAGS="-static --static -no-pie -s" ..
ninja
ninja install

# cargo-c
cd $WORKSPACE
cargo install --git https://github.com/lu-zero/cargo-c.git

# rav1e
cd $WORKSPACE
git clone https://github.com/xiph/rav1e.git
cd rav1e
RUSTFLAGS="-C linker=rust-lld -C strip=symbols -C opt-level=s" cargo cinstall --prefix=/usr --libdir=/usr/lib --includedir=/usr/include

# SVT-AV1
cd $WORKSPACE
git clone https://gitlab.com/AOMediaCodec/SVT-AV1.git
cd SVT-AV1
mkdir build
cd build
cmake -G Ninja -DCMAKE_INSTALL_PREFIX=/usr -DBUILD_DEC=ON -DBUILD_SHARED_LIBS=OFF -DENABLE_AVX512=ON -DCMAKE_BUILD_TYPE=MinSizeRel -DBUILD_SHARED_LIBS=OFF -DCMAKE_EXE_LINKER_FLAGS="-static --static -no-pie -s" ..
ninja
ninja install

# libavif
cd $WORKSPACE
git clone https://github.com/AOMediaCodec/libavif.git 
cd libavif
mkdir build
cd build
cmake -G Ninja -DCMAKE_INSTALL_PREFIX=/usr/local/libavifmm \
 -DAVIF_LIBXML2=SYSTEM -DAVIF_CODEC_AOM=SYSTEM -DAVIF_CODEC_DAV1D=SYSTEM \
 -DAVIF_CODEC_LIBGAV1=SYSTEM -DAVIF_CODEC_RAV1E=SYSTEM -DAVIF_CODEC_SVT=SYSTEM \
 -DAVIF_BUILD_APPS=SYSTEM -DCMAKE_BUILD_TYPE=MinSizeRel -DBUILD_SHARED_LIBS=OFF \
 -DCMAKE_EXE_LINKER_FLAGS="-static --static -no-pie -s -labsl_base" \
 -DLIBYUV_INCLUDE_DIR=/usr/include -DLIBYUV_LIBRARY=/usr/lib/libyuv.a \
 -DDAV1D_INCLUDE_DIR=/usr/include -DDAV1D_LIBRARY=/usr/lib/libdav1d.a \
 -DRAV1E_INCLUDE_DIR=/usr/include/rav1e -DRAV1E_LIBRARIES=/usr/lib/librav1e.a \
 -DSVT_INCLUDE_DIR=/usr/include -DSVT_LIBRARY=/usr/lib/libSvtAv1Enc.a 
 -DPNG_LIBRARY=/usr/lib/libpng.a -DPNG_PNG_INCLUDE_DIR=/usr/include \
 -DJPEG_LIBRARY=/usr/lib/libjpeg.a -DJPEG_INCLUDE_DIR=/usr/include \
 -DZLIB_LIBRARY_RELEASE=/usr/lib/libz.a -DLIBXML2_LIBRARY=/usr/lib/libxml2.a \
 -Dpkgcfg_lib_PC_LIBXML_xml2=/usr/lib/libxml2.a -DAVIF_BUILD_APPS=ON .. 
ninja
ninja install
cd ../
mkdir build2
cd build2
cmake -G Ninja -DCMAKE_INSTALL_PREFIX=/usr \
 -DAVIF_LIBXML2=SYSTEM -DAVIF_CODEC_AOM=SYSTEM -DAVIF_CODEC_DAV1D=SYSTEM \
 -DAVIF_CODEC_LIBGAV1=SYSTEM -DAVIF_CODEC_RAV1E=SYSTEM -DAVIF_CODEC_SVT=SYSTEM \
 -DAVIF_BUILD_APPS=SYSTEM -DCMAKE_BUILD_TYPE=MinSizeRel -DBUILD_SHARED_LIBS=OFF \
 -DCMAKE_EXE_LINKER_FLAGS="-static --static -no-pie -s -labsl_base" \
 -DLIBYUV_INCLUDE_DIR=/usr/include -DLIBYUV_LIBRARY=/usr/lib/libyuv.a \
 -DDAV1D_INCLUDE_DIR=/usr/include -DDAV1D_LIBRARY=/usr/lib/libdav1d.a \
 -DRAV1E_INCLUDE_DIR=/usr/include/rav1e -DRAV1E_LIBRARIES=/usr/lib/librav1e.a \
 -DSVT_INCLUDE_DIR=/usr/include -DSVT_LIBRARY=/usr/lib/libSvtAv1Enc.a 
 -DPNG_LIBRARY=/usr/lib/libpng.a -DPNG_PNG_INCLUDE_DIR=/usr/include \
 -DJPEG_LIBRARY=/usr/lib/libjpeg.a -DJPEG_INCLUDE_DIR=/usr/include \
 -DZLIB_LIBRARY_RELEASE=/usr/lib/libz.a -DLIBXML2_LIBRARY=/usr/lib/libxml2.a \
 -Dpkgcfg_lib_PC_LIBXML_xml2=/usr/lib/libxml2.a -DAVIF_BUILD_APPS=ON .. 
ninja
ninja install

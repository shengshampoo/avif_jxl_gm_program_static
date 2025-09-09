#! /bin/bash

set -e

WORKSPACE=/tmp/workspace


# Imath
cd $WORKSPACE
git clone https://github.com/AcademySoftwareFoundation/Imath.git
cd Imath
mkdir build0
cd build0
cmake -G Ninja -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=MinSizeRel -DBUILD_SHARED_LIBS=OFF -DCMAKE_EXE_LINKER_FLAGS="-static --static -no-pie -s" ..
ninja
ninja install

# openexr
cd $WORKSPACE
git clone https://github.com/AcademySoftwareFoundation/openexr.git
cd openexr
mkdir build0
cd build0
cmake -G Ninja -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=MinSizeRel -DBUILD_SHARED_LIBS=OFF -DCMAKE_EXE_LINKER_FLAGS="-static --static -no-pie -s" ..
ninja
ninja install

# jpeg-xl
cd $WORKSPACE
git clone --recursive https://gitlab.com/wg1/jpeg-xl.git
cd jpeg-xl
mkdir build
cd build
cmake -G Ninja -DCMAKE_INSTALL_PREFIX=/usr/local/jpegxlmm \
 -DCMAKE_BUILD_TYPE=MinSizeRel -DBUILD_SHARED_LIBS=OFF -DBUILD_TESTING=OFF \
 -DPNG_LIBRARY=/usr/lib/libpng.a -DPNG_PNG_INCLUDE_DIR=/usr/include \
 -DJPEG_LIBRARY=/usr/lib/libjpeg.a -DJPEG_INCLUDE_DIR=/usr/include \
 -DCMAKE_EXE_LINKER_FLAGS="-static --static -no-pie -s" \
 -DZLIB_LIBRARY_RELEASE=/usr/lib/libz.a .. 
sed -i 's@/usr/lib/libavif.a@/usr/lib/libavif.a /usr/lib/libaom.a /usr/lib/libgav1.a /usr/lib/libdav1d.a /usr/lib/libSvtAv1Enc.a /usr/lib/librav1e.a /usr/lib/libdav1d.a /usr/lib/libyuv.a@g' ./build.ninja
ninja
ninja install
cd ../
mkdir build2
cd build2
cmake -G Ninja -DCMAKE_INSTALL_PREFIX=/usr \
 -DCMAKE_BUILD_TYPE=MinSizeRel -DBUILD_SHARED_LIBS=OFF -DBUILD_TESTING=OFF \
 -DPNG_LIBRARY=/usr/lib/libpng.a -DPNG_PNG_INCLUDE_DIR=/usr/include \
 -DJPEG_LIBRARY=/usr/lib/libjpeg.a -DJPEG_INCLUDE_DIR=/usr/include \
 -DCMAKE_EXE_LINKER_FLAGS="-static --static -no-pie -s" \
 -DZLIB_LIBRARY_RELEASE=/usr/lib/libz.a .. 
sed -i 's@/usr/lib/libavif.a@/usr/lib/libavif.a /usr/lib/libaom.a /usr/lib/libgav1.a /usr/lib/libdav1d.a /usr/lib/libSvtAv1Enc.a /usr/lib/librav1e.a /usr/lib/libdav1d.a /usr/lib/libyuv.a@g' ./build.ninja
ninja
ninja install

cd /usr/local
tar vcJf ./jpegxlmm.tar.xz jpegxlmm

mv ./jpegxlmm.tar.xz /work/artifact/

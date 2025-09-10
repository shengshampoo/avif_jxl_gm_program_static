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

# libdeflate
cd $WORKSPACE
git clone https://github.com/ebiggers/libdeflate.git
cd libdeflate
mkdir build0
cd build0
cmake -G Ninja -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=MinSizeRel -DBUILD_SHARED_LIBS=OFF -DCMAKE_EXE_LINKER_FLAGS="-static --static -no-pie -s" ..
ninja
ninja install

# libtiff
cd $WORKSPACE
git clone https://gitlab.com/libtiff/libtiff.git
cd libtiff
mkdir build0
cd build0
cmake -G Ninja -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=MinSizeRel -DBUILD_SHARED_LIBS=OFF \
 -DCMAKE_EXE_LINKER_FLAGS="-static --static -no-pie -s" \
 -DZSTD_LIBRARY_RELEASE=/usr/lib/libzstd.a -DLIBLZMA_LIBRARY_RELEASE=/usr/lib/liblzma.a -DDeflate_LIBRARY_RELEASE=/usr/lib/libdeflate.a \
 -DJPEG_LIBRARY_RELEASE=/usr/lib/libjpeg.a -DWebP_LIBRARY_RELEASE=/usr/lib/libwebp.a -DZLIB_LIBRARY_RELEASE=/usr/lib/libz.a .. 
sed -i 's@/usr/lib/libwebp.a@/usr/lib/libwebp.a /usr/lib/libsharpyuv.a@g' ./build.ninja
ninja
ninja install

# OpenJPH
#cd $WORKSPACE
#git clone https://github.com/aous72/OpenJPH.git
#cd OpenJPH
#mkdir build0
#cd build0
#cmake -G Ninja -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=MinSizeRel -DBUILD_SHARED_LIBS=OFF -DOJPH_ENABLE_TIFF_SUPPORT=OFF -DCMAKE_EXE_LINKER_FLAGS="-static --static -no-pie -s" ..
#ninja
#ninja install

# openexr
#cd $WORKSPACE
#git clone https://github.com/AcademySoftwareFoundation/openexr.git
#cd openexr
#mkdir build0
#cd build0
#cmake -G Ninja -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=MinSizeRel -DBUILD_SHARED_LIBS=OFF -DCMAKE_EXE_LINKER_FLAGS="-static --static -no-pie -s" ..
#ninja
#ninja install

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

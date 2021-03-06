#!/bin/bash

setup ()
{
    if [ x = "x$ANDROID_BUILD_TOP" ] ; then
        echo "Android build environment must be configured"
        exit 1
    fi
    . "$ANDROID_BUILD_TOP"/build/envsetup.sh

    KERNEL_DIR="$(dirname "$(readlink -f "$0")")"
    BUILD_DIR="$KERNEL_DIR/build"
<<<<<<< HEAD
<<<<<<< HEAD
    MODULES=("fs/cifs/cifs.ko" "fs/fuse/fuse.ko" "fs/nls/nls_utf8.ko")
=======
    #MODULES=("fs/cifs/cifs.ko" "fs/fuse/fuse.ko" "fs/nls/nls_utf8.ko")
>>>>>>> b302688d4f6cc133e3b73238ff08ca4330cb64c9
=======
    #MODULES=("fs/cifs/cifs.ko" "fs/fuse/fuse.ko" "fs/nls/nls_utf8.ko")
>>>>>>> b302688d4f6cc133e3b73238ff08ca4330cb64c9

    if [ x = "x$NO_CCACHE" ] && ccache -V &>/dev/null ; then
        CCACHE=ccache
        CCACHE_BASEDIR="$KERNEL_DIR"
        CCACHE_COMPRESS=1
        CCACHE_DIR="$BUILD_DIR/.ccache"
        export CCACHE_DIR CCACHE_COMPRESS CCACHE_BASEDIR
    else
        CCACHE=""
    fi

    CROSS_PREFIX="$ANDROID_BUILD_TOP/prebuilt/linux-x86/toolchain/arm-eabi-4.4.3/bin/arm-eabi-"
}

build ()
{
    local target=$1
    echo "Building for $target"
    local target_dir="$BUILD_DIR/$target"
    local module
    rm -fr "$target_dir"
    mkdir -p "$target_dir/usr"
    cp "$KERNEL_DIR/usr/"*.list "$target_dir/usr"
    sed "s|usr/|$KERNEL_DIR/usr/|g" -i "$target_dir/usr/"*.list
<<<<<<< HEAD
<<<<<<< HEAD
    THREADS=`cat /proc/cpuinfo | grep processor | wc -l`
    make -j${THREADS} ARCH=arm ${target}_cm9_defconfig
    make -j${THREADS}
    cp "$KERNEL_DIR"/arch/arm/boot/zImage $ANDROID_BUILD_TOP/device/samsung/galaxytab/kernel
    for module in "${MODULES[@]}" ; do
        cp "$target_dir/$module" $ANDROID_BUILD_TOP/device/samsung/galaxytab/modules
    done
=======
    mka -C "$KERNEL_DIR" O="$target_dir" ${target}\_cm9_defconfig HOSTCC="$CCACHE gcc"
    mka -C "$KERNEL_DIR" O="$target_dir" HOSTCC="$CCACHE gcc" CROSS_COMPILE="$CCACHE $CROSS_PREFIX" zImage modules
    cp "$target_dir"/arch/arm/boot/zImage $ANDROID_BUILD_TOP/device/samsung/galaxytab/kernel-$target
>>>>>>> b302688d4f6cc133e3b73238ff08ca4330cb64c9
=======
    mka -C "$KERNEL_DIR" O="$target_dir" ${target}\_cm9_defconfig HOSTCC="$CCACHE gcc"
    mka -C "$KERNEL_DIR" O="$target_dir" HOSTCC="$CCACHE gcc" CROSS_COMPILE="$CCACHE $CROSS_PREFIX" zImage modules
    cp "$target_dir"/arch/arm/boot/zImage $ANDROID_BUILD_TOP/device/samsung/galaxytab/kernel-$target
>>>>>>> b302688d4f6cc133e3b73238ff08ca4330cb64c9
}
    
setup

<<<<<<< HEAD
<<<<<<< HEAD
=======
setup

>>>>>>> b302688d4f6cc133e3b73238ff08ca4330cb64c9
=======
setup

>>>>>>> b302688d4f6cc133e3b73238ff08ca4330cb64c9
if [ "$1" = clean ] ; then
    rm -fr "$BUILD_DIR"/*
    exit 0
fi

<<<<<<< HEAD
<<<<<<< HEAD
P1_target=$1
targets=("$@")
if [ 0 = "${#targets[@]}" ] ; then
    targets=($P1_target)
=======
targets=("$@")
if [ 0 = "${#targets[@]}" ] ; then
    targets=(p1 p1c p1l p1n)
>>>>>>> b302688d4f6cc133e3b73238ff08ca4330cb64c9
=======
targets=("$@")
if [ 0 = "${#targets[@]}" ] ; then
    targets=(p1 p1c p1l p1n)
>>>>>>> b302688d4f6cc133e3b73238ff08ca4330cb64c9
fi

START=$(date +%s)

for target in "${targets[@]}" ; do 
    build $target
done

END=$(date +%s)
ELAPSED=$((END - START))
E_MIN=$((ELAPSED / 60))
E_SEC=$((ELAPSED - E_MIN * 60))
printf "Elapsed: "
[ $E_MIN != 0 ] && printf "%d min(s) " $E_MIN
printf "%d sec(s)\n" $E_SEC

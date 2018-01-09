# Set info vars.
CURRENT_DATE=$(date +'%Y%m%d')
LOUP_VERSION=$1
ANDROID_VERSION=$2
FILE_NAME="Loup.Kernel-v${LOUP_VERSION}-${ANDROID_VERSION}-${CURRENT_DATE}.zip"

# Delete old stuff.
rm ~/CAF/AnyKernel2/*.zip
if [ -f ~/CAF/AnyKernel2/modules/system/lib/modules/wlan.ko ]; then
    rm ~/CAF/AnyKernel2/modules/system/lib/modules/wlan.ko
fi

# Start building anykernel zip.
cp ./arch/arm64/boot/Image.gz-dtb ~/CAF/AnyKernel2/zImage
find . -type f -name "wlan.ko" -exec cp -fv {} ~/CAF/AnyKernel2/modules/system/lib/modules/. \;

# Update kernel version
cp ~/CAF/AnyKernel2/anykernel-template.sh ~/CAF/AnyKernel2/anykernel.sh
sed -i -e "s/LOUP_VERSION/$LOUP_VERSION/g" ~/CAF/AnyKernel2/anykernel.sh
sed -i -e "s/ANDROID_VERSION/$ANDROID_VERSION/g" ~/CAF/AnyKernel2/anykernel.sh

# Zip it!.
pushd ~/CAF/AnyKernel2
zip -r9 ${FILE_NAME} * -x build.sh README.md anykernel-template.sh
popd

# Print final result in color!
GREEN='\033[0;32m'
echo ""
echo -e "${GREEN}> Succeed!, file located at $(readlink -f $FILE_NAME)"

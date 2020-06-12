# Set info vars.
CURRENT_DATE=$(date +'%Y%m%d')
LOUP_VERSION=$1
ANDROID_VERSION=$2
KERNEL_NAME=$3
FILE_NAME="${KERNEL_NAME}.Kernel-v${LOUP_VERSION}-${ANDROID_VERSION}-${CURRENT_DATE}.zip"

# Delete old stuff.
rm $LOUP_WORKING_DIR/AnyKernel3/*.zip
if [ -f $LOUP_WORKING_DIR/AnyKernel3/modules/system/lib/modules/wlan.ko ]; then
    rm $LOUP_WORKING_DIR/AnyKernel3/modules/system/lib/modules/wlan.ko
fi

# Start building anykernel zip, without any dtb. Will append at runtime :P
cp ./out/arch/arm64/boot/Image.gz $LOUP_WORKING_DIR/AnyKernel3/zImage
cp ./arch/arm64/boot/Image.gz $LOUP_WORKING_DIR/AnyKernel3/zImage

cp ./out/arch/arm64/boot/dts/qcom/santoni-treble.dtb $LOUP_WORKING_DIR/AnyKernel3/santoni-treble
cp ./arch/arm64/boot/dts/qcom/msm8940-pmi8950-qrd-sku7_S88536AA2-treble.dtb $LOUP_WORKING_DIR/AnyKernel3/santoni-treble

cp ./out/arch/arm64/boot/dts/qcom/santoni.dtb $LOUP_WORKING_DIR/AnyKernel3/santoni
cp ./arch/arm64/boot/dts/qcom/msm8940-pmi8950-qrd-sku7_S88536AA2.dtb $LOUP_WORKING_DIR/AnyKernel3/santoni

find . -type f -name "wlan.ko" -exec cp -fv {} $LOUP_WORKING_DIR/AnyKernel3/modules/system/lib/modules/. \;

# Update kernel version
cp $LOUP_WORKING_DIR/AnyKernel3/anykernel-template.sh $LOUP_WORKING_DIR/AnyKernel3/anykernel.sh
sed -i -e "s/LOUP_VERSION/$LOUP_VERSION/g" $LOUP_WORKING_DIR/AnyKernel3/anykernel.sh
sed -i -e "s/ANDROID_VERSION/$ANDROID_VERSION/g" $LOUP_WORKING_DIR/AnyKernel3/anykernel.sh
sed -i -e "s/KERNEL_NAME/$KERNEL_NAME/g" $LOUP_WORKING_DIR/AnyKernel3/anykernel.sh

# Zip it!.
pushd $LOUP_WORKING_DIR/AnyKernel3
zip -r9 ${FILE_NAME} * -x build.sh README.md anykernel-template.sh
popd

# Print final result in color!
GREEN='\033[0;32m'
echo ""
echo -e "${GREEN}> Succeed!, file located at $LOUP_WORKING_DIR/AnyKernel3/$FILE_NAME"

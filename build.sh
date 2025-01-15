#!/bin/sh
#要build的target名
UNIVERSAL_OUTPUT_FOLDER=Output
TARGET_NAME=ZLPhotoBrowser
BUILD_DIR=build_tmp

#创建输出目录，并删除之前的framework文件
rm -rf "${UNIVERSAL_OUTPUT_FOLDER}"
rm -rf $BUILD_DIR
mkdir $BUILD_DIR
mkdir -p "${UNIVERSAL_OUTPUT_FOLDER}"
mkdir -p "${UNIVERSAL_OUTPUT_FOLDER}"/ios_arm64
mkdir -p "${UNIVERSAL_OUTPUT_FOLDER}"/sim_x86_64
rm -rf "${UNIVERSAL_OUTPUT_FOLDER}/${TARGET_NAME}.framework"

#分别编译模拟器和真机的Framework
xcodebuild -target ${TARGET_NAME} ONLY_ACTIVE_ARCH=YES -arch arm64 -configuration Release -sdk iphoneos BUILD_DIR="${BUILD_DIR}" clean build
cp -af "${BUILD_DIR}/Release-iphoneos/${TARGET_NAME}.framework" "${UNIVERSAL_OUTPUT_FOLDER}"/ios_arm64

xcodebuild -target ${TARGET_NAME} ONLY_ACTIVE_ARCH=NO -configuration Release -sdk iphonesimulator BUILD_DIR="${BUILD_DIR}" clean build
cp -af "${BUILD_DIR}/Release-iphonesimulator/${TARGET_NAME}.framework" "${UNIVERSAL_OUTPUT_FOLDER}"/sim_x86_64

xcodebuild -create-xcframework -framework "${UNIVERSAL_OUTPUT_FOLDER}"/ios_arm64/${TARGET_NAME}.framework -framework "${UNIVERSAL_OUTPUT_FOLDER}"/sim_x86_64/${TARGET_NAME}.framework  -output "${UNIVERSAL_OUTPUT_FOLDER}"/${TARGET_NAME}.xcframework

rm -rf build
rm -rf $BUILD_DIR
rm -rf "${UNIVERSAL_OUTPUT_FOLDER}"/ios_arm64
rm -rf "${UNIVERSAL_OUTPUT_FOLDER}"/sim_x86_64

#打开合并后的文件夹
open "${UNIVERSAL_OUTPUT_FOLDER}"

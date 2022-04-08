gem install xcpretty

LIB_NAME="SwiftUIPager"
PROJ_PATH="$LIB_NAME.xcodeproj"
BUILD_PATH=".build"
FRAMEWORKS_PATH="$BUILD_PATH/frameworks"
XCFRAMEWORK_NAME="$LIB_NAME.xcframework"
XCFRAMEWORK_ZIP="$XCFRAMEWORK_NAME.zip"
XCFRAMEWORK_PATH="$BUILD_PATH/$XCFRAMEWORK_NAME"
XCFRAMEWORK_ZIP_PATH="$BUILD_PATH/$XCFRAMEWORK_ZIP"
rm $XCFRAMEWORK_ZIP_PATH

cp -a "Sources/$LIB_NAME/." "$LIB_NAME"

SCHEMES=( SwiftUIPager_Catalyst SwiftUIPager_macOS SwiftUIPager_iOS SwiftUIPager_watchOS SwiftUIPager_tvOS )
PLATFORMS=(
  ""
  "generic/platform=macOS"
  "generic/platform=iOS;generic/platform=iOS Simulator"
  "generic/platform=watchOS;generic/platform=watchOS Simulator"
  "generic/platform=tvOS;generic/platform=tvOS Simulator"
)
ARCHIVES=(
  "$LIB_NAME.macCatalyst.xcarchive"
  "$LIB_NAME.macos.xcarchive"
  "$LIB_NAME.iOS.xcarchive;$LIB_NAME.iOS-simulator.xcarchive"
  "$LIB_NAME.watchOS.xcarchive;$LIB_NAME.watchOS-simulator.xcarchive" 
  "$LIB_NAME.tvOS.xcarchive;$LIB_NAME.tvOS-simulator.xcarchive"
)

COMMAND="xcodebuild -create-xcframework "
xcodebuild clean -project $PROJ_PATH

for i in ${!SCHEMES[@]}; do
  IFS=";" read -r -a PLATFORM <<< "${PLATFORMS[i]}"
  IFS=";" read -r -a ARCHIVE <<< "${ARCHIVES[i]}"
  
  for j in ${!ARCHIVE[@]}; do
    ARCHIVE_PATH="$FRAMEWORKS_PATH/${ARCHIVE[$j]}"
    echo "[LOG] Archiving ${SCHEMES[$i]}. Destination ${PLATFORM[$j]}"
    if [ -z "${PLATFORM[$j]}" ]; then
      xcodebuild archive  -scheme ${SCHEMES[$i]} \
                          -project $PROJ_PATH \
                          -archivePath $ARCHIVE_PATH \
                          SKIP_INSTALL=NO \
                          BUILD_LIBRARY_FOR_DISTRIBUTION=YES | xcpretty
    else
      xcodebuild archive  -scheme ${SCHEMES[$i]} \
                          -project $PROJ_PATH \
                          -destination "${PLATFORM[$j]}" \
                          -archivePath $ARCHIVE_PATH \
                          SKIP_INSTALL=NO \
                          BUILD_LIBRARY_FOR_DISTRIBUTION=YES | xcpretty
    fi

    COMMAND="$COMMAND -framework $ARCHIVE_PATH/Products/Library/Frameworks/$LIB_NAME.framework"
  done

done
COMMAND="$COMMAND -output $XCFRAMEWORK_PATH"
$COMMAND | xcpretty
rm -rd $FRAMEWORKS_PATH
cd $BUILD_PATH
zip -r -X $XCFRAMEWORK_ZIP $XCFRAMEWORK_NAME
rm -rd $XCFRAMEWORK_NAME
cd ..
echo ::set-output name=path::$XCFRAMEWORK_ZIP_PATH
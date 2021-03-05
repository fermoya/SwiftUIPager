gem install xcpretty

SCHEMES=( SwiftUIPager_Catalyst SwiftUIPager_macOS SwiftUIPager_iOS SwiftUIPager_watchOS SwiftUIPager_tvOS )
PLATFORMS=( "platform=macOS,variant=Mac Catalyst" "platform=macOS" "generic/platform=iOS" "generic/platform=watchOS" "generic/platform=tvOS" )
if $SKIP_CATALYST; then
  echo "** Skiping Building for Catalyst **"
  SCHEMES=( SwiftUIPager_macOS SwiftUIPager_iOS SwiftUIPager_watchOS SwiftUIPager_tvOS )
  PLATFORMS=( "platform=macOS" "generic/platform=iOS" "generic/platform=watchOS" "generic/platform=tvOS" )
fi

rm -rd $DIR
for i in ${!SCHEMES[@]}; do
  xcodebuild clean build  -scheme ${SCHEMES[$i]} \
                          -project SwiftUIPager.xcodeproj \
                          -destination "${PLATFORMS[$i]}" || exit 1
done
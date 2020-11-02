gem install xcpretty

SCHEMES=( SwiftUIPager_Catalyst SwiftUIPager_macOS SwiftUIPager_iOS SwiftUIPager_watchOS SwiftUIPager_tvOS )
PLATFORMS=( "platform=macOS,variant=Mac Catalyst" "platform=macOS" "generic/platform=iOS" "generic/platform=watchOS" "generic/platform=tvOS" )
DIR=$(xcodebuild -project SwiftUIPager.xcodeproj -showBuildSettings | grep -m 1 "BUILD_DIR" | grep -oEi "\/.*")
rm -rd $DIR

for i in ${!SCHEMES[@]}; do
  xcodebuild clean build  -scheme ${SCHEMES[$i]} \
                          -project SwiftUIPager.xcodeproj \
                          -destination "${PLATFORMS[$i]}" | xcpretty

  COUNT=$(find $DIR -maxdepth 1 -type d | wc -l)
  if [ $COUNT -eq 2 ]; then
    echo "$(tput setaf 2)Build succeded for target ${SCHEMES[$i]}$(tput sgr0)"
  else
    echo "$(tput setaf 1)Build failed for target ${SCHEMES[$i]}$(tput sgr0)"
    exit 1
  fi
done
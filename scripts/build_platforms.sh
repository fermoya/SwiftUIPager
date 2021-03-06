DESTINATIONS=${DESTINATION:-all}

echo "DESTINATIONS -> $DESTINATIONS"

case "$DESTINATIONS" in
  *all*) DESTINATIONS=( catalyst macos ios watchos tvos );;
  *) IFS=";" read -r -a DESTINATIONS <<< "$DESTINATIONS";;
esac

build_target() {
  xcodebuild clean build  -scheme $1 \
                          -project SwiftUIPager.xcodeproj \
                          -destination "$2" || exit 1  
}

for i in ${!DESTINATIONS[@]}; do
  echo "${DESTINATIONS[$i]}"
  case "${DESTINATIONS[$i]}" in
    *ios*) build_target SwiftUIPager_iOS "generic/platform=iOS";;
    *macos*) build_target SwiftUIPager_macOS "platform=macOS";;
    *catalyst*) build_target SwiftUIPager_Catalyst "platform=macOS,variant=Mac Catalyst";;
    *watchos*) build_target SwiftUIPager_watchOS "generic/platform=watchOS";;
    *tvos*) build_target SwiftUIPager_tvOS "generic/platform=tvOS";;
    *) build_target SwiftUIPager_iOS "${DESTINATIONS[$i]}";;
  esac
done
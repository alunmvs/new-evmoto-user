build-apk-split:
	flutter build apk --split-per-abi
build-apk:
	flutter build apk
build-appbundle:
	flutter test test/ --reporter expanded && flutter build appbundle --release
scan-unused-assets:
	dart run unused_assets_removal --dry-run
delete-unused-assets:
	dart run unused_assets_removal --delete
clean-cache-ios:
	flutter clean && flutter pub get && cd ios && rm -rf Pods Podfile.lock && rm -rf ~/Library/Developer/Xcode/DerivedData && pod install
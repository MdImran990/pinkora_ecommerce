# Release checklist (Android)

Run every command from the project folder.

## 1. App name and internet permission
Open `android/app/src/main/AndroidManifest.xml`:
- Put this line just above `<application ...>`:
  `<uses-permission android:name="android.permission.INTERNET" />`
  (without it product images and the API do not work in the release APK)
- Change `android:label="pinkora_ecommerce"` to `android:label="Pinkora"`.

## 2. Launcher icon (already designed)
The icon files are in `assets/icon/`. Generate all sizes with:

    flutter pub get
    dart run flutter_launcher_icons

## 3. Package id (replace com.example.pinkora_ecommerce)
Choose your own id, for example `com.pinkora.shop`:

    dart pub add --dev change_app_package_name
    dart run change_app_package_name:main com.pinkora.shop

## 4. Signing key (once)
    keytool -genkey -v -keystore %USERPROFILE%\pinkora-release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias pinkora

Create `android/key.properties`:

    storePassword=YOUR_PASSWORD
    keyPassword=YOUR_PASSWORD
    keyAlias=pinkora
    storeFile=C:\\Users\\YOUR_NAME\\pinkora-release.jks

Then follow "Sign the app" in the Flutter docs
(docs.flutter.dev/deployment/android) to add the `signingConfigs` block to
`android/app/build.gradle(.kts)`. Keep the .jks file and passwords safe -
you need the same key for every update.

## 5. Build
    flutter build appbundle      (for the Play Store)
    flutter build apk --release  (to install directly on a phone)

Files are created in `build/app/outputs/`.

## 6. Before you publish
- Replace the mock/demo data and the demo product photos with your own.
- Add a Privacy Policy page/link (the Play Store asks for it).
- Update `version:` in `pubspec.yaml` for every new release (1.0.1+2 ...).

<p align='center'>
  <img height='96' src='https://raw.githubusercontent.com/probablykasper/notifier/master/logo/logo.png'>
</p>
<div align='center'>

# Notifier
A notification scheduling Android app with support for repeating notifications.

</div>


<p align='center'>
  <img height='350' src='https://raw.githubusercontent.com/probablykasper/notifier/master/screenshots/1.jpg'>
  <img height='350' src='https://raw.githubusercontent.com/probablykasper/notifier/master/screenshots/2.jpg'>
  <img height='350' src='https://raw.githubusercontent.com/probablykasper/notifier/master/screenshots/3.jpg'>
</p>

</div>

## Getting Started

1. Install Flutter
2. Run `flutter pub get`

All you really need is to [install Flutter](https://flutter.dev/docs/get-started/install). Just run `flutter run` to start debugging the app, like you would with any Flutter app.

The app is built using the [scoped_model](https://pub.dev/packages/scoped_model) package, which is worth knowing about. Other than that, it pretty much works like any basic Flutter app, so there's not much else that needs to be said.

### Generate app icon

I used the `flutter_launcher_icons` package for that, so follow [these instructions](https://pub.dev/packages/flutter_launcher_icons).

### Build

Follow [these steps](https://flutter.dev/docs/deployment/android).

### Releasing a new version

1. Specify a version and build number in `pubspec.yaml`, or use `--build-name` and `--build-number`
2. Generate Android apk: `flutter build apk`
3. Rename the output file to `notifier-x.y.z.apk`
4. Commit with the message `x.y.z` and add a tag/release to it with the output file attached.

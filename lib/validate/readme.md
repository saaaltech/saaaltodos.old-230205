# Why validate here rather than widget test?

Flutter cannot support widget test with theme mode and locale in `MaterialApp`
yet. All platform brightness will be `Brightness.light` and it will not change
in test environment. So that validation of those features can only be write and
view in real app.

All those widgets in this folder are not included in the app source code. But
you can introduce them into the app temporarily for testing.

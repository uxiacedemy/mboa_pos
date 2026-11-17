# Web regression checklist

Run from `C:\Users\EVERMATE\Desktop\mboa_pos` using the configured Flutter SDK wrapper.

## Automated gate

```text
cmd.exe /d /c "C:\Users\EVERMATE\flutter\bin\flutter.bat analyze"
cmd.exe /d /c "C:\Users\EVERMATE\flutter\bin\flutter.bat test"
cmd.exe /d /c "C:\Users\EVERMATE\flutter\bin\flutter.bat build web"
```

## Browser smoke test

1. Open `https://mboapos.web.app/#/login`.
2. Confirm the page loads without a blank screen or Firebase JavaScript error.
3. Confirm Staff/Owner mode switching, validation, and registration navigation render.
4. With a configured test account, confirm protected-route redirect and session restoration.
5. Confirm the desktop POS layout, catalog search/filter, cart, checkout review, receipt screen, PDF share, and print fallback.
6. Refresh the browser and confirm the expected auth/local state is retained without crossing tenant context.
7. Repeat after every shared-code change.

## Current baseline

- Flutter analyze: passed with no issues.
- Flutter tests: 7 passed.
- Flutter Web build: passed; the standard Wasm compatibility dry run reports dependency warnings, but the JavaScript Web build succeeds.
- Drift Web worker and SQLite WASM assets are included in `build/web`.
- Browser runtime smoke test: not performed in this change set.
- Full authenticated production checkout: not verified; local emulator integration passes, but production Functions and credentials are not confirmed.

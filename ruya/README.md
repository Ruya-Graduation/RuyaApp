# ruya

A new Flutter project.

## Deploy to GitHub Pages

The `Deploy Flutter Web` workflow deploys the `main` branch to GitHub Pages.

1. In the repository settings, open **Pages** and set **Source** to **GitHub Actions**.
2. Add a repository secret named `WEB_BASE_URL` containing only the HTTPS backend URL,
   for example `https://ruya.runasp.net`.
3. Push to `main`, or run the workflow manually from the **Actions** tab.

## Local web dev

```sh
cp env.json.example env.json   # then fill in BASE_URL
flutter run -d chrome --dart-define-from-file=env.json
```

## Local web build

```sh
flutter build web --release --dart-define-from-file=env.json
```

Mobile/desktop development is unchanged: copy `.env.example` to `.env`, fill in
`BASE_URL`, and run normally.

The deployed site is available at `https://ruya-graduation.github.io/RuyaApp/`.

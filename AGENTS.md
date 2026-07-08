# Repository Guidelines

## Repository Context

This repository is a personal fork of the upstream Commet project. Keep fork-specific changes clearly documented, scoped, and easy to compare against upstream when rebasing or contributing patches back.

## Project Structure & Module Organization

This is a Dart/Flutter workspace. The main Matrix client lives in `commet/`, with application code in `commet/lib`, assets in `commet/assets`, web entry files in `commet/web`, unit tests in `commet/unit_test`, and integration tests in `commet/integration_test`. Shared UI components are in `tiamat/`. Widget packages are under `widgets/`, including `widgets/calendar` and `widgets/matrix_widget_api`. Rust support code lives in `rust/`, and release/build scripts are in `commet/scripts` plus repository-level helper scripts in `scripts/`.

## Build, Test, and Development Commands

- `cd commet && flutter pub get`: fetch Dart dependencies for the app.
- `cd commet && dart run scripts/codegen.dart`: regenerate generated Dart/Rust bridge and localization-related files before builds.
- `cd commet && flutter run --dart-define BUILD_MODE=debug --dart-define PLATFORM=linux`: run the app locally on Linux.
- `./scripts/docker-build-web.sh`: build the Flutter web app in Docker and export artifacts to `build/docker-web`.
- `cd commet && ./scripts/unit-test.sh`: run the app unit test script with the configured Flutter test command.
- `cd commet && flutter analyze`: run static analysis using `analysis_options.yaml`.

## Coding Style & Naming Conventions

Use standard Dart formatting: two-space indentation, `lowerCamelCase` for variables and methods, `UpperCamelCase` for types, and `snake_case.dart` file names. Run `dart format` on edited Dart files. Keep generated files out of manual edits; rerun codegen instead. Follow the existing analyzer configuration, including exclusions for generated files and integration tests.

## Testing Guidelines

Place app unit tests in `commet/unit_test` and integration coverage in `commet/integration_test`. Name test files with the `_test.dart` suffix. Prefer focused tests near the behavior being changed, and run `./scripts/unit-test.sh` or targeted `flutter test` commands before submitting changes. For web build changes, verify `./scripts/docker-build-web.sh` completes successfully.

## Commit & Pull Request Guidelines

Recent history uses short, imperative commit subjects such as `Add Docker web build workflow` and `Fix small ui bugs (#1018)`. Keep commits scoped and descriptive. Pull requests should explain the change, link relevant issues, list test/build commands run, and include screenshots or screen recordings for visible UI changes.

## Security & Configuration Tips

Do not commit local secrets, signing keys, generated build outputs, or machine-specific configuration. The Docker web build is intended to avoid installing Flutter, Rust, and native build libraries on the host; prefer it for local web release verification. Respect `CONTRIBUTING.md`: AI-assisted changes must be understood, reviewed, and technically justified by the contributor.

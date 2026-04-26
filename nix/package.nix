{
  lib,
  stdenv,
  inputs,
  rustPlatform,
  typescript,
  fetchNpmDeps,
  cargo-tauri,
  deepfilternet,
  glib-networking,
  nodejs,
  npmHooks,
  openssl,
  pkg-config,
  webkitgtk_4_1,
  wrapGAppsHook4,
  libayatana-appindicator,
  librsvg,
  patchelf,
  alsa-lib,
  protobuf,
  libsoup_3,
  libopus,
  gst_all_1,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fancy-mumble";
  version = "0.2.1";

  src = inputs.self;

  prePatch = "cp Cargo.lock ${finalAttrs.cargoRoot}";

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    src = "${finalAttrs.src}/${finalAttrs.npmRoot}";
    hash = "sha256-FJbnPjGMkdU9OjvJoqgIvxrfQnpsokl4ekDss8UpM1A=";
  };

  cargoLock = {
    lockFile = ../Cargo.lock;

    outputHashes = {
      "deep_filter-0.5.7-pre" = "sha256-Wt31V+zMWa5EXZA+N3kmw6dX3nOGNhafSLRWQzB4R2k=";
    };
  };

  nativeBuildInputs = [
    protobuf
    nodejs
    typescript
    npmHooks.npmConfigHook

    cargo-tauri.hook

    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ wrapGAppsHook4 ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    glib-networking
    openssl
    webkitgtk_4_1
    libayatana-appindicator
    librsvg
    patchelf
    alsa-lib
    libsoup_3
    libopus
    deepfilternet
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
  ];

  cargoRoot = "crates/mumble-tauri";
  npmRoot = "${finalAttrs.cargoRoot}/ui";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  env.SKIP_SIGNAL_BRIDGE = 1;
})

{
  perSystem =
    {
      self',
      lib,
      pkgs,
      ...
    }:
    {

      devShells.default = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          self'.packages.toolchain
          cargo-tauri
          pkg-config
          nodejs
          cmake
          gcc
          protobuf
        ];

        buildInputs = with pkgs; [
          webkitgtk_4_1
          libayatana-appindicator
          librsvg
          patchelf
          alsa-lib
          gtk3
          libsoup_3
          libopus
          gst_all_1.gstreamer
          gst_all_1.gst-plugins-base
          gst_all_1.gst-plugins-good
        ];

        env.LD_LIBRARY_PATH = lib.makeLibraryPath [
          pkgs.libayatana-appindicator
        ];
      };
    };
}

{
  lib,
  pkgs,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
}:
let
  cargo_lock = builtins.readFile ./Cargo.lock;
in
pkgs.buildFHSUserEnv {
  name = "bazel-lsp";
  targetPkgs = pkgs:  (with pkgs; [
    cargo
    cargo-edit
    openssl
    pkg-config
    bazelisk
    zlib
  ]);
  multiPkgs = pkgs: (with pkgs; [
    zlib
  ]);
  extraInstallCommands = ''
  bazelisk build //:bazel-lsp -c opt
  '';
  runScript = ''
  bazel-bin/bazel-lsp
  '';
}

# stdenv.mkDerivation {
  # name = "bazel-lsp";
  # version = "0.6.4";
  # buildInputs = [
    # (pkgs.buildFHSUserEnv {
       # name = "bazel-lsp-build-env";
       # targetPkgs = pkgs: (with pkgs; [
         # cargo
         # cargo-edit
         # pkg-config
         # bazelisk
         # zlib
       # ]);
       # multiPkgs = pkgs: (with pkgs; [
         # zlib
       # ]); 
    # }).env
  # ];
  # shellHook = ''
    
  # '';
# }
# rustPlatform.buildRustPackage rec {
  # pname = "bazel-lsp";
  # version = "0.6.4";

  # src = fetchFromGitHub {
    # owner = "cameron-martin";
    # repo = pname;
    # rev = "d422cc3caeee994cc4f6e953db97190cc734730c";
    # sha256 = "sha256-dgrUlUKVlAJNqdrSdJPWyDCpaCYHG3Dy8juQzoNjK1w=";
  # };
  # cargoHash = "";
  # cargoLock = {
    # lockFile = cargo_lock;
    # outputHashes = {
      # "allocative-0.3.4" = "sha256-0RU6huDTpFq8wKf3yY4xOsG8EuLX8OAv7JZnXZBp50k=";
    # };
  # };
  # cargoPatches = [
  # ];

  # meta = with lib; {
    # description = "A bazel language server written in rust";
    # homepage = "https://github.com/cameron-martin/bazel-lsp";
    # license = with licenses; [mit];
    # mainProgram = "bazel-lsp";
  # };
# }

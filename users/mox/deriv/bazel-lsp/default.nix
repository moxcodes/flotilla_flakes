{
  lib,
  pkgs,
  stdenv,
  writeScript,
  pkg-config,
}:
let
  cargo_lock = builtins.readFile ./Cargo.lock;
in
pkgs.buildFHSEnv {
  name = "bazel-lsp";
  targetPkgs = pkgs:  (with pkgs; [
    wget
    unzip
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
  runScript = writeScript "build-and-run-bazel-lsp" ''
  if ! [ -f $HOME/.bazel-lsp/bazel-lsp-0.6.4/bazel-bin/bazel-lsp ]; then
    echo "bazel-lsp not yet built (needs to build at invocation, sorry...)"
    mkdir -p $HOME/.bazel-lsp/
    cd $HOME/.bazel-lsp
    echo "downloading from github..."
    wget https://github.com/cameron-martin/bazel-lsp/archive/refs/tags/v0.6.4.zip > /dev/null
    echo "decompressing..."
    unzip v0.6.4.zip > /dev/null
    cd bazel-lsp-0.6.4
    echo "building..."
    bazelisk build //:bazel-lsp -c opt
    echo "build complete. Future invocations won't have to do this nonsense."
  fi
  $HOME/.bazel-lsp/bazel-lsp-0.6.4/bazel-bin/bazel-lsp $@
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

{
  lib,
  pkgs,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
}:
let
  cargo_lock = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/azdavis/rjsonnet/896e5d1b6d460cfce1ec20b021dd80b8ed9602fe/Cargo.lock";
    sha256 = "1rsfv54mg9zyx7jk7myzdkn0swl8b5j65ad1zq6f9qz84ydwl1sq";
  };
in
rustPlatform.buildRustPackage rec {
  pname = "rjsonnet";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "azdavis";
    repo = pname;
    rev = "896e5d1b6d460cfce1ec20b021dd80b8ed9602fe";
    sha256 = "sha256-vamJquXmx1W31dHK8cDQ81ATELEYh08PGc6N3yI/nhk=";
  };

  # buildInputs = [
  #   (
  #     rustPlatform.buildRustPackage rec {
  #     pname = "language-util";
  #     version = "0.1.0";

  #     src = fetchFromGitHub {
  #       owner = "azdavis";
  #       repo = pname;
  #       rev = "df3c0d816fe6c5f5bec2a7ef43577becdbd9f665";
  #       sha256 = "";
  #     };

  #     cargoHash = "";
  
  #     meta = with lib; {
  #       description = "Language utilities";
  #       homepage = "https://github.com/azdavis/language-util";
  #       license = with licenses; [mit];
  #     };
  
  #     })
  # ];

  checkFlags = [
    "--skip=repo::no_debugging"
    "--skip=repo::architecture"
    "--skip=repo::rs_file_comments"
    "--skip=repo::changelog"
  ];
  cargoHash = "";
  cargoLock = {
    lockFile = cargo_lock;
    outputHashes = {
      "always-0.1.0" = "sha256-X/eUp5KbZ/6fuzskKTD4kWJSy7QK2A+1lMTyasr6e20=";
      "apply-changes-0.1.0" = "sha256-X/eUp5KbZ/6fuzskKTD4kWJSy7QK2A+1lMTyasr6e20=";
      "char-name-0.1.0" = "sha256-X/eUp5KbZ/6fuzskKTD4kWJSy7QK2A+1lMTyasr6e20=";
      "diagnostic-0.1.0" = "sha256-X/eUp5KbZ/6fuzskKTD4kWJSy7QK2A+1lMTyasr6e20=";
      "event-parse-0.1.0" = "sha256-X/eUp5KbZ/6fuzskKTD4kWJSy7QK2A+1lMTyasr6e20=";
      "fast-hash-0.1.0" = "sha256-X/eUp5KbZ/6fuzskKTD4kWJSy7QK2A+1lMTyasr6e20="; 
      "identifier-case-0.1.0" = "sha256-X/eUp5KbZ/6fuzskKTD4kWJSy7QK2A+1lMTyasr6e20=";
      "idx-0.1.0" = "sha256-X/eUp5KbZ/6fuzskKTD4kWJSy7QK2A+1lMTyasr6e20=";
      "paths-0.1.0" = "sha256-X/eUp5KbZ/6fuzskKTD4kWJSy7QK2A+1lMTyasr6e20=";
      "str-process-0.1.0" = "sha256-X/eUp5KbZ/6fuzskKTD4kWJSy7QK2A+1lMTyasr6e20=";
      "syntax-gen-0.1.0" = "sha256-X/eUp5KbZ/6fuzskKTD4kWJSy7QK2A+1lMTyasr6e20=";
      "text-pos-0.1.0" = "sha256-X/eUp5KbZ/6fuzskKTD4kWJSy7QK2A+1lMTyasr6e20=";
      "text-size-util-0.1.0" = "sha256-X/eUp5KbZ/6fuzskKTD4kWJSy7QK2A+1lMTyasr6e20=";
      "token-0.1.0" = "sha256-X/eUp5KbZ/6fuzskKTD4kWJSy7QK2A+1lMTyasr6e20=";
      "topo-sort-0.1.0" = "sha256-X/eUp5KbZ/6fuzskKTD4kWJSy7QK2A+1lMTyasr6e20=";
      "uniq-0.1.0" = "sha256-X/eUp5KbZ/6fuzskKTD4kWJSy7QK2A+1lMTyasr6e20=";
      "write-rs-tokens-0.1.0" = "sha256-X/eUp5KbZ/6fuzskKTD4kWJSy7QK2A+1lMTyasr6e20=";
    };
  };
  
  meta = with lib; {
    description = "A jsonnet language server written in rust";
    homepage = "https://github.com/azdavis/rjsonnet";
    license = with licenses; [mit];
    mainProgram = "rjsonnet";
  };
}

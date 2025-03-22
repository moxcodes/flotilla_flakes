{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
}:
rustPlatform.buildRustPackage rec {
  pname = "rjsonnet";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "azdavis";
    repo = pname;
    rev = version;
    sha256 = "";
  };

  cargoSha256 = "";

  meta = with lib; {
    description = "A jsonnet language server written in rust";
    homepage = "https://github.com/azdavis/rjsonnet";
    license = with licenses; [mit];
    mainProgram = "rjsonnet";
  };
}

{ lib, stdenv, fetchFromGitHub, rustPlatform, libxkbcommon, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "multibg-sway";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "gergo-salyi";
    repo = pname;
    rev = version;
    sha256 = "sha256-3Fk6z+SgGOcjoagl7C0+yQCkCNEEqTLfbMf9IsAfPzk=";
  };

  cargoSha256 = "sha256-I2DdmnzXSNhuUI1kNcs89oUCg/9mK3pzxkiTKs51oII=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libxkbcommon ];

  meta = with lib; {
    description = "A rust tool for setting different wallpapers for each workspace in Sway";
    homepage = "https://github.com/gergo-salyi/multibg-sway";
    license = with licenses; [ mit ];
    mainProgram = "multibg-sway";
  };
}
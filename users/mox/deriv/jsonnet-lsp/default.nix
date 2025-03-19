{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  pkg-config,
  go
}:
buildGoModule rec {
  pname = "jsonnet-lsp";
  version = "0.2.12";

  src = fetchFromGitHub {
    owner = "carlverge";
    repo = pname;
    rev = "b2be5205452fa8aa061d4e7e78a3a78942cdf60a";
    sha256 = "sha256-WwC5NQWSnn5pO/uhj8gES50ha0ATtKXjtauuji8gssg=";
  };

  vendorHash = "sha256-YDnyVcsgGF9JbzabRV2P7JnUv/wlTJWsBMNtEc2kN90=";
  
  meta = with lib; {
    description = "Jsonnet LSP written in golang";
    homepage = "https://github.com/carlverge/jsonnet-lsp";
    license = with licenses; [mit];
    mainProgram = "jsonnet-lsp";
  };
}

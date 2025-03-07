{
  lib,
  pkgs,
  buildPythonPackage,
  fetchPypi,
  huggingface-hub,
}:
buildPythonPackage rec {
  pname = "diffusers";
  version = "0.16.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TNdAA4LIbYXghCVVDeGxqB1O0DYj+9S82Dd4ZNnEbv4=";
  };

  propagatedBuildInputs = with pkgs.python3Packages; [filelock huggingface-hub importlib-metadata numpy pip pillow setuptools regex wheel];
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/huggingface/diffusers";
    description = "Diffusers: State-of-the-art diffusion models for image and audio generation in PyTorch";
  };
}

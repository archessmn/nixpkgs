{ lib, mkDerivation, fetchFromGitHub, ghcWithPackages, nixosTests }:

mkDerivation rec {
  pname = "standard-library";
  version = "2.1";

  src = fetchFromGitHub {
    repo = "agda-stdlib";
    owner = "agda";
    rev = "v${version}";
    hash = "sha256-tv/Fj8ZJgSvieNLlXBjyIR7MSmDp0e2QbN1d/0xBpFg=";
  };

  nativeBuildInputs = [ (ghcWithPackages (self : [ self.filemanip ])) ];
  preConfigure = ''
    runhaskell GenerateEverything.hs --include-deprecated
    # We will only build/consider Everything.agda, in particular we don't want Everything*.agda
    # do be copied to the store.
    rm EverythingSafe.agda
  '';

  passthru.tests = { inherit (nixosTests) agda; };
  meta = with lib; {
    homepage = "https://wiki.portal.chalmers.se/agda/pmwiki.php?n=Libraries.StandardLibrary";
    description = "Standard library for use with the Agda compiler";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with maintainers; [ jwiegley mudri alexarice turion ];
  };
}

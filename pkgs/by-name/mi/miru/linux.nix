{
  fetchurl,
  appimageTools,

  pname,
  version,
  meta,
  passthru,
}:

appimageTools.wrapType2 rec {
  inherit
    pname
    version
    meta
    passthru
    ;

  src = fetchurl {
    url = "https://github.com/ThaUnknown/miru/releases/download/v${version}/linux-Miru-${version}.AppImage";
    name = "${pname}-${version}.AppImage";
    hash = "sha256-wnqCKnZKt0Fj8TasdRVzI558W7aIB5FLkcDEiZfz3ZQ=";
  };

  extraInstallCommands =
    let
      contents = appimageTools.extractType2 { inherit pname version src; };
    in
    ''
      mkdir -p "$out/share/applications"
      mkdir -p "$out/share/lib/miru"
      cp -r ${contents}/{locales,resources} "$out/share/lib/miru"
      cp -r ${contents}/usr/* "$out"
      cp "${contents}/${pname}.desktop" "$out/share/applications/"
      substituteInPlace $out/share/applications/${pname}.desktop --replace 'Exec=AppRun' 'Exec=${pname}'
    '';
}

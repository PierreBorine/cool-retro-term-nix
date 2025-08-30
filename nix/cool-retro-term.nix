{ lib
, stdenv
, qtbase
, qmltermwidget
, qtquickcontrols2
, qtgraphicaleffects
, wrapQtAppsHook
, qmake
, nixosTests
}:
stdenv.mkDerivation {
  pname = "cool-retro-term";
  version = "1.2.0";

  src = ../.;

  patchPhase = ''
    sed -i -e '/qmltermwidget/d' cool-retro-term.pro
  '';

  buildInputs = [
    qtbase
    qmltermwidget
    qtquickcontrols2
    qtgraphicaleffects
    wrapQtAppsHook
  ];

  nativeBuildInputs = [ qmake ];

  installFlags = [ "INSTALL_ROOT=$(out)" ];

  preFixup = ''
    mv $out/usr/share $out/share
    mv $out/usr/bin $out/bin
    rmdir $out/usr
  '' + lib.optionalString stdenv.hostPlatform.isDarwin ''
    ln -s $out/bin/cool-retro-term.app/Contents/MacOS/cool-retro-term $out/bin/cool-retro-term
  '';

  passthru.tests.test = nixosTests.terminal-emulators.cool-retro-term;

  meta = {
    description = "Terminal emulator which mimics the old cathode display";
    longDescription = ''
      cool-retro-term is a terminal emulator which tries to mimic the look and
      feel of the old cathode tube screens. It has been designed to be
      eye-candy, customizable, and reasonably lightweight.
    '';
    homepage = "https://github.com/PierreBorine/cool-retro-term";
    license = lib.licenses.gpl3Plus;
    platforms = with lib.platforms; linux ++ darwin;
    mainProgram = "cool-retro-term";
  };
}

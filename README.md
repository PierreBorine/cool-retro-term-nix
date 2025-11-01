# cool-retro-term

|> Default Amber|C:\ IBM DOS|$ Default Green|
|---|---|---|
|![Default Amber Cool Retro Term](https://user-images.githubusercontent.com/121322/32070717-16708784-ba42-11e7-8572-a8fcc10d7f7d.gif)|![IBM DOS](https://user-images.githubusercontent.com/121322/32070716-16567e5c-ba42-11e7-9e64-ba96dfe9b64d.gif)|![Default Green Cool Retro Term](https://user-images.githubusercontent.com/121322/32070715-163a1c94-ba42-11e7-80bb-41fbf10fc634.gif)|

## 🔧 Fork
- Merged a couple fixes from other people
- Rewriten the config system so it is located in ~/.config as plain files instead of sqlite json
- Provide a Nix flake for easy installation and profile configuration

## ❄️ Nix
This fork provides a Nix flake containing a **package**, an **overlay** and a **Home Manager module**.

### Usage
Add this flake to your inputs.
```Nix
inputs.cool-retro-term = {
  url = "github:PierreBorine/cool-retro-term-nix";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

The package can be obtained using any of these
```Nix
inputs.cool-retro-term.packages.${system}.default
inputs.cool-retro-term.packages.${system}.cool-retro-term
inputs.cool-retro-term.packages.${system}.crt
```

The Home Manager module can be used like this
```Nix
# home-manager.nix
{inputs, ...}: {
  imports = [inputs.cool-retro-term.homeManagerModules.default];

  programs.cool-retro-term = {
    enable = true;
    profiles = [
      # Import a simple json file
      # You can easily create a theme from inside
      # the app, export it as json and add it here.
      ./pink.json

      # Or use an attribute set with the following attributes.
      {
        name = "My nice profile";
        options = {
          backgroundColor = "#000000";
          fontColor = "#0ccc68";
          frameColor = "#ffffff";
          flickering = 0.1;
          horizontalSync = 0.08;
          staticNoise = 0.048;
          chromaColor = 0;
          saturationColor = 0;
          frameGloss = 0;
          screenCurvature = 0.3;
          glowingLine = 0;
          burnIn = 0.2517;
          bloom = 0.5538;
          rasterization = 0;
          jitter = 0.1033;
          rbgShift = 0;
          brightness = 0.5;
          contrast = 0.7959;
          ambientLight = 0.2;
          windowOpacity = 1;
          fontName = "TERMINUS_SCALED";
          fontWidth = 1;
          margin = 0.5;
          blinkingCursor = false;
          frameMargin = 0.1;
        };
      }
    ];
  };
}
```

## Original description
cool-retro-term is a terminal emulator which mimics the look and feel of the old cathode tube screens.
It has been designed to be eye-candy, customizable, and reasonably lightweight.

It uses the QML port of qtermwidget (Konsole): https://github.com/Swordfish90/qmltermwidget.

This terminal emulator works under Linux and macOS and requires Qt5. It's suggested that you stick to the latest LTS version.

Settings such as colors, fonts, and effects can be accessed via context menu.

## Screenshots
![Image](<https://i.imgur.com/TNumkDn.png>)
![Image](<https://i.imgur.com/hfjWOM4.png>)
![Image](<https://i.imgur.com/GYRDPzJ.jpg>)

## Install

If you want to get a hold of the latest version, just go to the Releases page and grab the latest AppImage (Linux) or dmg (macOS).

Alternatively, most distributions such as Ubuntu, Fedora or Arch already package cool-retro-term in their official repositories.

## Building

Check out the wiki and follow the instructions on how to build it on [Linux](https://github.com/Swordfish90/cool-retro-term/wiki/Build-Instructions-(Linux)) and [macOS](https://github.com/Swordfish90/cool-retro-term/wiki/Build-Instructions-(macOS)).

self: {
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types literalExample mkIf removeSuffix;
  cfg = config.programs.cool-retro-term;

  profileSubmodule = types.submodule {
    options = {
      name = mkOption {
        type = types.str;
        description = "The profile's name";
      };
      options = mkOption {
        type = types.attrs;
        description = "The profile's options";
      };
    };
  };
in {
  options.programs.cool-retro-term = {
    enable = mkEnableOption "Whether to install a cool-retro-term fork with ability to configure using Nix";
    profiles = mkOption {
      type = with types; listOf (either path profileSubmodule);
      default = [];
      example = literalExample [
        ./retroStyle.json
        {
          name = "My nice style";
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
      description = ''
        List of profiles. Either a json or a submodule (see example).
        You could create a profile from inside the app then export it as a file.
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = [self.packages.${pkgs.system}.cool-retro-term];

    xdg.configFile = builtins.listToAttrs (builtins.map (x: let
        name =
          if (builtins.typeOf x) == "path"
          then removeSuffix ".json" (builtins.baseNameOf x)
          else x.name;
      in {
        name = "cool-retro-term/profiles/${name}.json";
        value.text = builtins.toJSON {
          text = name;
          obj_string =
            if (builtins.typeOf x) == "path"
            then builtins.readFile x
            else x.options;
          builtin = true;
        };
      })
      cfg.profiles);
  };
}

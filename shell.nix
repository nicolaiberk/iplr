let
    pkgs = import <unstable> { };
    lib = pkgs.lib;
    stdenv = pkgs.stdenv;
in pkgs.mkShell {
    buildInputs = with pkgs; [
    ];
    shellHook =
    ''
        export RENV_PATHS_LIBRARY=renv/library;
        alias rge="rg -g '!{**/migrations/*.py,**/node_modules/**,**/*.json,**/*.csv}'";
        alias rger="rg -g '!{**/migrations/*.py,**/node_modules/**,**/*.json,**/*.csv,**/*.R}'";
    '';
}
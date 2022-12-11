
# see 
# https://flyx.org/nix-flakes-latex/
#
{
  description = "LaTeX master thesis";
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    flake-utils.url = github:numtide/flake-utils;
  };
  outputs = { self, nixpkgs, flake-utils }:
    with flake-utils.lib; eachSystem allSystems (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      tex = pkgs.texlive.combine {
          # I gave up on specifying the needed packages. Instead I just use
          # scheme-full
          inherit (pkgs.texlive) scheme-full latex-bin latexmk
          ;
      };
    in rec {
      packages = {
        document = pkgs.stdenvNoCC.mkDerivation rec {
          name = "latex-thesis";
          # the variable self only contain those files that are checked into version control. 
          src = self;
          buildInputs = [ pkgs.coreutils tex ];
          phases = ["unpackPhase" "buildPhase" "installPhase"];
          # set explicit date with `SOURCE_DATE_EPOCH`
          # `-pretex suppresoptionalinfo` omits an ID from the generated pdf.
          # The ID is calculated based on the system date and time, and the
          # full path of the pdf. Thus it is not reproducible
          buildPhase = ''
            export PATH="${pkgs.lib.makeBinPath buildInputs}";
            mkdir -p .cache/texmf-var
            env TEXMFHOME=.cache TEXMFVAR=.cache/texmf-var \
              SOURCE_DATE_EPOCH=$(date -d "2017-11-24" +%s) \
              latexmk -interaction=nonstopmode -pdf -lualatex \
              -pretex="\pdfvariable suppressoptionalinfo 512\relax" \
              -usepretex report.tex
          '';
          installPhase = ''
            mkdir -p $out
            cp report.pdf $out/
          '';
        };
      };
      defaultPackage = packages.document;
    });
}

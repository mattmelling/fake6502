{
  description = "A library that emulates the 6502";
  outputs = { self, nixpkgs }: {
    defaultPackage.x86_64-linux = self.packages.x86_64-linux.fake6502;
    packages.x86_64-linux.fake6502 = let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
      };
    in pkgs.stdenv.mkDerivation {
      name = "fake6502";
      version = "2.3.0";
      src = ./.;
      installPhase = ''
        mkdir -p $out/{lib,include}
        cp build/*.o $out/lib/
        cp fake6502.h $out/include/
      '';
    };
    devShells.x86_64-linux.default = let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
    in pkgs.mkShell {
      buildInputs = with pkgs; [
        valgrind
        cppcheck
        lcov
      ];
    };
  };
}

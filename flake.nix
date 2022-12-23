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

        mkdir -p $out/lib/pkgconfig
        cp build/*.pc $out/lib/pkgconfig/
        for lib in 6502 2a03 65c02; do
            substituteInPlace $out/lib/pkgconfig/fake$lib.pc \
                --replace /usr $out
        done
      '';
      buildInputs = with pkgs; [
        m4
      ];
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

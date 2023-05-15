with import <nixpkgs> {}; rec {
    pingpogEnv = stdenv.mkDerivation {
        name = "pingpog-env";
        buildInputs = [ nasm qemu gdb ];
    };
}

{ mkShell
, default

, python3Packages
}:
mkShell {
  name = "stable-diffusion-shell";

  packages = [ python3Packages.ipython default.dependencyEnv ];

  shellHook = ''
    ipython
    exit 0
  '';
}

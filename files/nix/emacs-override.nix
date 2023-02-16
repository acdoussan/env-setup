# https://www.heinrichhartmann.com/posts/2021-08-08-nix-emacs/

with (import <nixpkgs> {});

(emacs.override {
     nativeComp = false;
     withX = true;
     withGTK3 = true;
     withXwidgets = true;
}).overrideAttrs (old : {
     pname = "emacs";
     version = "head";
     src = fetchFromGitHub {
        owner = "emacs-mirror";
        repo = "emacs";
        rev = "088425538f2122d88a4f4e132dbb2f1139648531";
        sha256 = "RMBIaAw+BMvF1SaJIMbVNPfRpLCRbHIE+ClXCiTUQs0=";
     };
     configureFlags = old.configureFlags ++ ["--with-json" "--with-tree-sitter" "--with-dbus" "--with-gif" "--with-jpeg" "--with-png" "--with-rsvg" "--with-tiff" "--with-xpm" "-with-gpm=no" "--with-modules" "--with-harfbuzz"];
     preConfigure = "./autogen.sh";
     buildInputs = old.buildInputs ++ [tree-sitter];
})

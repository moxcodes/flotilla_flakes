{
  lib,
  fetchFromGitHub,
}:
let
  mkArgs =
    {
      pname,
      version,
      variant,
      patches ? _: [ ],
      rev,
      hash,
      meta ? { },
    }:
    {
      inherit
        pname
        version
        variant
        patches
        ;

      src =
        {
          "mainline" = fetchFromGitHub {
            owner = "emacs-mirror";
            repo = pname;
            rev = rev;
            sha256 = hash;
          };
        }
        .${variant};

      meta = {
        homepage =
          {
            "mainline" = "https://www.gnu.org/software/emacs/";
          }
          .${variant};
        description =
          "Extensible, customizable GNU text editor";
        longDescription =
          ''
            GNU Emacs is an extensible, customizable text editor—and more. At its core
            is an interpreter for Emacs Lisp, a dialect of the Lisp programming
            language with extensions to support text editing.

            The features of GNU Emacs include: content-sensitive editing modes,
            including syntax coloring, for a wide variety of file types including
            plain text, source code, and HTML; complete built-in documentation,
            including a tutorial for new users; full Unicode support for nearly all
            human languages and their scripts; highly customizable, using Emacs Lisp
            code or a graphical interface; a large number of extensions that add other
            functionality, including a project planner, mail and news reader, debugger
            interface, calendar, and more. Many of these extensions are distributed
            with GNU Emacs; others are available separately.
          '';
        changelog =
          {
            "mainline" = "https://www.gnu.org/savannah-checkouts/gnu/emacs/news";
          }
          .${variant};
        license = lib.licenses.gpl3Plus;
        maintainers =
          {
            "mainline" = with lib.maintainers; [
              AndersonTorres
              adisbladis
              jwiegley
              lovek323
              matthewbauer
            ];
          }
          .${variant};
        platforms =
          {
            "mainline" = lib.platforms.all;
          }
          .${variant};
        mainProgram = "emacs";
      } // meta;
    };
in
{
  emacs31 = import ./make-emacs.nix (mkArgs {
    pname = "emacs";
    version = "31.0.50";
    variant = "mainline";
    rev = "19913b1567940b8af5bfcef5c6efe19a3656e66b";
    hash = "sha256-4oSLcUDR0MOEt53QOiZSVU8kPJ67GwugmBxdX3F15Ag=";
    patches = [];
  });
}


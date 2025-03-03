{ config, lib, pkgs, python_manager, ...}:
with lib;
let
  cfg = config.programs.spacemacs;

  spacemacsLayerType = types.submodule {
    options = with types; {
      variables = mkOption {
        type = attrsOf str;
        default = {};
      };
    };
  };

  spacemacsInitOptionType = types.str;

  packageSetupType = types.submodule {
    options = with types; {
      init = mkOption { type = str; default = "";};
      config = mkOption { type = str; default = "";};
    };
  };

  generalConfType = types.submodule {
    options = with types; {
      remove_keybindings = mkOption { type = listOf str; default = []; };
      keybindings = mkOption {
        type = attrsOf str;
        default = {};
        description = ''
          New keybindings to apply; attribute name is the keystroke, value is the
          command to associate with it.
        '';
      };
      set_variables = mkOption {
        type = attrsOf str;
        default = {};
        description = "Variables with to assign during init";
      };
      extra_config = mkOption { type = str; default = ""; };
    };
  };
  
  colorType = types.nullOr (types.strMatching "#[0-9A-F]{6}|nil");

in {
  options = with types; {
    programs.spacemacs = {
      enable = mkEnableOption "spacemacs, a configuration layer for emacs";

      layers = mkOption { type = attrsOf spacemacsLayerType; default = {}; };

      extra_packages = mkOption {
        type = attrsOf packageSetupType;
        default = {};
        description = ''
          Names and initialization script contents for additional
          packages to load.
          '';
      };

      global_config = mkOption {
        type = generalConfType;
        default = {};
      };

      modal_config = mkOption {
        type = attrsOf generalConfType;
        default = {};
        description = ''
          Associate settings with major modes, names are major modes, and
          configuration settings are applied as mode hooks.         
        '';
      };
      
      extra_els = mkOption {
        type = attrsOf path;
        description = ''
          Paths of .el libraries to copy to .emacs.d/lisp and load.
          The attribute names must be the library names to require.
          '';
        default = {};
      };

      extra_functions = mkOption {
        description = ''
          Additional definitions to insert in the body of the .spacemacs file.
          Typically used for defining self-contained custom behavior.
        '';
        type = str;
        default = "";
      };

      # TODO more of the user-configurable options could be brought into the
      # declarative nix language for better convenience
      user_env = mkOption {
        description = ''
          Environment variables setup.
          This function defines the environment variables for your Emacs session. By
          default it calls 'spacemacs/load-spacemacs-env' which loads the environment
          variables declared in `~/.spacemacs.env' or `~/.spacemacs.d/.spacemacs.env'.
          See the header of this file for more information.
        '';
        type = str;
        default = "";
      };

      user_init = mkOption {
        description = ''
          Initialization for user code:
          This function is called immediately after `dotspacemacs/init', before layer
          configuration.
          It is mostly for variables that should be set before packages are loaded.
          If you are unsure, try setting them in `dotspacemacs/user-config' first.
        '';
        type = str;
        default = "";
      };

      user_load = mkOption {
        description = ''
          Library to load while dumping.
          This function is called only while dumping Spacemacs configuration. You can
          `require' or `load' the libraries of your choice that will be included in the
          dump.
        '';
        type = str;
        default = "";
      };
      
      user_config = mkOption {
        description = ''
          Configuration for user code:
          This function is called at the very end of Spacemacs startup, after layer
          configuration.
          Put your configuration code here, except for variables that should be set
          before packages are loaded.
        '';
        type = str;
        default = "";
      };

      custom_colors = mkOption {
        description = ''
          
        '';
        default = {};
        type = types.submodule {
          options = {
            act1 = mkOption { type = colorType; default = null;
                              description = "One of mode-line's active colors.";};
            act2 = mkOption { type = colorType; default = null;
                              description = "The other active color of mode-line.";};
            base = mkOption { type = colorType; default = null;
                              description = "The basic color of normal text.";};
            base-dim = mkOption { type = colorType; default = null;
                                  description = "A dimmer version of the normal text color.";};
            bg1 = mkOption { type = colorType; default = null;
                             description = "The background color.";};
            bg2 = mkOption { type = colorType; default = null;
                             description =
                               "A darker background color. Used to highlight current line.";};
            bg3 = mkOption { type = colorType; default = null;
                             description = "Yet another darker shade of the background color.";};
            bg4 = mkOption { type = colorType; default = null;
                             description = "The darkest background color.";};
            border = mkOption { type = colorType; default = null;
                                description = "A border line color. Used in mode-line borders.";};
            cblk = mkOption { type = colorType; default = null;
                              description = "A code block color. Used in org's code blocks.";};
            cblk-bg = mkOption { type = colorType; default = null;
                                 description = "The background color of a code block.";};
            cblk-ln = mkOption { type = colorType; default = null;
                                 description = "A code block header line.";};
            cblk-ln-bg = mkOption { type = colorType; default = null;
                                    description = "The background of a code block header line.";};
            cursor = mkOption { type = colorType; default = null;
                                description = "The cursor/point color.";};
            const = mkOption { type = colorType; default = null;
                               description = "A constant.";};
            comment = mkOption { type = colorType; default = null;
                                 description = "A comment.";};
            comment-bg = mkOption { type = colorType; default = null;
                                    description = "The background color of a comment.";};
            comp = mkOption { type = colorType; default = null;
                              description = "A complementary color.";};
            err = mkOption { type = colorType; default = null;
                             description = "errors.";};
            func = mkOption { type = colorType; default = null;
                              description = "functions.";};
            head1 = mkOption { type = colorType; default = null;
                               description = "Level 1 of a heading. Used in org's headings.";};
            head1-bg = mkOption { type = colorType; default = null;
                                  description = "The background of level 1 headings.";};
            head2 = mkOption { type = colorType; default = null;
                               description = "Level 2 headings.";};
            head2-bg = mkOption { type = colorType; default = null;
                                  description = "Level 2 headings background.";};
            head3 = mkOption { type = colorType; default = null;
                               description = "Level 3 headings.";};
            head3-bg = mkOption { type = colorType; default = null;
                                  description = "Level 3 headings background.";};
            head4 = mkOption { type = colorType; default = null;
                               description = "Level 4 headings.";};
            head4-bg = mkOption { type = colorType; default = null;
                                  description = "Level 4 headings background.";};
            highlight = mkOption { type = colorType; default = null;
                                   description = "A highlighted area.";};
            highlight-dim = mkOption { type = colorType; default = null;
                                       description = "A dimmer highlighted area.";};
            keyword = mkOption { type = colorType; default = null;
                                 description = "A keyword or a builtin color.";};
            lnum = mkOption { type = colorType; default = null;
                              description = "Line numbers.";};
            mat = mkOption { type = colorType; default = null;
                             description = "A matched color. Used in matching parens," +
                                           " brackets and tags.";};
            meta = mkOption { type = colorType; default = null;
                              description = "A meta line. Used in org's meta line.";};
            str = mkOption { type = colorType; default = null;
                             description = "A string.";};
            suc = mkOption { type = colorType; default = null;
                             description = "To indicate success. Opposite of error.";};
            ttip = mkOption { type = colorType; default = null;
                              description = "Tooltip color.";};
            ttip-sl = mkOption { type = colorType; default = null;
                                 description = "Tooltip selection color.";};
            ttip-bg = mkOption { type = colorType; default = null;
                                 description = "Tooltip background color.";};
            type = mkOption { type = colorType; default = null;
                              description = "A type color.";};
            var = mkOption { type = colorType; default = null;
                             description = "A variable color.";};
            war = mkOption { type = colorType; default = null;
                             description = "A warning color.";};
          };
        };
      };
      
      dotspacemacs_options = mkOption {
        description = "spacemacs native options";
        default = {};
        type = types.submodule {
          options = {
            "enable-emacs-pdumper" = mkOption {
              description = ''
                If non-nil then enable support for the portable dumper. You'll need
                to compile Emacs 27 from source following the instructions in file
                EXPERIMENTAL.org at to root of the git repository.
              '';
              type = spacemacsInitOptionType;
              default = "nil";
            };

            "emacs-pdumper-executable-file" = mkOption {
              description = ''
                Name of executable file pointing to emacs 27+. This executable must be
                in your PATH.
              '';
              type = spacemacsInitOptionType;
              default = "\"emacs\"";
            };

            "emacs-dumper-dump-file" = mkOption {
              description = ''
                Name of the Spacemacs dump file. This is the file will be created by the
                portable dumper in the cache directory under dumps sub-directory.
                To load it when starting Emacs add the parameter `--dump-file'
                when invoking Emacs 27.1 executable on the command line, for instance:
                ./emacs --dump-file=$HOME/.emacs.d/.cache/dumps/spacemacs-27.1.pdmp
              '';
              type = spacemacsInitOptionType;
              default = "(format \"spacemacs-%s.pdmp\" emacs-version)";
            };

            "elpa-https" = mkOption {
              description = ''
                If non-nil ELPA repositories are contacted via HTTPS whenever it's
                possible. Set it to nil if you have no way to use HTTPS in your
                environment, otherwise it is strongly recommended to let it set to t.
                This variable has no effect if Emacs is launched with the parameter
                `--insecure' which forces the value of this variable to nil.
              '';
              type = spacemacsInitOptionType;
              default = "t";
            };

            "elpa-timeout" = mkOption {
              description = ''
                Maximum allowed time in seconds to contact an ELPA repository.
              '';
              type = spacemacsInitOptionType;
              default = "5";
            };

            "gc-cons" = mkOption {
              description = ''
                Set `gc-cons-threshold' and `gc-cons-percentage' when startup finishes.
                This is an advanced option and should not be changed unless you suspect
                performance issues due to garbage collection operations.
              '';
              type = spacemacsInitOptionType;
              default = "'(100000000 0.1)";
            };

            "read-process-output-max" = mkOption {
              description = ''
                Set `read-process-output-max' when startup finishes.
                This defines how much data is read from a foreign process.
                Setting this >= 1 MB should increase performance for lsp servers
                in emacs 27.
              '';
              type = spacemacsInitOptionType;
              default = "(* 1024 1024)";
            };

            "use-spacelpa" = mkOption {
              description = ''
                If non-nil then Spacelpa repository is the primary source to install
                a locked version of packages. If nil then Spacemacs will install the
                latest version of packages from MELPA. Spacelpa is currently in
                experimental state please use only for testing purposes.
              '';
              type = spacemacsInitOptionType;
              default = "nil";
            };

            "verify-spacelpa-archives" = mkOption {
              description = ''
                If non-nil then verify the signature for downloaded Spacelpa archives.
              '';
              type = spacemacsInitOptionType;
              default = "t";
            };

            "check-for-update" = mkOption {
              description = ''
                If non-nil then spacemacs will check for updates at startup
                when the current branch is not `develop'. Note that checking for
                new versions works via git commands, thus it calls GitHub services
                whenever you start Emacs. (default nil)
              '';
              type = spacemacsInitOptionType;
              default = "nil";
            };

            "elpa-subdirectory" = mkOption {
              description = ''
                If non-nil, a form that evaluates to a package directory. For example, to
                use different package directories for different Emacs versions, set this
                to `emacs-version'. (default 'emacs-version)
              '';
              type = spacemacsInitOptionType;
              default = "'emacs-version";
            };

            "editing-style" = mkOption {
              description = ''
                One of `vim', `emacs' or `hybrid'.
                `hybrid' is like `vim' except that `insert state' is replaced by the
                `hybrid state' with `emacs' key bindings. The value can also be a list
                with `:variables' keyword (similar to layers). Check the editing styles
                section of the documentation for details on available variables.
              '';
              type = spacemacsInitOptionType;
              default = "'vim";
            };

            "verbose-loading" = mkOption {
              description = ''
              '';
              type = spacemacsInitOptionType;
              default = "nil";
            };

            "startup-buffer-show-version" = mkOption {
              description = ''
                If non-nil show the version string in the Spacemacs buffer. It will
                appear as (spacemacs version)@(emacs version)
              '';
              type = spacemacsInitOptionType;
              default = "t";
            };

            "startup-banner" = mkOption {
              description = ''
                Specify the startup banner. Default value is `official', it displays
                the official spacemacs logo. An integer value is the index of text
                banner, `random' chooses a random text banner in `core/banners'
                directory. A string value must be a path to an image format supported
                by your Emacs build.
                If the value is nil then no banner is displayed. (default 'official)
              '';
              type = spacemacsInitOptionType;
              default = "nil";
            };

            "startup-lists" = mkOption {
              description = ''
                List of items to show in startup buffer or an association list of
                the form `(list-type . list-size)`. If nil then it is disabled.
                Possible values for list-type are:
                `recents' `recents-by-project' `bookmarks' `projects' `agenda' `todos'.
                List sizes may be nil, in which case
                `spacemacs-buffer-startup-lists-length' takes effect.
                The exceptional case is `recents-by-project', where list-type must be a
                pair of numbers, e.g. `(recents-by-project . (7 .  5))', where the first
                number is the project limit and the second the limit on the recent files
                within a project.
              '';
              type = spacemacsInitOptionType;
              default = "'((recents . 5) (projects . 7))";
            };

            "startup-buffer-responsive" = mkOption {
              description = ''
                True if the home buffer should respond to resize events. (default t)
              '';
              type = spacemacsInitOptionType;
              default = "t";
            };

            "new-empty-buffer-major-mode" = mkOption {
              description = ''
                Default major mode for a new empty buffer. Possible values are mode
                names such as `text-mode'; and `nil' to use Fundamental mode.
              '';
              type = spacemacsInitOptionType;
              default = "'text-mode";
            };

            "scratch-mode" = mkOption {
              description = ''
                Default major mode of the scratch buffer (default `text-mode')
              '';
              type = spacemacsInitOptionType;
              default = "'text-mode";
            };

            "scratch-buffer-persistent" = mkOption {
              description = ''
                If non-nil, *scratch* buffer will be persistent. Things you write down in
                *scratch* buffer will be saved and restored automatically.
              '';
              type = spacemacsInitOptionType;
              default = "nil";
            };

            "scratch-buffer-unkillable" = mkOption {
              description = ''
                If non-nil, `kill-buffer' on *scratch* buffer
                will bury it instead of killing.
              '';
              type = spacemacsInitOptionType;
              default = "nil";
            };

            "initial-scratch-message" = mkOption {
              description = ''
                Initial message in the scratch buffer, such as "Welcome to Spacemacs!"
              '';
              type = spacemacsInitOptionType;
              default = "nil";
            };

            "themes" = mkOption {
              description = ''
                List of themes, the first of the list is loaded when spacemacs starts.
                Press `SPC T n' to cycle to the next theme in the list (works great
                with 2 themes variants, one dark and one light)
              '';
              type = spacemacsInitOptionType;
              default = "'(spacemacs-dark spacemacs-light)";
            };

            "mode-line-theme" = mkOption {
              description = ''
                Set the theme for the Spaceline. Supported themes are `spacemacs',
                `all-the-icons', `custom', `doom', `vim-powerline' and `vanilla'. The
                first three are spaceline themes. `doom' is the doom-emacs mode-line.
                `vanilla' is default Emacs mode-line. `custom' is a user defined themes,
                refer to the DOCUMENTATION.org for more info on how to create your own
                spaceline theme. Value can be a symbol or list with additional properties.
              '';
              type = spacemacsInitOptionType;
              default = "'(spacemacs :separator wave :separator-scale 1.5)";
            };

            "colorize-cursor-according-to-state" = mkOption {
              description = ''
                If non-nil the cursor color matches the state color in GUI Emacs.
              '';
              type = spacemacsInitOptionType;
              default = "t";
            };

            "default-font" = mkOption {
              description = ''
                Default font or prioritized list of fonts. The `:size' can be specified as
                a non-negative integer (pixel size), or a floating-point (point size).
                Point size is recommended, because it's device independent. (default 10.0)
              '';
              type = spacemacsInitOptionType;
              default = "'(\"Source Code Pro\" :size 10.0 :weight normal :width normal)";
            };

            "leader-key" = mkOption {
              description = ''
                The leader key (default "SPC")
              '';
              type = spacemacsInitOptionType;
              default = "\"SPC\"";
            };

            "emacs-command-key" = mkOption {
              description = ''
                The key used for Emacs commands `M-x' (after pressing on the leader key).
              '';
              type = spacemacsInitOptionType;
              default = "\"SPC\"";
            };

            "ex-command-key" = mkOption {
              description = ''
                The key used for Vim Ex commands (default ":")
              '';
              type = spacemacsInitOptionType;
              default = "\":\"";
            };

            "emacs-leader-key" = mkOption {
              description = ''
                The leader key accessible in `emacs state' and `insert state'
              '';
              type = spacemacsInitOptionType;
              default = "\"M-m\"";
            };

            "major-mode-leader-key" = mkOption {
              description = ''
                Major mode leader key is a shortcut key which is the equivalent of
                pressing `<leader> m`. Set it to `nil` to disable it. (default ",")
              '';
              type = spacemacsInitOptionType;
              default = "\",\"";
            };

            "major-mode-emacs-leader-key" = mkOption {
              description = ''
                Major mode leader key accessible in `emacs state' and `insert state'.
                Thus M-RET should work as leader key in both GUI and terminal modes.
                C-M-m also should work in terminal mode, but not in GUI mode.
              '';
              type = spacemacsInitOptionType;
              default = "\"C-M-m\"";
            };

            "distinguish-gui-tab" = mkOption {
              description = ''
                These variables control whether separate commands are bound in the GUI to
                the key pairs `C-i', `TAB' and `C-m', `RET'.
                Setting it to a non-nil value, allows for separate commands under `C-i'
                and TAB or `C-m' and `RET'.
                In the terminal, these pairs are generally indistinguishable, so this only
                works in the GUI. (default nil)
              '';
              type = spacemacsInitOptionType;
              default = "nil";
            };

            "default-layout-name" = mkOption {
              description = ''
                Name of the default layout (default "Default")
              '';
              type = spacemacsInitOptionType;
              default = "\"Default\"";
            };

            "display-default-layout" = mkOption {
              description = ''
                If non-nil the default layout name is displayed in the mode-line.
              '';
              type = spacemacsInitOptionType;
              default = "nil";
            };

            "auto-resume-layouts" = mkOption {
              description = ''
                If non-nil then the last auto saved layouts are resumed automatically upon
                start.
              '';
              type = spacemacsInitOptionType;
              default = "nil";
            };

            "auto-generate-layout-names" = mkOption {
              description = ''
                If non-nil, auto-generate layout name when creating new layouts. Only has
                effect when using the "jump to layout by number" commands.
              '';
              type = spacemacsInitOptionType;
              default = "nil";
            };

            "large-file-size" = mkOption {
              description = ''
                Size (in MB) above which spacemacs will prompt to open the large file
                literally to avoid performance issues. Opening a file literally means that
                no major mode or minor modes are active. (default is 1)
              '';
              type = spacemacsInitOptionType;
              default = "1";
            };

            "auto-save-file-location" = mkOption {
              description = ''
                Location where to auto-save files. Possible values are `original' to
                auto-save the file in-place, `cache' to auto-save the file to another
                file stored in the cache directory and `nil' to disable auto-saving.
              '';
              type = spacemacsInitOptionType;
              default = "'cache";
            };

            "max-rollback-slots" = mkOption {
              description = ''
                Maximum number of rollback slots to keep in the cache. (default 5)
              '';
              type = spacemacsInitOptionType;
              default = "5";
            };

            "enable-paste-transient-state" = mkOption {
              description = ''
                If non-nil, the paste transient-state is enabled. While enabled, after you
                paste something, pressing `C-j' and `C-k' several times cycles through the
                elements in the `kill-ring'.
              '';
              type = spacemacsInitOptionType;
              default = "nil";
            };

            "which-key-delay" = mkOption {
              description = ''
                Which-key delay in seconds. The which-key buffer is the popup listing
                the commands bound to the current keystroke sequence. (default 0.4)
              '';
              type = spacemacsInitOptionType;
              default = "0.4";
            };

            "which-key-position" = mkOption {
              description = ''
                Which-key frame position. Possible values are `right', `bottom' and
                `right-then-bottom'. right-then-bottom tries to display the frame to the
                right; if there is insufficient space it displays it at the bottom.
              '';
              type = spacemacsInitOptionType;
              default = "'bottom";
            };

            "switch-to-buffer-prefers-purpose" = mkOption {
              description = ''
                Control where `switch-to-buffer' displays the buffer. If nil,
                `switch-to-buffer' displays the buffer in the current window even if
                another same-purpose window is available. If non-nil, `switch-to-buffer'
                displays the buffer in a same-purpose window even if the buffer can be
                displayed in the current window. (default nil)
              '';
              type = spacemacsInitOptionType;
              default = "nil";
            };

            "loading-progress-bar" = mkOption {
              description = ''
                If non-nil a progress bar is displayed when spacemacs is loading. This
                may increase the boot time on some systems and emacs builds, set it to
                nil to boost the loading time. (default t)
              '';
              type = spacemacsInitOptionType;
              default = "t";
            };

            "fullscreen-at-startup" = mkOption {
              description = ''
                If non-nil the frame is fullscreen when Emacs starts up. (default nil)
                (Emacs 24.4+ only)
              '';
              type = spacemacsInitOptionType;
              default = "nil";
            };

            "fullscreen-use-non-native" = mkOption {
              description = ''
                If non-nil `spacemacs/toggle-fullscreen' will not use native fullscreen.
                Use to disable fullscreen animations in OSX. (default nil)
              '';
              type = spacemacsInitOptionType;
              default = "nil";
            };

            "maximized-at-startup" = mkOption {
              description = ''
                If non-nil the frame is maximized when Emacs starts up.
                Takes effect only if `dotspacemacs-fullscreen-at-startup' is nil.
              '';
              type = spacemacsInitOptionType;
              default = "nil";
            };

            "undecorated-at-startup" = mkOption {
              description = ''
                If non-nil the frame is undecorated when Emacs starts up. Combine this
                variable with `dotspacemacs-maximized-at-startup' in OSX to obtain
                borderless fullscreen. (default nil)
              '';
              type = spacemacsInitOptionType;
              default = "nil";
            };

            "active-transparency" = mkOption {
              description = ''
                A value from the range (0..100), in increasing opacity, which describes
                the transparency level of a frame when it's active or selected.
                Transparency can be toggled through `toggle-transparency'. (default 90)
              '';
              type = spacemacsInitOptionType;
              default = "90";
            };

            "inactive-transparency" = mkOption {
              description = ''
                A value from the range (0..100), in increasing opacity, which describes
                the transparency level of a frame when it's inactive or deselected.
                Transparency can be toggled through `toggle-transparency'. (default 90)
              '';
              type = spacemacsInitOptionType;
              default = "90";
            };

            "show-transient-state-title" = mkOption {
              description = ''
                If non-nil show the titles of transient states. (default t)
              '';
              type = spacemacsInitOptionType;
              default = "t";
            };

            "show-transient-state-color-guide" = mkOption {
              description = ''
                If non-nil show the color guide hint for transient state keys. (default t)
              '';
              type = spacemacsInitOptionType;
              default = "t";
            };

            "mode-line-unicode-symbols" = mkOption {
              description = ''
                If non-nil unicode symbols are displayed in the mode line.
                If you use Emacs as a daemon and wants unicode characters only in GUI set
                the value to quoted `display-graphic-p'. (default t)
              '';
              type = spacemacsInitOptionType;
              default = "t";
            };

            "smooth-scrolling" = mkOption {
              description = ''
                If non-nil smooth scrolling (native-scrolling) is enabled. Smooth
                scrolling overrides the default behavior of Emacs which recenters point
                when it reaches the top or bottom of the screen. (default t)
              '';
              type = spacemacsInitOptionType;
              default = "t";
            };

            "line-numbers" = mkOption {
              description = ''
                Control line numbers activation.
                If set to `t', `relative' or `visual' then line numbers are enabled in all
                `prog-mode' and `text-mode' derivatives. If set to `relative', line
                numbers are relative. If set to `visual', line numbers are also relative,
                but lines are only visual lines are counted. For example, folded lines
                will not be counted and wrapped lines are counted as multiple lines.
                This variable can also be set to a property list for finer control:
                '(:relative nil
                :visual nil
                :disabled-for-modes dired-mode
                doc-view-mode
                markdown-mode
                org-mode
                pdf-view-mode
                text-mode
                :size-limit-kb 1000)
                When used in a plist, `visual' takes precedence over `relative'.
              '';
              type = spacemacsInitOptionType;
              default = "t";
            };

            "folding-method" = mkOption {
              description = ''
                Code folding method. Possible values are `evil', `origami' and `vimish'.
              '';
              type = spacemacsInitOptionType;
              default = "'evil";
            };

            "smartparens-strict-mode" = mkOption {
              description = ''
                If non-nil `smartparens-strict-mode' will be enabled in programming modes.
              '';
              type = spacemacsInitOptionType;
              default = "nil";
            };

            "smart-closing-parenthesis" = mkOption {
              description = ''
                If non-nil pressing the closing parenthesis `)' key in insert mode passes
                over any automatically added closing parenthesis, bracket, quote, etc...
                This can be temporary disabled by pressing `C-q' before `)'.
              '';
              type = spacemacsInitOptionType;
              default = "nil";
            };

            "highlight-delimiters" = mkOption {
              description = ''
                Select a scope to highlight delimiters. Possible values are `any',
                `current', `all' or `nil'. Default is `all' (highlight any scope and
                emphasis the current one).
              '';
              type = spacemacsInitOptionType;
              default = "'all";
            };

            "enable-server" = mkOption {
              description = ''
                If non-nil, start an Emacs server if one is not already running.
              '';
              type = spacemacsInitOptionType;
              default = "nil";
            };

            "server-socket-dir" = mkOption {
              description = ''
                Set the emacs server socket location.
                If nil, uses whatever the Emacs default is, otherwise a directory path
                like \"~/.emacs.d/server\". It has no effect if
                `dotspacemacs-enable-server' is nil.
              '';
              type = spacemacsInitOptionType;
              default = "nil";
            };

            "persistent-server" = mkOption {
              description = ''
                If non-nil, advise quit functions to keep server open when quitting.
              '';
              type = spacemacsInitOptionType;
              default = "nil";
            };

            "search-tools" = mkOption {
              description = ''
                List of search tool executable names. Spacemacs uses the first installed
                tool of the list. Supported tools are `rg', `ag', `pt', `ack' and `grep'.
              '';
              type = spacemacsInitOptionType;
              default = "'(\"rg\" \"ag\" \"pt\" \"ack\" \"grep\")";
            };

            "frame-title-format" = mkOption {
              description = ''
                Format specification for setting the frame title.
                %a - the `abbreviated-file-name', or `buffer-name'
                %t - `projectile-project-name'
                %I - `invocation-name'
                %S - `system-name'
                %U - contents of $USER
                %b - buffer name
                %f - visited file name
                %F - frame name
                %s - process status
                %p - percent of buffer above top of window, or Top, Bot or All
                %P - percent of buffer above bottom of window, perhaps plus Top, or Bot or All
                %m - mode name
                %n - Narrow if appropriate
                %z - mnemonics of buffer, terminal, and keyboard coding systems
                %Z - like %z, but including the end-of-line format
              '';
              type = spacemacsInitOptionType;
              default = "\"%I@%S\"";
            };

            "icon-title-format" = mkOption {
              description = ''
                Format specification for setting the icon title format
              '';
              type = spacemacsInitOptionType;
              default = "nil";
            };

            "show-trailing-whitespace" = mkOption {
              description = ''
                Show trailing whitespace (default t)
              '';
              type = spacemacsInitOptionType;
              default = "t";
            };

            "whitespace-cleanup" = mkOption {
              description = ''
                Delete whitespace while saving buffer. Possible values are `all'
                to aggressively delete empty line and long sequences of whitespace,
                `trailing' to delete only the whitespace at end of lines, `changed' to
                delete only whitespace for changed lines or `nil' to disable cleanup.
              '';
              type = spacemacsInitOptionType;
              default = "nil";
            };

            "use-clean-aindent-mode" = mkOption {
              description = ''
                If non nil activate `clean-aindent-mode' which tries to correct
                virtual indentation of simple modes. This can interfer with mode specific
                indent handling like has been reported for `go-mode'.
                If it does deactivate it here.
              '';
              type = spacemacsInitOptionType;
              default = "t";
            };

            "swap-number-row" = mkOption {
              description = ''
                If non-nil shift your number row to match the entered keyboard layout
                (only in insert state). Currently supported keyboard layouts are:
                `qwerty-us', `qwertz-de' and `querty-ca-fr'.
                New layouts can be added in `spacemacs-editing' layer.
              '';
              type = spacemacsInitOptionType;
              default = "nil";
            };

            "zone-out-when-idle" = mkOption {
              description = ''
                Either nil or a number of seconds. If non-nil zone out after the specified
                number of seconds.
              '';
              type = spacemacsInitOptionType;
              default = "nil";
            };

            "pretty-docs" = mkOption {
              description = ''
                Run `spacemacs/prettify-org-buffer' when
                visiting README.org files of Spacemacs.
              '';
              type = spacemacsInitOptionType;
              default = "nil";
            };

            "home-shorten-agenda-source" = mkOption {
              description = ''
                If nil the home buffer shows the full path of agenda items
                and todos. If non nil only the file name is shown.
              '';
              type = spacemacsInitOptionType;
              default = "nil";
            };
          };
        };
      };
    };
  };
  config = mkIf cfg.enable {
    home.file = mkMerge [
      (attrsets.mapAttrs' (name: value:
        nameValuePair (".emacs.d/lisp/" + name + ".el")
          ({source = value;})) cfg.extra_els)
      {
        ".emacs.d" = {
          recursive = true;
          source = pkgs.fetchFromGitHub {
            owner = "syl20bnr";
            repo = "spacemacs";
            # spacemacs hasn't cut a release since 2018, so just grab
            # the latest hash whenever you decide to update :|
            rev = "a58a7d79b3713bcf693bb61d9ba83d650a6aba86";
            sha256 = "D5uI9nIf0Ocxs6ZPj9/BebFM81bizZdSAHRu43csuMA=";
          };
        };
        ".spacemacs" = {
          source = pkgs.writeTextFile {
            name = ".spacemacs";
            text = let
              indent = count: (
                concatStrings (replicate count " "));
              layer_var_acc = acc: name: value: (
                acc + "\n" + (indent 7) + name + " " + value);
              layer_acc = acc: name: value: (
                acc + "\n" + (indent 5) + "(" + name +
                ( attrsets.foldlAttrs layer_var_acc " :variables" value.variables) + ")");
              option_acc = acc: name: value: (
                acc + "\n" + (indent 3) + "dotspacemacs-" + name + " " + value);
              packages_string = (
                strings.optionalString (cfg.extra_packages != {})
                  ((indent 3) + "dotspacemacs-additional-packages '(use-package\n"
                   + (indent 38)
                   + (strings.concatStringsSep ("\n" + indent 38)
                      (attrNames cfg.extra_packages))
                   + ")\n"));
              color_acc = acc: name: value: (
                acc + "\n" + (indent 28) + "(" + name + " . " +
                (if value == "nil" then "nil" else "\"" + value + "\"") +
                ")");
              custom_colors_to_use = attrsets.filterAttrs (
                name: value: value != null) cfg.custom_colors;
              custom_set_colors = if (custom_colors_to_use != {})
                                  then
                                    ((indent 2) +
                                     "(custom-set-variables '(spacemacs-theme-custom-colors\n" +
                                     (indent 26) + "'(" +
                                     (attrsets.foldlAttrs color_acc "" custom_colors_to_use) + ")))\n")
                                  else
                                    "";
              require_acc = acc: name: value: (
                acc + "\n" + (indent 2) + "(require '" + name + ")");
              custom_el_config = (attrsets.foldlAttrs require_acc "" cfg.extra_els)
                                 + "\n";
              create_variable_sets = varsets: spacing:
                (attrsets.foldlAttrs
                  (acc: name: value: acc + "\n" + (indent spacing) +
                                   "(setq " + name + " " + value + ")" )
                "" varsets);
              create_remove_keybindings = remkeys: spacing:
                (strings.concatStringsSep ("\n" + indent spacing)
                  (lists.forEach remkeys
                    (s: "(global-unset-key (kbd \"" + s + "\"))")));
              create_add_keybindings = addkeys: spacing:
                (attrsets.foldlAttrs
                  (acc: name: value: acc + "\n" + (indent spacing) +
                                   "(global-set-key (kbd \"" + name +
                                   "\") " + value + ")" )
                 "" addkeys);
              create_local_remove_keybindings = remkeys: spacing:
                (strings.concatStringsSep ("\n" + indent spacing)
                  (lists.forEach remkeys
                    (s: "(local-unset-key (kbd \"" + s + "\"))")));
              create_local_add_keybindings = addkeys: spacing:
                (attrsets.foldlAttrs
                  (acc: name: value: acc + "\n" + (indent spacing) +
                                   "(local-set-key (kbd \"" + name +
                                   "\") " + value + ")" )
                 "" addkeys);
            in ''
             (defun dotspacemacs/layers ()
               "Layer configuration"
               (setq-default
                dotspacemacs-distribution 'spacemacs-base
                dotspacemacs-enable-lazy-installation 'unused
                dotspacemacs-ask-for-lazy-installation t
                dotspacemacs-configuration-layer-path '()
                dotspacemacs-configuration-layers
                '(
             '' + (attrsets.foldlAttrs layer_acc "" cfg.layers) + ")\n"
            +  packages_string + ''
             
                dotspacemacs-frozen-packages '()
                dotspacemacs-excluded-packages '()
                dotspacemacs-install-packages 'used-only))
             
             (defun dotspacemacs/init ()
               (setq-default
             '' +
            (attrsets.foldlAttrs option_acc "" cfg.dotspacemacs_options) +
            "))\n\n" + cfg.extra_functions +
            "\n(defun dotspacemacs/user-env ()\n" +
            cfg.user_env + "\n" + (indent 2) +
            "(spacemacs/load-spacemacs-env))\n" +
            "\n(defun dotspacemacs/user-init ()\n" +
              custom_set_colors + "\n" + (indent 2) +
              "(add-to-list 'load-path \"" +  config.home.homeDirectory +
              "/.emacs.d/lisp/\")\n" + (indent 2) +
              # extra package init contents
              builtins.replaceStrings ["\n"] [("\n" + indent 2)]
              (strings.concatStringsSep "\n"
                 (attrsets.mapAttrsToList
                   (name: value: value.init)
                   cfg.extra_packages)) +
              cfg.user_init + ")\n" +
            "\n(defun dotspacemacs/user-load ()\n" +
              cfg.user_load + ")\n" +
            "\n(defun dotspacemacs/user-config  ()\n" + (indent 2) +
              # extra package conf contents
              builtins.replaceStrings ["\n"] [("\n" + indent 2)]
                (strings.concatStringsSep "\n"
                   (attrsets.mapAttrsToList
                     (name: value: value.config)
                     cfg.extra_packages)) + "\n" + (indent 2) +
              # variable sets
              (create_variable_sets cfg.global_config.set_variables 2) +
              "\n" + (indent 2) + 
              # keybinding removal
              (create_remove_keybindings cfg.global_config.remove_keybindings 2) +
              "\n" + (indent 2) + 
              # keybinding additions
              (create_add_keybindings cfg.global_config.keybindings 2) +
              "\n" + (indent 2) +
              (builtins.replaceStrings ["\n"] [("\n" + indent 2)]
               cfg.global_config.extra_config) + "\n" + (indent 2) +
              # modal configs
              (attrsets.foldlAttrs
                (acc: name: value:
                  acc + "\n" + (indent 2) +
                  "(add-hook '" + name + "-hook\n" + (indent 4) +
                  "'(lambda ()\n" + (indent 6) + "(" +
                  (create_variable_sets value.set_variables 6) +
                  "\n" + (indent 6) +
                  (create_local_remove_keybindings value.remove_keybindings 6) +
                  "\n" + (indent 6) +
                  (create_local_add_keybindings value.keybindings 6) +
                  "\n" + (indent 6) +
                  (builtins.replaceStrings ["\n"]  [("\n" + indent 6)]
                    value.extra_config)
                  + ")))\n")
                "" cfg.modal_config) +
              custom_el_config +
              cfg.user_config + ")\n" +
            "\n(defun dotspacemacs/emacs-custom-settings ())\n";
          };
        };
      }
    ];
    home.packages = with pkgs; with lib;
      mkIf (attrsets.hasAttrByPath ["lsp"] cfg.layers) (
        let
          cpp_backend = (attrsets.attrByPath
            ["c-c++" "variables" "c-c++-backend"] "" cfg.layers);
          python_backend = if (attrsets.hasAttrByPath ["python"] cfg.layers)
            then (attrsets.attrByPath["python" "variables" "python-lsp-server"]
                  "'pylsp")
              else  "";
        in
          mkMerge [
            (mkIf (cpp_backend == "'lsp-ccls") [ccls])
            (mkIf (cpp_backend == "'lsp-clangd") [libclang])
            (mkIf
              ((attrsets.attrByPath ["nixos" "variables" "nix-backend" ] "" cfg.layers)
               == "'lsp")
              [(builtins.getFlake "github:nix-community/rnix-lsp/95d40673fe43642e2e1144341e86d0036abd95d9").packages."${system}".rnix-lsp ])
            (mkIf (attrsets.hasAttrByPath ["rust"] cfg.layers) [rust-analyzer clippy rustfmt])
          ]
      );
    python_manager.python_packages = with pkgs; with lib;
      mkIf (attrsets.hasAttrByPath ["lsp"] cfg.layers) (
        let python_backend = if (attrsets.hasAttrByPath ["python"] cfg.layers)
          then (attrsets.attrByPath["python" "variables" "python-lsp-server"]
                "'pylsp" cfg.layers.python)
          else  "";
        in
          mkMerge [
      (mkIf (python_backend == "'pylsp") ["python-lsp-server"])
      ]);
  };
}

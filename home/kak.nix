{ config, pkgs, ... }:

let
mkPlugin = name:
  let src = pkgs.dotfiles-inputs."kakounePlugins-${name}";
   in pkgs.kakouneUtils.buildKakounePlugin {
        inherit name src;
      };
in

{
  config = {
    home.packages = [
      (pkgs.kakoune.override {
        configure = {
          plugins = [
            (mkPlugin "surround")
            (mkPlugin "rainbow")
            (mkPlugin "kakboard")
          ];
        };
      })
      pkgs.kak-lsp
    ];

    home.file.".config/kak/kakrc".text = ''
      set-option global ui_options ncurses_status_on_top=false
      set-option global ui_options ncurses_assistant=off

      add-highlighter global/ show-matching
      add-highlighter global/ number-lines
      add-highlighter global/ wrap
      set-option global scrolloff 5,0

      add-highlighter global/ regex \b(TODO|FIXME|NOTE)\b 0:default+rb

      # -   to select inner object
      # =   to select outer object
      # a-s to add a new cursor to the next occurence of the selection
      map global normal -- -     <a-i>
      map global normal -- =     <a-a>
      map global normal -- <a-s> '*N'
      map global normal -- (     ':surround<ret>'
      map global normal -- )     ':delete-surround<ret>'
      map global normal -- *     ':change-surround<ret>'

      hook global WinCreate .* %{ kakboard-enable }

      # case insensitive search
      map global normal / /(?i)

      # tab inserts spaces
      hook global InsertChar \t %{ exec -draft -itersel h@ }
      set global tabstop 4
      set global indentwidth 4

      # always indent as much as the previous one
      set global disabled_hooks .*-indent
      hook global InsertChar \n %{ execute-keys -draft \; K <a-&> }

      # remove trailing spaces
      hook global BufWritePre .* %{ try %{ execute-keys -draft \%s\h+$<ret>d } }

      # lsp
      eval %sh{kak-lsp --kakoune -s $kak_session}
      map global user l %{: enter-user-mode lsp<ret>} -docstring "LSP mode"
      set global lsp_hover_max_lines 3
      lsp-enable
      lsp-auto-hover-enable
    '';

    home.file.".config/kak-lsp/kak-lsp.toml".text = ''
      [language.haskell]
      filetypes = ["haskell"]
      roots  = ["*.cabal"]
      command = "haskell-language-server"
      args = ["--lsp"]

      [language.ocaml]
      filetypes = ["ocaml"]
      roots  = ["dune-project"]
      command = "ocamllsp"

      [language.rust]
      filetypes = ["rust"]
      roots  = ["cargo.toml"]
      command = "rls"
    '';
  };
}

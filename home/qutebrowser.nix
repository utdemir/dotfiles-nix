{ config, pkgs, ... }:

{
  config = {
    home.packages = [ pkgs.qutebrowser ];

    home.file.".config/qutebrowser/config.py".text = ''
      c.aliases = {}
      c.tabs.tabs_are_windows = True
      c.tabs.show = "multiple"
      c.statusbar.hide = False
      c.downloads.location.directory = "~/downloads"
      c.content.pdfjs = True
      c.editor.command = ["kitty", "kak", "{}"]
      c.content.javascript.enabled = False

      config.load_autoconfig()
    '';
  };
}

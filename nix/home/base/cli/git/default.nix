{ pkgs, vars, ... }:
{
  programs.git = {
    enable = true;
    userName = vars.userid;
    userEmail = "85932406+ichi-h@users.noreply.github.com";

    extraConfig = {
      core.autocrlf = false;
      core.filemode = false;
      core.quotepath = false;
      core.editor = "nvim";
      color.ui = "auto";
      http.postBuffer = "16M";
      init.defaultBranch = "main";
      pull.rebase = false;
      submodule.recurse = true;
    };

    ignores = [
      "*~"
      "*.swp"
      "__pycache__"
      ".DS_Store"
      ".envrc"
    ];
  };
}

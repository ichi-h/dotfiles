{ pkgs, vars, ... }:
{
  programs.git = {
    enable = true;

    settings = {
      user.email = "85932406+ichi-h@users.noreply.github.com";
      user.name = vars.userid;
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
      ".direnv/"
      ".env"
      ".ichi-h/"
      ".sisyphus/"
      "CLAUDE.local.md"
      ".serena/language_servers/"
      ".serena/serena_config.yml"
      ".serena/logs"
    ];
  };
}

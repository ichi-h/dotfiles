{ vars, ... }:
{
  services.xremap = {
    userName = vars.username;
    serviceMode = "system";
    config = {
      virtual_modifiers = [ "CapsLock" ];
      modmap = [
        {
          name = "Kill CapsLock";
          remap = {
            CapsLock = {
              held = "CapsLock";
              free_hold = true;
            };
          };
        }
      ];
      keymap = [
        {
          name = "Emacs keybind";
          remap = {
            CapsLock-f = "Right";
            CapsLock-b = "Left";
            CapsLock-p = "Up";
            CapsLock-n = "Down";
            CapsLock-a = "Alt-Left";
            CapsLock-e = "Alt-Right";
          };
        }
        {
          name = "Niri shortcuts";
          remap = {
            Ctrl_L-Shift_L-h = "Super-h";
            Ctrl_L-Shift_L-j = "Super-j";
            Ctrl_L-Shift_L-k = "Super-k";
            Ctrl_L-Shift_L-l = "Super-l";
            Ctrl_L-Shift_L-p = "Super-p";
            Ctrl_L-Shift_L-n = "Super-n";
            Ctrl_L-Shift_L-f = "Super-f";
            Ctrl_L-Shift_L-b = "Super-b";
          };
        }
        {
          name = "CapsLock utils";
          remap = {
            CapsLock-u = "Ctrl-u";
            CapsLock-d = "Ctrl-d";
            CapsLock-k = "F7";
            CapsLock-BackSpace = "Ctrl-BackSpace";
            CapsLock-Esc = "BackSpace";
            CapsLock-Space = "Ctrl-Space";
            # CapsLock-KEY_SEMICOLON = "Ctrl-KEY_SEMICOLON";
            # CapsLock-Shift-KEY_SEMICOLON = "Ctrl-Shift-KEY_SEMICOLON";
          };
        }
        {
          name = "Move tabs";
          remap = {
            Ctrl_L-h = "Shift-Ctrl-tab";
            Ctrl_L-l = "Ctrl-tab";
          };
        }
      ];
    };
  };
}

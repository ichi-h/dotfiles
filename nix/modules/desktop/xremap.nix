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

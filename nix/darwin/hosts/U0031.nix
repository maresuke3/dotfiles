{ ... }: {
  networking.hostName = "U0031";
  system.primaryUser = "daiki-fukushima";

  users.users.daiki-fukushima = {
    name = "daiki-fukushima";
    home = "/Users/daiki-fukushima";
  };
}

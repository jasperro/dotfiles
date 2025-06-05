{
  services.mosquitto = {
    enable = true;
    listeners = [
      {
        users = {
          mosquitto = {
            hashedPassword = "$6$IelzC+f0VnizZt46$9vt3K23ezggMxxDX9uXwexZ7W65+7faCuwNGYpJpxDm4GKwE3OCeD6l/tB+etDqVxd9UcWJPCgWp3EEkq6d2nQ==";
          };
        };
      }
    ];
  };
}

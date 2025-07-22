{
  systemd.network = {
    links."10-wan" = {
      # the hardware address of the specially treated "wan" port
      matchConfig.MACAddress = "3c:ec:ef:71:a2:07";
      linkConfig.Name = "wan";
    };
    networks."10-wan" = {
      matchConfig.Name = "wan";
      networkConfig = {
        DHCP = "yes";
      };
      dhcpV4Config.UseDNS = "no";
      dhcpV6Config.UseDNS = "no";
      extraConfig = ''
        [IPv6AcceptRA]
        UseDNS = no
      '';
    };
  };
}

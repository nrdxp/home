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
        IPv6AcceptRA = true; # Explicitly enable RA for SLAAC and to trigger DHCPv6 if needed
        DHCPPrefixDelegation = true; # Request prefix delegation from ISP via DHCPv6
      };
      dhcpV4Config.UseDNS = "no";
      dhcpV6Config = {
        UseDNS = "no";
        WithoutRA = "solicit"; # Start DHCPv6 solicitation even without RA "managed" flag
        PrefixDelegationHint = "::/60";
      };
      extraConfig = ''
        [IPv6AcceptRA]
        UseDNS = no
      '';
    };
  };
}

{...}: {
  networking.nameservers = [
    "1.1.1.2#security.cloudflare-dns.com"
    "2606:4700:4700::1112#security.cloudflare-dns.com"
  ];

  services.resolved = {
    enable = true;
    dnssec = "true";
    fallbackDns = [
      "1.0.0.2#security.cloudflare-dns.com"
      "2606:4700:4700::1002#security.cloudflare-dns.com"
    ];
    extraConfig = ''
      DNSOverTLS=yes
    '';
  };
}

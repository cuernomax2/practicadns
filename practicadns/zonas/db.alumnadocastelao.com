$TTL    3600
@       IN      SOA     ns.alumnadocastelao.com. mgonzalezulla@danielcastelao.org. (
                   2022051001           ; Serial
                         3600           ; Refresh [1h]
                          600           ; Retry   [10m]
                        86400           ; Expire  [1d]
                          600 )         ; Negative Cache TTL [1h]
;
@       IN      NS      ns.alumnadocastelao.com.
@       IN      MX      10.1.0.10

test     IN      A       10.1.0.2
alias    IN      A       11.11.11.11
alias 	 IN      TXT     mensaje

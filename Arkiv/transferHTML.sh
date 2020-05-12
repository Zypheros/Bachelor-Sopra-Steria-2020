#!/bin/bash
#Script for å overføre FRA webtjeneren til Azure Web app, rom for forbedring

#scriptet som skal kjøres på vpnadmin, tar ned index.html (erstatt etter behov)
SCRIPT1 = "scp webadmin@192.168.38.129:/var/www/html/index.html /tmp/index.html; exit"

ssh vpnadmin@109.189.13.10 "${SCRIPT1}"
cd /home/site/wwwroot/www/html
scp vpnadmin@109.189.13.10:/tmp/index.html ./index.html

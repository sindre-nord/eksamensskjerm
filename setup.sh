
# First ask user for the name of the link to vist on boot
echo "What is the name of the link you want to visit on boot? This will be added to the autostart file.\n"
read link

# Insert the following string into the autostart file
echo "@lxpanel --profile LXDE-pi
@pcmanfm --desktop --profile LXDE-pi
#@screensaver -no-splash
 
point-rip
@chromium-browser --start-fullscreen --start-maximized https://ntnu.no -i 3600
#-i 3600 betyr at siden oppdateres hvert 3600 sekund, altså hver time.
@chromium-browser --start-fullscreen -a $link" >> /etc/xdg/lxsession/LXDE-pi/autostart

echo "Do you wish to overwrite the current wpa_supplicant.conf file? (y/n)"
read answer

#Parse user arg
if [ "$answer" = "y" ]; then
    echo "Please enter the username:"
    read username
    echo "Please enter the password:"
    read password
    echo "Please enter the path to the ca_cert file:"
    read ca_cert_path

    # Insert the following string into the wpa_supplicant.conf file
    echo "ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
country=NO
 
network={
    identity="$username"
    password="$password"
    ssid="eduroam"
    proto=RSN
    key_mgmt=WPA-EAP
    pairwise=CCMP
    auth_alg=OPEN
    eap=PEAP
    ca_cert="$ca_cert_path"
    altsubject_match="DNS:radius.ntnu.no"
    phase1="peaplable=0"
    phase2="auth=MSCHAPV2"
    priority=999
    proactive_key_caching=1
}" >> /etc/wpa_supplicant/wpa_supplicant.conf

    # Insert the following string into the wpa_supplicant.conf file
    systemctl daemon-reload
    wpa_supplicant -i wlan0 -c /etc/wpa_supplicant/wpa_supplicant.conf -B
fi

echo "The setup is now complete. A reboot is strongly recommended, want to do it now? (y/n)"
read answer

#Parse user arg
if [ "$answer" = "y" ]; then
    echo "Rebooting..."
    reboot
fi
echo "Setup complete, press enter to exit."
read answer

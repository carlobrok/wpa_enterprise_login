#!/bin/bash

#
#   Notes:
#
#   - Zenity must be installed
#   - R UN THIS SCRIPT AS ROOT
#   - The wireless interface should be set correctly
#
#
#   Description:
#
#   This script opens a zenity dialog which asks for your username and password.
#   The credentials are written to /etc/wpa_supplicant/wpa_supplicant_eap.conf (root only!),
#   a copy of the wpa_supplicant_eap.conf from this repository.
#   Make sure this file can only be accessed by root user!
#   Then the wpa_supplicant daemon is started searching for the wifi network given by the config.
#


ENTRY=`zenity --password --username --title "GBGS1 - WLAN Login"`

if [ $? -ne 0 ]
then
   exit 1
fi

USERNAME=`echo $ENTRY | cut -d'|' -f1`
PASSWORD=`echo $ENTRY | cut -d'|' -f2`

#cp wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant_eap.conf
sed -e "s/user/$USERNAME/g" -e "s/passwd/$PASSWORD/g" wpa_supplicant.conf > /etc/wpa_supplicant/wpa_supplicant_eap.conf

wpa_supplicant -d -i wlp2s0 -c /etc/wpa_supplicant/wpa_supplicant_eap.conf

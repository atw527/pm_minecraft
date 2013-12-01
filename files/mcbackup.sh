#!/bin/bash

#
# FILE MANAGED BY PUPPET
#

screen -d -r minecraft -X register c "say ** Backup Yo Stuffz! May lag a sec during backup. **$(echo -ne '\r')"
screen -d -r minecraft -X paste c

# remove old backups #
rdiff-backup --remove-older-than 12D --force /home/bukkit/mcbackup/

# disable level saving #
screen -d -r minecraft -X register c "save-off$(echo -ne '\r')"
screen -d -r minecraft -X paste c

# run the local backup #
rdiff-backup --exclude /home/bukkit/minecraft/plugins/dynmap/web /home/bukkit/minecraft /home/bukkit/mcbackup

# enable level saving #
screen -d -r minecraft -X register c "save-on$(echo -ne '\r')"
screen -d -r minecraft -X paste c


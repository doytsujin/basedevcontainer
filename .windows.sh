#!/bin/sh

if [ -d "~/.ssh" ]; then
  # If the ~/.ssh directory exists, it's either
  # already populated by some custom configuration,
  # or it has been bind mounted with an older docker-compose.yml
  # for Linux and OSX, so we should leave it as is.
  echo "~/.ssh directory already exists, exiting"
  exit 0
fi

if [ -d /tmp/.ssh ]; then
  # Retro-compatibility
  echo "Copying content of /tmp/.ssh to ~/.ssh"
  ln -s /mnt/ssh ~/.ssh
  exit 0
fi

if [ "$(stat -c '%U' /mnt/ssh)" != "UNKNOWN" ]; then
  echo "Unix host detected, symlinking /mnt/ssh to ~/.ssh"
  ln -s /mnt/ssh ~/.ssh
  exit 0
fi

echo "Windows host detected, copying content of /mnt/ssh to ~/.ssh"
cp -rf /mnt/ssh/* ~/.ssh/
chmod 600 ~/.ssh/*
chmod 644 ~/.ssh/*.pub &> /dev/null

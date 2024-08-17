# Notes
# Login to app store to make mas applications (vimari, xcode etc) install successfully
#
# For full yabai/skhd functionallity
#   - Disable SIP: https://github.com/koekeishiya/yabai/wiki/Disabling-System-Integrity-Protection
#   - Reboot and start holding down cmd+r
#   - csrutil disable --with kext --with dtrace --with nvram --with basesystem
#   - Allow to automatically load scripting addition on startup:
#   - sudo visudo -f /private/etc/sudoers.d/yabai
#   - Add the following line (replace <user> with actual user):
#   - <user> ALL = (root) NOPASSWD: /run/current-system/sw/bin/yabai --load-sa
#
# Must grant full disk access to term application - will get 'operation not permitted' when accessing eg ~/Library/Containers/*
#   - System Preferences -> Security & Privacy -> Full Disk Access
#
# Install ssh keys into home directory before starting (needed for git clone)


sh <(curl -L https://nixos.org/nix/install) --daemon
# 'restart' shell environment
zsh
# install git etc (xcode-select --install or preferebly via nix)
nix-shell -p git gitAndTools.gh nixFlakes
# darwin-rebuild cant find the git installed in the shell, so for now:
# xcode-select --install
echo "Adding installed ssh keys"
ssh-add -K

# get ssh identity/keys from somewhere (?)
echo "Please provide the hostname (nix-darwin configuration name)"
read -rp 'hostname: ' hostname
sudo scutil --set HostName "$hostname"

echo "Installing dotfiles"
DOTFILES_DIR=$HOME/.config/dotfiles
git clone git@github.com:planetbeldar/dotfiles.git "$DOTFILES_DIR"

# install homebrew - it's being used to install some applications (via nix-darwin)
echo "Installing homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

echo "Building and installing the nix configuration $hostname"
pushd "$DOTFILES_DIR" || exit
# update ulimit maxfiles (file descriptors) with launch daemon (https://github.com/vlaci/nix-doom-emacs/issues/387#issuecomment-974757540 & https://discussions.apple.com/thread/253001317?answerId=255632520022#255632520022)
sudo cp config/darwin/limit.maxfiles.plist /Library/LaunchDaemons/
sudo cp config/darwin/limit.maxproc.plist /Library/LaunchDaemons/
sudo launchctl load -w /Library/LaunchDaemons/limit.maxfiles.plist
sudo launchctl load -w /Library/LaunchDaemons/limit.maxproc.plist
# build configuration
# darwin-rebuild build --flake . --impure
nix build ".#darwinConfigurations."$hostname".system" -L --impure --experimental-features 'nix-command flakes'
# backup old nix configuration
sudo mv -vn  /etc/nix/nix.conf /etc/nix/nix.conf.old
# symlink /run (the tab character is important) - update 240816: this is handled by the installer
# echo -e 'run\tprivate/var/run' | sudo tee -a /etc/synthetic.conf
# /System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util -t
# switch system configuration
./result/sw/bin/darwin-rebuild switch --flake . --impure

# Apply macos settings (defaults etc)
./config/darwin/.macos
popd || exit

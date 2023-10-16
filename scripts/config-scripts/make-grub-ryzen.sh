#!/bin/bash

# Specify the desired grub configuration
GRUB_CONFIG="
GRUB_DEFAULT=\"0\"
GRUB_TIMEOUT=\"0\"
GRUB_DISTRIBUTOR=\"Arch\"
GRUB_CMDLINE_LINUX_DEFAULT=\"quiet\"
GRUB_CMDLINE_LINUX=\"net.ifnames=0 iommu=pt idle=nomwait rcu_nocbs=0-15 processor.max_cstate=1\"

# Preload both GPT and MBR modules so that they are not missed
GRUB_PRELOAD_MODULES=\"part_gpt part_msdos\"

# Uncomment to enable Hidden Menu, and optionally hide the timeout count
GRUB_HIDDEN_TIMEOUT=\"0\"
GRUB_HIDDEN_TIMEOUT_QUIET=\"true\"

# Uncomment to use basic console
GRUB_TERMINAL_INPUT=\"console\"

# Uncomment to disable graphical terminal
#GRUB_TERMINAL_OUTPUT=\"console\"

# The resolution used on graphical terminal
# note that you can use only modes which your graphic card supports via VBE
# you can see them in real GRUB with the command \`vbeinfo\'
#GRUB_GFXMODE=\"1680x1050x8\"
GRUB_GFXMODE=\"1024x768,800x600\"

# Uncomment to allow the kernel use the same resolution used by grub
GRUB_GFXPAYLOAD_LINUX=\"keep\"

# Uncomment if you want GRUB to pass to the Linux kernel the old parameter
# format \"root=/dev/xxx\" instead of \"root=/dev/disk/by-uuid/xxx\"
#GRUB_DISABLE_LINUX_UUID=\"true\"

# Uncomment to disable generation of recovery mode menu entries
GRUB_DISABLE_RECOVERY=\"true\"

# Uncomment and set to the desired menu colors.  Used by normal and wallpaper
# modes only.  Entries specified as foreground/background.
export GRUB_COLOR_NORMAL=\"light-blue/black\"
export GRUB_COLOR_HIGHLIGHT=\"light-cyan/blue\"

# Uncomment one of them for the gfx desired, a image background or a gfxtheme
#GRUB_BACKGROUND=\"/path/to/wallpaper\"
GRUB_THEME=\"/usr/share/grub/themes/artix/theme.txt\"

# Uncomment to get a beep at GRUB start
#GRUB_INIT_TUNE=\"480 440 1\"

GRUB_SAVEDEFAULT=\"true\"

GRUB_DISABLE_LINUX_RECOVERY=\"true\"

# Probe for other installed operating systems
GRUB_DISABLE_OS_PROBER=\"false\"
"

# Backup the original grub configuration file
sudo cp /etc/default/grub /etc/default/grub.bak

# Modify the grub configuration file
echo "$GRUB_CONFIG" | sudo tee /etc/default/grub > /dev/null

# Update grub
sudo grub-mkconfig -o /boot/grub/grub.cfg

echo "Grub configuration updated successfully."
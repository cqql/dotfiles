require "tmpdir"
require "find"

def manage_git_repo(path, repo)
  if File.directory?(path + "/.git")
    sh "cd #{path} && git pull"
  else
    if File.directory?(path)
      # Allow cloning into existing directories
      Dir.mktmpdir do |dir|
        sh "git clone #{repo} #{dir}"
        sh "cp --recursive #{dir}/. #{path}"
      end
    else
      sh "git clone #{repo} #{path}"
    end
  end
end

FILES = Find.find("home")
ORG_FILES = FileList.new(FILES.select { |f| f.end_with? ".org" })
ELISP = FileList.new(FILES.select { |f| f.end_with?(".el") })
ELISP.include(ORG_FILES.ext(".el"))
ORG_FILES.gsub!(/^home/, Dir.home)
ELISP.gsub!(/^home/, Dir.home)

task :default => [:dotfiles, :tools, :packages, :user_services]

task :dotfiles do
  sh "find home -maxdepth 1 -mindepth 1 -exec cp --recursive --preserve=mode {} #{Dir.home} \\;"

  # Update the font cache
  sh "fc-cache"
end

multitask :tools => [:pyenv, :pyenv_virtualenv, :vim_plug, :antigen]

task :pyenv do
  manage_git_repo "#{Dir.home}/.pyenv", "https://github.com/yyuu/pyenv.git"
end

task :pyenv_virtualenv => :pyenv do
  manage_git_repo "#{Dir.home}/.pyenv/plugins/pyenv-virtualenv", "https://github.com/yyuu/pyenv-virtualenv.git"
end

task :vim_plug do
  manage_git_repo "#{Dir.home}/.vim/plug", "https://github.com/junegunn/vim-plug.git"
end

task :antigen do
  manage_git_repo "#{Dir.home}/.antigen", "https://github.com/zsh-users/antigen.git"
end

multitask :packages => [:emacs, :vim_packages]

task :emacs => [:quelpa, :compile_elisp]

task :quelpa => :dotfiles do
  sh "emacs --script home/.emacs.d/quelpa-install.el"
end

task :compile_elisp => :dotfiles do
  ORG_FILES.each do |f|
    sh <<END
emacs --quick --batch --eval \
      "(progn (require 'ob-tangle) (org-babel-tangle-file \\"#{f}\\"))"
END
  end

  ELISP.each do |f|
    # We are not using --quick because we want to have installed libraries
    # available
    sh <<END
emacs --no-init-file --batch --funcall batch-byte-compile #{f}
END
  end
end

task :vim_packages => [:vim_plug, :dotfiles] do
  sh "vim +PlugUpdate +qall"
end

task :user_services do
  sh <<END
systemctl --user daemon-reload
systemctl --user enable mute-on-suspend.service
systemctl --user enable lock-screen.service
END
end

task :system => [:pacaur, :system_packages, :system_conf, :lingering]

task :pacaur do
  if not system("pacman -Q pacaur")
    sh <<END
# Create build directory
dir=$(mktemp -d)
cd $dir

# Install dependencies
sudo pacman -S --noconfirm yajl expac

# Install cower
curl -o PKGBUILD https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=cower
makepkg PKGBUILD --skippgpcheck
sudo pacman -U cower*.tar.xz --noconfirm

# Install pacaur
curl -o PKGBUILD https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=pacaur
makepkg PKGBUILD
sudo pacman -U pacaur*.tar.xz --noconfirm

# Clean build directory
cd ~
rm -r $dir
END
  end
end

task :system_packages => [:pacaur, :system_conf] do
  sh <<END
# XOrg packages
xorg="xorg-server xorg-xrdb xorg-xrandr xorg-xmodmap xorg-xev"

# Desktop manager
dm="lightdm lightdm-gtk-greeter light-git"

# Window manager
wm="i3-wm i3lock i3status rlwrap rofi autorandr-git"

# Sound control
sound="pulseaudio pulseaudio-alsa pavucontrol"

# Network suite
network="networkmanager network-manager-applet"

# Security
security="firehol"

# Taking screenshots
screenshot="maim slop"

# Terminal and shell
shell="rxvt-unicode bash-completion zsh"

# Cryptography
crypto="openssl openssh gnome-keyring"

# Utilities
utils="htop tree rsync tab"

# Network utilities
netutils="nmap tcpdump dnsutils"

# Programming tools
programming="git vim emacs the_silver_searcher"

# Web
web="firefox chromium"

pacaur -S --needed --noconfirm $xorg $dm $wm $network $sound $security \
       $screenshot $shell $crypto $utils $netutils $programming $web

# Start desktop manager on boot
sudo systemctl enable lightdm.service

# Autostart the firewall
sudo systemctl enable firehol.service
sudo systemctl start firehol.service

# Trigger user services on suspend
sudo systemctl daemon-reload
sudo systemctl enable user-suspend@#{`id -u ${ENV["USER"]}`.strip}.service
END
end

task :system_conf do
  sh "sudo cp --recursive --force --preserve=mode etc usr /"
end

desc "Enable lingering for user-level systemd services"
task :lingering do
  sh "sudo loginctl enable-linger #{ENV["USER"]}"
end

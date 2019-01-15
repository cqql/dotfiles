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

task :default => [:dotfiles, :tools, :packages, :dualscreen]

task :dotfiles do
  sh "find home -maxdepth 1 -mindepth 1 -exec cp --recursive --preserve=mode {} #{Dir.home} \\;"

  # Update the font cache
  sh "fc-cache"

  # Reload X resources database
  sh "xrdb ~/.Xresources"
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

multitask :packages => [:emacs]

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

task :dualscreen do
  sh "plasmapkg2 -t kwinscript -u dual-screen"
end

task :system => [:system_packages, :system_conf]

task :emacs do
  sh "sudo add-apt-repository ppa:kelleyk/emacs"
end

task :system_packages => [:system_conf] do
  sh <<END
# Security
security="firehol"

# Taking screenshots
screenshot="maim slop"

# Terminal and shell
shell="rxvt-unicode bash-completion zsh"

# Cryptography
crypto="openssl openssh-client openssh-server gnome-keyring"

# Utilities
utils="htop tree rsync"

# Network utilities
netutils="nmap tcpdump dnsutils"

# Programming tools
programming="git vim emacs26"

# Web
web="firefox"

sudo apt-get install --yes $security $screenshot $shell $crypto $utils $netutils $programming $web

sudo systemctl enable firehol.service
END
end

task :system_conf do
  sh "sudo cp --recursive --force --preserve=mode etc usr /"
end

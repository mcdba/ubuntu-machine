namespace :gems do
  desc "Install RubyGems"
  task :install_rubygems, :roles => :app do
    run "curl -LO http://rubyforge.org/frs/download.php/45905/rubygems-#{rubygem_version}.tgz"
    run "tar xvzf rubygems-#{rubygem_version}.tgz"
    run "cd rubygems-#{rubygem_version} && sudo ruby setup.rb"
    sudo "ln -s /usr/bin/gem1.8 /usr/bin/gem"
    sudo "gem update"
    sudo "gem update --system"
    run "rm -Rf rubygems-#{rubygem_version}*"
  end
  
  desc "Install Gem Dependencies"
  task :install_deps, :roles => :app do
    sudo "aptitude install -y imagemagick libmagick9-dev"
    sudo "aptitude install -y libxslt-dev"
    sudo "aptitude install -y libopenssl-ruby" if ["aws", "scalr"].include?(hosting_provider)
  end
  
  desc "Install github"
  task :install_github, :roles => :app do
    sudo "/opt/ruby-enterprise/bin/gem sources -a http://gems.github.com"
  end
    
  desc "List gems on remote server"
  task :list, :roles => :app do
    stream "/opt/ruby-enterprise/bin/gem list"
  end

  desc "Update gems on remote server"
  task :update, :roles => :app do
    sudo "/opt/ruby-enterprise/bin/gem update"
  end
  
  desc "Update gem system on remote server"
  task :update_system, :roles => :app do
    sudo "/opt/ruby-enterprise/bin/gem update --system"
  end

  desc "Install a gem on the remote server"
  task :install, :roles => :app do
    name = Capistrano::CLI.ui.ask("Which gem should we install: ")
    sudo "/opt/ruby-enterprise/bin/gem install #{name}"
  end

  desc "Uninstall a gem on the remote server"
  task :uninstall, :roles => :app do
    name = Capistrano::CLI.ui.ask("Which gem should we uninstall: ")
    sudo "/opt/ruby-enterprise/bin/gem uninstall #{name}"
  end
end

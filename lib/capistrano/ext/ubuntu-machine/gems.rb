namespace :gems do
  desc "Install RubyGems"
  task :install_rubygems, :roles => :app do
    run "wget http://rubyforge.org/frs/download.php/45905/rubygems-#{rubygem_version}.tgz"
    run "tar xvzf rubygems-#{rubygem_version}.tgz"
    run "cd rubygems-#{rubygem_version} && sudo ruby setup.rb"
    sudo "ln -s /usr/bin/gem1.8 /usr/bin/gem"
    sudo "gem update"
    sudo "gem update --system"
    run "rm -Rf rubygems-#{rubygem_version}*"
  end
  
  desc "List gems on remote server"
  task :list, :roles => :app do
    stream "gem list"
  end

  desc "Update gems on remote server"
  task :update, :roles => :app do
    sudo "gem update"
  end
  
  desc "Update gem system on remote server"
  task :update_system, :roles => :app do
    sudo "gem update --system"
  end

  desc "Install a gem on the remote server"
  task :install, :roles => :app do
    name = Capistrano::CLI.ui.ask("Which gem should we install: ")
    sudo "gem install #{name}"
  end

  desc "Uninstall a gem on the remote server"
  task :uninstall, :roles => :app do
    name = Capistrano::CLI.ui.ask("Which gem should we uninstall: ")
    sudo "gem uninstall #{name}"
  end

  desc "Adds the --no-rdoc and --no-ri flags to the .gemrc; you don't need docs on a production server."
  task :add_nodocs_to_gemrc, :roles => :app do
    run "echo 'gem: --no-rdoc --no-ri' >> ~/.gemrc"
  end

  desc "Scp local gem to the remote server and install it"
  task :deploy_local_gem, :roles => :app do
    local_gem_path = Capistrano::CLI.ui.ask("Please supply the path to the local gem: ")
    run "mkdir -p gems"
    upload(local_gem_path,'~/gems/',:via => :scp, :recursive => false)
    sudo_keepalive
    run "cd gems/ && sudo gem install -l #{File.basename(local_gem_path)}"
  end

  # TODO: Refactor with deploy_local_gem
  desc "Scp a set of local gems preconfigured in :local_gems_to_deploy to the remote server and install them"
  task :deploy_local_gems, :roles => :app do
    _cset(:local_gems_to_deploy) { abort "Please specify the local gems you want to deploy:\n  set :local_gems_to_deploy, ['/path/to/your_local-1.2.gem']" }
    run "mkdir -p gems"
    # First upload all gems
    local_gems_to_deploy.each do |local_gem_path|
      upload(local_gem_path,'~/gems/',:via => :scp, :recursive => false)
    end
    # Then install them
    local_gems_to_deploy.each do |local_gem_path|
      sudo_keepalive
      run "cd gems/ && sudo gem install -l #{File.basename(local_gem_path)}"
    end
  end
end

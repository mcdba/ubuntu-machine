namespace :rails3 do
  desc "Install Rails3"
  task :install, :roles => :app do
    sudo "apt-get install wget"
    sudo "gem install tzinfo builder memcache-client rack rack-test rack-mount erubis mail text-format thor bundler i18n"
    sudo "gem install rails --pre"
  end
end

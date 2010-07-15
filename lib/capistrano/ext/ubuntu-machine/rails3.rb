namespace :rails3 do
  desc "Install Rails3"
  task :install, :roles => :app do
    sudo "/opt/ruby-enterprise/bin/gem install tzinfo builder memcache-client rack rack-test rack-mount erubis mail text-format thor bundler i18n --no-ri --no-rdoc"
    sudo "/opt/ruby-enterprise/bin/gem install rails --pre --no-ri --no-rdoc"
    end
end

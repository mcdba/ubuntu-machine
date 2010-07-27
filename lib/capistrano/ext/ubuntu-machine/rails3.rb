namespace :rails3 do
  desc "Install Rails3"
  task :install, :roles => :app do
     sudo "/opt/ruby-enterprise/bin/gem install rails --pre --no-ri --no-rdoc"
    end
end

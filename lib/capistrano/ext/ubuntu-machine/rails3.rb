namespace :rails3 do
  desc "Install Rails3"
  task :install, :roles => :app do
     sudo "/opt/ruby-enterprise/bin/gem install rails --pre --no-ri --no-rdoc"
     sudo "apt-get install libxml2-dev libxslt1-dev"
     sudo "chown #{user_to_create}:#{user_to_create} /home/#{user_to_create}/.gem"
    end
end

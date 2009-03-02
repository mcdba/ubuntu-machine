namespace :sphinx do
  desc "Install sphinx"
  task :install, :roles => :app do
    #sudo "sudo apt-get build-dep git-core -y"
    run "curl -O http://www.sphinxsearch.com/downloads/sphinx-#{sphinx_version}.tar.gz"
    run "tar xvzf sphinx-#{sphinx_version}.tar.gz"
    run "cd sphinx-#{sphinx_version}"
    run "cd sphinx-#{sphinx_version} && ./configure"
    run "cd sphinx-#{sphinx_version} && make"
    run "cd sphinx-#{sphinx_version} && sudo make install"
    run "rm sphinx-#{sphinx_version}.tar.gz"
    run "rm -Rf sphinx-#{sphinx_version}"
  end

  task :add_sphinx_cron_jobs, :roles => :app, :except => { :no_release => true } do
    tmpname = "/tmp/appname-crontab.#{Time.now.strftime('%s')}"
    # run crontab -l or echo '' instead because the crontab command will fail if the user has no pre-existing crontab file.
    # in this case, echo '' is run and the cap recipe won't fail altogether.
    run "(crontab -l || echo '') | grep -v 'rake ultrasphinx' > #{tmpname}"
    run "echo \"*/6 * * * * bash -c 'cd #{current_path}; RAILS_ENV=production rake ultrasphinx:index:delta >> log/ultrasphinx-index.log 2>&1'\" >> #{tmpname}"
    run "echo \"1 4 * * * bash -c 'cd #{current_path}; RAILS_ENV=production rake ultrasphinx:index:main >> log/ultrasphinx-index.log 2>&1'\" >> #{tmpname}"
    run "echo \"*/3 * * * * bash -c 'cd #{current_path}; RAILS_ENV=production rake ultrasphinx:daemon:start >> log/ultrasphinx-daemon.log 2>&1'\" >> #{tmpname}"
    run "crontab #{tmpname}"
    run "rm #{tmpname}"
  end
  
end

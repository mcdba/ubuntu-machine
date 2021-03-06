namespace :ffmpeg do
  # FFmpeg install has been tested in June 2009 as working with these settings: 
  # set :x264_commit_hash, '2c597171d5126c3ccae7546f6699d6c4d8ec5e3a'
  # set :ffmpeg_commit_hash, 'cc32213534573a127e01a0e2ed4962eb4b1939fd'
  # set :libswscale_commit_hash, '0fa4ae3fc08f75277e2c1f225561053243f18576'
  _cset :x264_commit_hash, ''
  _cset :ffmpeg_commit_hash, ''
  _cset :libswscale_commit_hash, ''

  desc 'Install FFmpeg dependencies'
  task :install_dependencies, :roles => :app do
    #TODO: Ensure that the multiverse repositories/sources are available and being used by aptitude \
    # otherwise add them to /etc/apt/sources.list since they are needed for libraries such as libmp3lame-dev
    sudo "aptitude install -y ccache checkinstall fakeroot liba52-0.7.4-dev liba52-dev libfaac-dev libfaad-dev libfreetype6-dev libgpac-dev libjpeg62-dev liblame-dev liblame0 libmp3lame-dev libogg-dev libpng12-dev libtheora-dev libtiff4-dev libvorbis-dev libxvidcore4-dev"
    run "wget http://www.tortall.net/projects/yasm/releases/yasm-0.7.1.tar.gz -O yasm-0.7.1.tar.gz && tar -xzf yasm-0.7.1.tar.gz && cd yasm-0.7.1 && ./configure && make && sudo checkinstall -y"
    sudo "ldconfig"
    run "if test -x x264; then cd x264 && git checkout master && git pull; else git clone git://git.videolan.org/x264.git; fi"
    if x264_commit_hash.size > 0
      run "cd x264 && git checkout #{x264_commit_hash}"
    end
    run "cd x264 && ./configure --enable-pthread --enable-mp4-output --enable-shared --enable-pic --extra-asflags='-fPIC' --extra-cflags='-march=k8 -mtune=k8 -pipe -fomit-frame-pointer' && make && sudo checkinstall -y"
    sudo "ldconfig"
    run "wget http://ftp.penguin.cz/pub/users/utx/amr/amrnb-7.0.0.2.tar.bz2 -O amrnb-7.0.0.2.tar.bz2 && tar -xjf amrnb-7.0.0.2.tar.bz2 && cd amrnb-7.0.0.2 && ./configure && make && sudo make install"
    run "wget http://ftp.penguin.cz/pub/users/utx/amr/amrwb-7.0.0.3.tar.bz2 -O amrwb-7.0.0.3.tar.bz2 && tar -xjf amrwb-7.0.0.3.tar.bz2 && cd amrwb-7.0.0.3 && ./configure && make && sudo make install"
    sudo "ldconfig"
  end

  desc 'Install FFmpeg'
  task :install, :roles => :app do
    install_dependencies
    run "if test -x ffmpeg; then cd ffmpeg && git checkout master && git pull; else git clone git://git.ffmpeg.org/ffmpeg; fi"
    run "if test -x ffmpeg/libswscale; then cd ffmpeg/libswscale && git checkout master && git pull; else cd ffmpeg && git clone git://git.ffmpeg.org/libswscale; fi"
    if ffmpeg_commit_hash.size > 0
      run "cd ffmpeg && git checkout #{ffmpeg_commit_hash}"
    end
    if libswscale_commit_hash.size > 0
      run "cd ffmpeg/libswscale && git checkout #{libswscale_commit_hash}"
    end
    sudo "ldconfig"
    run "cd ffmpeg && ./configure --enable-gpl --enable-shared --enable-nonfree --enable-libfaadbin --enable-libamr-nb --enable-libamr-wb --enable-libfaac --enable-libfaad --enable-libmp3lame --enable-libx264 --enable-pthreads --enable-libxvid --disable-liba52 --disable-libvorbis --disable-libtheora --disable-libgsm --disable-postproc --disable-swscale --disable-debug --cc='ccache gcc' && make && sudo checkinstall -y"
    sudo "ldconfig"
  end
end
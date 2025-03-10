# frozen_string_literal: true

require_relative "util"

module Scripting
  class Flutter < Scripting::Util
    attr_reader :flutter_file, :flutter_link, :android_file, :android_link

    def initialize
      @flutter_file = "flutter_linux_3.29.1-stable.tar.xz"
      @flutter_link = "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/#{flutter_file}"
      @android_file = "android-studio-2024.3.1.13-linux.tar.gz"
      @android_link = "https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2024.3.1.13/#{android_file}"
      super
    end

    def run
      install_dependencies
      setup_flutter
      setup_android_studio
      run_android_studio
    end

    protected

    def install_dependencies
      puts "Installing dependencies for Flutter and Android Studio...".start

      bash("sudo apt-get update -qq && sudo apt-get upgrade -qq")
      bash("sudo apt-get install -qq libglu1-mesa libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1 libbz2-1.0:i386")
      bash("sudo apt-get install -qq qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils")
      bash("sudo apt-get install -qq clang ninja-build libgtk-3-dev")

      puts "Dependencies were successfully installed.".end
    end

    def setup_flutter
      puts "Installing Flutter...".start

      rm_rf("/usr/bin/flutter", sudo: true)

      download(flutter_link)
      bash("tar -xf #{flutter_file} -C $HOME/development")
      bash("echo 'export PATH=\"$HOME/development/flutter/bin:$PATH\"' >> ~/.zshenv")

      rm_rf(flutter_file)

      puts "Flutter was successfully installed.".end
    end

    def setup_android_studio
      puts "Installing Android Studio...".start

      rm_rf("/usr/bin/android-studio", sudo: true)

      download(android_link)
      bash("sudo tar -xf #{android_file} android-studio")
      mv("android-studio", "/usr/bin/", sudo: true)

      rm_rf(android_file)

      puts "Android Studio was successfully installed.".end
    end

    def run_android_studio
      puts "Starting Android Studio... Proceed with GUI installation.".warning

      cd("/usr/bin/android-studio/bin") do
        bash("./studio.sh")
      end

      puts "Android Studio was successfully installed..".end
      puts "Do NOT forget to run `flutter doctor` AFTER installing cmdline-tools components from Android SDK".warning
    end
  end
end

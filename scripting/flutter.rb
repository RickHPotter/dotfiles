# frozen_string_literal: true

require_relative "util"

module Scripting
  class Flutter < Scripting::Util
    def self.run
      new.run
    end

    def run
      install_dependencies
      setup_flutter
      setup_android_studio
      run_android_studio
    end

    protected

    def install_dependencies
      bash("sudo apt-get update -qq && sudo apt-get upgrade -qq")
      bash("sudo apt-get install -qq libglu1-mesa libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1 libbz2-1.0:i386")
      bash("sudo apt-get install -qq qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils")
      bash("sudo apt-get install -qq clang ninja-build libgtk-3-dev")
    end

    def setup_flutter
      file = "flutter_linux_3.22.1-stable.tar.xz"
      link = "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/#{file}"

      download(link)
      bash("sudo tar -xf #{file} -C /usr/bin/")
      bash("echo 'export PATH=\"$HOME/development/flutter/bin:$PATH\"' >> ~/.zshenv")

      rm_rf(file)

      p "Flutter was successfully installed."
    end

    def setup_android_studio
      file = "android-studio-2023.3.1.19-linux.tar.gz"
      link = "https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2023.3.1.19/#{file}"

      download(link)
      bash("sudo tar -xf #{file} android-studio")
      mv("android-studio", "/usr/bin/", sudo: true)

      rm_rf(file)

      p "Android Studio was successfully installed."
    end

    def run_android_studio
      p "Starting Android Studio... Proceed with GUI installation."

      cd("/usr/bin/android-studio/bin") do
        bash("./studio.sh")
      end

      p "Android Studio was successfully installed.."
      p "Do not forget to run flutter doctor AFTR installing cmdline-tools components from Android SDK"
    end
  end
end

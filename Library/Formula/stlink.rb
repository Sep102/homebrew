require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Stlink < Formula
  homepage 'https://github.com/texane/stlink'
  url 'https://github.com/texane/stlink.git', :revision => '992a9c2'
  version '20130507-992a9c2'
  sha1 'e07e9d6f5356bc016d5dd0f3c1105037c1e1dedf'
  head 'https://github.com/texane/stlink.git'

  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'pkg-config' => :build
  depends_on 'libusb'

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end

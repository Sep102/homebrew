require 'formula'

class Openttd < Formula
  url 'http://us.binaries.openttd.org/binaries/releases/1.1.0/openttd-1.1.0-source.tar.gz'
  head 'git://git.openttd.org/openttd/trunk.git'
  homepage 'http://www.openttd.org/'
  md5 'd5ca3357e5c7f995aa43414ff4d93cfb'

  depends_on 'lzo'
  depends_on 'xz'

  def install
    system "./configure", "--prefix-dir=#{prefix}"
    system "make bundle"
    prefix.install 'bundle/OpenTTD.app'
  end

  def caveats; <<-EOS.undent
    Note: This does not install any art assets. You will be prompted
    on first run to download an asset set.
    Having an original TTD CD will help.
    EOS
  end
end

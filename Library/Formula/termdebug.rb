require 'formula'

class Termdebug < Formula
  homepage ''
  url 'http://os.ghalkes.nl/dist/termdebug-1.2.tgz'
  sha1 '8695a09465ccc39a965c19cd8fcbfc59a20ff1ce'

  def install
    system "./configure", "--prefix=#{prefix}"

    system "make all" 
    system "make install"
  end
end

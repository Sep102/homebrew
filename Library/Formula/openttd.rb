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
    
    ohai 'Downloading freeware data packs (OpenGFX, OpenMSX, OpenSFX).'
    cd 'bundle/OpenTTD.app/Contents/Resources' do
      cd 'data' do
        curl 'http://bundles.openttdcoop.org/opengfx/releases/0.3.3/opengfx-0.3.3.zip',
             'http://bundles.openttdcoop.org/opensfx/releases/0.2.3/opensfx-0.2.3.zip',
             '-OO'

        system 'for zip in open*.zip; do unzip $zip; rm $zip; done'
      end
      cd 'gm' do
        curl 'http://bundles.openttdcoop.org/openmsx/releases/0.3.1/openmsx-0.3.1.zip',
             '-O'

        system 'for zip in open*.zip; do unzip $zip; rm $zip; done'
      end
    end

    prefix.install 'bundle/OpenTTD.app'
  end

  def caveats; <<-EOS.undent
      OpenTTD.app installed to: #{prefix}
      If you have access to the sound and graphics files from the original 
      Transport Tycoon Deluxe, you can install them by following the 
      instructions in section 4.2 of the OpenTTD readme.
    EOS
  end
end

require 'formula'

class Moonscript < Formula
  url 'http://moonscript.org/rocks/moonscript-0.1.0-1.rockspec', :using => :curl
  version '0.1.0-1'
  md5 '34859f29ea4637dd0309cab09b50a951'
  homepage 'http://moonscript.org/'

  depends_on 'lua'
  depends_on 'luarocks'

  def install
	['lpeg', 'alt-getopt', 'luafilesystem'].each do |rock|
		system 'luarocks', 'install', rock
	end

	system 'luarocks', 'build', 'moonscript-0.1.0-1.rockspec'
  end

  def test
	  true
  end
end

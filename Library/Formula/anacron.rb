require 'formula'

class Anacron < Formula
  url 'http://downloads.sourceforge.net/project/anacron/anacron/2.3/anacron-2.3.tar.gz'
  homepage 'http://sourceforge.net/projects/anacron/'
  md5 '865cc1dfe1ed75c470d3e6de13763f03'

  # anacron isn't smart enough to create its directories, so it needs them
  # to stick around
  skip_clean 'var/spool/anacron'

  def patches
    DATA
  end

  def install
    # The README is mostly out of date/not for MacOS and largely superseded by
    # brew itself and caveats, so just delete it (unless someone wanted to
    # rewrite part/all of it)
    rm 'README'

    curl '-qq', 'https://trac.macports.org/export/78141/trunk/dports/sysutils/anacron/files/obstack.h', '-O'
    curl '-qq', 'https://trac.macports.org/export/78141/trunk/dports/sysutils/anacron/files/obstack.c', '-O'

    # Update man pages with new paths
    inreplace ['anacron.8', 'anacrontab.5'],
      '/etc/anacrontab', "#{HOMEBREW_PREFIX}/etc/anacrontab"

    inreplace 'anacron.8', '/var/spool', "#{HOMEBREW_PREFIX}/var/spool"

    ENV['PREFIX'] = prefix
    system 'make'
    system 'make install'

    (prefix+'com.anacron.anacron.plist').write startup_plist
    ln_s (prefix+'var/spool'), var
  end

  def caveats; <<-EOS.undent
    You can enable anacron to automatically load on login with:
        mkdir -p ~/Library/LaunchAgents
        cp #{prefix}/com.anacron.anacron.plist ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/com.anacron.anacron.plist

        Or start it manually:
            #{HOMEBREW_PREFIX}/sbin/anacron

        Add "-s" to run tasks sequentially as each finish.

    No anacrontab installed by default.
    Please create #{etc}/anacrontab with the format described in anacrontab(5).

    EOS
  end

  def startup_plist
    return <<-EOPLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>com.anacron.anacron</string>
  <key>KeepAlive</key>
  <true/>
  <key>ProgramArguments</key>
  <array>
    <string>#{HOMEBREW_PREFIX}/sbin/anacron -s</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
</dict>
</plist>
    EOPLIST
  end
end


__END__
diff --git a/Makefile b/Makefile
index 555e524..a5cf3e7 100644
--- a/Makefile
+++ b/Makefile
@@ -19,16 +19,15 @@
 #   `COPYING' that comes with the Anacron source distribution.
 
 
-PREFIX = 
-BINDIR = $(PREFIX)/usr/sbin
-MANDIR = $(PREFIX)/usr/man
+BINDIR = $(PREFIX)/sbin
+MANDIR = $(PREFIX)/share/man
 CFLAGS = -Wall -pedantic -O2
 #CFLAGS = -Wall -O2 -g -DDEBUG
 
 # If you change these, please update the man-pages too
 # Only absolute paths here, please
-SPOOLDIR = /var/spool/anacron
-ANACRONTAB = /etc/anacrontab
+SPOOLDIR = $(PREFIX)/var/spool/anacron
+ANACRONTAB = $(PREFIX)/etc/anacrontab
 
 RELEASE = 2.3
 package_name = anacron-$(RELEASE)
@@ -64,7 +63,7 @@ anacron: $(objects)
 
 .PHONY: installdirs
 installdirs:
-	$(INSTALL_DIR) $(BINDIR) $(PREFIX)$(SPOOLDIR) \
+	$(INSTALL_DIR) $(BINDIR) $(SPOOLDIR) \
		$(MANDIR)/man5 $(MANDIR)/man8
 
 .PHONY: install
diff --git a/gregor.c b/gregor.c
index 1464398..012a575 100644
--- a/gregor.c
+++ b/gregor.c
@@ -65,7 +65,7 @@ day_num(int year, int month, int day)
 {
     int dn;
     int i;
-    const int isleap; /* save three calls to leap() */
+    int isleap; /* save three calls to leap() */
 
     /* Some validity checks */
 
diff --git a/readtab.c b/readtab.c
index 4157ebc..1b2dd08 100644
--- a/readtab.c
+++ b/readtab.c
@@ -29,13 +29,13 @@
 #include <errno.h>
 #include <stdio.h>
 #include <stdlib.h>
-#include <obstack.h>
 #include <limits.h>
 #include <fnmatch.h>
 #include <unistd.h>
 #include <signal.h>
 #include "global.h"
 #include "matchrx.h"
+#include "obstack.h"
 
 static struct obstack input_o;   /* holds input line */
 static struct obstack tab_o;    /* holds processed data read from anacrontab */

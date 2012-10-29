require 'formula'

class MyMan < Formula
  homepage 'http://myman.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/myman/myman/myman-0.6/myman-0.6.tar.gz'
  sha1 'affdef4c29e32ab0e48508455a581b06ea6dc23c'

  depends_on 'gnu-sed'
  depends_on 'coreutils'

  def patches
    DATA
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make", "install", "MANDIR=#{man6}", "INFODIR=#{info}"
  end
end


__END__
diff --git a/Makefile b/Makefile
index b4334a4..ee6089c 100644
--- a/Makefile
+++ b/Makefile
@@ -637,13 +637,13 @@ RMFLAGS = -f
 REMOVE = $(RM) $(RMFLAGS) $(EXTRARMFLAGS)
 
 # directory removal (empty directories only!)
-RMDIR = rmdir
+RMDIR = grmdir
 RMDIRFLAGS = --ignore-fail-on-non-empty
 REMOVE_DIR = $(RMDIR) $(RMDIRFLAGS) $(EXTRARMDIRFLAGS)
 
 # file and directory installation
 #INSTALL = /usr/bin/install
-INSTALL = install
+INSTALL = ginstall
 INSTALLFLAGS =
 STRIPINSTALLFLAGS =
 INSTALL_PROGRAM = $(INSTALL) $(INSTALLFLAGS) $(EXTRAINSTALLFLAGS)
diff --git a/configure b/configure
index 04f0202..aeb7219 100755
--- a/configure
+++ b/configure
@@ -73,7 +73,7 @@ build=`
         ' 2>/dev/null ||
             echo "${MACHTYPE:-${cputype:-unknown}-${vendor:-unknown}-${ostype:-unknown}}"
     ) |
-        sed '
+        gsed '
            s/\([^-/]\+\)\/\([^-]\+\)/\2-\1/g;
         ' |
             tr "${charclass_ascii_upper}"/ "${charclass_ascii_lower}"-
@@ -131,7 +131,7 @@ __EOF__
 echolinex()
 {
     echoline "$*" |
-        sed -ne '1 h; 2,$ H; $ {; g; s/[\\?""]/\\&/g; s/'"${char_tab}"'/\\t/g; s/'"\\${char_newline}"'/\\n/g; p; }'
+        gsed -ne '1 h; 2,$ H; $ {; g; s/[\\?""]/\\&/g; s/'"${char_tab}"'/\\t/g; s/'"\\${char_newline}"'/\\n/g; p; }'
 }
 
 ${END_ECHOLINE_LIBRARY}
@@ -153,14 +153,14 @@ varsafe()
     # --enable and --with parameter names into shell variable names
 
     echoline "$*" |
-        sed -ne 's/[^'"${charclass_ascii_id}"']/_/g; 1 h; 2,$ H; $ {; g; s/\
+        gsed -ne 's/[^'"${charclass_ascii_id}"']/_/g; 1 h; 2,$ H; $ {; g; s/\
 /_/g; p; }'
 }
 
 qw()
 {
     echoline "$*" |
-        sed -ne 's/\([ '\!'"#$&'\''()*;<>?@^`{|}~\\]\|\[\|\]\)/\\\1/g; 1 h; 2,$ H; $ {; g; s/\
+        gsed -ne 's/\([ '\!'"#$&'\''()*;<>?@^`{|}~\\]\|\[\|\]\)/\\\1/g; 1 h; 2,$ H; $ {; g; s/\
 /"${char_newline}"/g; s/'"${char_tab}"'/"${char_tab}"/g; p; }'
 }
 
@@ -168,7 +168,7 @@ mqw()
 {
 
     echoline "$*" |
-        sed -ne '
+        gsed -ne '
             1 h;
             2,$ H;
             $ {;
@@ -513,7 +513,7 @@ ${_echoline:-:} "${'"${feature}"':+endif}"
 
 mqlib()
 {
-    sed -n -e '/START_STRING_QUOTING_LIBRARY/,/END_STRING_QUOTING_LIBRARY/ p' < \
+    gsed -n -e '/START_STRING_QUOTING_LIBRARY/,/END_STRING_QUOTING_LIBRARY/ p' < \
         "${srcdir}/Makefile"
 }

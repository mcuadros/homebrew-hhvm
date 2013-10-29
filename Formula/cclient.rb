require 'formula'

class Cclient <Formula
  url 'ftp://ftp.cac.washington.edu/mail/imap.tar.Z'
  homepage 'http://www.washington.edu/imap/'
  md5 'd9f7fd4e1d93ad9fca1df8717a79d1c5'
  version '2007e'

  def patches; DATA; end

  def install
    # make breaks with -j option
    system "/usr/bin/make", "oxp","MAKEFLAGS="
    system "install -m 755 -d #{prefix}/include/c-client"
    system "cd c-client; install -m 644 \
      c-client.h dummy.h env.h env_unix.h fdstring.h flockcyg.h flocksim.h \
      flstring.h fs.h ftl.h imap4r1.h linkage.c linkage.h mail.h \
      misc.h netmsg.h newsrc.h nl.h nntp.h osdep.h \
      pseudo.h rfc822.h smtp.h sslio.h tcp.h tcp_unix.h unix.h \
      utf8.h utf8aux.h \
    #{prefix}/include/c-client"
    lib.install "c-client/c-client.a" => "libc-client4.a"
    #system "ranlib #{prefix}/lib/libc-client4.a"
  end
end

__END__
diff --git a/Makefile b/Makefile
index e6e4987..d75306c 100644
--- a/Makefile
+++ b/Makefile
@@ -418,7 +418,7 @@ oxp:  an
 	$(TOUCH) ip6
 	$(BUILD) BUILDTYPE=osx IP=$(IP6) EXTRAAUTHENTICATORS="$(EXTRAAUTHENTICATORS) gss" \
 	PASSWDTYPE=pam \
-	EXTRACFLAGS="$(EXTRACFLAGS) -DMAC_OSX_KLUDGE=1" \
+	EXTRACFLAGS="$(EXTRACFLAGS)" \
 	SPECIALS="SSLINCLUDE=/usr/include/openssl SSLLIB=/usr/lib SSLCERTS=/System/Library/OpenSSL/certs SSLKEYS=/System/Library/OpenSSL/private GSSINCLUDE=/usr/include GSSLIB=/usr/lib PAMDLFLAGS=-lpam"
 
 osx:	osxok an
diff --git a/src/osdep/unix/ckp_pam.c b/src/osdep/unix/ckp_pam.c
index 60c6c1f..674941c 100644
--- a/src/osdep/unix/ckp_pam.c
+++ b/src/osdep/unix/ckp_pam.c
@@ -27,11 +27,7 @@
  */
 
 
-#ifdef MAC_OSX_KLUDGE		/* why can't Apple be compatible? */
-#include <pam/pam_appl.h>
-#else
 #include <security/pam_appl.h>
-#endif
 
 struct checkpw_cred {
   char *uname;			/* user name */

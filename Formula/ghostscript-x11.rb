class GhostscriptX11 < Formula
  desc "Interpreter for PostScript and PDF"
  homepage "https://www.ghostscript.com/"
  url "https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs9533/ghostpdl-9.53.3.tar.gz"
  sha256 "96d04e4e464bddb062c1774ea895c4f1c1c94e6c4b62f5d32218ebd44dd65ba1"
  license "AGPL-3.0-or-later"

  livecheck do
    url :head
    regex(/^ghostpdl[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  keg_only :shadowed_by_ghostscript, "ghostscript core formula provides non-X11 version"
  
  head do
    # Can't use shallow clone. Doing so = fatal errors.
    url "https://git.ghostscript.com/ghostpdl.git", shallow: false

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libtiff"
  depends_on :x11

  on_macos do
    patch :DATA # Uncomment macOS-specific make vars
  end
  
  on_linux do
    depends_on "fontconfig"
    depends_on "libidn"
  end

  # https://sourceforge.net/projects/gs-fonts/
  resource "fonts" do
    url "https://downloads.sourceforge.net/project/gs-fonts/gs-fonts/8.11%20%28base%2035%2C%20GPL%29/ghostscript-fonts-std-8.11.tar.gz"
    sha256 "0eb6f356119f2e49b2563210852e17f57f9dcc5755f350a69a46a0d641a0c401"
  end

  def install
    # Fixes: ./soobj/dxmainc.o: file not recognized: File truncated
    ENV.deparallelize unless OS.mac?

    args = %W[
      --prefix=#{prefix}
      --disable-cups
      --disable-compile-inits
      --disable-gtk
      --disable-fontconfig
      --without-libidn
    ]

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end

    # Install binaries and libraries
    system "make", "install"
    system "make", "install-so"

    (pkgshare/"fonts").install resource("fonts")
    (man/"de").rmtree
  end

  test do
    ps = test_fixtures("test.ps")
    assert_match /Hello World!/, shell_output("#{bin}/ps2ascii #{ps}")
  end
end

__END__
diff --git i/base/unix-dll.mak w/base/unix-dll.mak
index f50c09c00adb..8855133b400c 100644
--- i/base/unix-dll.mak
+++ w/base/unix-dll.mak
@@ -89,18 +89,33 @@ GPDL_SONAME_MAJOR_MINOR=$(GPDL_SONAME_BASE)$(GS_SOEXT)$(SO_LIB_VERSION_SEPARATOR
 # similar linkers it must containt the trailing "="
 # LDFLAGS_SO=-shared -Wl,$(LD_SET_DT_SONAME)$(LDFLAGS_SO_PREFIX)$(GS_SONAME_MAJOR)


 # MacOS X
-#GS_SOEXT=dylib
-#GS_SONAME=$(GS_SONAME_BASE).$(GS_SOEXT)
-#GS_SONAME_MAJOR=$(GS_SONAME_BASE).$(GS_VERSION_MAJOR).$(GS_SOEXT)
-#GS_SONAME_MAJOR_MINOR=$(GS_SONAME_BASE).$(GS_VERSION_MAJOR).$(GS_VERSION_MINOR).$(GS_SOEXT)
+GS_SOEXT=dylib
+GS_SONAME=$(GS_SONAME_BASE).$(GS_SOEXT)
+GS_SONAME_MAJOR=$(GS_SONAME_BASE).$(GS_VERSION_MAJOR).$(GS_SOEXT)
+GS_SONAME_MAJOR_MINOR=$(GS_SONAME_BASE).$(GS_VERSION_MAJOR).$(GS_VERSION_MINOR).$(GS_SOEXT)
 #LDFLAGS_SO=-dynamiclib -flat_namespace
-#LDFLAGS_SO_MAC=-dynamiclib -install_name $(GS_SONAME_MAJOR_MINOR)
+GS_LDFLAGS_SO=-dynamiclib -install_name $(GS_SONAME_MAJOR_MINOR)
 #LDFLAGS_SO=-dynamiclib -install_name $(FRAMEWORK_NAME)

+PCL_SONAME=$(PCL_SONAME_BASE).$(GS_SOEXT)
+PCL_SONAME_MAJOR=$(PCL_SONAME_BASE).$(GS_VERSION_MAJOR).$(GS_SOEXT)
+PCL_SONAME_MAJOR_MINOR=$(PCL_SONAME_BASE).$(GS_VERSION_MAJOR).$(GS_VERSION_MINOR).$(GS_SOEXT)
+PCL_LDFLAGS_SO=-dynamiclib -install_name $(PCL_SONAME_MAJOR_MINOR)
+
+XPS_SONAME=$(XPS_SONAME_BASE).$(GS_SOEXT)
+XPS_SONAME_MAJOR=$(XPS_SONAME_BASE).$(GS_VERSION_MAJOR).$(GS_SOEXT)
+XPS_SONAME_MAJOR_MINOR=$(XPS_SONAME_BASE).$(GS_VERSION_MAJOR).$(GS_VERSION_MINOR).$(GS_SOEXT)
+XPS_LDFLAGS_SO=-dynamiclib -install_name $(XPS_SONAME_MAJOR_MINOR)
+
+GPDL_SONAME=$(GPDL_SONAME_BASE).$(GS_SOEXT)
+GPDL_SONAME_MAJOR=$(GPDL_SONAME_BASE).$(GS_VERSION_MAJOR).$(GS_SOEXT)
+GPDL_SONAME_MAJOR_MINOR=$(GPDL_SONAME_BASE).$(GS_VERSION_MAJOR).$(GS_VERSION_MINOR).$(GS_SOEXT)
+GPDL_LDFLAGS_SO=-dynamiclib -install_name $(GPDL_SONAME_MAJOR_MINOR)
+
 GS_SO=$(BINDIR)/$(GS_SONAME)
 GS_SO_MAJOR=$(BINDIR)/$(GS_SONAME_MAJOR)
 GS_SO_MAJOR_MINOR=$(BINDIR)/$(GS_SONAME_MAJOR_MINOR)

 PCL_SO=$(BINDIR)/$(PCL_SONAME)

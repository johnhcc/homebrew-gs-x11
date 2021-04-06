class Gv < Formula
  desc "View and navigate through PostScript and PDF documents"
  homepage "https://www.gnu.org/s/gv/"
  url "https://ftp.gnu.org/gnu/gv/gv-3.7.4.tar.gz"
  mirror "https://ftpmirror.gnu.org/gv/gv-3.7.4.tar.gz"
  sha256 "2162b3b3a95481d3855b3c4e28f974617eef67824523e56e20b56f12fe201a61"

  depends_on "pkg-config" => :build
  depends_on "johnhcc/gs-x11/ghostscript-x11"
  depends_on "libx11"
  depends_on "libxaw3d"

  skip_clean "share/gv/safe-gs-workdir"

  def install
    inreplace "src/Makefile.in", "GV.gsInterpreter:\tgs", "GV.gsInterpreter:\t#{HOMEBREW_PREFIX\
}/opt/ghostscript-x11/bin/gs"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-SIGCHLD-fallback"
    system "make", "install", "LC_ALL=C"
  end

  test do
    system "#{bin}/gv", "--version"
  end
end

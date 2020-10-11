# Ghostscript and GV with X11 for MacOS and Linux

The Homebrew core Ghostscript formula no longer supports X11, which also prevents use of GV (a derivative of Ghostview). I created this custom tap to allow users to install these formulae once again, on either Mac and Linux systems. First, [install Homebrew](https://brew.sh) if necessary.

To install Ghostscript with X11 support:
```
brew install johnhcc/gs-x11/ghostscript-x11
```
Ghostscript will be installed as [keg-only](https://docs.brew.sh/FAQ#what-does-keg-only-mean), meaning it will not be linked into `/usr/local` to prevent conflicts with the core Ghostscript formula. However you can still access the X11-enabled binaries directly at `$(brew --prefix)/opt/ghostscript-x11/bin`.

Similarly, GV can be installed with:
```
brew install johnhcc/gs-x11/gv
```

### Disclaimer
*These formulae are modifications of Homebrew-provided formula files. There is no guarantee of timely (or any) updates to this tap or the formulae therein (this doesn't mean I won't try, though). Use at your own risk.*

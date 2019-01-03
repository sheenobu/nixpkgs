{ stdenv, fetchurl, libwpg, libwpd, lcms, pkgconfig, librevenge, icu, boost, cppunit }:

stdenv.mkDerivation rec {
  name = "libcdr-0.1.5";

  src = fetchurl {
    url = "https://dev-www.libreoffice.org/src/${name}.tar.xz";
    sha256 = "0j1skr11jwvafn0l6p37v3i4lqc8wcn489g8f7c4mqwbk94mrkka";
  };

  buildInputs = [ libwpg libwpd lcms librevenge icu boost cppunit ];

  nativeBuildInputs = [ pkgconfig ];

  # Boost 1.59 compatability fix
  # Attempt removing when updating
  postPatch = ''
    sed -i 's,^CPPFLAGS.*,\0 -DBOOST_ERROR_CODE_HEADER_ONLY -DBOOST_SYSTEM_NO_DEPRECATED,' src/lib/Makefile.in
  '';

  configureFlags = stdenv.lib.optional stdenv.cc.isClang "--disable-werror";

  CXXFLAGS="--std=gnu++0x"; # For c++11 constants in lcms2.h

  meta = {
    description = "A library providing ability to interpret and import Corel Draw drawings into various applications";
    homepage = http://www.freedesktop.org/wiki/Software/libcdr;
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.mpl20;
  };
}

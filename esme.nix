{ stdenv, chibi, readline }:

stdenv.mkDerivation {
  name = "chibi-0.1";
  src = ./.;
  buildInputs = [ chibi readline ];
  meta = with stdenv.lib; {
    homepage = "https://github.com/ttuegel/esme";
    license = [ licenses.gpl3Plus ];
    platforms = chibi.meta.platforms;
    shortDescription = "Shell inspired by Scheme";
  };
}

#!/bin/sh

set -e

# Build from autotools(-like) tarballs
tarball_build() (
    if [ "$#" -lt 3 ] ; then
        echo "Usage: tarball_build <name> <url-format> <version> [configure_options...]"
        exit 2
    fi

    url="$(printf "$2" "$3")"
    filename="tmp-${url##*/}"
    name="$1"
    version="$3"
    shift 3

    # Add --insecure if installed certs become too old, to ignore verification errors
    curl --location "$url" > "$filename"
    tar xf "$filename"
    rm "$filename"
    cd "$name"-"$version"

    ./configure "$@"
    make -j "$(nproc)"
    sudo make install
    make clean
)

mkdir -p /tmp/build
cd /tmp/build

## GNU FriBidi
### libass min version 0.19.0, but 0.19.1 is the first "CVS release"
### and I couldn't locate a 0.19.0 tarball
urlfmt='https://github.com/fribidi/fribidi/releases/download/FRIBIDI_0_19_1/fribidi-%s.tar.gz'
tarball_build fribidi "$urlfmt" "0.19.1"

## FreeType2 (without HarfBuzz)
### Internal version 9.17.3 == external version 2.3.6
urlfmt='https://download.savannah.gnu.org/releases/freetype/freetype-old/freetype-%s.tar.bz2'
tarball_build freetype "$urlfmt" "2.3.6"

## HarfBuzz
urlfmt='https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-%s.tar.bz2'
tarball_build harfbuzz "$urlfmt" "1.2.3"

## Fontconfig
urlfmt='https://www.freedesktop.org/software/fontconfig/release/fontconfig-%s.tar.bz2'
tarball_build fontconfig "$urlfmt" "2.10.92"

# Clean up
cd /
rm -fr /tmp/build

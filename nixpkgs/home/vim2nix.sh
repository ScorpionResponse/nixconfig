#!/usr/bin/env sh
# Simple script to create a buildVimPlugin drv for NixOs
# JagaJaga 2014
# Scorpionresponse 2020
# Usage ./vim2nix.sh repoOwner/repoName (only github is supported)

if [ $# -ne 1 ]; then
    echo "Usage: $0 <github path>"
    echo "Eg $0 scorpionresponse/nixconfig"
    exit 1
fi

github_path="$1"

homepage="https://github.com/${github_path}"
rep="https://github.com/${github_path}.git"
rev=$(git ls-remote "${rep}" | head -1 | cut -f1)

owner=$(echo "${github_path}" | cut -d"/" -f1)
repo=$(echo "${github_path}" | cut -d"/" -f2)
if [ "$repo" = "vim" ]; then
	name="$owner"
else
	name=$(echo "${repo}" | sed 's/vim-\(.*\)/\1/g' | sed 's/\(.*\)\.vim/\1/g')
fi

hashurl="$homepage/archive/${rev}.tar.gz"
hash=$(nix-prefetch-url --unpack "${hashurl}" 2>&1 | tail -n1)

if [ -n "$name" ]; then
    git clone "$rep" "$name" > /dev/null 2>&1
    cd "$name"
    version=$(git log -n 1 --pretty=format:"%ci" | sed 's/\([0-9-]\)\s.*/\1/g')
    cd ../
    rm -rf "$name"
else
    version="0.0"
fi

echo "
  $name = pkgs.vimUtils.buildVimPlugin {
    name = \"$name-git-$version\";
    src = pkgs.fetchFromGitHub {
      owner = \"$owner\";
      repo = \"$repo\";
      rev = \"$rev\";
      sha256 = \"$hash\";
     };
    meta = {
      homepage = $homepage; 
      maintainers = [ \"$owner\" ];
    };
  };
"

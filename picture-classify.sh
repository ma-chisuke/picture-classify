#!/bin/bash -u

DISTINATION=dist

function classify() {
  local _f=$1
  local _subDir
  _subDir=$(exiftool "${_f}" | grep "File Modification Date/Time" | sed 's/.*: //g' | awk '{ print $1}' | tr : _)

  mkdir -p "./${DISTINATION}/${_subDir}"
  if ! mv -v "${_f}" "./${DISTINATION}/${_subDir}/" ;then
    echo "Error. Failed move file."
    exit 2
  fi
}

while read -r l ;do
  [[ -z $l ]] && exit
  classify "$l"
done <<_EOL_
$(find . \
  -type f \
  -and ! -path "./${DISTINATION}/*" \
  -and ! -path "./.vscode/*" \
  -and ! -name "*.sh" \
  -and ! -name ".*")
_EOL_

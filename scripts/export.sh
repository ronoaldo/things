#!/usr/bin/bash
set -e
# set -x

export_png() {
	echo
    echo "Generating preview for $scad ..."
	IN="$1"
	OUT="${1/.scad/.png}"
	PRESET=""
	if [ "${2}" != "" ]; then
		export PRESET="-p $3 -P $2" OUT="${1/.scad/}_${2}.png"
	fi
    openscad \
        --autocenter \
		--viewall \
        --colorscheme Metallic \
		--backend manifold \
        --render \
        --imgsize=1024,768 \
		$PRESET -o "$OUT" "$IN" 
}

export_stl() {
	echo
    echo "Generating default printable part for $scad ..."
	IN="$1"
	OUT="${1/.scad/.stl}"
	PRESET=""
	if [ "${2}" != "" ]; then
		export PRESET="-p $3 -P $2" OUT="${1/.scad/}_${2}.stl"
	fi
    openscad \
		--render \
        --enable predictible-output \
		--backend manifold \
		$PRESET -o "$OUT" "$IN"
}

echo "Exporting ..."
FILES="${@:-$(find -type f -iname *.scad | grep -v third_party | grep -v wip)}"
for scad in $FILES ; do
	presets=${scad/.scad/.json}
	if [ -f $presets ]; then
		# If we have additional parameter presets, export the variations
		for p in $(cat "${presets}" | jq -r '.parameterSets | keys | .[]') ; do
			echo "Exporting preset $p from $presets"
			export_stl "$scad" "$p" "$presets"
			export_png "$scad" "$p" "$presets"
		done
	else
		# Otherwise, export default model only
		export_png "$scad"
		export_stl "$scad"
	fi
done

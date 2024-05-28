#!/usr/bin/bash
set -e

JOBS=""
export_png() {
    echo "Generating preview for $scad ..."
	IN="$1"
	OUT="${1/.scad/.png}"
	PRESET=""
	if [ "${2}" != "" ]; then
		export PRESET="-p $3 -P $2" OUT="${1/.scad/}_${2}.png"
	fi
    openscad \
        --enable sort-stl \
        --autocenter --viewall \
        --colorscheme Metallic \
        --render \
        --imgsize=1024,768 \
		$PRESET -o "$OUT" "$IN" &
    JOB=$!
    echo "Job started with PID: $JOB"
    export JOBS="$JOBS $JOB"
}

export_stl() {
    echo "Generating default printable part for $scad ..."
	IN="$1"
	OUT="${1/.scad/.stl}"
	PRESET=""
	if [ "${2}" != "" ]; then
		export PRESET="-p $3 -P $2" OUT="${1/.scad/}_${2}.stl"
	fi
    openscad \
        --enable sort-stl \
		$PRESET -o "$OUT" "$IN" &
    JOB=$!
    echo "Job started with PID: $JOB"
    export JOBS="$JOBS $JOB"
}

FILES="${@:-$(find -type f -iname *.scad | grep -v third_party)}"
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

echo "Waiting for $JOBS ..."
sleep 1
for pid in $JOBS ; do
    wait $pid || echo "$pid finished"
done
#!/bin/bash
set -e

function list_models_as_markdown() {
    echo "# Models" > MODELS.toc
    
    FOLDER=""
    find -type f -iname '*.stl' | grep -v 'wip/' | while read STL ; do
        _PREFIX="${STL%/*}"
        _PREFIX="${_PREFIX#./}"
        if [ "$FOLDER" != "${_PREFIX}" ]; then
            export FOLDER="${_PREFIX}"
            TITLE="${FOLDER^}"
            TITLE="${TITLE/-/ }"
            echo
            echo "## ${TITLE}"
            echo "1. [${TITLE}](#${FOLDER})" >> MODELS.toc
        fi
        PNG="${STL/.stl/.png}"

        echo "---"
        echo "![$PNG]($PNG)"
        echo "View [model STL file]($STL)"
        echo
    done
}

function cleanup() {
    rm -f MODELS.toc MODELS.body.md
}

list_models_as_markdown > MODELS.body.md
cat MODELS.toc MODELS.body.md > MODELS.md
cleanup
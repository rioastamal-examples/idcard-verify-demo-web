#!/bin/sh

realpath() {
    [[ $1 = /* ]] && {
        echo "$1"
        return 0
    }

    [[ "$1" = "." ]] && {
        echo "$PWD"
        return 0
    }

    echo "$PWD/${1#./}"
}

[ -z "$BASE_API_URL" ] && {
    echo "Missing BASE_API_URL env." >&2
    exit 1
}

BASE_DIR=$( dirname "$0" )
ABS_DIR=$( realpath $BASE_DIR )

rm -r $ABS_DIR/dist/*
mkdir -p $ABS_DIR/dist/public

echo "$@" | grep '\-\-build' > /dev/null && {
    echo "Frontend Build: Replacing BASE_API_URL with ${BASE_API_URL}..."
    cp -a $ABS_DIR/src/* $ABS_DIR/dist/public/
    sed "s#{{BASE_API_URL}}#$BASE_API_URL#g" $ABS_DIR/src/index.html > $ABS_DIR/dist/public/index.html
    sed "s#{{BASE_API_URL}}#$BASE_API_URL#g" $ABS_DIR/src/profile/index.html > $ABS_DIR/dist/public/profile/index.html
    sed "s#{{BASE_API_URL}}#$BASE_API_URL#g" $ABS_DIR/src/dashboard/index.html > $ABS_DIR/dist/public/dashboard/index.html
}

cd $ABS_DIR/dist/public && \
zip -r $ABS_DIR/dist/serverless-frontend.zip ./*

exit 0
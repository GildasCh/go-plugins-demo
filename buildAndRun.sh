#!/usr/bin/env bash

set -x

# Compile plugins

pluginSrc='pluginSrc'
pluginDirs=`ls $pluginSrc`
mkdir -p plugins

for i in ${pluginDirs}
do
    fullPath=${pluginSrc}/$i
    (cd $fullPath; docker run --rm -v "$PWD":/usr/src/$fullPath -w /usr/src/$fullPath golang:1.8 go build -buildmode=plugin)
done

mv -f `find $pluginSrc -name '*.so'` plugins/

# Compile main app

docker run --rm -v "$PWD":/usr/src/myapp -w /usr/src/myapp golang:1.8 go build

# Run it

./myapp plugins

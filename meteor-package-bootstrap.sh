#!/bin/sh

# Exit on any error
set -e

dest="$1"

if [ "$1" == "" ]; then
	echo "USAGE: $0 <output-path>"
	echo
	echo "NOTE: The package name is determined as the last part of the path."
	echo "      Do not rename the package afterwards, because the url of the"
	echo "      glyphicons will then be incorrect."
	exit 1
fi

if [ -d "$dest" ]; then
	echo "Output package path already exists. Aborting."
	echo "$dest"
	exit 2
fi

package_name=`basename "$dest"`
extradesc=''

if [ -f less/bootstrap.less ] && [ -f Makefile ]; then
	# Git checkout

	echo "* Local folder looks like a bootstrap git checkout"
	css_dir="docs/assets/css"
	js_dir="docs/assets/js"

	echo "* Running 'npm install' to install any missing build dependencies"
	npm install

	echo "* Building bootstrap ('make')"
	make

	if [ -d .git ]; then
		extradesc="; `git rev-parse --abbrev-ref HEAD` `git rev-parse --short HEAD`"
	fi

elif [ -f css/bootstrap.css ]; then
	# Precompiled

	echo "* Local folder looks like a precompiled bootstrap distribution"
	css_dir="css"
	js_dir="js"
	
else

	echo "ERROR: Current folder does neither seem to be a bootstrap checkout"
	echo "       nor a precompiled distributions. Aborting."
	exit 9

fi

echo "* Creating Meteor package at $dest"
mkdir "$dest" "$dest/css" "$dest/js" "$dest/img"

echo "* Copying CSS"
# Fix icon urls
cat "$css_dir/bootstrap.css" \
	| sed "s/url(\".*\\/glyphicons-halflings/url(\"\\/packages\\/$package_name\\/img\\/glyphicons-halflings/" \
	> "$dest/css/bootstrap.css"

cp "$css_dir/bootstrap-responsive.css" "$dest/css/"

echo "* Copying JS"
cp "$js_dir/bootstrap.js" "$dest/js/"

echo "* Copying icon images"
cp img/glyphicons-halflings-white.png img/glyphicons-halflings.png "$dest/img"

echo "* Generating package.js"
cat > "$dest/package.js" <<EOF
Package.describe({
  summary: "Front-end framework from Twitter (customized using meteor-package-bootstrap.sh$extradesc)"
});
Package.on_use(function (api) {
  api.use('jquery');
  var path = Npm.require('path');
  api.add_files(path.join('css', 'bootstrap.css'), 'client');
  api.add_files(path.join('css', 'bootstrap-responsive.css'), 'client');
  api.add_files(path.join('js', 'bootstrap.js'), 'client');
  api.add_files(path.join('img', 'glyphicons-halflings.png'), 'client');
  api.add_files(path.join('img', 'glyphicons-halflings-white.png'), 'client');
});
EOF


echo "* Your package name is '$package_name' and is located at: $dest"
if [ "$package_name" != "bootstrap" ]; then
	echo "* WARNING: You might want to use 'bootstrap' as the package name to satisfy dependencies by other packages"
fi
echo "* NOTE: You cannot rename it afterwards, because the icon urls will be incorrect!"
exit 0


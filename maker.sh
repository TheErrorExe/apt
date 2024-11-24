#!/bin/bash

# Verzeichnisse
DIST_DIR="dists/stable"
COMPONENT_DIR="$DIST_DIR/main/binary-i386"

# Release-Datei erstellen
cat > $DIST_DIR/Release <<EOF
Origin: TheErrorExe Repo
Label: Stable
Suite: stable
Codename: stable
Date: $(date -R)
Architectures: amd64
Components: main
EOF

# Hashes berechnen
echo "MD5Sum:" >> $DIST_DIR/Release
for file in $COMPONENT_DIR/Packages*; do
  md5=$(md5sum $file | awk '{print $1}')
  size=$(stat --printf="%s" $file)
  relpath=${file#$DIST_DIR/}
  echo " $md5 $size $relpath" >> $DIST_DIR/Release
done

echo "SHA256:" >> $DIST_DIR/Release
for file in $COMPONENT_DIR/Packages*; do
  sha256=$(sha256sum $file | awk '{print $1}')
  size=$(stat --printf="%s" $file)
  relpath=${file#$DIST_DIR/}
  echo " $sha256 $size $relpath" >> $DIST_DIR/Release
done

echo "Release-Datei wurde erstellt: $DIST_DIR/Release"

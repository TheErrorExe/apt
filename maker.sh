#!/bin/bash

# Variablen
REPO_NAME="TheErrorExe"
DEB_PACKAGE="../deb-build/revivemii-patcher_1.0-1_amd64.deb"
REPO_DIR="./apt-repo"  # Das Repository wird im aktuellen Verzeichnis erstellt
PACKAGE_DIR="$REPO_DIR/pool/main/r/revivemii-patcher"
DEB_FILE_NAME=$(basename "$DEB_PACKAGE")
GIT_EMAIL="theerrorexe@gmail.com"
GIT_NAME="TheErrorExe"
GIT_REMOTE_URL="git@github.com:TheErrorExe/theerrorexe-repo.git"  # Ändere dies auf die tatsächliche Remote-URL
BRANCH_NAME="main"  # Branch Name

# Überprüfen, ob das DEB-Paket existiert
if [ ! -f "$DEB_PACKAGE" ]; then
    echo "Das DEB-Paket $DEB_PACKAGE wurde nicht gefunden!"
    exit 1
fi

# Git-Konfiguration (falls noch nicht gesetzt)
git config user.name "$GIT_NAME"
git config user.email "$GIT_EMAIL"

# Schritt 1: Repository-Verzeichnis erstellen, wenn es noch nicht existiert
echo "Erstelle APT-Repository-Struktur..."
mkdir -p "$PACKAGE_DIR"

# Schritt 2: DEB-Paket in das Repository kopieren
echo "Kopiere DEB-Paket in das Repository..."
cp "$DEB_PACKAGE" "$PACKAGE_DIR"

# Schritt 3: Die APT-Repositoriestruktur erstellen
echo "Erstelle die Verzeichnisse für das APT-Repository..."
mkdir -p "$REPO_DIR/dists/stable/main/binary-amd64"

# Schritt 4: Paket scannen und die Packages-Datei erstellen
echo "Scanne Pakete und erstelle Packages.gz..."
dpkg-scanpackages "$REPO_DIR/pool" /dev/null | gzip -9c > "$REPO_DIR/dists/stable/main/binary-amd64/Packages.gz"

# Schritt 5: Release-Datei erstellen
echo "Erstelle Release-Datei..."
cat > "$REPO_DIR/dists/stable/Release" <<EOF
Origin: $REPO_NAME Repository
Label: TheErrorExe APT Repo
Suite: stable
Codename: stable
Architectures: amd64
Components: main
Description: APT repository for TheErrorExe
EOF

# Schritt 6: Git-Initialisierung (falls das Repo noch nicht existiert)
#if [ ! -d ".git" ]; then
#    echo "Initialisiere Git-Repository..."
#    git init
#    git remote add origin "$GIT_REMOTE_URL"
#fi

# Schritt 7: Git-Operationen (add, commit, push)
echo "Führe Git-Operationen durch..."
git add .
git commit -m "Initial commit: APT repository für $REPO_NAME mit dem Paket $DEB_FILE_NAME"
#git push -u origin "$BRANCH_NAME"  # Push zu GitHub oder einem anderen Git-Remote

# Erfolgsmeldung
echo "Das APT-Repository wurde erfolgreich erstellt und zum Git-Repository gepusht. Du kannst jetzt das Repository mit APT nutzen."

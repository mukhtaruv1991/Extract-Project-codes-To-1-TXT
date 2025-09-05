#!/data/data/com.termux/files/usr/bin/bash
echo "Installing Mukh-IDE Backup Tool..."
TARGET_DIR="\$HOME/bin"
TARGET_FILE="\$TARGET_DIR/backup-txt"
mkdir -p "\$TARGET_DIR"
cp "backup-txt" "\$TARGET_FILE"
chmod +x "\$TARGET_FILE"
if ! grep -q 'export PATH="\$HOME/bin:\$PATH"' ~/.bashrc; then
  echo -e '\n# Add user-specific bin directory to PATH\nexport PATH="\$HOME/bin:\$PATH"' >> ~/.bashrc
  export PATH="\$HOME/bin:\$PATH"
  echo "✅ Directory \$TARGET_DIR added to your PATH."
else
  echo "✅ Your PATH is already configured."
fi
echo "Installing dependencies (curl, rsync, zip, unzip, tar, termux-api)..."
pkg install -y curl rsync zip unzip tar termux-api
echo -e "\n🎉 Installation complete! Run 'backup-txt --help' to get started."

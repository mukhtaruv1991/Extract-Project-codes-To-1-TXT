#!/data/data/com.termux/files/usr/bin/bash

# --- Intelligent Self-Downloading Installer for Mukh-IDE Tools ---

echo "🚀 Starting installation for Mukh-IDE Tools..."

# --- 1. Define GitHub source and local target ---
GITHUB_USER="mukhtaruv1991"
GITHUB_REPO="Extract-Project-codes-To-1-TXT"
BASE_URL="https://raw.githubusercontent.com/$GITHUB_USER/$GITHUB_REPO/main"
    
TARGET_DIR="$HOME/bin"
TOOLS_TO_INSTALL=("backup-txt" "gh-publish")

# --- 2. Create Target Directory ---
mkdir -p "$TARGET_DIR"

# --- 3. NEW: Download, Copy, and Set Permissions ---
echo "  -> Downloading the latest versions of the tools..."
for tool in "${TOOLS_TO_INSTALL[@]}"; do
  echo "     - Downloading '$tool'..."
  # Use curl to download the file directly to the target directory
  if curl -sL "$BASE_URL/$tool" -o "$TARGET_DIR/$tool"; then
    chmod +x "$TARGET_DIR/$tool"
    echo "       ✅ '$tool' installed successfully."
  else
    echo "       ❌ Failed to download '$tool'. Please check your internet connection and the repository URL."
  fi
done

# --- 4. Ensure ~/bin is in PATH ---
if ! grep -q 'export PATH="$HOME/bin:$PATH"' ~/.bashrc; then
  echo "  -> Adding '$TARGET_DIR' to your PATH..."
  echo -e '\n# Add user-specific bin directory\nexport PATH="$HOME/bin:$PATH"' >> ~/.bashrc
  export PATH="$TARGET_DIR:$PATH"
else
  echo "  -> Your PATH is already configured correctly."
fi

# --- 5. Dependency Check (remains the same) ---
echo "  -> Checking for required dependencies..."
DEPS=("git" "curl" "jq" "rsync" "zip" "unzip" "tar" "termux-api")
PACKAGES_TO_INSTALL=()
for dep in "${DEPS[@]}"; do
  if ! command -v "$dep" &> /dev/null; then
    PACKAGES_TO_INSTALL+=("$dep")
  fi
done
if [ ${#PACKAGES_TO_INSTALL[@]} -gt 0 ]; then
  echo "  -> Installing missing packages: ${PACKAGES_TO_INSTALL[*]}..."
  pkg install -y "${PACKAGES_TO_INSTALL[@]}"
else
  echo "  -> All dependencies are already satisfied."
fi

# --- 6. Final Message ---
echo ""
echo "🎉 Installation complete!"
echo "Run 'backup-txt --help' or 'gh-publish --help' to get started."


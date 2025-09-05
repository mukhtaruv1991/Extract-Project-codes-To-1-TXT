#!/data/data/com.termux/files/usr/bin/bash

# --- Intelligent Installer for Mukh-IDE Tools ---

echo "🚀 Starting installation for Mukh-IDE Tools..."
echo "This script will install 'backup-txt' and 'gh-publish'."

# --- 1. Define Target and Source ---
TARGET_DIR="$HOME/bin"
# قائمة الأدوات التي سيتم تثبيتها
TOOLS_TO_INSTALL=("backup-txt" "gh-publish")

# --- 2. Create Target Directory ---
mkdir -p "$TARGET_DIR"

# --- 3. Copy and Set Permissions for Tools ---
for tool in "${TOOLS_TO_INSTALL[@]}"; do
  if [ -f "$tool" ]; then
    echo "  -> Installing '$tool'..."
    cp "$tool" "$TARGET_DIR/$tool"
    chmod +x "$TARGET_DIR/$tool"
  else
    echo "  ⚠️ Warning: Source file '$tool' not found. Skipping."
  fi
done

# --- 4. Ensure ~/bin is in PATH ---
if ! grep -q 'export PATH="$HOME/bin:$PATH"' ~/.bashrc; then
  echo "  -> Adding '$TARGET_DIR' to your PATH..."
  echo -e '\n# Add user-specific bin directory for custom tools\nexport PATH="$HOME/bin:$PATH"' >> ~/.bashrc
  # Apply changes to the current session immediately
  export PATH="$TARGET_DIR:$PATH"
  echo "  ✅ Your PATH has been updated."
else
  echo "  -> Your PATH is already configured correctly."
fi

# --- 5. NEW: Intelligent Dependency Check ---
echo "  -> Checking for required dependencies..."

# قائمة المتطلبات
DEPS=("git" "curl" "jq" "rsync" "zip" "unzip" "tar" "termux-api")
# قائمة الحزم التي يجب تثبيتها
PACKAGES_TO_INSTALL=()

for dep in "${DEPS[@]}"; do
  # استخدم `command -v` للتحقق من وجود الأمر
  if ! command -v "$dep" &> /dev/null; then
    echo "     - Dependency '$dep' is missing."
    # قم بمطابقة الأمر مع اسم الحزمة (في حالتنا، هما نفس الشيء)
    # بالنسبة لـ termux-api، الأمر هو termux-share، لكن الحزمة هي termux-api
    if [ "$dep" == "termux-api" ]; then
        # تحقق من وجود أي أمر من الحزمة
        if ! command -v termux-share &> /dev/null; then
            PACKAGES_TO_INSTALL+=("termux-api")
        fi
    else
        PACKAGES_TO_INSTALL+=("$dep")
    fi
  else
    echo "     - Dependency '$dep' is already installed. ✅"
  fi
done

# تثبيت الحزم الناقصة فقط
if [ ${#PACKAGES_TO_INSTALL[@]} -gt 0 ]; then
  echo "  -> Installing missing packages: ${PACKAGES_TO_INSTALL[*]}..."
  pkg install -y "${PACKAGES_TO_INSTALL[@]}"
else
  echo "  -> All dependencies are already satisfied."
fi

# --- 6. Final Message ---
echo ""
echo "🎉 Installation complete!"
echo "The following commands are now available system-wide in Termux:"
echo "   - backup-txt"
echo "   - gh-publish"
echo ""
echo "Run 'backup-txt --help' or 'gh-publish --help' to get started."
echo "Don't forget to run 'gh-publish --setup' to configure your GitHub token."


#!/bin/bash

if ! is-macos; then
    return
fi

echo "**************************************************"
echo "Configuring iTerm2"
echo "**************************************************"

DYNAMIC_PROFILES_DIR="$HOME/Library/Application Support/iTerm2/DynamicProfiles"
ITERM_PLIST="$HOME/Library/Preferences/com.googlecode.iterm2.plist"

# Symlink dynamic profiles
mkdir -p "$DYNAMIC_PROFILES_DIR"
ln -sfv "$DOTFILES_DIR/etc/iterm/profiles.json" "$DYNAMIC_PROFILES_DIR/profiles.json"

# Install shell integration
if [ ! -f "$HOME/.iterm2_shell_integration.zsh" ]; then
    curl -L https://iterm2.com/shell_integration/zsh -o "$HOME/.iterm2_shell_integration.zsh"
fi

# Global settings via defaults write
defaults write com.googlecode.iterm2 AlternateMouseScroll -bool true
defaults write com.googlecode.iterm2 DimOnlyText -bool true
defaults write com.googlecode.iterm2 KillJobsInServersOnQuit -bool true
defaults write com.googlecode.iterm2 OnlyWhenMoreTabs -bool false
defaults write com.googlecode.iterm2 OptionIsMetaForSpecialChars -bool true
defaults write com.googlecode.iterm2 PromptOnQuit -bool false
defaults write com.googlecode.iterm2 RunJobsInServers -bool true
defaults write com.googlecode.iterm2 "Selection Respects Soft Boundaries" -bool false
defaults write com.googlecode.iterm2 SplitPaneDimmingAmount -float 0.29875114329268304
defaults write com.googlecode.iterm2 SwitchPaneModifier -int 5
defaults write com.googlecode.iterm2 "Default Bookmark Guid" -string "68FF9249-CAE4-460C-985C-1E033E9CFC83"

# Global key map via PlistBuddy (defaults write can't handle nested dicts)
# Keys: Option+Left/Right (word jump), Cmd+Left/Right (line start/end),
#        Cmd+Backspace (delete line), Option+Backspace (delete word), Ctrl+/ (vim comment)
/usr/libexec/PlistBuddy -c "Delete :GlobalKeyMap" "$ITERM_PLIST" 2>/dev/null
/usr/libexec/PlistBuddy -c "Add :GlobalKeyMap dict" "$ITERM_PLIST"

add_global_key() {
    local key="$1" action="$2" text="$3"
    /usr/libexec/PlistBuddy \
        -c "Add :GlobalKeyMap:${key} dict" \
        -c "Add :GlobalKeyMap:${key}:Version integer 2" \
        -c "Add :GlobalKeyMap:${key}:\"Apply Mode\" integer 0" \
        -c "Add :GlobalKeyMap:${key}:Action integer ${action}" \
        -c "Add :GlobalKeyMap:${key}:Text string ${text}" \
        -c "Add :GlobalKeyMap:${key}:Escaping integer 2" \
        "$ITERM_PLIST"
}

add_global_key "0xf702-0x280000-0x7b" 10 "b" # Option+Left: word back
add_global_key "0xf703-0x280000-0x7c" 10 "f" # Option+Right: word forward
add_global_key "0xf702-0x300000-0x7b" 11 "1" # Cmd+Left: line start
add_global_key "0xf703-0x300000-0x7c" 11 "5" # Cmd+Right: line end
add_global_key "0x7f-0x100000-0x33" 11 "15"  # Cmd+Backspace: delete to line start
add_global_key "0x7f-0x80000-0x33" 11 "17"   # Option+Backspace: delete word
add_global_key "0x2f-0x40000-0x2c" 11 "0x1f" # Ctrl+/: comment toggle

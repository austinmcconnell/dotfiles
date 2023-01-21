#!/bin/sh

dockutil --no-restart --remove "/Applications/Firefox.app"
dockutil --no-restart --add "/Applications/Firefox.app" --position 1

dockutil --no-restart --remove "/Applications/Canary Mail.app"
dockutil --no-restart --add "/Applications/Canary Mail.app" --after "Firefox"

dockutil --no-restart --remove "/System/Applications/Messages.app"
dockutil --no-restart --add "/System/Applications/Messages.app" --after "Canary Mail"

dockutil --no-restart --remove "/System/Applications/FaceTime.app"
dockutil --no-restart --add "/System/Applications/FaceTime.app" --after "Messages"

dockutil --no-restart --remove "/System/Applications/Home.app"
dockutil --no-restart --add "/System/Applications/Home.app" --after "FaceTime"

dockutil --no-restart --remove "/System/Applications/Calendar.app"
dockutil --no-restart --add "/System/Applications/Calendar.app" --after "Home"

dockutil --no-restart --remove "/System/Applications/Music.app"
dockutil --no-restart --add "/System/Applications/Music.app" --after "Calendar"

dockutil --no-restart --remove "/System/Applications/TV.app"
dockutil --no-restart --add "/System/Applications/TV.app" --after "Music"

dockutil --no-restart --remove "/System/Applications/App Store.app"
dockutil --no-restart --add "/System/Applications/App Store.app" --after "TV"

dockutil --no-restart --remove "/System/Applications/System Settings.app"
dockutil --no-restart --add "/System/Applications/System Settings.app" --after "App Store"

dockutil --no-restart --remove "/Applications/Steam.app"
dockutil --no-restart --add "/Applications/Steam.app" --after "System Settings"

dockutil --no-restart --remove "/Applications/Sublime Text.app"
dockutil --no-restart --add "/Applications/Sublime Text.app" --after "Steam"

dockutil --no-restart --remove "/Applications/Visual Studio Code.app"
dockutil --no-restart --add "/Applications/Visual Studio Code.app" --after "Sublime Text"

dockutil --no-restart --remove "/Applications/TablePlus.app"
dockutil --no-restart --add "/Applications/TablePlus.app" --after "Visual Studio Code"

dockutil --no-restart --remove "/Applications/iTerm.app"
dockutil --no-restart --add "/Applications/iTerm.app" --after "TablePlus"

dockutil --no-restart --remove "/Applications/Reeder.app"
dockutil --no-restart --add "/Applications/Reeder.app" --after "iTerm"

dockutil --no-restart --remove "/Applications/Obsidian.app"
dockutil --no-restart --add "/Applications/Obsidian.app" --after "Reeder"

dockutil --no-restart --remove "/System/Applications/Notes.app"
dockutil --no-restart --add "/System/Applications/Notes.app" --after "Obsidian"

dockutil --no-restart --remove "/System/Applications/Reminders.app"
dockutil --no-restart --add "/System/Applications/Reminders.app" --after "Notes"

dockutil --no-restart --remove "/System/Applications/Photos.app"
dockutil --no-restart --add "/System/Applications/Photos.app" --after "Reminders"

killall Dock

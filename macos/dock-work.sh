#!/bin/bash

dockutil --no-restart --remove "/Applications/Google Chrome.app"
dockutil --no-restart --add "/Applications/Google Chrome.app" --position 1

dockutil --no-restart --remove "/Applications/Canary Mail.app"
dockutil --no-restart --add "/Applications/Canary Mail.app" --after "Google Chrome"

dockutil --no-restart --remove "/System/Applications/Messages.app"
dockutil --no-restart --add "/System/Applications/Messages.app" --after "Canary Mail"

dockutil --no-restart --remove "/System/Applications/FaceTime.app"
dockutil --no-restart --add "/System/Applications/FaceTime.app" --after "Messages"

dockutil --no-restart --remove "/System/Applications/Music.app"
dockutil --no-restart --add "/System/Applications/Music.app" --after "FaceTime"

dockutil --no-restart --remove "/System/Applications/App Store.app"
dockutil --no-restart --add "/System/Applications/App Store.app" --after "Music"

dockutil --no-restart --remove "/System/Applications/System Settings.app"
dockutil --no-restart --add "/System/Applications/System Settings.app" --after "App Store"

dockutil --no-restart --remove "/Applications/Visual Studio Code.app"
dockutil --no-restart --add "/Applications/Visual Studio Code.app" --after "System Settings"

dockutil --no-restart --remove "/Applications/TablePlus.app"
dockutil --no-restart --add "/Applications/TablePlus.app" --after "Visual Studio Code"

dockutil --no-restart --remove "/Applications/DataGrip.app"
dockutil --no-restart --add "/Applications/DataGrip.app" --after "TablePlus"

dockutil --no-restart --remove "/Applications/Postman.app"
dockutil --no-restart --add "/Applications/Postman.app" --after "DataGrip"

dockutil --no-restart --remove "/Applications/OpenLens.app"
dockutil --no-restart --add "/Applications/OpenLens.app" --after "iTerm"

dockutil --no-restart --remove "/Applications/iTerm.app"
dockutil --no-restart --add "/Applications/iTerm.app" --after "OpenLens"

dockutil --no-restart --remove "/Applications/Sublime Text.app"
dockutil --no-restart --add "/Applications/Sublime Text.app" --after "iTerm"

dockutil --no-restart --remove "/Applications/Obsidian.app"
dockutil --no-restart --add "/Applications/Obsidian.app" --after "Sublime Text"

dockutil --no-restart --remove "/Applications/Slack.app"
dockutil --no-restart --add "/Applications/Slack.app" --after "Obsidian"

killall Dock

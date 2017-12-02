#!/bin/sh

dockutil --no-restart --remove all
dockutil --no-restart --add "/Applications/Google Chrome.app"
dockutil --no-restart --add "/Applications/Airmail 3.app"
dockutil --no-restart --add "/Applications/Skype.app"
dockutil --no-restart --add "/Applications/App Store.app"
dockutil --no-restart --add "/Applications/Steam.app"
dockutil --no-restart --add "/Applications/System Preferences.app"
dockutil --no-restart --add "/Applications/Textual.app"
dockutil --no-restart --add "/Applications/Slack.app"
dockutil --no-restart --add "/Applications/PyCharm.app"
dockutil --no-restart --add "/Applications/Sublime Text.app"
dockutil --no-restart --add "/Applications/iTerm.app"
dockutil --no-restart --add "/Applications/Simplenote.app"
dockutil --no-restart --add "/Applications/MacDown.app"
dockutil --no-restart --add "/Applications/Transmit.app"
dockutil --no-restart --add "/Applications/Postico.app"
dockutil --no-restart --add "/Applications/Dashlane.app"
dockutil --no-restart --add "/Applications/Exodus.app"

killall Dock

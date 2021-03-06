#!/bin/sh

dockutil --no-restart --remove all
dockutil --no-restart --add "/Applications/Google Chrome.app"
dockutil --no-restart --add "/Applications/Airmail 3.app"
dockutil --no-restart --add "/Applications/App Store.app"
dockutil --no-restart --add "/Applications/System Preferences.app"
dockutil --no-restart --add "/Applications/Steam.app"
dockutil --no-restart --add "/Applications/Slack.app"
dockutil --no-restart --add "/Applications/PyCharm.app"
dockutil --no-restart --add "/Applications/iTerm.app"
dockutil --no-restart --add "/Applications/Atom.app"
dockutil --no-restart --add "/Applications/Evernote.app"
dockutil --no-restart --add "/Applications/Simplenote.app"
dockutil --no-restart --add "/Applications/MacDown.app"
dockutil --no-restart --add "/Applications/Postico.app"
dockutil --no-restart --add "/Applications/Luminar 3.app"

killall Dock

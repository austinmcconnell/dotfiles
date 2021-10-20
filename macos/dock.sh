#!/bin/sh

dockutil --no-restart --remove all
dockutil --no-restart --add "/Applications/Safari.app"
dockutil --no-restart --add "/Applications/Canary Mail.app"
dockutil --no-restart --add "/System//Applications/Messages.app"
dockutil --no-restart --add "/System//Applications/Facetime.app"
dockutil --no-restart --add "/System//Applications/Calendar.app"
dockutil --no-restart --add "/System//Applications/Music.app"
dockutil --no-restart --add "/System//Applications/App Store.app"
dockutil --no-restart --add "/System//Applications/System Preferences.app"
dockutil --no-restart --add "/Applications/Steam.app"
dockutil --no-restart --add "/Applications/Visual Studio Code.app"
dockutil --no-restart --add "/Applications/iTerm.app"
dockutil --no-restart --add "/Applications/Hyper.app"
dockutil --no-restart --add "/Applications/Atom.app"
dockutil --no-restart --add "/Applications/Slack.app"
dockutil --no-restart --add "/Applications/Evernote.app"
dockutil --no-restart --add "/System//Applications/Notes.app"
dockutil --no-restart --add "/System//Applications/Reminders.app"
dockutil --no-restart --add "/System//Applications/Photos.app"
dockutil --no-restart --add "/Applications/Luminar 4.app"

killall Dock

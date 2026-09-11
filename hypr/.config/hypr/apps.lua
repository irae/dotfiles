-- App-specific tweaks.
-- Explicit requires, not require_all: it uses `find -type f`, which does not
-- match the symlinks stow creates.
require("hypr.apps.meld")
require("hypr.apps.zoom-workplace")

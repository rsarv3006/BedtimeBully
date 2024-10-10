#!/bin/sh
curl https://mise.jdx.dev/install.sh | sh
export PATH="$HOME/.local/bin/$PATH" # Installs the tools in .mise.toml in the project root

~/.local/bin/mise --version
~/.local/bin/mise install # Installs the version from .mise.toml

eval "$(mise activate bash --shims)" # activate shims to enable local use of mise

mise doctor # verify the output of mise is correct on CI

cd ..
~/.local/bin/mise x -- tuist fetch
~/.local/bin/mise x -- tuist generate # Generate the Xcode Project using Tuist

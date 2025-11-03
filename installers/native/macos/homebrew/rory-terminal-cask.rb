cask "rory-terminal" do
  version "3.0.0"
  sha256 "PLACEHOLDER_SHA256"

  url "https://github.com/RLR-GitHub/terminal-themes/releases/download/v#{version}/RoryTerminal-#{version}.dmg"
  name "Rory Terminal"
  desc "Cyberpunk terminal themes with Matrix animations - GUI Application"
  homepage "https://github.com/RLR-GitHub/terminal-themes"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  conflicts_with formula: "rory-terminal"

  app "RoryTerminal.app"

  uninstall launchctl: "com.rlrgithub.roryterminal",
            quit:      "com.rlrgithub.roryterminal",
            delete:    [
              "/Library/LaunchAgents/com.rlrgithub.roryterminal.plist",
              "~/Library/LaunchAgents/com.rlrgithub.roryterminal.plist",
            ]

  zap trash: [
    "~/Library/Application Support/RoryTerminal",
    "~/Library/Caches/com.rlrgithub.roryterminal",
    "~/Library/Preferences/com.rlrgithub.roryterminal.plist",
    "~/Library/Saved Application State/com.rlrgithub.roryterminal.savedState",
    "~/.config/rory-terminal",
  ]

  # Create command-line tools symlinks
  postflight do
    # Create symlinks in /usr/local/bin
    system_command "/bin/ln",
                   args: ["-sf", "#{appdir}/RoryTerminal.app/Contents/MacOS/RoryTerminal", "#{HOMEBREW_PREFIX}/bin/rory-terminal"],
                   sudo: false
    
    system_command "/bin/ln",
                   args: ["-sf", "#{appdir}/RoryTerminal.app/Contents/Resources/rory-terminal/core/option1-starship/theme-manager.sh", "#{HOMEBREW_PREFIX}/bin/rory-theme"],
                   sudo: false
  end

  # Remove symlinks on uninstall
  uninstall_postflight do
    system_command "/bin/rm",
                   args: ["-f", "#{HOMEBREW_PREFIX}/bin/rory-terminal", "#{HOMEBREW_PREFIX}/bin/rory-theme"],
                   sudo: false
  end

  caveats <<~EOS
    Rory Terminal.app has been installed!

    You can launch it from:
      - Applications folder
      - Spotlight (search for "Rory Terminal")
      - Command line: open -a "Rory Terminal"

    Command-line tools are available:
      rory-terminal    # Launch the app
      rory-theme       # Manage themes from CLI

    To integrate with your terminal:
      rory-terminal install

    First time setup:
      1. Launch Rory Terminal
      2. Select your preferred theme
      3. Click "Apply Theme"
      4. Open a new terminal to see the changes

    For the full CLI experience without the GUI, install the formula instead:
      brew install rory-terminal
  EOS
end

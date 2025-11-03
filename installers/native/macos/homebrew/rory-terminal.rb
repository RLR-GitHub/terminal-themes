class RoryTerminal < Formula
  desc "Cyberpunk terminal themes with Matrix animations"
  homepage "https://github.com/RLR-GitHub/terminal-themes"
  url "https://github.com/RLR-GitHub/terminal-themes/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "PLACEHOLDER_SHA256"
  license "MIT"
  head "https://github.com/RLR-GitHub/terminal-themes.git", branch: "main"

  depends_on "bash" => :run
  depends_on "python@3.11" => :run

  # Optional dependencies for enhanced features
  depends_on "starship" => :recommended
  depends_on "git" => :recommended
  depends_on "curl" => :recommended
  depends_on "bat" => :optional
  depends_on "eza" => :optional
  depends_on "git-delta" => :optional

  def install
    # Install core files
    libexec.install "core", "themes", "config"
    
    # Install scripts
    libexec.install "installers/install.sh"
    libexec.install "installers/desktop/rory-terminal-launcher.sh"
    libexec.install "installers/desktop/theme-selector.py"
    libexec.install "installers/desktop/theme-selector-zenity.sh"
    
    # Create wrapper script
    (bin/"rory-terminal").write <<~EOS
      #!/bin/bash
      export RORY_TERMINAL_DIR="#{libexec}"
      exec "#{libexec}/installers/desktop/rory-terminal-launcher.sh" "$@"
    EOS
    
    # Create additional command shortcuts
    (bin/"rory-theme").write <<~EOS
      #!/bin/bash
      export RORY_TERMINAL_DIR="#{libexec}"
      exec "#{libexec}/core/option1-starship/theme-manager.sh" "$@"
    EOS
    
    (bin/"rory-matrix").write <<~EOS
      #!/bin/bash
      export RORY_TERMINAL_DIR="#{libexec}"
      theme="${1:-hacker}"
      exec "#{libexec}/themes/bash/matrix-$theme.sh"
    EOS
    
    # Install shell integrations
    bash_completion.install_symlink libexec/"installers/completions/rory-terminal.bash" => "rory-terminal"
    zsh_completion.install_symlink libexec/"installers/completions/_rory-terminal" => "_rory-terminal"
    fish_completion.install_symlink libexec/"installers/completions/rory-terminal.fish" => "rory-terminal.fish"
    
    # Install man pages (if available)
    # man1.install "docs/man/rory-terminal.1"
    
    # Install documentation
    doc.install "README.md", "LICENSE"
    doc.install Dir["docs/*.md"]
  end

  def post_install
    # Create config directory
    (var/"rory-terminal").mkpath
    
    # Create default config if not exists
    config_file = etc/"rory-terminal/config.json"
    unless config_file.exist?
      (etc/"rory-terminal").mkpath
      config_file.write <<~JSON
        {
          "currentTheme": "hacker",
          "enableAnimations": true,
          "starshipIntegration": true
        }
      JSON
    end
  end

  def caveats
    <<~EOS
      Rory Terminal has been installed!

      Quick start:
        rory-terminal              # Open theme selector
        rory-theme set halloween   # Set a theme
        rory-matrix christmas      # Run Matrix animation
        rory-theme list           # List available themes

      To integrate with your shell, run:
        rory-terminal install

      For GUI app, install the cask:
        brew install --cask rory-terminal

      Configuration file location:
        #{etc}/rory-terminal/config.json

      To enable Starship integration:
        1. Install Starship: brew install starship
        2. Run: rory-theme enable-starship
    EOS
  end

  test do
    # Test basic functionality
    assert_match "Available themes", shell_output("#{bin}/rory-theme list")
    assert_match "halloween", shell_output("#{bin}/rory-theme list")
    assert_match "christmas", shell_output("#{bin}/rory-theme list")
    
    # Test theme setting (dry run)
    ENV["RORY_TERMINAL_DRY_RUN"] = "1"
    assert_match "Theme would be set to: hacker", 
                 shell_output("#{bin}/rory-theme set hacker")
  end

  service do
    run [opt_bin/"rory-terminal", "--background"]
    keep_alive false
    log_path var/"log/rory-terminal/service.log"
    error_log_path var/"log/rory-terminal/service-error.log"
  end
end

#!/usr/bin/env python3
"""
Rory Terminal Theme Selector
A simple GUI for selecting and previewing terminal themes
"""

import os
import sys
import json
import subprocess
import tkinter as tk
from tkinter import ttk, messagebox
import threading
import time

class ThemeSelector:
    def __init__(self, root):
        self.root = root
        self.root.title("Rory Terminal - Theme Selector")
        self.root.geometry("600x500")
        
        # Set icon if available
        try:
            icon_path = os.path.join(os.path.dirname(__file__), "../../assets/icons/rory-terminal.png")
            if os.path.exists(icon_path):
                photo = tk.PhotoImage(file=icon_path)
                root.iconphoto(False, photo)
        except:
            pass
        
        # Theme data
        self.themes = {
            "halloween": {
                "name": "Halloween",
                "icon": "🎃",
                "description": "Spooky orange matrix rain with Halloween symbols",
                "colors": {"primary": "#ff6b00", "secondary": "#ff8800", "bg": "#1a0f00"}
            },
            "christmas": {
                "name": "Christmas",
                "icon": "🎄",
                "description": "Festive red and green with holiday cheer",
                "colors": {"primary": "#ff0000", "secondary": "#00ff00", "bg": "#0f1a0f"}
            },
            "easter": {
                "name": "Easter",
                "icon": "🐰",
                "description": "Pastel rainbow colors for spring",
                "colors": {"primary": "#ff69b4", "secondary": "#87ceeb", "bg": "#1a0f1a"}
            },
            "hacker": {
                "name": "Hacker",
                "icon": "💻",
                "description": "Bright green cyberpunk aesthetic",
                "colors": {"primary": "#00ff00", "secondary": "#33ff33", "bg": "#0a1a0a"}
            },
            "matrix": {
                "name": "Matrix",
                "icon": "🟢",
                "description": "Classic Matrix movie green",
                "colors": {"primary": "#0f0", "secondary": "#0f3", "bg": "#001a00"}
            }
        }
        
        # Detect installation
        self.rory_terminal_dir = self.find_installation()
        self.current_theme = self.get_current_theme()
        
        # Create UI
        self.create_widgets()
        
        # Start matrix preview animation
        self.matrix_running = False
        self.matrix_process = None
        
    def find_installation(self):
        """Find Rory Terminal installation directory"""
        paths = [
            "/opt/rory-terminal",
            os.path.expanduser("~/.local/share/rory-terminal"),
            os.path.join(os.path.dirname(__file__), "../..")
        ]
        
        for path in paths:
            if os.path.exists(path) and os.path.isdir(path):
                return path
        
        return None
    
    def get_current_theme(self):
        """Get the currently active theme"""
        if not self.rory_terminal_dir:
            return "hacker"
        
        config_file = os.path.expanduser("~/.config/rory-terminal/current-theme")
        if os.path.exists(config_file):
            try:
                with open(config_file, 'r') as f:
                    return f.read().strip()
            except:
                pass
        
        return "hacker"
    
    def create_widgets(self):
        """Create the UI elements"""
        # Main container
        main_frame = ttk.Frame(self.root, padding="10")
        main_frame.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
        
        # Configure grid weights
        self.root.columnconfigure(0, weight=1)
        self.root.rowconfigure(0, weight=1)
        main_frame.columnconfigure(0, weight=1)
        main_frame.rowconfigure(2, weight=1)
        
        # Header
        header_frame = ttk.Frame(main_frame)
        header_frame.grid(row=0, column=0, sticky=(tk.W, tk.E), pady=(0, 10))
        
        title_label = ttk.Label(header_frame, text="Rory Terminal Themes", 
                               font=('Arial', 18, 'bold'))
        title_label.pack()
        
        subtitle_label = ttk.Label(header_frame, text="Select your cyberpunk terminal theme",
                                  font=('Arial', 10))
        subtitle_label.pack()
        
        # Theme selection frame
        selection_frame = ttk.LabelFrame(main_frame, text="Available Themes", padding="10")
        selection_frame.grid(row=1, column=0, sticky=(tk.W, tk.E), pady=10)
        selection_frame.columnconfigure(0, weight=1)
        
        # Theme radio buttons
        self.selected_theme = tk.StringVar(value=self.current_theme)
        
        for i, (theme_id, theme_data) in enumerate(self.themes.items()):
            theme_frame = ttk.Frame(selection_frame)
            theme_frame.grid(row=i, column=0, sticky=(tk.W, tk.E), pady=5)
            
            # Radio button
            radio = ttk.Radiobutton(theme_frame, 
                                   text=f"{theme_data['icon']} {theme_data['name']}", 
                                   variable=self.selected_theme, 
                                   value=theme_id,
                                   command=self.on_theme_select)
            radio.pack(side=tk.LEFT)
            
            # Description
            desc_label = ttk.Label(theme_frame, text=f" - {theme_data['description']}",
                                  font=('Arial', 9))
            desc_label.pack(side=tk.LEFT, padx=(10, 0))
            
            # Current theme indicator
            if theme_id == self.current_theme:
                current_label = ttk.Label(theme_frame, text="(current)", 
                                        foreground="green", font=('Arial', 9, 'italic'))
                current_label.pack(side=tk.LEFT, padx=(5, 0))
        
        # Preview frame
        preview_frame = ttk.LabelFrame(main_frame, text="Preview", padding="10")
        preview_frame.grid(row=2, column=0, sticky=(tk.W, tk.E, tk.N, tk.S), pady=10)
        preview_frame.columnconfigure(0, weight=1)
        preview_frame.rowconfigure(0, weight=1)
        
        # Preview canvas
        self.preview_canvas = tk.Canvas(preview_frame, bg="black", height=150)
        self.preview_canvas.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
        
        # Action buttons frame
        button_frame = ttk.Frame(main_frame)
        button_frame.grid(row=3, column=0, sticky=(tk.W, tk.E), pady=(10, 0))
        
        # Apply button
        self.apply_button = ttk.Button(button_frame, text="Apply Theme", 
                                      command=self.apply_theme)
        self.apply_button.pack(side=tk.LEFT, padx=5)
        
        # Preview Matrix button
        self.matrix_button = ttk.Button(button_frame, text="Preview Matrix", 
                                       command=self.toggle_matrix_preview)
        self.matrix_button.pack(side=tk.LEFT, padx=5)
        
        # Settings button
        settings_button = ttk.Button(button_frame, text="Settings", 
                                    command=self.open_settings)
        settings_button.pack(side=tk.LEFT, padx=5)
        
        # Close button
        close_button = ttk.Button(button_frame, text="Close", 
                                 command=self.root.quit)
        close_button.pack(side=tk.RIGHT, padx=5)
        
        # Status bar
        self.status_var = tk.StringVar(value="Ready")
        status_bar = ttk.Label(main_frame, textvariable=self.status_var, 
                              relief=tk.SUNKEN, anchor=tk.W)
        status_bar.grid(row=4, column=0, sticky=(tk.W, tk.E), pady=(10, 0))
        
        # Initial preview
        self.update_preview()
    
    def on_theme_select(self):
        """Handle theme selection"""
        self.update_preview()
    
    def update_preview(self):
        """Update the preview canvas with theme colors"""
        theme_id = self.selected_theme.get()
        theme = self.themes[theme_id]
        colors = theme['colors']
        
        # Clear canvas
        self.preview_canvas.delete("all")
        
        # Set background
        self.preview_canvas.configure(bg=colors['bg'])
        
        # Draw some matrix-style text
        width = self.preview_canvas.winfo_width()
        height = self.preview_canvas.winfo_height()
        
        if width > 1 and height > 1:  # Canvas is realized
            # Draw theme name
            self.preview_canvas.create_text(width/2, 30, 
                                          text=f"{theme['icon']} {theme['name']} Theme",
                                          font=('Courier', 16, 'bold'),
                                          fill=colors['primary'])
            
            # Draw some matrix rain simulation
            for x in range(20, width, 30):
                for y in range(50, height, 20):
                    if (x + y) % 40 < 20:
                        char = theme['icon'] if (x + y) % 60 < 30 else "0"
                        color = colors['primary'] if (x + y) % 80 < 40 else colors['secondary']
                        self.preview_canvas.create_text(x, y, text=char,
                                                      font=('Courier', 12),
                                                      fill=color)
        
        # Schedule redraw after canvas is properly sized
        if width <= 1:
            self.root.after(100, self.update_preview)
    
    def apply_theme(self):
        """Apply the selected theme"""
        theme_id = self.selected_theme.get()
        
        if not self.rory_terminal_dir:
            messagebox.showerror("Error", "Rory Terminal installation not found!")
            return
        
        self.status_var.set(f"Applying {self.themes[theme_id]['name']} theme...")
        self.apply_button.configure(state="disabled")
        
        # Run theme manager in background
        def apply_theme_thread():
            try:
                theme_manager = os.path.join(self.rory_terminal_dir, 
                                           "core/option1-starship/theme-manager.sh")
                if os.path.exists(theme_manager):
                    result = subprocess.run([theme_manager, "set", theme_id], 
                                          capture_output=True, text=True)
                    if result.returncode == 0:
                        self.current_theme = theme_id
                        self.root.after(0, self.on_theme_applied, True)
                    else:
                        self.root.after(0, self.on_theme_applied, False, result.stderr)
                else:
                    self.root.after(0, self.on_theme_applied, False, "Theme manager not found")
            except Exception as e:
                self.root.after(0, self.on_theme_applied, False, str(e))
        
        thread = threading.Thread(target=apply_theme_thread)
        thread.start()
    
    def on_theme_applied(self, success, error_msg=None):
        """Handle theme application result"""
        self.apply_button.configure(state="normal")
        
        if success:
            self.status_var.set(f"{self.themes[self.current_theme]['name']} theme applied!")
            messagebox.showinfo("Success", 
                              f"{self.themes[self.current_theme]['name']} theme applied!\n\n"
                              "Open a new terminal to see the changes.")
            # Update UI to show new current theme
            self.create_widgets()
        else:
            self.status_var.set("Failed to apply theme")
            messagebox.showerror("Error", f"Failed to apply theme:\n{error_msg}")
    
    def toggle_matrix_preview(self):
        """Toggle matrix animation preview"""
        if self.matrix_running:
            self.stop_matrix_preview()
        else:
            self.start_matrix_preview()
    
    def start_matrix_preview(self):
        """Start matrix animation in terminal"""
        if not self.rory_terminal_dir:
            messagebox.showerror("Error", "Rory Terminal installation not found!")
            return
        
        theme_id = self.selected_theme.get()
        matrix_script = os.path.join(self.rory_terminal_dir, 
                                   f"themes/bash/matrix-{theme_id}.sh")
        
        if not os.path.exists(matrix_script):
            messagebox.showerror("Error", f"Matrix script not found for {theme_id} theme!")
            return
        
        launcher = os.path.join(os.path.dirname(__file__), "rory-terminal-launcher.sh")
        
        try:
            # Use the launcher to open in terminal
            self.matrix_process = subprocess.Popen([launcher, "--matrix", "--theme", theme_id])
            self.matrix_running = True
            self.matrix_button.configure(text="Stop Matrix")
            self.status_var.set(f"Running {self.themes[theme_id]['name']} matrix animation...")
        except Exception as e:
            messagebox.showerror("Error", f"Failed to start matrix animation:\n{str(e)}")
    
    def stop_matrix_preview(self):
        """Stop matrix animation"""
        if self.matrix_process:
            try:
                self.matrix_process.terminate()
            except:
                pass
            self.matrix_process = None
        
        self.matrix_running = False
        self.matrix_button.configure(text="Preview Matrix")
        self.status_var.set("Ready")
    
    def open_settings(self):
        """Open settings/configuration"""
        config_file = os.path.expanduser("~/.config/rory-terminal/config.json")
        
        if os.path.exists(config_file):
            try:
                # Try to open with default editor
                if sys.platform == "darwin":
                    subprocess.run(["open", config_file])
                elif sys.platform.startswith("linux"):
                    subprocess.run(["xdg-open", config_file])
            except:
                messagebox.showinfo("Settings", f"Configuration file:\n{config_file}")
        else:
            messagebox.showinfo("Settings", 
                              "No configuration file found.\n"
                              "Settings are managed through the theme manager.")
    
    def run(self):
        """Run the application"""
        # Center window
        self.root.update_idletasks()
        x = (self.root.winfo_screenwidth() // 2) - (self.root.winfo_width() // 2)
        y = (self.root.winfo_screenheight() // 2) - (self.root.winfo_height() // 2)
        self.root.geometry(f"+{x}+{y}")
        
        # Set window icon for taskbar
        try:
            if sys.platform.startswith("linux"):
                self.root.wm_iconname("rory-terminal")
        except:
            pass
        
        self.root.mainloop()

def main():
    """Main entry point"""
    root = tk.Tk()
    app = ThemeSelector(root)
    app.run()

if __name__ == "__main__":
    main()

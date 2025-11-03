/*
 * PTY Wrapper - Pseudoterminal Interceptor
 * Intercepts terminal I/O to inject custom color styling
 * 
 * Compile: gcc -o pty-wrapper pty-wrapper.c -lutil
 * Usage: ./pty-wrapper <command> [args...]
 */

#define _XOPEN_SOURCE 600
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <sys/select.h>
#include <sys/ioctl.h>

#ifdef __APPLE__
    #include <util.h>
#elif __linux__
    #include <pty.h>
#endif

#define BUFFER_SIZE 4096

/* Color injection rules - loaded from config */
typedef struct {
    char *pattern;
    char *color_code;
} ColorRule;

/* ANSI color codes */
#define COLOR_RESET     "\033[0m"
#define COLOR_RED       "\033[31m"
#define COLOR_GREEN     "\033[32m"
#define COLOR_YELLOW    "\033[33m"
#define COLOR_BLUE      "\033[34m"
#define COLOR_MAGENTA   "\033[35m"
#define COLOR_CYAN      "\033[36m"
#define COLOR_BRIGHT_GREEN "\033[92m"

/* Simple pattern matching and color injection */
void inject_colors(char *input, char *output, size_t max_len) {
    char *in_ptr = input;
    char *out_ptr = output;
    size_t remaining = max_len - 1;
    
    /* Example rules - in production, load from color-rules.json */
    /* Pattern: error/warning keywords */
    char *patterns[] = {"error", "ERROR", "Error", "warning", "WARNING", "Warning", 
                        "success", "SUCCESS", "Success", "failed", "FAILED", "Failed"};
    char *colors[] = {COLOR_RED, COLOR_RED, COLOR_RED, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW,
                      COLOR_GREEN, COLOR_GREEN, COLOR_GREEN, COLOR_RED, COLOR_RED, COLOR_RED};
    int num_patterns = sizeof(patterns) / sizeof(patterns[0]);
    
    while (*in_ptr && remaining > 0) {
        int matched = 0;
        
        /* Check each pattern */
        for (int i = 0; i < num_patterns; i++) {
            size_t pattern_len = strlen(patterns[i]);
            if (strncmp(in_ptr, patterns[i], pattern_len) == 0) {
                /* Inject color code */
                size_t color_len = strlen(colors[i]);
                if (remaining >= pattern_len + color_len + strlen(COLOR_RESET)) {
                    strcpy(out_ptr, colors[i]);
                    out_ptr += color_len;
                    remaining -= color_len;
                    
                    strncpy(out_ptr, in_ptr, pattern_len);
                    out_ptr += pattern_len;
                    remaining -= pattern_len;
                    
                    strcpy(out_ptr, COLOR_RESET);
                    out_ptr += strlen(COLOR_RESET);
                    remaining -= strlen(COLOR_RESET);
                    
                    in_ptr += pattern_len;
                    matched = 1;
                    break;
                }
            }
        }
        
        if (!matched) {
            *out_ptr++ = *in_ptr++;
            remaining--;
        }
    }
    
    *out_ptr = '\0';
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <command> [args...]\n", argv[0]);
        return 1;
    }
    
    int master, slave;
    pid_t pid;
    char buffer[BUFFER_SIZE];
    char colored_buffer[BUFFER_SIZE * 2];  /* Extra space for color codes */
    struct winsize ws;
    
    /* Get current terminal size */
    if (ioctl(STDIN_FILENO, TIOCGWINSZ, &ws) < 0) {
        perror("ioctl(TIOCGWINSZ)");
        return 1;
    }
    
    /* Create pseudo-terminal */
    if (openpty(&master, &slave, NULL, NULL, &ws) < 0) {
        perror("openpty");
        return 1;
    }
    
    /* Fork process */
    pid = fork();
    if (pid < 0) {
        perror("fork");
        return 1;
    }
    
    if (pid == 0) {
        /* Child process */
        close(master);
        
        /* Make slave the controlling terminal */
        setsid();
        if (ioctl(slave, TIOCSCTTY, 0) < 0) {
            perror("ioctl(TIOCSCTTY)");
            exit(1);
        }
        
        /* Redirect stdin/stdout/stderr to slave */
        dup2(slave, STDIN_FILENO);
        dup2(slave, STDOUT_FILENO);
        dup2(slave, STDERR_FILENO);
        close(slave);
        
        /* Execute command */
        execvp(argv[1], &argv[1]);
        perror("execvp");
        exit(1);
    }
    
    /* Parent process */
    close(slave);
    
    /* Set master to non-blocking */
    int flags = fcntl(master, F_GETFL, 0);
    fcntl(master, F_SETFL, flags | O_NONBLOCK);
    
    /* Main I/O loop */
    fd_set readfds;
    int max_fd = (master > STDIN_FILENO) ? master : STDIN_FILENO;
    
    while (1) {
        FD_ZERO(&readfds);
        FD_SET(STDIN_FILENO, &readfds);
        FD_SET(master, &readfds);
        
        if (select(max_fd + 1, &readfds, NULL, NULL, NULL) < 0) {
            if (errno == EINTR) continue;
            perror("select");
            break;
        }
        
        /* Data from stdin -> master (user input) */
        if (FD_ISSET(STDIN_FILENO, &readfds)) {
            ssize_t n = read(STDIN_FILENO, buffer, sizeof(buffer));
            if (n <= 0) break;
            write(master, buffer, n);
        }
        
        /* Data from master -> stdout (command output) */
        if (FD_ISSET(master, &readfds)) {
            ssize_t n = read(master, buffer, sizeof(buffer));
            if (n <= 0) break;
            
            buffer[n] = '\0';
            
            /* Inject colors */
            inject_colors(buffer, colored_buffer, sizeof(colored_buffer));
            
            write(STDOUT_FILENO, colored_buffer, strlen(colored_buffer));
        }
    }
    
    close(master);
    return 0;
}


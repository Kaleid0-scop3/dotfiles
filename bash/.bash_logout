# ~/.bash_logout

# when leaving the console clear the screen to increase privacy
[[ "$SHLVL" = 1 ]] && command -v clear_console &> /dev/null &&
    clear_console -q

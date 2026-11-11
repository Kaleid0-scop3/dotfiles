# ~/.bash_logout

# when leaving the console clear the screen to increase privacy
[[ "$SHLVL" = 1 && -x "$(which clear_console)" ]] &&
    clear_console -q

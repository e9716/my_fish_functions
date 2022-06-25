function get_os_name
    argparse -n open_fish_config -x 'w,h' \
        w/wsl \
        h/help -- $argv
    or return 1

    set -l help_msg "Description: Returns the name of the OS distribution you are currently using.

Usage:
    get_os_name [option]

Options:
    -h, --help        print this help message.
    -w, --wsl         returns whether wsl is used (true or false).

Examples:
    # When using ArchLinux with WSL.
    \$ get_os_name
    > arch
    \$ get_os_name -w
    > true

    # When using Ubuntu without WSL.
    \$ get_os_name
    > ubuntu
    \$ get_os_name -w
    > false
"

    if set -lq _flag_help
        echo $help_msg
    else if set -lq _flag_wsl
        if [ (string match -r -- "\d*-microsoft-standard-WSL2" (uname -r)) ]
            echo true
        else
            echo false
        end
    else
        for i in (string split ' ' (echo (ls -a /etc/ | grep -E '.*release')))
            if test $i != 'os-release'; or test $i != 'system-release';
                echo (string match -r '(.+)(-release)' $i)[2]
                break
            end
        end
    end
end

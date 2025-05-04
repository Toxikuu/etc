# /etc/profile.d/25-prefs/10-functions.sh
# Defines preferred functions

# Convenience function for licensing projects
license() {
    export -f license

    local li="${1,,}"

    add() {
        curl -fsSL "$1" -o "${2:-LICENSE}"
    }

    # Incomplete list of licenses I use on occasion
    case "$li" in
        gpl|gpl3)
            add "https://www.gnu.org/licenses/gpl-3.0.txt"
        ;;
        0mit)
            add "https://github.com/spdx/license-list-data/raw/refs/heads/main/text/MIT-0.txt"
        ;;
        mit)
            add "https://raw.githubusercontent.com/spdx/license-list-data/main/text/MIT.txt"
        ;;
        mpl)
            add "https://www.mozilla.org/media/MPL/2.0/index.f75d2927d3c1.txt"
        ;;
        0bsd)
            add "https://github.com/spdx/license-list-data/raw/refs/heads/main/text/0BSD.txt"
        ;;
        1bsd)
            add "https://github.com/spdx/license-list-data/raw/refs/heads/main/text/BSD-1-Clause.txt"
        ;;
        2bsd)
            add "https://github.com/spdx/license-list-data/raw/refs/heads/main/text/BSD-2-Clause.txt"
        ;;
        3bsd)
            add "https://github.com/spdx/license-list-data/raw/refs/heads/main/text/BSD-3-Clause.txt"
        ;;
        4bsd)
            add "https://github.com/spdx/license-list-data/raw/refs/heads/main/text/BSD-4-Clause.txt"
        ;;
        apache)
            add "https://www.apache.org/licenses/LICENSE-2.0.txt"
        ;;
        artistic)
            add "https://github.com/spdx/license-list-data/raw/refs/heads/main/text/Artistic-2.0.txt"
        ;;
        futo|sourcefirst)
            add "https://gitlab.futo.org/videostreaming/grayjay/-/raw/master/LICENSE.md" LICENSE.md
        ;;
        unlicense)
            add "https://github.com/spdx/license-list-data/blob/main/text/Unlicense.txt"
        ;;
        cc|cc0)
            add "https://github.com/spdx/license-list-data/raw/refs/heads/main/text/CC0-1.0.txt"
        ;;
    esac
}

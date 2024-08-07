# Terminal Customization

## Install Oh My Bash

> Make sure you change `my_theme` and `My Machine` to your preference.

* Copy the [**OhMyBashScript.sh** file](https://github.com/CoolBytesIN/dev-toolbox/blob/main/utilities/scripts/ohMyBashScript.sh) to a specific location on the machine.
* Change permissions of the file and execute it:
```shell
chmod 744 ohMyBashScript.sh && ./ohMyBashScript.sh
```

* Now, create a custom theme file using:
```shell
mkdir -p ~/.oh-my-bash/custom/themes/my_theme/ && vi ~/.oh-my-bash/custom/themes/my_theme/my_theme.theme.sh
```

* Add the following content to it:
```sh
#! bash oh-my-bash.module

# Change this to your preference
MACHINE_NAME="My Machine"

SCM_THEME_PROMPT_DIRTY=" ${_omb_prompt_brown}✗"
SCM_THEME_PROMPT_CLEAN=" ${_omb_prompt_bold_green}✓"
SCM_THEME_PROMPT_PREFIX=" ${_omb_prompt_green}|"
SCM_THEME_PROMPT_SUFFIX="${_omb_prompt_green}|"

GIT_THEME_PROMPT_DIRTY=" ${_omb_prompt_brown}✗"
GIT_THEME_PROMPT_CLEAN=" ${_omb_prompt_bold_green}✓"
GIT_THEME_PROMPT_PREFIX=" ${_omb_prompt_green}|"
GIT_THEME_PROMPT_SUFFIX="${_omb_prompt_green}|"

RVM_THEME_PROMPT_PREFIX="|"
RVM_THEME_PROMPT_SUFFIX="|"

__bobby_clock() {
  printf "$(clock_prompt) "

  if [ "${THEME_SHOW_CLOCK_CHAR}" == "true" ]; then
    printf "$(clock_char) "
  fi
}

function _omb_theme_PROMPT_COMMAND() {
    #PS1="${_omb_prompt_bold_teal}$(scm_char)${_omb_prompt_green}$(scm_prompt_info)${_omb_prompt_purple}$(_omb_prompt_print_ruby_env) ${_omb_prompt_olive}\h ${_omb_prompt_reset_color}in ${_omb_prompt_green}\w ${_omb_prompt_reset_color}\n${_omb_prompt_green}→${_omb_prompt_reset_color} "
    PS1="\n${_omb_prompt_bold_yellow}$(if [ "${VIRTUAL_ENV:-default}" != "default" ]; then echo "(${VIRTUAL_ENV##*/}) " ; fi)${_omb_prompt_bold_blue}($MACHINE_NAME) ${_omb_prompt_bold_red}\d ${_omb_prompt_bold_red}\t $(clock_char) $(battery_char) ${_omb_prompt_bold_blue}\u${_omb_prompt_gray}@${_omb_prompt_bold_teal}\h ${_omb_prompt_white}in ${_omb_prompt_bold_green}\w\n${_omb_prompt_bold_yellow}$(scm_prompt_char_info) ${_omb_prompt_brown}$AWS_PROFILE ${_omb_prompt_green}→${_omb_prompt_reset_color} "
}

THEME_SHOW_CLOCK_CHAR=${THEME_SHOW_CLOCK_CHAR:-"true"}
THEME_CLOCK_CHAR_COLOR=${THEME_CLOCK_CHAR_COLOR:-"$_omb_prompt_brown"}
THEME_CLOCK_COLOR=${THEME_CLOCK_COLOR:-"$_omb_prompt_bold_teal"}
THEME_CLOCK_FORMAT=${THEME_CLOCK_FORMAT:-"%Y-%m-%d %H:%M:%S"}

_omb_util_add_prompt_command _omb_theme_PROMPT_COMMAND
```

* Change OSH_THEME to `my_theme` in `.bashrc` file:
```shell
vi ~/.bashrc
```

* Apply changes by sourcing `.bashrc` file:
```shell
source ~/.bashrc
```

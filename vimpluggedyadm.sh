cd ~/.vim/plugged/
for x in $(find . -type d) ; do if [ -d "${x}/.git" ] ; then cd "${x}" ; origin="$(git config --get remote.origin.url)" ; cd - 1>/dev/null; yadm submodule add "${origin}" "${x}" ; fi ; done

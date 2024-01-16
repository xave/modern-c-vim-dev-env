#!/usr/bin/env bash

set -eou pipefail
#set -x # print debugging

main() {
	CFLAGS="-Wall -Wextra -fexceptions -DNDEBUG "
	CFLAGS+="-arch arm64 " #macOS
	CFLAGS+="-g "          #DEBUGGING

	CC="clang"
	INCLUDES+="$(pkg-config --cflags gtk4)"
	LIBS+="$(pkg-config --libs gtk4)"
	SRCS="src/main.c"
	BUILDAPP="./build/app"

	mkdir -p ./build/
	$CC $CFLAGS $INCLUDES -o $BUILDAPP $SRCS $LIBS
	make-compile-cmds-json-C

}

function make-compile-cmds-json-C() {
	################################################################################
	# This function makes the compile_commands.json databse for LSP functionality
	################################################################################
	CURRENTDIR="$PWD"

	isGitDir() {
		(
			cd "$CURRENTDIR" || return
			[[ $(git rev-parse --is-inside-work-tree 2>/dev/null) == true ]] ||
				echo false
		)
	}

	BUILDDIR="build"
	GITROOT="$(git rev-parse --show-toplevel)"

	if [[ ! $(isGitDir $CURRENTDIR) == false ]]; then
		(
			cd ${CURRENTDIR}
			if [[ (-d "${GITROOT}/") ]]; then
				IFS=$'\n'
				mkdir -p "${GITROOT}/${BUILDDIR}"
				#FILEPATHS=($(find ${GITROOT} -name "*.c"))
				IGNOREDIR="examples"
				FILEPATHS=($(find ${GITROOT} -not \( -path ${GITROOT}/$IGNOREDIR -prune \) -name "*.c"))
				unset IFS

				#echo "Paths:"
				#printf "%s\n" "${FILEPATHS[@]}"
				#echo "-----------------------"

				# Make the compilation database pieces
				declare -i i=1 #Simple hash
				for FILEPATH in "${FILEPATHS[@]}"; do
					BASENAME=${FILEPATH##*/}
					$CC -MJ ${GITROOT}/${BUILDDIR}/$i-$BASENAME.o.json $CFLAGS $INCLUDES -o ${GITROOT}/${BUILDDIR}/$i-$BASENAME.o -c $FILEPATH $LIBS
					i=$((i + 1))
				done
				echo "-----------------------"
				# Combine those pieces to make compile_commands.json
				sed -e '1s/^/[\'$'\n''/' -e '$s/,$/\'$'\n'']/' ${GITROOT}/${BUILDDIR}/*.o.json >"${GITROOT}"/compile_commands.json
				echo "Created ${GITROOT}/compile_commands.json"
			fi
		)
	else
		echo "$CURRENTDIR is not in a git repository"
		return
	fi
}

main "$@"
exit

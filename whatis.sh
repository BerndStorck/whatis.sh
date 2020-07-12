#! /bin/bash
#
#  whatis.sh
#
#  A wrapper for the whatis command which integrates the short
#  description of bash's buildin commands in the output of whatis.
#
#  The script calls whatis and help to generate a whatis like output, it
#  needs the program column.
#
#  Bernd Storck, 2020-07-12
#
#  Contact: https://www.facebook.com/BStLinux/

PROGNAME="$(basename $0)"
VERSION="1.1.0"

### HANDLING OF PARAMETERS ###############
case "$1" in
	--help|-h|--hilf|--hilfe)
		echo -e "$PROGNAME ($VERSION)

	$PROGNAME is a wrapper for the whatis command which integrates
	information on bash's buildin commands by calling bash's help
	and by generating a whatis like output of all program descriptions."
		exit
		;;
esac

if [ "${1:0:2}" = '-s' ]; then
	section="$1"
	shift
fi

# Remove numbers greater than 9, which are not used as section numbers:
section="$(sed -E 's:(9|[[:digit:]]{2,})::g' <<< "$section")"
# Remove double commas:
section="$(sed -E 's:,+:,:g' <<< "$section")"
# Remove comma directly behind "-s":
section="$(sed -E 's:^-s,:-s:' <<< "$section")"
# Remove comma at the end of the option:
section="$(sed -E 's:,$::' <<< "$section")"
# If all option values have been invalid, then delete section variable:
if [ "$section" = "-s" ]; then
	section=''
fi

### MAIN ########################
rm -rf /tmp/which.sh_err
for i in "$@"
do
	whatis $section $i 2>/dev/null
	if test -z "$section"; then
		if help "$i" &> /dev/null; then
			echo -ne "$i (buildin) -\c";
			help "$i" | tail +2 | head -1
		else
			echo -e "\e[0;31m$i (unknown) - Command not found / Kein passendes Kommando gefunden\e[0m" >> /tmp/which.sh_err
		fi
	fi
done > /tmp/which.sh_results

if test -s /tmp/which.sh_err 2> /dev/null; then
	cat /tmp/which.sh_err >> /tmp/which.sh_results && rm -rf /tmp/which.sh_err
fi

sed -E 's:^(.*\))[[:blank:]]+\-[[:blank:]]+(.*)$:\1=- \2:' /tmp/which.sh_results |\
column -s'=' -t

rm -rf /tmp/which.sh_results

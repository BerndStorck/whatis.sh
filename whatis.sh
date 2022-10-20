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
#  Bernd Storck, 2020-07-13, 2020-08-31, 2020-10-21, 2022-10-19
#
#  Contact: https://www.facebook.com/BStLinux/

PROGNAME="${0##*/}"
TITLE="$PROGNAME"
VERSION="1.3.0"


if [ "$(echo "$LANG" | cut -c 1-2)" == "de" ]; then
	UI_LANG="Deutsch"
else
	UI_LANG="English"
fi


function help_screen() {
# Displays program purpose and usage help.

echo -e "\e[1;33m$TITLE ($VERSION) \e[0m\n"

if [ "$1" = "hilf" ] || [ "$UI_LANG" == "Deutsch" ]; then

echo -e "   ist ein Wrapper für den whatis-Befehl, er zeigt alle
   Kurzbeschreibungen sowohl von bash-eigenen Kommandos als
   auch von externen Kommandos inklusive installierter Ruby-Gems
   im Stile von whatis an.

AUFRUFPARAMETER:
   -s1|2|…|7|8	 	Sucht Kommandos nur im Handbuchseitenabschnitt n.
   -sn,m,… 		Sucht Kommandos nur der Abschnitte n, m usw.
   --list|-l 		Listet die Handbuchsektionen auf.
   --hilf 		Diese Hilfe anzeigen
   --version 		Zeigt die Programversion an.

BEISPIELAUFRUFE:
   \033[1;32mAufruf			Beschreibung\033[0m

   $PROGNAME ls type		Kurzbeschreibung des Programms ls und
   				des Kommandos type anzeigen.

   $PROGNAME -s1,8 <commands>	Zeigt für nicht in die Bash eingebaute Befehle
   				nur Informationen aus den Sektionen 1 und 8 der
   				Handbuchseiten an."

else  # English help:
echo -e "   is a wrapper of the command whatis, it generates a
   whatis like list of the short program descriptions for 
   for bash buildin commands and for external programs including
   ruby gems.

PARAMETERS:
   -s1|2|…|7|8	 	Looks only for commands from manual section n.
   -sn,m,… 		Looks only for commands from manual sections n, m etc.
   --list|-l 		Lists the sections of the manual pages.
   --help|-h 		Show this help.
   --version|-V		Print program name and version.
   -#|-v		Print versions number.

EXAMPLES:
   \033[1;32mCall				Description\033[0m

   $PROGNAME ls type		Shows a short description of the program ls and
   				then command type.

   $PROGNAME -s1,8 <commands>	Shows for not bash buildin commands only information
   				from the manual page sections 1 und 8."
fi
}


function list_manual_sections() {
# Displays a manual secions list.

if [ "$UI_LANG" == "Deutsch" ]; then

echo -e " Die folgende Tabelle zeigt die Nummern der Abschnitte der
 Handbuchseiten und den Typ der dort zu findenden Seiten.

   1  Ausführbare Programme oder Shell-Befehle
   2  Systemaufrufe (Kernel-Funktionen)
   3  Bibliotheksaufrufe (Funktionen in Programmbibliotheken)
   4  Spezielle Dateien (gewöhnlich in /dev)
   5  Dateiformate und Konventionen, wie /etc/passwd
   6  Spiele
   7  Verschiedenes (inkl. Makropaketen und Konventionen), wie man(7), groff(7)
   8  Befehle für die Systemverwaltung (Kommandos für root)
   9  Kernel-Routinen [nicht Standard]

 Zu weitergehenden Informationen gelangen Sie durch das Kommando \"man man\"."

else  # English list:
echo -e " The table below shows the section numbers of the
 manual followed by the types of pages they contain.

   1  Executable programs or shell commands
   2  System calls (functions provided by the kernel)
   3  Library calls (functions within program libraries)
   4  Special files (usually found in /dev)
   5  File formats and conventions eg /etc/passwd
   6  Games
   7  Miscellaneous (incl. macro packages and conventions), e.g. man(7), groff(7)
   8  System administration commands (usually only for root)
   9  Kernel routines [Non standard]

 For further information use the command \"man man\"."
fi
}


### HANDLING OF PARAMETERS ###############
case "$1" in
	--help|-h|--hilf|--hilfe)
		help_screen "${1:2:4}"
		exit
		;;
	--list|-l)
		list_manual_sections
		exit
		;;
	--version|-V)
		echo "$PROGNAME ($VERSION)"
		exit
		;;
	-v|-\#) ## 2020-08-31
		echo "$VERSION"
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

#echo "\"${@}\""
#loopno=0

### MAIN ########################
rm -rf /tmp/whatis.sh_err
for i in "$@"
do
  # loopno="$(( loopno++ ))"
  if [ -z "$section" ]; then
	  whatis "$i" 2>/dev/null | grep -Es "^$i[^-\w]+"
	  hasManpage="$?"
  else
	  whatis "$section" "$i" 2>/dev/null | grep -Es "^$i[^-\w]+"
	  hasManpage="$?"
  fi
  if gem info "$i" 2> /dev/null | grep -s "$i" > /dev/null; then 
		echo -ne "$i (rubygem) -\c"
    gem info "$i" | tail -n 1
	elif help "$i" &> /dev/null; then
		echo -ne "$i (buildin) -\c"
		help "$i" | tail +2 | head -1
	elif [ "$hasManpage" != "0" ]; then
	  whatis "$section" "^$i" 2>/dev/null
	  hasManpage="$?"
    if  [ "$hasManpage" != "0" ]; then
		  echo -e "\e[0;31m$i (unknown) - Command not found / Kein passendes Kommando gefunden\e[0m" >> /tmp/whatis.sh_err
    fi
	fi
done > /tmp/whatis.sh_results

if test -s /tmp/whatis.sh_err 2> /dev/null; then
	cat /tmp/whatis.sh_err >> /tmp/whatis.sh_results && rm -rf /tmp/whatis.sh_err
fi

sed -E 's:^(.*\))[[:blank:]]+\-[[:blank:]]+(.*)$:\1=- \2:' /tmp/whatis.sh_results |\
column -s'=' -t

rm -rf /tmp/whatis.sh_results

#echo "Last loop was: #${loopno}"

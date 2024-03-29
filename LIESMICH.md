# whatis.sh #

## Kurzbeschreibung ##

"whatis.sh" ist ein Wrapper für das Kommando "whatis". Das bedeutet, dass das Skript dem Aufruf von whatis vorgeschaltet wird, um die Antwort von whatis in spezieller Weise zu ergänzen. "whatis.sh ergänzt die Ausgabe des normalen 'whatis'-Kommandos um die Kurzbeschreibungen der in die Bash eingebauten Kommandos und um die Kurzbeschreibung von RubyGems, die nicht in den Standard-Handbuchseiten, den Manpages, beschrieben sind. 

## Voraussetzungen ##

**Das Packet bsdmainutils muss installiert sein, weil dieses Skript das mit bsdmainutils  bereitgestellte Programm "column" benötigt.**

## Gegenüberstellung ##

### Standard whatis ###
```bash
BStLinux@linux-sys: ~ $ whatis ls set schlumpf gist export
ls (1)               - Verzeichnisinhalte auflisten
gist-paste (1)       - upload code to https://gist.github.com
set: nichts passendes.
schlumpf: nichts passendes.
export: nichts passendes.
BStLinux@linux-sys: ~ $ 
```

### whatis.sh ###
**Achtung:** "whats" wurde als Alias für "'whatis.sh" angelegt. 

```bash
BStLinux@linux-sys: ~ $ whats ls set schlumpf gist export
ls (1)                 - Verzeichnisinhalte auflisten
set (buildin)          - Set or unset values of shell options and positional parameters.
gist (rubygem)         - Just allows you to upload gists
export (buildin)       - Setzt das Attribut »export« für Shell-Variablen.
schlumpf (unknown)     - Command not found / Kein passendes Kommando gefunden
BStLinux@linux-sys: ~ $
```

## Weitere Leistungen ##

Das Skript kann Parameter `-s` an whatis weitergeben, dazu muss er der erste Aufrufparameter sein und die Werte für den Parameter müssen ohne Leerzeichen auf das `-s` folgen.

| Falsch              | Richtig            |
| ------------------- | ------------------ |
| `whatis.sh -s 1 ls` | `whatis.sh -s1 ls` |

**Achtung:** "whats" wurde als Alias für "'whatis.sh" angelegt. 

```bash
BStLinux@linux-sys: ~ $ whats -s1,8 cd exit ls useradd
cd (buildin)    - Wechselt das Arbeitsverzeichnis.
exit (buildin)  - Beendet die aktuelle Shell.
ls (1)          - Verzeichnisinhalte auflisten
useradd (8)     - erstellt einen neuen Benutzer oder aktualisiert die St...
BStLinux@linux-sys: ~ $
```

'whatis.sh' versucht, unzulässige Sektionsnummern, d. h. zu hohe Zahlen für den Parameter `-s`, zu löschen und nur zulässige Werte an das Standardkommando whatis weiterzugeben.  


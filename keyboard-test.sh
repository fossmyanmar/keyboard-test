#!/bin/bash
BACKUPFILE=./xkb-original.tar
BACKUPDATA=/usr/share/X11/xkb/

backup(){
	if [ -f "$BACKUPFILE" ]
	then 
		zenity --info --no-wrap --text="Backup is here $BACKUPFILE" --title="Backup" --icon-name="file-roller" && \
		echo "Backup file: $BACKUPFILE" 
	
	else
		tar -cvf "$BACKUPFILE" "$BACKUPDATA" && \
		zenity --info --no-wrap --text="Backup is here $BACKUPFILE" --title="Backup" --icon-name="file-roller" && \
		echo "Backup File!"

	fi
}

restore(){
	if [ ! -f "$BACKUPFILE" ]
	then 
		zenity --error --text=" File Not Found ! " --no-wrap \
		&& echo "can't restore, File Not Found"
	else
		sudo tar -xvf "$BACKUPFILE" -C /  && \
		zenity --info --no-wrap --text="Restore from here $BACKUPFILE" --title="Restored" --icon-name="file-roller" && \
		echo "Restored"
	fi
}

install_test(){
	backup
	sudo cp -rv src/symbols/mm /usr/share/X11/xkb/symbols/ && zenity --info --no-wrap --text="Keyboard Copies" --title="Copy"
	sudo cp -rv src/rules/* /usr/share/X11/xkb/rules/ && zenity --info --no-wrap --text="Config Copies" --title="Copy"
	zenity --info --no-wrap --text="Success Install, Add and Check Keyboard" --title="Install"
}

changesys(){
        gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('xkb', '$kb')]"
	sleep 1
	gkbd-keyboard-display -l  "$(echo -e "${kb//+/\\t}")" & gedit & 
}

zenity_menu(){
menu_welcome="$(zenity  --width 300 --height 300 --list --radiolist  --column "Choose" --column "Menu" \
	TRUE  "Install" \
	FALSE "Backup" \
        FALSE "Mon" \
	FALSE "Mon A1" \
	FALSE "Shan" \
	FALSE "Shan Zawgyi-Tai" \
	FALSE "Burmese" \
	FALSE "Burmese Zawgyi" \
       	FALSE "Restore" \
	FALSE "Exit" \
	--title="Keyboard Tester" --text="Please Select Menu")"
         if [ "$menu_welcome" = "Exit" ]; then
                echo "done"
                exit
         elif [ "$menu_welcome" = "Restore" ]; then
                echo "Reset Keyboard Config"
                restore
         elif [ "$menu_welcome" = "Backup" ]; then
                backup
         elif [ "$menu_welcome" = "Mon" ]; then
                kb="mm+mnw"
                changesys
         elif [ "$menu_welcome" = "Mon A1" ]; then
                kb="mm+mnw-a1"
                changesys
         elif [ "$menu_welcome" = "Shan" ]; then
                kb="mm+shn"
                changesys
         elif [ "$menu_welcome" = "Shan Zawgyi-Tai" ]; then
                kb="mm+zgt"
                changesys
         elif [ "$menu_welcome" = "Burmese" ]; then
                kb=mm
                changesys
         elif [ "$menu_welcome" = "Burmese Zawgyi" ]; then
                kb="mm+zawgyi"
                changesys
         elif [ "$menu_welcome" = "Install" ]; then
		 install_test
         else
                clear
                echo Invalid option
         fi
	 zenity_menu
}


case "$1" in
  mnw)
                kb="mm+mnw"
                changesys
        ;;
  mnwa1)
                kb="mm+mnw-phonetic"
                changesys
        ;;
  zawgyi)
                kb="mm+zawgyi"
                changesys
        ;;
  bur)
                kb=mm
                changesys
        ;;
  shn)
                kb="mm+shn"
                changesys
        ;;
  zgt)
                kb="mm+zgt"
                changesys
        ;;
  backup)
		backup
        ;;
  restore)
	  	restore
        ;;
  install)
	  	install_test
	;;
  menu)
	        zenity_menu
	;;
  *)
        echo
        echo $"Usage: $0 {bur|zawgyi|mnw|mnwa1|shn|zgt|install|backup|restore|menu}"
        echo
        echo $" install                           # Backup and Replace Keyboard File"  
        echo
        echo $" bur | zawgyi | mnw | mnwa1 | shn | zgt  # Its support keyboard layout"  
        echo
        echo $" backup | restore                  # Its keyboard file backup and restore"  
        echo
        echo $" menu                              # Its GUI Menu"  
        echo
        exit 1
esac
exit 0


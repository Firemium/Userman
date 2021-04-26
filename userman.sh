#!/bin/bash

#Colors
    cyan='\e[0;36m'
    lightcyan='\e[96m'
    lightgreen='\e[1;32m'
    white='\e[1;37m'
    red='\e[1;31m'
    yellow='\e[1;33m'
    blue='\e[1;34m'
    tp='\e[0m'
    green='\e[0;32m'
    blink='\e[5m'


err() {
    echo -e "\e[31m[$(date +'%Y-%m-%dT%H:%M:%S%z')] ERROR: $*\e[0m" >&2
    exit 1
}

warn() {
    echo -e "\e[35m[$(date +'%Y-%m-%dT%H:%M:%S%z')] WARN: $*\e[0m" >&2
}

mainmenu() {
    clear
    echo "Lütfen bazı işlemleri yapmak için izin gerekli olduğundan şifrenizi girin ..."
    sudo clear
    warn "Bu aracın neden olduğu / neden olacağı her türlü hasar sizin sorumluluğunuzdadır."
    warn "Lütfen Destek Olmayı Unutmayın https://github.com/Firemium/Userman"
    echo "----------------------"
    echo "|       USERMAN      |"
    echo "----------------------"
    echo ""
    echo ""
    echo -e "$yellow Yeni bir kullanıcı oluşturmak için$white 1'e$yellow basın."
    echo -e "$yellow Bir kullanıcıyı kaldırmak için$white 2'ye$yellow basın."
    echo -e "$yellow Sudoers'a bir kullanıcı eklemek için$white 3'e$yellow basın"
    echo -e "$yellow Sudoers dosyasını yazdırmak için$white 4'e$yellow basın."
	echo -e "$yellow Bir kullanıcıyı sudoers dosyasından kaldırmak için$white 5'e$yellow basın."
	echo -e "$yellow Bir kullanıcının şifresini değiştirmek için$white 6'ya$yellow basın."
	echo -e "$yellow Tüm kullanıcıları listelemek için$white 7'ye$yellow basın."
	echo -e "$yellow Çıkış yapmak için$white 8'ye$yellow basın"
    read  -n 1 -p "Ne Yapmak iStersin ? :  " mainmenuinput
    if [[ $mainmenuinput = "1" ]] ; then
        clear
        newuser
    elif [[ $mainmenuinput = "2" ]] ; then
        clear
        removeuser
    elif [[ $mainmenuinput = "3" ]] ; then 
        clear
        addsudoer
    elif [[ $mainmenuinput = "4" ]] ; then
        clear
        print_sudoers
    elif [[ $mainmenuinput = "5" ]] ; then
        clear
        removesudoer
    elif [[ $mainmenuinput = "6" ]] ; then
        clear
        change_passwd
    elif [[ $mainmenuinput = "7" ]] ; then
        clear
        listusers
    elif [[ $mainmenuinput = "8" ]] ; then
        clear
        exit_prog
    else
        clear
        mainmenu
    fi

}

newuser() {
    warn "Bu aracın neden olduğu / neden olacağı her türlü hasar sizin sorumluluğunuzdadır."
    echo "------------------------------"
	echo "    Yeni kullanıcı oluştur    "
	echo "------------------------------"
	echo ""
    read -p "Yeni kullanıcının kullanıcı adı nedir? (İptal etmek için u! Yazın" username
    if [[ $username = "u!" ]] ; then
        clear
        mainmenu
    fi
    sudo adduser $username
    if [ $? -eq 0] ; then
        echo
    else 
        err "Kullanıcı oluşturulamadı"
    fi
    warn "Kullanıcı oluşturma işlemi tamamlandı! 2 saniye içinde ana menüye dönülüyor ..."
    sleep 2
    mainmenu
}

removeuser() {
	warn "Bu aracın neden olduğu / neden olacağı her türlü hasar sizin sorumluluğunuzdadır."
	echo "------------------------------"
	echo "    Bir kullanıcıyı kaldır    "
	echo "------------------------------"
	echo
	read -p "Yeni kullanıcının kullanıcı adı nedir? (İptal etmek için u! Yazın)" username_del
	if [ "$username_del" = "u!" ]; then
		clear
		mainmenu
	fi
	sudo deluser $username_del
	if [ $? -eq 0 ]; then
		echo
	else
		err "Kullanıcı oluşturma başarısız oldu."
	fi
	warn "Kullanıcıyı kaldırma işlemi tamamlandı! 5 saniye içinde ana menüye dönülüyor ..."
	sleep 5
	mainmenu
}

exit_prog() {
    warn "Userman aracını kullandığınız için teşekkürler!"
    warn "İyi Günler"
    read -n 1 -p "Çıkmak istediğine emin misin? (y / n)" exit_sure
	if [ "$exit_sure" = "y" ]; then
		clear
		exit
	elif [ "$exit_sure" = "n" ]; then
		clear
		mainmenu
	else
		clear
		exit_prog
	fi
}

addsudoer() {
	# etc/sudoers.tmp
	warn "Bu aracın neden olduğu / neden olacağı her türlü hasar sizin sorumluluğunuzdadır."
	echo "----------------------------------------"
	echo "     Sudoers'a bir kullanıcı ekleyin    "
	echo "----------------------------------------"
	echo
	read -p "Sudoers dosyasına eklenecek kullanıcının kullanıcı adı nedir? (İptal etmek için u! Yazın)" username_sudo
	if [ "$username_sudo" = "u!" ]; then
		mainmenu
	else
		sudo usermod -aG sudo $username_sudo
	fi

	if [ $? -eq 0 ]; then
		echo
	else
		err "Kullanıcıyı sudoers'a ekleme başarısız oldu."
	fi
	warn "Kullanıcıyı sudoers'a eklemek tamamlandı! 2 saniye içinde ana menüye dönülüyor ..."
	sleep 2
	mainmenu
}

print_sudoers() {
	sudo cat /etc/sudoers
	echo
	echo
	warn "Sudoer'ların yazdırılması tamamlandı! 5 saniye içinde ana menüye dönülüyor ..."
	sleep 5
	mainmenu
}

removesudoer() {
	warn "Bu aracın neden olduğu / neden olacağı her türlü hasar sizin sorumluluğunuzdadır"
	echo "--------------------------------------"
	echo "  Bir kullanıcıyı sudoers'dan kaldır  "
	echo "--------------------------------------"
	echo
	read -p "Sudoers dosyasından kaldırılacak kullanıcının kullanıcı adı nedir? (İptal etmek için u! Yazın) " username_sudo_rem
	if [ "$username_sudo_rem" = "u!" ]; then
		mainmenu
	else
		sudo deluser $username_sudo_rem sudo
	fi
	if [ $? -eq 0 ]; then
		echo
	else
		err "Kullanıcıyı sudoers'dan kaldırma başarısız oldu."
	fi
	warn "Kullanıcıyı sudoers'dan kaldırma işlemi tamamlandı! 5 saniye içinde ana menüye dönülüyor ..."
	sleep 5
	mainmenu
}

removesudoer() {
	warn "Bu aracın neden olduğu / neden olacağı her türlü hasar sizin sorumluluğunuzdadır."
	echo "--------------------------------------"
	echo "  Bir kullanıcıyı sudoers'dan kaldır  "
	echo "--------------------------------------"
	echo
	read -p "Sudoers dosyasından kaldırılacak kullanıcının kullanıcı adı nedir? (İptal etmek için u! Yazın) " username_sudo_rem
	if [ "$username_sudo_rem" = "u!" ]; then
		mainmenu
	else
		sudo deluser $username_sudo_rem sudo
	fi
	if [ $? -eq 0 ]; then
		echo
	else
		err "Kullanıcıyı sudoers'dan kaldırma başarısız oldu."
	fi
	warn "Kullanıcıyı sudoers'dan kaldırma işlemi tamamlandı! 5 saniye içinde ana menüye dönülüyor ..."
	sleep 5
	mainmenu
}

change_passwd() {
	warn "Bu aracın neden olduğu / neden olacağı her türlü hasar sizin sorumluluğunuzdadır."
	echo "------------------------------"
	echo "         Şifre değiştir       "
	echo "------------------------------"
	echo
	read -p "Hangi hesap şifresini değiştirmek istiyorsunuz? (İptal etmek için u! Yazın)" username_chng_passwd
	if [ "$username_chng_passwd" = "u!" ]; then
		mainmenu
	else
		sudo passwd $username_chng_passwd
	fi
	if [ $? -eq 0 ]; then
		echo
	else
		err "Kullanıcının şifresinin değiştirilmesi $username_chng_passwd başarısız oldu."
	fi
	warn "Parolanın değiştirilmesi tamamlandı! 5 saniye içinde ana menüye dönülüyor ..."
	sleep 5
	mainmenu
}

listusers() {
	echo "Bu işlem biraz zaman aldığı için lütfen biraz bekleyin ... (NOT: Bu, kök ve sistem kullanıcılarını yazdırmaz.)"
	eval getent passwd {$(awk '/^UID_MIN/ {print $2}' /etc/login.defs)..$(awk '/^UID_MAX/ {print $2}' /etc/login.defs)} | cut -d: -f1
	warn "Kullanıcıların yazdırılması tamamlandı! 10 saniye içinde ana menüye dönülüyor ..."
	sleep 5
	mainmenu
}

mainmenu

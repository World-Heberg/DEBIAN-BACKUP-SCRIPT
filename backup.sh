#!/bin/sh
clear
echo $emplacement_script $*
choix=0

if [ ! -d /home/backups ]
	then
		mkdir /home/backups
fi
cd /
cat << "EOF"
 _    _            _     _        _   _      _                                         
| |  | |          | |   | |      | | | |    | |                                        
| |  | | ___  _ __| | __| |______| |_| | ___| |__   ___ _ __ __ _   ___ ___  _ __ ___  
| |/\| |/ _ \| '__| |/ _` |______|  _  |/ _ \ '_ \ / _ \ '__/ _` | / __/ _ \| '_ ` _ \ 
\  /\  / (_) | |  | | (_| |      | | | |  __/ |_) |  __/ | | (_| || (_| (_) | | | | | |
 \/  \/ \___/|_|  |_|\__,_|      \_| |_/\___|_.__/ \___|_|  \__, (_)___\___/|_| |_| |_|
                                                             __/ |                     
                                                            |___/          
EOF
echo "Sauvegardez vos données simplement grâce à notre script ! (Une suggestion, une question ? contact@world-heberg.com"
echo "https://world-heberg.com"
sleep 3

clear
echo "Choisissez le format d'enregistrement de votre backup :"
echo "[\033[32m1\033[0m] - Archive zip"
echo "[\033[32m2\033[0m] - FTP distant"
read choix

if [ $choix = 1 ]
	then
		apt-get install zip -y
		clear
		echo "Vous avez sélectionné le format : \033[31mArchive zip\033[0m"
		echo "Veuillez indiquer ou se trouve le dossier à archiver (Ex: /home ou /var/www):"
		read emplacement
		if [ ! -d $emplacement ]
			then
				echo "\033[31mLe dossier n'existe pas.\033[0m"
				echo "\033[31mFermeture du script.\033[0m"
				exit
		fi

		echo "Veuillez indiquer le nom de l'archive (Ex: backup.zip):"
		read nom_archive
		if [ ! -e $nom_archive ]
        		then
				echo "\033[32mCréation de la backup en cours...\033[0m"
   				zip -r $nom_archive $emplacement
			    	mv /$nom_archive /home/backups/
		    		echo "\033[32mBackup terminée !\033[0m"
				echo "\033[32mEmplacement de la backup : \033[1m/home/backups/$nom_archive\033[0m"
			else
				echo "\033[31mLe fichier existe déjà.\033[0m"
				rm /$nom_archive
		                echo "\033[31mLe fichier exitant a été supprimé\033[0m"
				echo "\033[31mFermeture du script.\033[0m"
				exit
		fi

elif [ $choix = 2 ]
	then
		apt-get install ncftp -y
  		clear
		echo "Vous avez sélectionné le format : \033[31mFTP Distant\033[0m"
        echo "Veuillez indiquer où se trouve le dossier à archiver (depuis la racine) :"
    	read emplacement
        if [ ! -d $emplacement ]
        	then
          		echo "Le dossier n'existe pas."
				echo "Fermeture du script."
				exit
      	fi

        echo "Veuillez indiquer le nom de l'archive (Ex: backup.zip):"
        read nom_archive

        if [ ! -e $nom_archive ]
        		then
        		clear
                echo "Veuillez indiquer le serveur FTP :"
      			read serveur
                echo "Veuillez indiquer l'utilisateur FTP :"
      			read user
                echo "Veuillez indiquer le mot de passe de l'utilisateur :"
      			read pass

		echo "\033[32mCréation de la backup en cours...\033[0m"
   		zip -r $nom_archive $emplacement
		echo "\033[32mArchive créée !\033[0m"
		echo "\033[32mConnexion au serveur FTP ...\033[0m"

ncftp -u"$user" -p"$pass" $serveur <<EOF
mkdir -p backups
cd backups
put $nom_archive
bye
EOF
		echo "\033[32mVotre fichier a bien été transféré.\033[0m"
		echo "\033[31m$emplacement \033[0m\033[35m=>\033[0m Dossier de <$user> \033[32m./backups/$nom_archive.\033[0m"
		echo "\033[31mDéconnexion du serveur.\033[0m"
		rm /$nom_archive

				else
					echo "\033[31mLe fichier existe déjà.\033[0m"
					rm /$nom_archive
		       	    echo "\033[31mLe fichier exitant a été supprimé\033[0m"
					echo "\033[31mFermeture du script.\033[0m"
					exit
		fi

	else
		echo "\033[31mErreur dans la séléction.\033[0m"
		echo "\033[31mFermeture du script.\033[0m"
		exit
fi
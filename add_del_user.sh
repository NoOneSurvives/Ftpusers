#!/bin/bash

echo "�������� ��������:"
echo "1 - ���������� ������������ � FTP � �������� �����"
echo "2 - �������� ������������ � �������� �����"
echo "3 - �������� ������������ ��� �������� �����"
echo "4 - �����"

read doing

case $doing in
1)
echo "������� ��� ������������:"
        exist (){
        read user
                if [[ -a /etc/vsftpd/user_conf/$user ]]
                    then
                        echo "���������� ������������ ������������ $user, ������� ������ ��� ������������:"
                        exist
                    else
                        echo "����� ������������ : $user"
                fi
                }
exist
echo "������� ������ ��� $user:"
read -s password
echo "��������� ������:"
        func (){
        read -s check
                if [ "$password" = "$check" ]
                        then
                                echo "$user" >> /etc/vsftpd/logins.txt
                                echo "$password" >> /etc/vsftpd/logins.txt
                                echo "������������ ��������, ��������� ����..."
                                mv /etc/vsftpd/logins.db /etc/vsftpd/backup/logins.db`date +%y_%m_%d`.ADD
                                db47_load -T -t hash -f /etc/vsftpd/logins.txt /etc/vsftpd/logins.db
                                echo "������� ����� ������������..."
                                mkdir /var/ftp/$user
                                cp /etc/vsftpd/README.txt /var/ftp/$user
                                chown ftp:ftp /var/ftp/$user
                                echo "C������ ������ ������������..."
                                touch "/etc/vsftpd/user_conf/$user"
                                echo "������������ ��������! ���������� FTP:"
                                service vsftpd restart
                        else
                                echo "������ �� ���������! ������� ������:"
                                func
 fi
                exit 0
                }
func
;;
2)
echo "������� ��� ������������ ��� ��������:"
        func_del_all (){
        read user_del_all
                if [[ -a /etc/vsftpd/user_conf/$user_del_all ]]
                    then
                        echo "������������ ������������ $user_del_all �������, ���������� � �������� ����� � ������������? -  (y/n) "
                        read answer_del_all
                            if [[ "$answer_del_all" != "y" ]]
                                then
                                        echo "������������ � ����� �� �������."
                                        exit
                                else
                                        echo "������ ����� ����!"
                                        mv /etc/vsftpd/logins.db /etc/vsftpd/backup/logins.db`date +%y_%m_%d`.DEL
                                        echo "������� ����� ������������ � ����. ����."
                                        rm -rf "/var/ftp/$user_del_all"
                                        rm "/etc/vsftpd/user_conf/$user_del_all"
                                        echo "������� ���� logins.txt ."
                                        sed -i -e "/$user_del_all/,+1 d" /etc/vsftpd/logins.txt
                                        echo "���e������� ����."
                                        db47_load -T -t hash -f /etc/vsftpd/logins.txt /etc/vsftpd/logins.db
                                        echo "������! ������������ $user_del_all � ��� ����� �������!"
                            fi
                    else
                        echo "����� ������������ �� �������!"
                fi
        exit 0
                    }
func_del_all
;;
3)
echo "������� ��� ������������ ��� ��������:"
        func_del_user (){
        read user_del
                if grep -q $user_del /etc/vsftpd/logins.txt
                    then
                            echo "������������ $user_del ������, ���������� � �������� ������������? - (y/n) "
                            read answer_del
                                if [[ "answer_del" != "y" ]]
then
                                            echo "������������ �� ������."
                                            exit
                                    else
                                            echo "������ ����� ����!"
                                            mv /etc/vsftpd/logins.db /etc/vstpd/backup/logins.db`date +%y_%m_%d`.DEL
                                            echo "������� ����. ����."
                                            rm "/etc/vsftpd/user_conf/$user_del"
                                            echo "������� ���� logins.txt"
                                            sed -i -e "/$user_del/,+1 d" /etc/vsftpd/logins.txt
                                            echo "����������� ����."
                                            db47_load -T -t hash -f /etc/vsftpd/logins.txt /etc/vsftpd/logins.db
                                            echo "������! ������������ $user_del ������!"
                                fi
                        else
                            echo "������������ �� ������!"
                fi
        exit 0
                        }
func_del_user
;;
4)
exit 0
;;
*)
echo "������������ �����."

esac

#!/bin/bash

echo "Выберите действие:"
echo "1 - Добавление пользователя в FTP и создание папки"
echo "2 - Удаление пользователя и удаление папки"
echo "3 - Удаление пользователя БЕЗ удаления папки"
echo "4 - Выход"

read doing

case $doing in
1)
echo "Введите имя пользователя:"
        exist (){
        read user
                if [[ -a /etc/vsftpd/user_conf/$user ]]
                    then
                        echo "Существует конфигурация пользователя $user, введите другое имя пользователя:"
                        exist
                    else
                        echo "НОВЫЙ ПОЛЬЗОВАТЕЛЬ : $user"
                fi
                }
exist
echo "Введите пароль для $user:"
read -s password
echo "Повторите пароль:"
        func (){
        read -s check
                if [ "$password" = "$check" ]
                        then
                                echo "$user" >> /etc/vsftpd/logins.txt
                                echo "$password" >> /etc/vsftpd/logins.txt
                                echo "Пользователь добавлен, обновляем базу..."
                                mv /etc/vsftpd/logins.db /etc/vsftpd/backup/logins.db`date +%y_%m_%d`.ADD
                                db47_load -T -t hash -f /etc/vsftpd/logins.txt /etc/vsftpd/logins.db
                                echo "Создаем папку пользователя..."
                                mkdir /var/ftp/$user
                                cp /etc/vsftpd/README.txt /var/ftp/$user
                                chown ftp:ftp /var/ftp/$user
                                echo "Cоздаем личную конфигурацию..."
                                touch "/etc/vsftpd/user_conf/$user"
                                echo "Пользователь добавлен! Рестартуем FTP:"
                                service vsftpd restart
                        else
                                echo "Пароль не совпадает! Введите заново:"
                                func
 fi
                exit 0
                }
func
;;
2)
echo "Введите имя пользователя для удаления:"
        func_del_all (){
        read user_del_all
                if [[ -a /etc/vsftpd/user_conf/$user_del_all ]]
                    then
                        echo "Конфигурация пользователя $user_del_all найдена, приступить к УДАЛЕНИЮ папки и пользователя? -  (y/n) "
                        read answer_del_all
                            if [[ "$answer_del_all" != "y" ]]
                                then
                                        echo "Пользователь и папка не удалены."
                                        exit
                                else
                                        echo "Делаем бэкап базы!"
                                        mv /etc/vsftpd/logins.db /etc/vsftpd/backup/logins.db`date +%y_%m_%d`.DEL
                                        echo "Удаляем папку пользователя и конф. файл."
                                        rm -rf "/var/ftp/$user_del_all"
                                        rm "/etc/vsftpd/user_conf/$user_del_all"
                                        echo "Очищаем файл logins.txt ."
                                        sed -i -e "/$user_del_all/,+1 d" /etc/vsftpd/logins.txt
                                        echo "Перeсоздаем базу."
                                        db47_load -T -t hash -f /etc/vsftpd/logins.txt /etc/vsftpd/logins.db
                                        echo "Готово! Пользователь $user_del_all и его папка УДАЛЕНЫ!"
                            fi
                    else
                        echo "Папка пользователя не найдена!"
                fi
        exit 0
                    }
func_del_all
;;
3)
echo "Введите имя пользователя для удаления:"
        func_del_user (){
        read user_del
                if grep -q $user_del /etc/vsftpd/logins.txt
                    then
                            echo "Пользователь $user_del найден, приступить к УДАЛЕНИЮ пользователя? - (y/n) "
                            read answer_del
                                if [[ "answer_del" != "y" ]]
then
                                            echo "Пользователь не удален."
                                            exit
                                    else
                                            echo "Делаем бэкап базы!"
                                            mv /etc/vsftpd/logins.db /etc/vstpd/backup/logins.db`date +%y_%m_%d`.DEL
                                            echo "Удаляем конф. файл."
                                            rm "/etc/vsftpd/user_conf/$user_del"
                                            echo "Очищаем файл logins.txt"
                                            sed -i -e "/$user_del/,+1 d" /etc/vsftpd/logins.txt
                                            echo "Пересоздаем базу."
                                            db47_load -T -t hash -f /etc/vsftpd/logins.txt /etc/vsftpd/logins.db
                                            echo "Готово! Пользователь $user_del удален!"
                                fi
                        else
                            echo "Пользователь не найден!"
                fi
        exit 0
                        }
func_del_user
;;
4)
exit 0
;;
*)
echo "Неправильный выбор."

esac

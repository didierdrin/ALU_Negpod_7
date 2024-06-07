#!/usr/bin/env bash

# user inteface/ Prompt
echo "------------------"
echo "ALU REGISTRATION SYSTEM"
echo "------------------"
echo "1. Create Student Record"
echo "2. View Student Record"
echo "3. Update Student Record"
echo "4. Delete Student Record"
echo "5. Sort Student emails"
echo "6. Exit"

#Counter to keep track of the number of times the user has interacted with the system
counter=0

# While loop is set at true to keep the program running until the user decides to exit
while true; do
    # If the counter is bigger than 0, Ubwo ni ukuvaga ko atari ubwambere loop ibaye ho
    if [ $counter -gt 0 ]; then
        echo -e "\n****************Let's Continue*****************"
    fi
    # niba counter ari 0; then ni bwo bwambere user akoresheje system
    if [ $counter -eq 0 ]; then
        echo -e "\n****************Let's Get Started**************"
    fi
    # dusabe user ko yandika icyo ashaka gukora muri system
    read -p "Enter your choice: " choice

    if [[ $choice =~ ^[1-6]+$ ]]; then
        case $choice in
            1 ) 
                # ====================================REGISTRATION=================================
                # Asking the user to enter the email
                read -p "Enter Email: " email
                
                # amagambo ya emails zisanzwe ari stored muri array
                # -------- @amagambo ari muri terminal variable
                terminal=("alustudent" "alustaff" "aluadmin" "gmail" "yahoo")
                # -------- @amagambo ari muri extension variable
                extension=("com" "org" "net" "edu" "gov")

                # Definition y'uko email yashobora kuba valid
                regex="^[a-zA-Z0-9.]+@($(IFS="|"; echo "${terminal[*]}"))\.($(IFS="|"; echo "${extension[*]}"))$"
                #kureba ko bisa na syntax ya regex
                if [[ $email =~ $regex ]]; then
                    :
                else
                    echo "Email is invalid"
                    continue
                fi
                # gusaba imyaka
                read -p "Enter age: " age
                if [[ $age =~ ^[1-9][0-9]*$ ]]; then
                    :
                else
                    echo "Age is invalid"
                    continue
                fi
                #gusaba ID
                read -p "Enter ID: " id
                if [[ $id =~ ^[1-9][0-9]*$ ]]; then
                    :
                else
                    echo "ID is invalid"
                    continue
                fi
                # kubika amakuza muri file yitwa students-list_1023.txt
                echo "$email, $age, $id" >> students-list_1023.txt
                # kongera counter kugira ngo tubashe kumenya inshuro user yakoresheje system
                ((counter++))
                ;;
            2 ) 
                # ======================================VIEW THE LIST=====================================
                cat students-list_1023.txt
                # Kongera counter kugira ngo tubashe kumenya inshuro user yakoresheje system
                ((counter++))
                ;;
            
            3 ) 
                # ======================================UPDATE=====================================
                # asking the user to enter the ID for searching
                read -p "Enter ID: " id1
                # grep izakora search muri file yacu then izakora output yayo
                echo "------------------------------------------------------"
                grep "$id1" students-list_1023.txt
                echo "------------------------------------------------------"
                # tuzabaze niba user ashaka guhindura ID y'umuntu twakoresheje
                # Igisubizo tuzakibike muri variable yitwa choix
                read -p "Do you want to change the ID (Y/n)? :" choix
                # niba choix yaravuze Y, user azaba ashaka guhindura ID
                if [[ $choix == "Y" ]]; then
                    # dusabe user yandike ID ashaka kuyihinduramo ayibike muri variable id2
                    read -p "Enter new ID: " id2
                    # sed izakora search muri file yacu then ihindure id igendeye kuyari isanzwemo
                    sed -i "s/$id1/$id2/g" students-list_1023.txt
                fi
                # Prompt to update email
                read -p "Do you want to change the email (Y/n)? :" choix_email
                if [[ $choix_email == "Y" ]]; then
                    read -p "Enter new email: " email2
                    # Validate new email
                    if [[ $email2 =~ $regex ]]; then
                        old_email=$(grep "$id2" students-list_1023.txt | cut -d "," -f 1)
                        sed -i "s/$old_email/$email2/g" students-list_1023.txt
                    else
                        echo "New email is invalid"
                        continue
                    fi
                fi

                # Prompt to update age
                read -p "Do you want to change the age (Y/n)? :" choix_age
                if [[ $choix_age == "Y" ]]; then
                    read -p "Enter new age: " age2
                    # Validate new age
                    if [[ $age2 =~ ^[1-9][0-9]*$ ]]; then
                        old_age=$(grep "$id2" students-list_1023.txt | cut -d "," -f 2)
                        sed -i "s/,$old_age,/$age2,/g" students-list_1023.txt
                    else
                        echo "New age is invalid"
                        continue
                    fi
                fi

                # Kongera counter kugira ngo tubashe kumenya inshuro user yakoresheje system
                ((counter++))
                ;;
            
            4 ) 
                # ======================================DELETE=====================================
                # Asking the user to enter the ID for searching
                read -p "Enter ID: " id1
                # tuzabanze to outputinge ibiri muri file students-list_1023.txt
                # output tuyihe grep
                # grep -v izakora reverse search (search all lines not containing the pattern)
                # output yayo tuyibike muri temp.txt
                cat students-list_1023.txt | grep -v "$id1" > temp.txt
                # tuzahita dusiba the initial file version (students-list_1023.txt)
                rm students-list_1023.txt
                # tuzahite duhindurira izina temp.txt ibe the new students-list_1023.txt
                mv temp.txt students-list_1023.txt
                # Kongera counter kugira ngo tubashe kumenya inshuro user yakoresheje system
                ((counter++))
                ;;
            
            5 )
                # ======================================SORT=====================================
                cat students-list_1023.txt | cut -d "," -f 1 | sort > student-emails.txt
                ;;
            
            6 )
                # =============================EXITING THE PROGRAM==============================
                # izabanza yandike exiting...
                echo "Exiting..."
                #ivanemo exit value ya 0 to mean exit value itahuye na error
                exit 0
                ;;
        esac
    else
        # niba user yanditse choice y'icyo ashaka gukora muri system yacu itari muri range ya 1-6
        # tuzamubwira ko yanditse choice idahari
        echo "Invalid choice"
    fi
done

#!/bin/bash

while true; do 
    echo "Menu"
    echo "1. Nano"
    echo "2. vi"
    echo "3. links"
    echo "4. Exit"
    read -p "Select " choice

    case $choice in 
        1)
            nano
            ;;
        2)
            vi
            ;;
        3)
            links
            ;;
        4)
            echo "exiting"
            exit 0
            ;;
        *) 
            echo "Incorrect choice"
            ;;
    esac
done
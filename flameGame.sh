#!/bin/bash

# Adventure Quest - RPG Game with Stats, Items, and Levels

echo "Welcome to Adventure Quest!"

player_health=10
player_attack=1
player_defense=0
player_experience=0
player_level=1

function display_stats() {
    echo -e "\e[1;34mYour Stats - Level: $player_level, Health: $player_health, Attack: $player_attack, Defense: $player_defense, Experience: $player_experience\e[0m"
}

function level_up() {
    echo "Congratulations! You leveled up!"
    ((player_level++))
    ((player_health += 5))
    ((player_attack += 2))
    ((player_defense++))
    display_stats
}

function explore() {
    echo "You venture deeper into the forest..."
    random_event=$((RANDOM % 3))
    case $random_event in
        0)
            echo "You discover a hidden treasure! You gain a Sword (+1 Attack)."
            ((player_attack++))
            ;;
        1)
            echo "You encounter a friendly creature. It gives you a Shield (+1 Defense)."
            ((player_defense++))
            ;;
        2)
            echo "Uh-oh! You stumbled upon a trap and lose 2 health."
            ((player_health -= 2))
            ;;
    esac

    ((player_experience += 2))
    display_stats
}

function battle() {
    creatures=("Goblin" "Skeleton" "Spider" "Wolf")
    enemy_name=${creatures[RANDOM % ${#creatures[@]}]}
    enemy_health=$((10 + player_level * 2))

    echo "You bravely confront a $enemy_name!"

    while ((enemy_health > 0)); do
        echo "Player Health: $player_health"
        echo "Enemy Health: $enemy_health"
        echo "Options: (1) Attack, (2) Defend, (3) Run"
        read -r battle_choice

        case $battle_choice in
            1)
                player_damage=$((RANDOM % (player_attack + 1)))
                enemy_damage=$((RANDOM % (2 + player_level) + 1))
                actual_enemy_damage=$((enemy_damage - player_defense))
                ((enemy_health -= player_damage))
                ((player_health -= actual_enemy_damage))

                echo "You attack, dealing $player_damage damage."
                echo "$enemy_name attacks, dealing $actual_enemy_damage damage after armor."

                if ((enemy_health <= 0)); then
                    echo "Congratulations! You defeated the $enemy_name."
                    ((player_experience += 5))
                    display_stats
                    break
                fi
                ;;
            2)
                echo "You defend, blocking incoming damage."
                ;;
            3)
                echo "You run away from the $enemy_name. Coward!"
                break
                ;;
            *)
                echo "Invalid choice. Please enter a number between 1 and 3."
                ;;
        esac

        if ((player_health <= 0)); then
            echo "Game over! You were defeated by the $enemy_name."
            exit 0
        fi
    done
}

while true; do
    display_stats

    echo "What do you want to do?"
    echo "1) Explore deeper into the forest"
    echo "2) Rest and recover"
    echo "3) Confront a creature"
    echo "4) Quit"

    read -r choice

    case $choice in
        1)
            explore
            ;;
        2)
            echo "You decide to rest and recover..."
            echo "You regain 3 health."
            ((player_health += 3))
            ;;
        3)
            battle
            ;;
        4)
            echo "Quitting the game. Final stats - Level: $player_level, Health: $player_health, Attack: $player_attack, Defense: $player_defense, Experience: $player_experience"
            exit 0
            ;;
        *)
            echo "Invalid choice. Please enter a number between 1 and 4."
            ;;
    esac

    if ((player_experience >= player_level * 10)); then
        level_up
    fi

done

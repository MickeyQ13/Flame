#!/bin/bash

# Adventure Quest - RPG Game with Stats, Items, and Levels

echo "Welcome to Adventure Quest!"

player_health=10
player_attack=1
player_defense=0
player_experience=0
player_level=1
turn=0

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
    random_event=$((RANDOM % 4))
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
        3)
            nERD
            ;;
    esac

    ((player_experience += 2))
    display_stats
}

function battle() {
    creatures=("Goblin" "Skeleton" "Spider" "Wolf")
    enemy_name=${creatures[RANDOM % ${#creatures[@]} ] }
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

function nERD() {
    echo "You encounter a wild Grant!"
    echo "    (._.)    "
    echo "    /) )\    "
    echo "_____/ \_____"
    echo "Being the troll that he is, he demands you pay the toll before moving on. What do you give him?"
    echo "1) A funny t-shirt"
    echo "2) A wad of sticky notes"
    echo "3) A John"

    read -r choice

    case $choice in
        1)
            echo "You hand him the shirt, which he takes excitedly. "
            echo "However, his excitement quickly turns to disappointment, as he already owns this particular funny t-shirt."
            echo "He runs you over with a Kei truck."

            echo "      _____                      "
            echo "     /     \                     "
            echo "  __/ (._.) |_______   <<<<      "
            echo " |   ___         ___|    <<<<    "   
            echo " ---|   |-------|   |  <<<<      "   
            echo "_____---_________---___________  "

            echo "Game over! You were defeated by the Grant."
            echo -n "Final stats: "
            display_stats
            exit 0
            ;;
        2)
            echo "You chuck the wad of sticky notes at him."
            echo "He holds it for a few seconds with a puzzled look on his face."
            echo "Unsure whether to pity you or fear you, he decides to let you pass out of sheer confusion. Well done! (+10 Experience)"

            echo "     ('~')    "
            echo "     \) )->   "
            echo " _____/ \_____"
            ((player_experience += 10))
            ;;
        3)
            echo "You present the Grant with the John. Both are overjoyed!"
            echo "However, as they run into eachothers arms and start jumping for joy..."
            echo "They acidentally jump too high and land on top of you, killing you instantly."

            echo "            !!!!          "
            echo "       ( .3.)/\(._. )     "
            echo "        /) )    ( (\      "
            echo "        / /      \ \      "
            echo "                          "
            echo "           ('o')          "
            echo "           \) )/          "
            echo "____________/_\___________"

            echo "Game over! You were defeated by the Kangaroids."
            echo -n "Final stats: "
            display_stats
            exit 0
            ;;
    esac
}

while true; do
    display_stats
    ((turn++))

    echo "This is turn # $turn" > "$turn"
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

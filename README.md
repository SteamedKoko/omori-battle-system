
# Omori Battle System
Turn based battle system from Omori, made entirely with gdscript. It isn't fully featured as a few key mechanics are missing, 
but there is a core system in place that allows the rest of the features to be imlemented without much difficulty.

<p align="center">
<img width="640" alt="image" align="center" src="https://github.com/user-attachments/assets/a81892ac-abfe-455a-a305-b0140af53878" />
</p>
<p align="center">The game can be played on itch: https://steamedkoko.itch.io/kokomori</p>


## Flow of the battle
* **BattleManager** is the entry point and handles all of the battle data as well as the flow of turns and executing actions.
* **BattleCombatant** can be either **BattleEnemy** or **BattlePlayer**. It handles everything related to the combatant and acts as an orchestrator for everything 
related to the combatant like UI or combatant data (health, juice, etc).
* A list of **Command**  are cycled through which handle actions to be executed by the player or the enemy during the action phase of the fight


## Missing Features (Ordered from easiest to implement to hardest)
* Omori plot armor where omori survives once a battle with 1 hp on fatal blow
* Hit / Miss based on hit stat
* Stat buffs and debuffs
* Combo bar charges
* Toys
* Snacks
* Combo Attacks

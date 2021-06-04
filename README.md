# instsport

A trivia sports app made with Flutter.

https://docs.google.com/document/d/19o2-g4rQIK-bq8Wn9rgKJhgDCua6lXtmkzjm0m9dDBQ/edit

**App name:** Inst Sport

**Technical specifications:**
- **operating system (OS):** Android (Flutter)
- **screen orientation:** horizontal
- **number of screens:** 5
- **number of languages:** Russian, English
- **ux/ui link on figma:** 
https://www.figma.com/file/LeSvDLZlGe7WAJBXkAoOno/Inst-sport?node-id=0%3A1
- **sound link:** 
https://drive.google.com/drive/folders/1l527tFgXVLJrUEGy7chR89yGShtkDF3_?usp=sharing
- **package name:** com.instmatchgamesport

**Main Menu screen**:
On the screen, the scoreboard with the best scores is divided into 3 categories (gold, silver, bronze). Depending on the points obtained for the game sessions, the categories are shifted. For example, the scoreboard displays 123; 100; 50. If a player earns 110 points in the last game session, the order of points on the screen will be as follows: 123; 110; 100.
- The "Play" button (takes you to the "Gameplay" screen)
- Settings button (takes you to the Settings screen)

<img src="/docs/Main page.png" alt="Main page" height="150">


**“Settings" screen:**
In the sound section, the user changes the volume using a slider inside the scale. He holds his finger on the slider and moves it, thereby changing the volume of the app's sound effects (0 on the left, 100 on the right).
- Back button (returns back to the Main Menu screen)
- Sound setting (static window with the word "Sound", sound icon, volume bar with slider)
- Language setting (left/right button, when clicked changes the RUS / ENG inscription between the buttons), selecting a specific inscription changes the language of the application interface


**Gameplay screen:**
The player connects balls and matching paraphernalia to each other:
tennis ball - racket
football - football player's shoe
basketball - basketball hand
volleyball - volleyball's arm
baseball - bat
golf ball - club
To link cards, the player taps on the chosen card and draws a connecting yellow line away from it. To link to another card, he taps on the desired card and the line connects. If the line is connected correctly, it turns neon green, if incorrectly, it turns neon red.  
If correct, he is given 1 point and the playing field is refreshed. Always the player is given time - the initial time in the timer is 15 seconds. When a player receives 1 point, 5 seconds of timer time is also added. If the wrong choice is made, 5 seconds are taken away from the player. 
The difficulty of the game changes due to the number of cards and their movement on the playing field:
up to 5 points there are only 3 types of cards on the field, the cards are static
from 5 to 10 on the field 6 types of cards, cards are static
From 15 points and above, the cards begin to move around the board within the confines of the screen (every 5 points more the cards begin to move faster);
The game ends when the timer reaches 0.

<img src="/docs/Gameplay.png" alt="Gameplay" height="150">


**End of Game screen:**
- "Your Points" caption (displays the number of points earned in the currently completed game session)
- Reboot Button (starts the game session anew at 0 and takes you to the Gameplay Screen)
- Main Menu button (takes you to the Main Menu screen)

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

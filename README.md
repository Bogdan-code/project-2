# project 2

Casino Bank App

A simple command-line Ruby application that allows users to create accounts, log in, manage a virtual bank balance, and play various casino games or perform paid writing tasks to earn money.

Features

User Authentication: Secure signup and login with encoded passwords.

Bank Management: View and update your virtual cash balance.

Casino Games:

Coin Flip: 50/50 chance to double your bet.

Dice: Guess a number 1–6 to win 5x your bet.

Roulette: Play roulette via an external roulette.rb script.

Work: Practice typing predefined or random texts to earn $25 per correct entry.

Snake Game Integration: Launch an external game.rb script (Snake) to earn $5 per point scored.

Prerequisites

Ruby (version 2.5+ recommended)

A Unix-like environment (macOS, Linux)

Ensure game.rb and roulette.rb are present in the same directory.

Installation & Setup

Clone the repository

git clone https://github.com/yourusername/casino-bank-app.git
cd casino-bank-app

Install dependencies
No external gems required. Standard Ruby library used.

Prepare data files

Create an empty logins.txt in the project root:

touch logins.txt

Create a bank/ directory:

mkdir bank

Verify external scripts
Ensure that game.rb (Snake) and roulette.rb (Roulette) exist and are executable:

ls -l game.rb roulette.rb

Usage

Launch the main application:

ruby index.rb

Signup: Choose signup to create a new account with a unique username and password. Passwords are stored encoded in logins.txt.

Login: Choose login and enter your credentials.

Main Menu:

Work: Earn cash by typing a shown text correctly.

Bank: View your current balance.

Casino: Access games (coinflip, dice, roulette).

Game: Play Snake to earn cash based on your score.

Quit: Log out and return to the login/signup menu.

File Structure

├── bank/               # Stores user balance files (e.g., username.txt)
├── game.rb             # Snake game script
├── roulette.rb         # Roulette game script
├── logins.txt          # Stores encoded usernames and passwords
└── main.rb             # Entry point for the application

Encryption

Passwords are encoded using a custom character mapping defined by:

ALPHABET = "!?åäöabcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
ENCODING = ")/=#(MOhqm0PnycUZeLdK8YvDCgNfb7FJtiHT52BrxoAkas9RWlXpEujSGI64VzQ31w"

Use the encode method to translate plaintext passwords into their encoded forms before storage.

Contributing

Fork the repository.

Create a feature branch: git checkout -b feature/YourFeature.

Commit your changes: git commit -m "Add your feature".

Push to the branch: git push origin feature/YourFeature.

Open a pull request.

License

MIT License


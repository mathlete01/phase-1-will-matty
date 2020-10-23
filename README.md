# Senate Money Tracker

Senate Money Tracker is a lightweight, Ruby, CLI application that quickly connectes senators with the top ten industries that have proivded them the lagest campaign contributions over the previous election cycle. All data provided by https://www.opensecrets.org/, and https://www.propublica.org/

## Tutorial

## Installation

1. Clone this repo to a local director
2. Visit https://www.propublica.org/datastore/api/propublica-congress-api to request a ProPublica API key
3. Open the `bin/api.rb` file and insert your ProPublica API key as a _string_ for the value variable `pro_pub_key` near the top of the file
4. Visit https://www.opensecrets.org/api/admin/index.php?function=login to request an Open Secrets API key
5. Open the `bin/api.rb` file and insert your Open Secrets API key as a _string_ value of the variable `open_secrets_key`
6. Within the project directory run `bundle install` to get the required gems
7. In the top level of the prject directory run `ruby bin/seed_db.rb` to initially seed the database. Note: this only needs to be done before the first time the app is launched. It can be performed again in the future to ensure the data is the most up-to-date, but it is not necessary.

## Usage

Launch the app by navigating to the top level of the app and running

```bash
ruby bin/run.rb
```

After that you're off to the races. Make selections using the number next to the menu item or type `home` anywhere in the app to return to the main menu or `exit` to quit. For example:

```
Kyrsten Sinema's top 10 campain contributing industries are:
---------------------------------------------
1. Retired, $1,783,913
2. Lawyers/Law Firms, $1,481,712
3. Securities & Investment, $1,147,978
4. Women's Issues, $850,585
...
```

Typing 4 and pressing enter will bring up a list of all candidates that have Women's Issues as a top 10 campaing contributer.

## Roadmap

Future releases of this project will include connections from highly contributing industries to congressional bills relating to those industries as well as senators votes. This will allow users to navigate from a senators contributions from an industry to a list of bills related to that industry and how the senator voted on each bill. Some of the groundwork for this update is already wirrten in the form of unrun api requests located in the `bin/api.rb` file

## Authors and acknowledgment

This project was created by Matty Sallin (https://github.com/mathlete01) and Will Lytle (https://github.com/wlytle) with highly appreciated guidance and assitance from Lantz Warrick and Hal Dun.

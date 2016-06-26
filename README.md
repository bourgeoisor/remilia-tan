# Remilia-tan

Remilia-tan is one of the two bots currently governing the #wanikani channel on Rizon.

## Installation / Usage

To be able to launch, you should have [Node.js](https://nodejs.org/en/) and [npm](https://www.npmjs.com/) installed already.

Clone the repository:

    git clone https://github.com/finiks/remilia-tan.git

To launch the bot:

    bin/hubot
    
Remilia is set to launch on IRC. To lauch locally, `bin/hubot` needs to be modified to remove the `-a irc` flag.

# Environment Variables

The following variables should be set to have full functionality of the bot:
- HUBOT_IRC_SERVER
- HUBOT_IRC_ROOMS
- HUBOT_IRC_NICK
- HUBOT_GOOGLE_CSE_ID
- HUBOT_GOOGLE_CSE_KEY
- ANILIST_CLIENT_ID
- ANILIST_CLIENT_SECRET

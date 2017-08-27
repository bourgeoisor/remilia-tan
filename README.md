# Remilia-tan

Remilia-tan is one of the two bots currently governing the #wanikani channel on Rizon.

## Installation / Usage

To be able to launch, you should have [Node.js](https://nodejs.org/en/) and [npm](https://www.npmjs.com/) installed already.
[Docker](https://www.docker.com) is also necessary to be able to build and launch the container.

### With Docker (Recommended)

Clone the repository:

    git clone https://github.com/finiks/remilia-tan.git
    cd remilia-tan

To build the container:

    docker build . -t remilia

To launch the bot:

    docker run -it remilia shell

To launch the bot in production mode, you can drop the `shell` argument.
In that mode, Remilia is set to launch with the IRC adapter.

# Environment Variables

The following variables should be set to have full functionality of the bot. Note that they are not necessary to run the robot, though.
- HUBOT_GOOGLE_CSE_ID
- HUBOT_GOOGLE_CSE_KEY
- ANILIST_CLIENT_ID
- ANILIST_CLIENT_SECRET

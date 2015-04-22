[[https://raw.githubusercontent.com/hipchat/triatomic/master/logo.png | width = 200px]]

# Triatomic: HipChat Hubot for Heroku

Triatomic is a chat bot built on the [Hubot][hubot] framework, combined
with the [HipChat adapter][hubot-hipchat]. It was initially generated by
the [Yeoman][yeoman] [hubot generator][generator-hubot], and configured
to be deployed on [Heroku][heroku] to get you up and running as quick as possible.

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy?template=https://github.com/hipchat/triatomic)

This README is intended to help get you started, but you may need or want to dig
into additional documentation at the following locations. Out of the box
some fun and silly scripts are included, but this bot can can become a
powerful ally once augmented with a combination of community and custom
scripts.

[hubot-hipchat]: https://github.com/hipchat/hubot-hipchat
[hubot]: http://hubot.github.com
[heroku]: http://www.heroku.com
[yeoman]: http://yeoman.io
[generator-hubot]: https://github.com/github/generator-hubot

### Why "Triatomic"?

HipChat Hubot for Heroku is kind of a mouthful. Abbreviated, you get
HHH, which is the molecular abbreviation to triatomic hydrogen, which in
turn sounds cooler than "HHH". In the end, you can give your Triatomic bot
whatever public-facing name you want, since you'll be creating a unique HipChat
user account for it to use.

### Running Triatomic Locally

You can test your hubot by running the following, however some plugins will not
behave as expected unless the [environment variables](#configuration) they rely
upon have been set.

### Configuration

A few scripts (including some installed by default) require environment
variables to be set as a simple form of configuration.

Each script should have a commented header which contains a "Configuration"
section that explains which values it requires to be placed in which variable.
When you have lots of scripts installed this process can be quite labour
intensive. The following shell command can be used as a stop gap until an
easier way to do this has been implemented.

    grep -o 'hubot-[a-z0-9_-]\+' external-scripts.json | \
      xargs -n1 -i sh -c 'sed -n "/^# Configuration/,/^#$/ s/^/{} /p" \
          $(find node_modules/{}/ -name "*.coffee")' | \
        awk -F '#' '{ printf "%-25s %s\n", $1, $2 }'

How to set environment variables will be specific to your operating system.
Rather than recreate the various methods and best practices in achieving this,
it's suggested that you search for a dedicated guide focused on your OS.

### Scripting

An example script is included at `scripts/example.coffee`, so check it out to
get started, along with the [Scripting Guide](scripting-docs).

For many common tasks, there's a good chance someone has already one to do just
the thing.

[scripting-docs]: https://github.com/github/hubot/blob/master/docs/scripting.md

### external-scripts

There will inevitably be functionality that everyone will want. Instead of
writing it yourself, you can use existing plugins.

Hubot is able to load plugins from third-party `npm` packages. This is the
recommended way to add functionality to your hubot. You can get a list of
available hubot plugins on [npmjs.com](npmjs) or by using `npm search`:

    % npm search hubot-scripts panda
    NAME             DESCRIPTION                        AUTHOR DATE       VERSION KEYWORDS
    hubot-pandapanda a hubot script for panda responses =missu 2014-11-30 0.9.2   hubot hubot-scripts panda
    ...


To use a package, check the package's documentation, but in general it is:

1. Use `npm install --save` to add the package to `package.json` and install it
2. Add the package name to `external-scripts.json` as a double quoted string

You can review `external-scripts.json` to see what is included by default.

##### Advanced Usage

It is also possible to define `external-scripts.json` as an object to
explicitly specify which scripts from a package should be included. The example
below, for example, will only activate two of the six available scripts inside
the `hubot-fun` plugin, but all four of those in `hubot-auto-deploy`.

```json
{
  "hubot-fun": [
    "crazy",
    "thanks"
  ],
  "hubot-auto-deploy": "*"
}
```

**Be aware that not all plugins support this usage and will typically fallback
to including all scripts.**

[npmjs]: https://www.npmjs.com

### hubot-scripts

Before hubot plugin packages were adopted, most plugins were held in the
[hubot-scripts][hubot-scripts] package. Some of these plugins have yet to be
migrated to their own packages. They can still be used but the setup is a bit
different.

To enable scripts from the hubot-scripts package, add the script name with
extension as a double quoted string to the `hubot-scripts.json` file in this
repo.

[hubot-scripts]: https://github.com/github/hubot-scripts

##  Persistence

If you are going to use the `hubot-redis-brain` package (strongly suggested),
you will need to add the Redis to Go addon on Heroku which requires a verified
account or you can create an account at [Redis to Go][redistogo] and manually
set the `REDISTOGO_URL` variable.

    % heroku config:add REDISTOGO_URL="..."

If you don't need any persistence feel free to remove the `hubot-redis-brain`
from `external-scripts.json` and you don't need to worry about redis at all.

[redistogo]: https://redistogo.com/

## Deployment

### The Easy Way

The easy way to get Triatomic running on Heroku is to to click this big purple
button and fill out the required fields!

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy?template=https://github.com/hipchat/triatomic)

### The Slightly Harder Way

    % heroku create --stack cedar
    % git push heroku master

    If you run into any problems, checkout Heroku's [docs][heroku-node-docs].

If your Heroku account has been verified you can run the following to enable
and add the Redis to Go addon to your app.

    % heroku addons:add redistogo:nano

Next you will need to set some environment variables for your bot to know how
to connect to HipChat.  At a minimum, you will need to create a new user for
your bot and then set the following:

    % heroku config:set HUBOT_HIPCHAT_JID=123_456@chat.hipchat.com
    % heroku config:set HUBOT_HIPCHAT_PASSWORD=yourbotpassword

Obviously, replace the example values with your own.  See the
[HuBot HipChat documentation][hubot-hipchat] for more information on the
available environment variables you can use.

More detailed documentation can be found on the [deploying hubot onto
Heroku][deploy-heroku] wiki page.

### Deploying to UNIX or Windows

If you would like to deploy to either a UNIX operating system or Windows.
Please check out the [deploying hubot onto UNIX][deploy-unix] and [deploying
hubot onto Windows][deploy-windows] wiki pages.

[heroku-node-docs]: http://devcenter.heroku.com/articles/node-js
[deploy-heroku]: https://github.com/github/hubot/blob/master/docs/deploying/heroku.md
[deploy-unix]: https://github.com/github/hubot/blob/master/docs/deploying/unix.md
[deploy-windows]: https://github.com/github/hubot/blob/master/docs/deploying/unix.md

## Restart the bot

You may want to get comfortable with `heroku logs` and `heroku restart` if
you're having issues.

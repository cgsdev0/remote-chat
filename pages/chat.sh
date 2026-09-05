if [[ "$REQUEST_METHOD" != "POST" ]]; then
  # only allow POST to this endpoint
  return $(status_code 405)
fi

if [[ "${HTTP_HEADERS[token]}" != "$SHARED_SECRET" ]]; then
  return $(status_code 401)
fi

refresh badcop_
source twitch_secrets badcop_

CHAN=just__jane
MESSAGE="hello world"

auth() {
    printf "%s\r\n" \
        "CAP REQ :twitch.tv/membership twitch.tv/tags twitch.tv/commands" \
        "PASS oauth:${TWITCH_ACCESS_TOKEN}" \
        "NICK ${TWITCH_NICK}" \
        "JOIN #${CHAN}" \
        "PRIVMSG #${CHAN} :$MESSAGE"
}

auth | websocat -E wss://irc-ws.chat.twitch.tv

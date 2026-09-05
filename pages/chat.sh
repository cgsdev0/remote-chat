if [[ "$REQUEST_METHOD" != "POST" ]]; then
  # only allow POST to this endpoint
  return $(status_code 405)
fi

if [[ "${HTTP_HEADERS[token]}" != "$SHARED_SECRET" ]]; then
  return $(status_code 401)
fi

WHO="${QUERY_PARAMS[user_id]//[^0-9]}"

source refresh badcop_
source twitch_secrets badcop_

AT_STRING=
if [[ -n "$WHO" ]]; then
  USER_DATA=$(curl "https://api.twitch.tv/helix/users?id=${WHO}" \
    -H "Authorization: Bearer ${TWITCH_ACCESS_TOKEN}")
  AT_STRING="@$(echo "$USER_DATA" | jq -r '.display_name') "
fi

CHAN=just__jane
MESSAGE="${AT_STRING}hey! you! yeah you! you need a license for that!!! (see redeems)"

auth() {
    printf "%s\r\n" \
        "CAP REQ :twitch.tv/membership twitch.tv/tags twitch.tv/commands" \
        "PASS oauth:${TWITCH_ACCESS_TOKEN}" \
        "NICK ${TWITCH_NICK}" \
        "JOIN #${CHAN}" \
        "PRIVMSG #${CHAN} :$MESSAGE"
}

auth | websocat -E wss://irc-ws.chat.twitch.tv

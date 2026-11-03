#!/bin/bash

source ../config/config.env

city="Wroclaw"
startDateTime=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

if [[ "$OSTYPE" == "darwin"* ]]; then 
    endDateTime=$(date -u -v+7d +"%Y-%m-%dT%H:%M:%SZ") #macOS
else
    endDateTime=$(date -u -d "+7 days" +"%Y-%m-%dT%H:%M:%SZ") #Linux
fi

echo "City: $city"
echo "From $startDateTime to $endDateTime"

url="https://app.ticketmaster.com/discovery/v2/events.json?city=$city&startDateTime=$startDateTime&endDateTime=$endDateTime&apikey=$TICKETMASTER_API_KEY"

response=$(curl -s "$url")

data=$(echo "$response" | jq -r '
    ._embedded.events[] | 
    [
        .name,
        .dates.start.localDate,
        ._embedded.venues[0].name,
        ""
    ] | join("\n")'
)

message="test"

curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
    -d "chat_id=${TELEGRAM_CHAT_ID}" \
    -d "text=${data}" \
    -d "parse_mode=Markdown"
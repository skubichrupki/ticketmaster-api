#!/bin/bash

source config/config.env

city="Wroclaw"
startDateTime=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
endDateTime=$(date -u -d "+7 days" +"%Y-%m-%dT%H:%M:%SZ")
echo "City: $city"
echo "From $startDateTime to $endDateTime"

url="https://app.ticketmaster.com/discovery/v2/events.json?city=$city&startDateTime=$startDateTime&endDateTime=$endDateTime&apikey=$TICKETMASTER_API_KEY"

response=$(curl -s "$url")

echo "$response" | jq -r '
._embedded.events[] | 
[   
    .name,
    .dates.start.localDate,
    ._embedded.venues[0].name
] | 
@tsv'
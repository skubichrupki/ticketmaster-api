#!/bin/bash

source config/config.env

response=$(curl -s "https://app.ticketmaster.com/discovery/v2/events.json?city=Wroclaw&classificationName=music&apikey=$TICKETMASTER_API_KEY")

echo "$response" | jq -r '._embedded.events[] | [.name, .dates.start.localDate, ._embedded.venues[0].name] | @tsv'
# ELM_MASTER_BIN=~/elm/Elm-Platform/master/bin/

all:	compile
	@true

start:
	heroku docker:start

release:
	heroku docker:release

## Non-Docker tasks
compile:
	PATH=${ELM_MASTER_BIN}:${PATH} elm make src/Chronicle/Main.elm --output=build/static/elm.js
	cp index.html build/static/index.html
	cp style.css build/static/style.css

run:	compile
	cd build/static && \
		SPAS_USERNAME=user \
		SPAS_PASSWORD=password \
		SPAS_V1SCHEMA=1 \
		PORT=3000 \
		DATABASE_URL=${DATABASE_URL} ../../../spas/dist/build/spas/spas

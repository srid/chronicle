all:	compile
	@true

start:
	heroku docker:start

release:
	heroku docker:release

## Non-Docker tasks
compile:
	elm make src/Elm/Main.elm --output=build/static/elm.js
	cp src/Html/index.html build/static/index.html

run:	compile
	cd build && ../../postgrest/dist/build/postgrest/postgrest -p 3000 -D ${DATABASE_URL}

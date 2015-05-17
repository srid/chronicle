all:	compile
	@true

start:
	heroku docker:start

release:
	heroku docker:release

## Non-Docker tasks
compile:
	elm make src/Chronicle/Main.elm --output=build/static/elm.js
	cp index.html build/static/index.html
	cp style.css build/static/style.css

run:	compile
	cd build && ../../postgrest/dist/build/postgrest/postgrest -p 3000 -D ${DATABASE_URL}

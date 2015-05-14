all:	compile
	@true
	
start:
	heroku docker:start

release:
	heroku docker:release

## Non-Docker tasks
compile:
	elm make src/Main.elm --output=build/index.html

run:	compile
	cd build && ../../postgrest/dist/build/postgrest/postgrest -p 3000 -D ${DATABASE_URL}

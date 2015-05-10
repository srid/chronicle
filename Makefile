all:
	heroku docker:start

release:
	heroku docker:release

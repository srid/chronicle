FROM heroku/cedar:14

ENV CABAL_INSTALL cabal install --disable-documentation -j
ENV PATH /root/.cabal/bin:$PATH

# Install Haskell and Cabal
RUN apt-get update && \
    apt-get -y install haskell-platform wget libncurses5-dev && \
    apt-get clean
RUN cabal update && ${CABAL_INSTALL} cabal-install

# Install postgrest
# Using my fork basic auth, --db-uri and static file serving support.
ENV POSTGREST_REPO "https://github.com/srid/postgrest.git -b heroku "
RUN git clone ${POSTGREST_REPO} /tmp/postgres
RUN cd /tmp/postgres && ${CABAL_INSTALL}
RUN mkdir -p /app/bin
RUN cp /root/.cabal/bin/* /app/bin/

# Elm 0.15, per http://elm-lang.org/Install.elm
# Modify this instruction for newer releases.
ENV ELM_VERSION 0.15
RUN mkdir /tmp/elm \
  && cd /tmp/elm \
  && cabal sandbox init \
  && ${CABAL_INSTALL} elm-compiler-0.15 elm-package-0.5 elm-make-0.1.2 \
  && ${CABAL_INSTALL} elm-repl-0.4.1 elm-reactor-0.3.1 \
  && cp .cabal-sandbox/bin/* /app/bin/
ENV PATH /app/bin:$PATH

# Startup scripts for heroku
RUN mkdir -p /app/.profile.d /app/bin
RUN echo "export PATH=\"/app/bin:\$PATH\"" > /app/.profile.d/appbin.sh
RUN echo "cd /app" >> /app/.profile.d/appbin.sh

ENV PORT 3000
EXPOSE 3000

#
# ----------
#

# Install dependencies only if the spec files change:
ADD elm-package.json Makefile /app/src/
WORKDIR /app/src
RUN elm package install --yes


# TODO: Figure out a way to combine the above (postgrest) with elm reactor for fast development.
# Perhaps just volume mount and run elm-reactor here.

ONBUILD COPY . /app/src
ONBUILD RUN elm make src/Main.elm --output=build/index.html
# Install everything to /app
ONBUILD RUN cp -r build/* /app/
ONBUILD WORKDIR /app
ONBUILD RUN rm -rf /app/src

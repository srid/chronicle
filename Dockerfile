# This Dockerfile installs both Go and Elm that are required to compile our
# backend and frontend code. It then proceeds to build the local sources via the
# ONBUILD instruction.

FROM heroku/cedar:14

# Install Haskell and Cabal
RUN apt-get update && \
    apt-get -y install haskell-platform wget libncurses5-dev && \
    apt-get clean
RUN cabal update && cabal install cabal-install

# Elm 0.15, per http://elm-lang.org/Install.elm
# Modify this instruction for newer releases.
ENV ELM_VERSION 0.15
ENV CABAL_INSTALL cabal install --disable-documentation -j
RUN ${CABAL_INSTALL} elm-compiler-0.15 elm-package-0.5 elm-make-0.1.2 && \
    ${CABAL_INSTALL} elm-repl-0.4.1 elm-reactor-0.3.1
# Static file server
RUN ${CABAL_INSTALL} wai-app-static
ENV PATH /root/.cabal/bin:$PATH

# Startup scripts for heroku
RUN mkdir -p /app/.profile.d
RUN echo "export PATH=\"/app/bin:\$PATH\"" > /app/.profile.d/appbin.sh
RUN echo "cd /app" >> /app/.profile.d/appbin.sh

ENV PORT 3000
EXPOSE 3000

#
# ----------
#

# Install dependencis only if the spec files change:
ADD elm-package.json Makefile /app/src/
WORKDIR /app/src
RUN elm package install --yes


ONBUILD COPY . /app/src
ONBUILD RUN elm make src/Main.elm --output=build/index.html
# Install everything to /app
ONBUILD RUN cp -r build/* /app/
ONBUILD WORKDIR /app
ONBUILD RUN rm -rf /app/src

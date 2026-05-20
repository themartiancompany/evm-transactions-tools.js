# SPDX-License-Identifier: AGPL-3.0

#    -----------------------------------------------------
#    Copyright © 2024, 2025, 2026  Pellegrino Prevete
#
#    All rights reserved
#    -----------------------------------------------------
#
#    This program is free software: you can redistribute
#    it and/or modify it under the terms of the
#    GNU Affero General Public License as published by
#    the Free Software Foundation, either version 3 of
#    the License, or (at your option) any later version.
#
#    This program is distributed in the hope that it
#    will be useful, but WITHOUT ANY WARRANTY;
#    without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#    See the GNU Affero General Public License for
#    more details.
#
#    You should have received a copy of the
#    GNU Affero General Public License
#    along with this program.
#    If not, see <https://www.gnu.org/licenses/>.

SHELL=bash
PREFIX ?= /usr/local
_PROJECT_NPM=evm-transactions-tools
_PROJECT=$(_PROJECT_NPM).js
_NAMESPACE=themartiancompany
DOC_DIR=$(DESTDIR)$(PREFIX)/share/doc/$(_PROJECT_NPM)
USR_DIR=$(DESTDIR)$(PREFIX)
BIN_DIR=$(DESTDIR)$(PREFIX)/bin
LIB_DIR=$(DESTDIR)$(PREFIX)/lib/$(_PROJECT_NPM)
MAN_DIR?=$(DESTDIR)$(PREFIX)/share/man
NODE_DIR=$(PREFIX)/lib/node_modules/$(_PROJECT_NPM)
BUILD_NPM_DIR=build

_INSTALL_FILE=\
  install \
    -vDm644
_INSTALL_EXE=\
  install \
    -vDm755
_INSTALL_DIR=\
  install \
    -vdm755

DOC_FILES=\
  $(wildcard \
      *.rst) \
  $(wildcard \
      *.md)
NPM_FILES=\
  "README.md" \
  "COPYING" \
  "AUTHORS.rst" \
  "dist" \
  "lib" \
  "eslint.config.mjs" \
  "$(_PROJECT_NPM)" \
  "fs-worker.webpack.config.cjs" \
  "package.json" \
  "webpack.config.cjs"

MAN_FILES=\
  evm-transaction-get

all: build-man build-npm build-scripts

check: eslint

eslint:

	npm \
	  install \
	  --save-dev; \
	npx \
	  eslint \
	    "."

install: install-scripts install-doc install-examples install-man

install-scripts:

	$(_INSTALL_DIR) \
	  "$(LIB_DIR)/nodejs/lib"
	for _file in $(NPM_FILES); do
	  $(_INSTALL_FILE) \
	    "$${_file}" \
	    "$(LIB_DIR)/nodejs/$${_file}"; \
	  ln \
	    -s \
            "$(PREFIX)/lib/$(_PROJECT_NPM)/nodejs/$${_file}" \
	    "$(LIB_DIR)/$${_file}" || \
	  true; \
	done
	# ln \
	#   -s \
	#   "$(PREFIX)/lib/$(_PROJECT_NPM)/node/lib$(_PROJECT_NPM)" \
	#   "$(LIB_DIR)/$(_PROJECT_NPM)-js" || \
	# true

build-man:

	git \
	  submodule \
	    update \
	    --init \
	      "man" || \
	true
	mkdir \
	  -p \
	  "build/man"
	cp \
	  "man/variables.rst" \
	  "build/man"; \
	_tag="$$( \
	  git \
	    tag | \
	    sort \
	      -V | \
              head \
	        -n \
	          1)"; \
	cat \
	  "man/evm-transaction-get.1.rst" | \
	  sed \
	    "s/evm-transaction-get/evm-transaction-get.js/g" > \
	    "build/man/evm-transaction-get.js.1.rst"; \
	for _file in $(MAN_FILES); do \
	  cp \
	    "man/$${_file}.1.rst" \
	    "build/man/$${_file}.1.rst"; \
	  rst2man \
	    "build/man/$${_file}.1.rst" \
	    "build/man/$${_file}.1"; \
	  rm \
	    "build/man/$${_file}.1.rst"; \
        done
	rm \
	  "build/man/variables.rst"

build-npm:

	make \
	  build-man
	for _file in $(NPM_FILES); do \
	  if [[ -d "$${_file}" ]]; then \
	    mkdir \
	      -p \
	      "build/$${_file}"; \
	    cp \
	      -r \
	      "$${_file}"/* \
	      "build/$${_file}/"; \
	  elif [[ -e "$${_file}" ]]; then \
	    cp \
	      -r \
	      "$${_file}" \
	      "build/$${_file}"; \
	  fi; \
	done; \
	cd \
	  "build"; \
	_version="$$( \
	  npm \
	    view \
	      "$${PWD}" \
	      "version")"; \
	npm \
	  install; \
	npm \
	  run \
	    "build"; \
	npm \
	  pack; \
	mv \
	  "$(_PROJECT_NPM)-$${_version}.tgz" \
	  ".."

install-npm:

	_npm_opts=( \
	  -g \
	  --prefix \
	    '$(USR_DIR)' \
	); \
	_version="$$( \
	  npm \
	    view \
	      "$${PWD}" \
	      "version")"; \
	npm \
	  install \
	    "$${_npm_opts[@]}" \
	    "$(_PROJECT_NPM)-$${_version}.tgz"; \
	$(_INSTALL_DIR) \
	  "$(DESTDIR)$(PREFIX)/lib"; \
	ln \
	  -s \
	  "$(NODE_DIR)" \
	  "$(LIB_DIR)" || \
	true

publish-npm:

	cd \
	  "build"; \
	npm \
	  publish \
	  --access \
	    "public"

install-doc:

	$(_INSTALL_FILE) \
	  $(DOC_FILES) \
	  -t \
	  $(DOC_DIR)

install-man:

	$(_INSTALL_DIR) \
	  "$(MAN_DIR)/man1"
	$(_INSTALL_FILE) \
	  "build/man/$(_PROJECT_NPM).1" \
	  "$(MAN_DIR)/man1/$(_PROJECT_NPM).1"

.PHONY: check build-man build-npm build-scripts install install-doc install-man install-npm install-scripts shellcheck

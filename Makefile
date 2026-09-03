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
NODE_DIR=$(DESTDIR)$(PREFIX)/lib/node_modules/$(_PROJECT_NPM)
BUILD_NPM_DIR=build

_MAKE_LINK=\
  ln \
    -sv
_MAKE_EXE=\
  chmod \
    755
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
_PROGRAMS=\
  "transaction-get" \
  "transaction-receipt-get"
_ALIASES=\
  "receipt" \
  "receipt-get" \
  "receipt-info" \
  "transaction" \
  "transaction-get" \
  "transaction-info" \
  "transaction-receipt" \
  "transaction-receipt-get" \
  "transaction-receipt-info" \
  "tx" \
  "tx-info"
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

	if [[ "$(_NPM)" == "false" ]]; then \
	  $(_INSTALL_DIR) \
	    "$(LIB_DIR)/nodejs"; \
	  cp \
	    -r \
	    $$(printf \
	         "$${PWD}/%s " \
	         $$(cat \
	              "$${PWD}/package.json" | \
	              jq \
	                --raw-output \
	                '.files[]')) \
	    "$(LIB_DIR)/nodejs"; \
	  $(_MAKE_EXE) \
	    "$(LIB_DIR)/nodejs/$(_PROJECT_NPM)"; \
	  if [[ ! -s "$(BIN_DIR)/receipt" && \
	        ! -e "$(BIN_DIR)/receipt" ]]; then \
	    $(_MAKE_LINK) \
	      "$(PREFIX)/lib/$(_PROJECT)/nodejs/transaction-receipt-get" \
	      "$(BIN_DIR)/receipt"; \
	  fi; \
	  if [[ ! -s "$(BIN_DIR)/receipt-info" && \
	        ! -e "$(BIN_DIR)/receipt-info" ]]; then \
	    $(_MAKE_LINK) \
	      "$(PREFIX)/lib/$(_PROJECT)/nodejs/transaction-receipt-get" \
	      "$(BIN_DIR)/receipt-info"; \
	  fi; \
	  if [[ ! -s "$(BIN_DIR)/transaction" && \
	        ! -e "$(BIN_DIR)/transaction" ]]; then \
	    $(_MAKE_LINK) \
	      "$(PREFIX)/lib/$(_PROJECT)/nodejs/transaction-get" \
	      "$(BIN_DIR)/transaction"; \
	  fi; \
	  if [[ ! -s "$(BIN_DIR)/transaction-info" && \
	        ! -e "$(BIN_DIR)/transaction-info" ]]; then \
	    $(_MAKE_LINK) \
	      "$(PREFIX)/lib/$(_PROJECT)/nodejs/transaction-get" \
	      "$(BIN_DIR)/transaction-info"; \
	  fi; \
	  if [[ ! -s "$(BIN_DIR)/transaction-receipt" && \
	        ! -e "$(BIN_DIR)/transaction-receipt" ]]; then \
	    $(_MAKE_LINK) \
	      "$(PREFIX)/lib/$(_PROJECT)/nodejs/transaction-receipt-get" \
	      "$(BIN_DIR)/transaction-receipt"; \
	  fi; \
	  if [[ ! -s "$(BIN_DIR)/transaction-receipt-info" && \
	        ! -e "$(BIN_DIR)/transaction-receipt-info" ]]; then \
	    $(_MAKE_LINK) \
	      "$(PREFIX)/lib/$(_PROJECT)/nodejs/transaction-receipt-get" \
	      "$(BIN_DIR)/transaction-receipt-info"; \
	  fi; \
	  if [[ ! -s "$(BIN_DIR)/tx" && \
	        ! -e "$(BIN_DIR)/tx" ]]; then \
	    $(_MAKE_LINK) \
	      "$(PREFIX)/lib/$(_PROJECT)/nodejs/transaction-get" \
	      "$(BIN_DIR)/tx"; \
	  fi; \
	  if [[ ! -s "$(BIN_DIR)/tx-info" && \
	        ! -e "$(BIN_DIR)/tx-info" ]]; then \
	    $(_MAKE_LINK) \
	      "$(PREFIX)/lib/$(_PROJECT)/nodejs/transaction-get" \
	      "$(BIN_DIR)/tx-info"; \
	  fi; \
	  for _program in \
	    $(_PROGRAMS); do \
	    if [[ ! -s "$(BIN_DIR)/$${_program}" && \
	          ! -e "$(BIN_DIR)/$${_program}" ]]; then \
	      $(_MAKE_LINK) \
	        "$(PREFIX)/lib/$(_PROJECT_NPM)/nodejs/$${_program}" \
	        "$(BIN_DIR)/$${_program}"; \
	    fi; \
	  done; \
	  rm \
	    "$(LIB_DIR)/node_modules" || \
	    true; \
	  if [[ ! -s "$(LIB_DIR)/node_modules" ]]; then \
	    $(_MAKE_LINK) \
	      "$(PREFIX)/lib/node_modules" \
	      "$(LIB_DIR)/nodejs/node_modules"; \
	  fi; \
	  rm \
	    -rf \
	    "$(DESTDIR)$(PREFIX)/lib/node_modules/$(_PROJECT)" \
	    "$(DESTDIR)$(PREFIX)/lib/node_modules/$(_PROJECT_NPM)"; \
	  if [[ ! -s "$(DESTDIR)$(PREFIX)/lib/node_modules/$(_PROJECT)" || \
	        ! -e "$(DESTDIR)$(PREFIX)/lib/node_modules/$(_PROJECT)" ]]; then \
	    $(_MAKE_LINK) \
	      "$(PREFIX)/lib/$(_PROJECT_NPM)/nodejs" \
	      "$(DESTDIR)$(PREFIX)/lib/node_modules/$(_PROJECT)"; \
	  fi; \
	  if [[ ! -s "$(DESTDIR)$(PREFIX)/lib/node_modules/$(_PROJECT_NPM)" ]]; then \
	    $(_MAKE_LINK) \
	      "$(PREFIX)/lib/$(_PROJECT_NPM)/nodejs" \
	      "$(DESTDIR)$(PREFIX)/lib/node_modules/$(_PROJECT_NPM)" || \
	      true; \
	  fi; \
	  if [[ ! -s "$(DESTDIR)$(PREFIX)/lib/$(_PROJECT)" ]]; then \
	    $(_MAKE_LINK) \
	      "$(PREFIX)/lib/$(_PROJECT_NPM)/nodejs" \
	      "$(DESTDIR)$(PREFIX)/lib/$(_PROJECT)" || \
	      true; \
	  fi; \
	  if [[ ! -s "$(DESTDIR)$(PREFIX)/lib/$(_PROJECT_NPM)" ]]; then \
	    $(_MAKE_LINK) \
	      "$(PREFIX)/lib/$(_PROJECT_NPM)/nodejs" \
	      "$(DESTDIR)$(PREFIX)/lib/$(_PROJECT_NPM)" || \
	      true; \
	  fi; \
	elif [[ "$(_NPM)" == "true" ]]; then \
	  make \
	    install-npm; \
	  $(_MAKE_LINK) \
	    "$(PREFIX)/lib/node_modules/$(_PROJECT_NPM)" \
	    "$(LIB_DIR)/nodejs" || \
	  true; \
	fi;

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
	  "$(PREFIX)/lib/node_modules/$(_PROJECT_NPM)" \
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

uninstall-scripts:

	for _program in \
	  $(_PROGRAMS) \
	  $(_ALIASES); do \
	  rm \
	    "$(BIN_DIR)/$${_program}"; \
	done

.PHONY: check build-man build-npm build-scripts install install-doc install-man install-npm install-scripts shellcheck

#!/usr/bin/env bash

# # If not running interactively, don't do anything
# [[ $- != *i* ]] && return 0

[[ -f "/etc/profile" ]] && . "/etc/profile"
[[ -f "${HOME}/.bashrc" ]] && . "${HOME}/.bashrc"

mesg n 2> /dev/null || true

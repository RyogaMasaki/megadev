#!/bin/sh

expr $(stat --printf="%s\n" $1) / 32


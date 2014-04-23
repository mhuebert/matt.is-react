#!/bin/bash

coffee ./utils/firebase-compile-rules.coffee ./security-rules ./security-rules/_compiled.json


if [ "$?" -ne "0" ]; then
  echo "Rule compilation failed"
  exit 1
fi

echo "Rules compiled"

firebase deploy
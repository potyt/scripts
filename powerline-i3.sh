#! /usr/bin/env bash

python $(python -c "import sys; print([x for x in sys.path if x.endswith('site-packages')][0])")/powerline/bindings/i3/powerline-i3.py

t = t/
j = 1
o =

# `make test` usage:
#   make test
#   make test t=t/00.load.t
#   make test j=8
#   make test o=-v

test:
	prove -r $o -j$j --exec='perl6 -Ilib -I../yaml-libyaml-perl6' $t

testv:
	make test o=-v

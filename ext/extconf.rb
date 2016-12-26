#!/usr/bin/env ruby

#  ruby setup.rb all -- --with-swishe-dir=/opt/swishe/2.4.3
require 'mkmf'

# pkg_config("swish") (with no options) seems to assume that
# lib-only-1 is defined by the -config script, which wasn't
# the case for me.
cfl = pkg_config("swish", 'cflags')
ldfl = pkg_config("swish", 'libs')
# puts "cfl: #{cfl}"
# puts "ldfl: #{ldfl}"
$CFLAGS += " " <<  cfl
$LDFLAGS += " " <<  ldfl
# puts "dir config..."
dir_config "swishe"
if have_header("swish-e.h") and have_library('swish-e')
  # puts "creating makefile..."
  create_makefile('swishe_base')
else
  puts "error creating makefile"
  exit 1
end


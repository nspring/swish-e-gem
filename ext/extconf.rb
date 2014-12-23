#!/opt/ruby/1.8/bin/ruby

#  ruby setup.rb all -- --with-swishe-dir=/opt/swishe/2.4.3
require 'mkmf'

dir_config "swishe"
if have_header("swish-e.h") and have_library('swish-e')
  create_makefile('swishe_base')
else
  puts "error creating makefile"
  exit 1
end


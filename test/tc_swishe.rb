#!/usr/bin/env ruby

require 'minitest'
require "fileutils"

$:.unshift  File.join(File.dirname(__FILE__), "..", "lib")
$:.unshift  File.join(File.dirname(__FILE__), "..", "ext")

# --pg: ./extconf.rb --with-swishe-dir=/opt/swishe/2.4.3

require 'swishe'

DIR=File.expand_path(File.dirname(__FILE__))
IDX="#{DIR}/index.swish-e"

class TestSwishe < Minitest::Test
  def setup
    unless File.exists?(IDX)
      FileUtils::cd(DIR) do 
        cmd="swish-e -c testcase.swishe"
        puts "running `#{cmd}' for updating index"
        system cmd
      end
    end
    @sw=SwishE.new(IDX)
  end
  def test_single
    res = @sw.query("another")
    assert_equal(1,res.size)
  end
  def test_double
    res = @sw.query("testing")
    assert_equal(2,res.size)
  end
  def test_res_count
    rcary=@sw.query("this").collect do |result|
      result.reccount
    end
    assert_equal([1,2], rcary)
  end
  def test_offset
    rcary=@sw.query("this",2).collect do |result|
      result.reccount
    end
    assert_equal([2], rcary)
  end

  def test_limit
    rcary=@sw.query("this",1,1).collect do |result|
      result.reccount
    end
    assert_equal([1], rcary)
  end

  def test_limit_infinite
    rcary=@sw.query("this",1,-1).collect do |result|
      result.reccount
    end
    assert_equal([1,2], rcary)
  end

  def test_too_many
    # this used to raise an exception: "Too many open files (SwishE::IndexFileError)"
    1.upto(125) do
      x=SwishE.new(IDX) 
      x.close
    end
  end
  
  def test_search_no_options
    assert_raise(SwishE::SwishEError) do
      rcary=@sw.search(nil)
    end
  end
  
  def test_search
    rcary=@sw.search({"query" => "this"})
  end
  
  def test_search_order
    results = @sw.search({"query" => "This is","order" => "swishdocsize asc"}).collect do |r| r.docpath end
    assert_equal(results,["./idx/fileb.txt","./idx/filea.txt"])
  end

  def test_search_order_limit
    results = @sw.search({"query" => "This is","order" => "swishdocsize asc","limit" => 1}).collect do |r| r.docpath end
    assert_equal(results,["./idx/fileb.txt"])
    results = @sw.search({"query" => "This is","order" => "swishdocsize asc","limit" => 1,"start" => 2}).collect do |r| r.docpath end
    assert_equal(results,["./idx/filea.txt"])
  end

end

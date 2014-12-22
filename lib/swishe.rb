#--
# swig -ruby -o swishe_base.c swish-e.i
# ruby extconf.rb --with-swishe-dir=/opt/swishe/2.4.3
# make
#++
# Main file that defines the ruby part of the Swish-e bindings. Contains the
# module SwishEWrapper and the class SwishE.


require 'swishe_base'

# Simple wrapper module for the Swish-E C-API. The goal is to use this module
# just as the api that is defined in the file 'SWISH-LIBRARY.html' as shipped
# with Swish-e. We currently rely on swishe_base, that is a swig generated
# interface to Swish-e
module SwishEWrapper
  include Swishe_base
  alias swish_init SwishInit
  alias swish_close SwishClose
  alias swish_query SwishQuery
  alias swish_next_result SwishNextResult
  alias swish_seek_result SwishSeekResult
  alias swish_error SwishError
  alias swish_last_error_msg SwishLastErrorMsg
  alias swish_error_string SwishErrorString
  alias swish_result_property_str SwishResultPropertyStr
  alias swish_result_property_u_long SwishResultPropertyULong
  alias new_search_object New_Search_Object
  alias swish_execute SwishExecute
  alias swish_set_sort SwishSetSort
end


# High Level class for using the Swish-e file indexer. This api is subject to
# change. Currently there is only limited searching available. If you just
# need to access the plain C API, you should look at the SwishEWrapper module.
class SwishE
  include SwishEWrapper

  # General Swish-E error, unspecified
  class SwishEError < Exception ; end
  
  # Swish-E Error when there is something wrong with the Index file.
  class IndexFileError < SwishEError ; end
  
  # Class to access the fields in the result set.
  class Result
    attr_accessor :reccount
    include SwishEWrapper
    def initialize(result)
      @result=result
      # There seems to be a bug which I can't locate: reccount looks like a global variable. 
      # It defaults to the max count of the results. So I query this property before going to the
      # next record. This is perhaps just a workaround. See 
      # http://rubyforge.org/tracker/index.php?func=detail&aid=8630&group_id=2688&atid=10339
      @reccount=swish_result_property_u_long @result, "swishreccount"
    end
    # Dynamically return the result based on the name of method. For example,
    # calling Result#foo tries to get the property name 'foo' from swish-e.
    def method_missing(meth)
      swish_result_property_str(@result,meth.to_s) 
    end
    # Return the property "swishdocpath".
    def docpath
      swish_result_property_str(@result,"swishdocpath")
    end
    # Return the property "swishrank".
    def rank
      swish_result_property_u_long(@result, "swishrank")
    end
    # Return the property "swishdocsize".
    def docsize
      swish_result_property_u_long @result, "swishdocsize"
    end
    # Return the property "swishtitle".
    def title
      swish_result_property_str @result, "swishtitle"
    end
    # Return the property "swishdbfile".
    def dbfile
      swish_result_property_str @result, "swishdbfile" 
    end
    # Return the property "swishlastmodified".
    def lastmodified
      swish_result_property_str @result, "swishlastmodified" 
    end
    # Return the property "swishreccount".
    # def reccount
    #   swish_result_property_u_long @result, "swishreccount" 
    # end
    # Return the property "swishfilenum".
    def filenum
      swish_result_property_u_long  @result, "swishfilenum" 
    end
  end
  
  # Create a new instance of the Swish-e wrapper. Run query(<tt>string</tt>)
  # to obtain the search results. Don't forget to close the session, or you
  # will lose file handles and enventually run into an error 'too many open
  # files'. You can use the block form that closes the session for you.
  # _indexfiles_ is an array of paths to index files or a string where the 
  # index files are separated by spaces.
  def initialize(indexfiles)
    indexfiles = [indexfiles] if String===indexfiles 
    set_index(indexfiles.join(" "))
    if block_given?
      yield self
      close
    end
  end

  # Does all necessary cleaning. Don't forget to call this (or use the block
  # form of 'new') when done.
  def close
    swish_close(@handle)
  end
  
  # search is a replacement for the method _query_, which allows you to set parameters in a hash.
  # Keys or the parameter hash are _query_, _start_, _limit_ and _order_. _query_ is the string you 
  # are looking for, _start_ and _limit_ are the same as the command line parameters <tt>-b</tt> and <tt>-m</tt>
  # and _order_ is the equivalent as the command line parameter <tt>-s</tt>. Example for the order are <tt>swishdocsize asc</tt>
  # and <tt>swishrank desc</tt>. You see that you need to put the word "swish" in front of the properties.
  def search(options)
    raise(SwishEError, "No options given.") unless options
    q = options["query"]
    raise(SwishEError, "No query string given.") unless q
    searchobject = new_search_object(@handle, q);
    if options["order"]
      swish_set_sort( searchobject,options["order"])
    end
    res = swish_execute(searchobject,q);
    return query_internal(res,options["start"] || 1, options["limit"] || -1)
  end
  # Return an Array of Result instances. Raises SwischEError or IndexFileError in case
  # of an error. _start_ is the result offset from the beginning (starting at 1, which is the default).
  # _limit_ is the number of results returned, -1 indicates all results.
  def query(string,start = 1,limit = -1, sort = nil )
    # SW_SEARCH New_Search_Object(SW_HANDLE handle, const char *query);
    # void SwishSetSort( SW_SEARCH srch, char *sort );
    # void SwishSetQuery( SW_SEARCH srch, char *query );
    res=swish_query(@handle,string)
    check_error
    return query_internal(res,start,limit)
  end

  private

  def query_internal(res,start,count)
    results=[]
    if start != 1
      swish_seek_result(res,start - 1) # offset is 0
    end
    c = 0
    while result=swish_next_result(res)
      results << Result.new(result)
      c = c + 1
      if count == c then break end
    end
    return results
  end

  def set_index(indexfile)
    @handle=swish_init indexfile
    check_error
  end
  def check_error
    return if swish_error(@handle) == 0

    # we have an error
    last_msg=swish_last_error_msg(@handle)
    case swish_error_string(@handle)
    when 'Index file error'
      raise IndexFileError, last_msg
    else
      raise SwishEError, last_msg
    end
  end
end

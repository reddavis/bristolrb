require File.dirname(__FILE__) + '/../test_helper'
class BaseTest < Test::Unit::TestCase
	def setup
		@rss09 = SimpleRSS.parse open(File.dirname(__FILE__) + '/../data/rss09.rdf'), true
		@rss20 = SimpleRSS.parse open(File.dirname(__FILE__) + '/../data/rss20.xml'), false
		@atom = SimpleRSS.parse open(File.dirname(__FILE__) + '/../data/atom.xml')
	end
	
	def test_channel
		assert_equal @rss09, @rss09.channel
		assert_equal @rss20, @rss20.channel
		assert_equal @atom, @atom.feed
	end
	
	def test_items
		assert_kind_of Array, @rss09.items
		assert_kind_of Array, @rss20.items
		assert_kind_of Array, @atom.entries
	end
	
	def test_rss09
		assert_equal 10, @rss09.items.size
		assert_equal "Slashdot", @rss09.title
		assert_equal "http://slashdot.org/", @rss09.channel.link
		assert_equal "http://books.slashdot.org/article.pl?sid=05/08/29/1319236&amp;from=rss", @rss09.items.first.link
		assert_equal "http://books.slashdot.org/article.pl?sid=05/08/29/1319236&amp;from=rss", @rss09.items.first[:link]
    assert_equal Time.parse("Wed Aug 24 13:33:34 UTC 2005"), @rss20.items.first.pubDate
    assert_equal Time.parse("Fri Sep 09 02:52:31 PDT 2005"), @rss09.channel.dc_date
	end

	def test_rss20
		assert_equal 10, @rss20.items.size
		assert_equal "Technoblog", @rss20.title
		assert_equal "http://tech.rufy.com", @rss20.channel.link
		assert_equal "http://feeds.feedburner.com/rufytech?m=68", @rss20.items.first.link
		assert_equal "http://feeds.feedburner.com/rufytech?m=68", @rss20.items.first[:link]
		assert_equal "This is an XML content feed. It is intended to be viewed in a newsreader or syndicated to another site.", @rss20.channel.feedburner_browserFriendly
	end
	
	def test_atom
		assert_equal 1, @atom.entries.size
		assert_equal "dive into mark", @atom.title
		assert_equal "http://example.org/", @atom.feed.link
		assert_equal "http://example.org/2005/04/02/atom", @atom.entries.first.link
		assert_equal "http://example.org/2005/04/02/atom", @atom.entries.first[:link]
	end
	
	def test_bad_feed
	  assert_raise(SimpleRSSError) { SimpleRSS.parse(open(File.dirname(__FILE__) + '/../data/not-rss.xml')) }
	end
end
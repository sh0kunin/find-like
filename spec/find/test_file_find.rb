# test_file_find.rb
#
# Test case for the FileFind, which is responsible for doing the actual search.
require 'test-unit'
require 'fileutils'
require 'find_like'

include FileUtils

class Test_File_Find < Test::Unit::TestCase
  def self.startup
    Dir.chdir(File.dirname(File.expand_path(__FILE__)))
  end

  def setup
    @file_rb    = 'test.rb'
    @file_txt1  = 'test.txt'
    @file_txt2  = 'foo.txt'
    @file_doc   = 'foo.doc'
    @directory1 = 'directory'
    @directory2 = 'dir'

    File.open(@file_rb, 'w'){}
    File.open(@file_txt1, 'w'){}
    File.open(@file_txt2, 'w'){}
    File.open(@file_doc, 'w'){}

    Dir.mkdir(@directory1) unless File.exist?(@directory1)
    Dir.mkdir(@directory2) unless File.exist?(@directory2)

    File.open(File.join(@directory1, 'bar.txt'), 'w'){}
    File.open(File.join(@directory2, 'baz.txt'), 'w'){}
    @file_find_obj = FindLike::FileFind.new(nil, '*.txt', nil, nil, false, nil)
  end

  test "name accessor basic functionality" do
    assert_respond_to(@file_find_obj, :name)
    assert_respond_to(@file_find_obj, :name=)
  end

  test "name method returns expected default value" do
    assert_equal('*.txt', @file_find_obj.name)
  end


  test "exclude_dir accessor basic functionality" do
    assert_respond_to(@file_find_obj, :exclude_dir)
    assert_respond_to(@file_find_obj, :exclude_dir=)
  end

  test "exclude_dir method returns expected default value" do
    assert_nil(@file_find_obj.exclude_dir)
  end

  test "find method with prune option works as expected" do
    find_file_second = FindLike::FileFind.new(nil, '*.txt', nil, "/foo/", false, ".")
    assert_equal('baz.txt', File.basename(find_file_second.find.first))
  end

  test "version constant is set to expected value" do
    assert_equal('0.2.0', FindLike::VERSION)
  end

  test "follow basic functionality" do
    assert_equal(@file_find_obj.follow, true)
    # assert_respond_to(@rule1, :path=)
  end

  test "path method returns expected value" do
    assert_equal(Dir.pwd, @file_find_obj.path)
  end

  test "find method basic functionality" do
    assert_respond_to(@file_find_obj, :find)
    assert_nothing_raised{ @file_find_obj.find }
  end

  test "find method returns expected value" do
    assert_kind_of(Array, @file_find_obj.find)
    assert_nil(@file_find_obj.find{})
  end
  test "ftype accessor basic functionality" do
    assert_respond_to(@file_find_obj, :ftype)
    assert_respond_to(@file_find_obj, :ftype=)
  end

  test "ftype method returns expected default value" do
    assert_nil(@file_find_obj.ftype)
  end

  test "ftype method works as expected" do
    assert_false(@file_find_obj.find.empty?)
  end

  test "follow accessor basic functionality" do
    assert_respond_to(@file_find_obj, :follow)
    assert_respond_to(@file_find_obj, :follow=)
  end

  test "follow method returns expected default value" do
    assert_true(@file_find_obj.follow)
  end

  def teardown
    rm_rf(@file_rb)
    rm_rf(@file_txt1)
    rm_rf(@file_txt2)
    rm_rf(@file_doc)
    rm_rf(@directory1)
    rm_rf(@directory2)
    @file_find_obj = nil
    @file_rb = nil
    @file_txt1 = nil
    @file_txt2 = nil
    @file_doc = nil
  end

  def self.shutdown
  end
end

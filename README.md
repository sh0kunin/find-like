# Find::Like

[![Build Status](https://travis-ci.org/45minutepromise/find-like.png?branch=master)](https://travis-ci.org/45minutepromise/find-like)
[![Coverage Status](https://coveralls.io/repos/github/45minutepromise/find-like/badge.svg?branch=master)](https://coveralls.io/github/45minutepromise/find-like?branch=master)
[![Documentation](http://img.shields.io/badge/docs-rdoc.info-blue.svg)](http://www.rubydoc.info/github/45minutepromise/find-like/master)

find -like tool is a comand line interface, that will allow you to search for files in a directory hierarchy.
The synopsis of the command line interface adhere to the following format:
``find [--P | --L] [--exclude-dir=path] --path=path [expression]``


## Prerequisite 

1. Ruby 2.4 : You can use rvm to maintain your rubies and install ruby 2.4.
[RVM]: https://rvm.io/rvm/install
 
    $ \curl -sSL https://get.rvm.io | bash -s stable --ruby
    
2. Bundler : Open a terminal 

    
    $ gem install bundler
    
 [Bundler]: http://bundler.io/
    
## Command line installation
Open a terminal and do following to get ready to use find_like
 
    $ git clone https://github.com/45minutepromise/find-like
    $ cd find-like
    $ bundle install
    $ bundle exec rake install
 

## Usage

Find like execute similar to how ```find``` command work on unix systems.

Lets try to understand each argument 

| Argument              | Description                                        |
| ---                  | ---                                              |
| `--path=path`          | This is a mandatory argument, provide path where you want to start search from.|
| `[--P or --L]`         | These are optional argument. --P is default, in case none is supplied. --P - Cause the file information and file type returned for each symbolic link to be those of the link itself. This should be the default behaviour. --L - Cause the file information and file type returned for each symbolic link to be those of the file referenced by the link, not the link itself. If the reference file does not exist, the file information and type will be for the link itself.| 
| `--name=pattern`       | True if the last component of the pathname being examined matches pattern .|
| `--rname=pattern`      | True if the whole path of the file matches pattern using regular expression. To match a file named `'./foo/bar'`|
| `--type=f`             | True if the whole path of the file matches pattern using regular expression. To match a file named `'./foo/bar'`|


* `--path=path` 

```find_like --path='directory-path-to-start-search-from''```

```find_like --path=.```  
return all files/directory/links in the current directory recursively

```find_like --path=/Users/uditgupta```  
return all files/directory/links in `/Users/uditgupta` recursively

* `[--P | --L]`

-P - Cause the file information and file type returned for each symbolic link to be those of the link itself. This should be the default behaviour.
-L - Cause the file information and file type returned for each symbolic link to be those of the file referenced by the link, not the link itself. If the reference file does not exist, the file information and type will be for the link itself.

```find_like --L --path=.```  
return all files/directory/links in the current directory recursively, including the paths to the symlinks if any, else will resolve to originals.

* `--name=pattern` 
```find_like --path=. --name=*.rb```  
return all files/directory/links that ends with .rb in the current directory recursively.

```find_like --path=/Users/uditgupta --name=test.rb```
return all files that ends with test.rb in the `/Users/uditgupta` directory recursively.

* `--rname=pattern` 
 you can use the regular expression `'.*/[ba]*'` or `'.*/foo/.*'` or `'/foo/ '`.
 
```find_like --L --path=/Users/uditgupta --name=*.rb --rname="*/foo/*"```  
return all files that ends with .rb and matches regular expression `*/foo/*` in the `/Users/uditgupta` directory recursively.

* `--type=f|d|l`

```find_like --path=. --type=d```
return only directories in current directory recursively.

```find_like --path=. --type=d```
return only files in current directory recursively.

```find_like --path=. --type=d```
return only links in current directory recursively.

* `--exclude-dir=name-of-the-directory`
 
`find_like --path=.  --exclude-dir=find_like`
return all files excluding the directory `find_like`.

`find_like --path=.  --exclude-dir=.git`
return all files excluding the directory `.git`.

## Continuous Integration  

Using Travis CI to keep a check on the health of `master` branch.
    [Travis find_like]: https://travis-ci.org/45minutepromise/find-like
   
 Each pushed commit runs the test, both spec and unit tests.
 + Check if the code passed the code analyzer  `Rubocop`
    [Rubocop]: https://github.com/bbatsov/rubocop

 + Check if the code coverage is upto the mark, using `coveralls` to handle that:
    [coveralls]: https://coveralls.io/github/45minutepromise/find-like?branch=master

 + Check if the documentation is up to date. Using Yard to handle library documentation
     [Yard]: https://github.com/lsegal/yard
   
    You can also read complete documentation of the find-like project here,
    [find-like] (http://www.rubydoc.info/github/45minutepromise/find-like/master)
    
To run the CI task locally
 
    $ bundle exec rake ci

 ## Usage as a gem in your ruby project.
 
 Add this line to your application's Gemfile:
 
 ```ruby
 gem 'find_like'
 ```
 
 And then execute:
 
     $ bundle install
 
 Or install it yourself as:
 
     $ gem install find_like

## Test

This repository has rspec tests and unit test to provide full coverage of the code, Running the following command to executes all tests suite.

    $ bundle exec rake test
  
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. 

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/45minutepromise/find-like. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Find::Like project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/find-like/blob/master/CODE_OF_CONDUCT.md).

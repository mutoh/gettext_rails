#
# Rakefile for gettext_rails.
#
# Use setup.rb or gem for installation.
# You don't need to use this file directly.
#
# Copyright(c) 2009 Masao Mutoh
#
# This program is licenced under the same licence as Ruby.
#

#make lib and paralel gettext checkout available
$LOAD_PATH.unshift "./lib"
gettext_path = File.join(ENV["GETTEXT_PATH"] || "../gettext/", "lib")
$LOAD_PATH.unshift gettext_path

require 'rubygems'
require 'rake'
require 'rake/packagetask'
require 'rake/gempackagetask'
require 'rake/rdoctask'

gettext_path = File.join(ENV["GETTEXT_PATH"] || "../gettext/", "lib")
$LOAD_PATH.unshift gettext_path

require 'gettext_rails/version'

PKG_VERSION = GetTextRails::VERSION

############################################################
# Manage po/mo files
############################################################
desc "Create *.mo from *.po"
task :makemo do
  $stderr.puts "Create active_record mo files."
  require 'gettext/tools'
  GetText.create_mofiles

  $stderr.puts "Create sample mo files."
  GetText.create_mofiles(:po_root => "sample/po", 
                         :mo_root => "sample/locale")

  $stderr.puts "Create samples/rails plugin mo files."
  GetText.create_mofiles(:po_root => "sample/vendor/plugins/lang_helper/po", 
                         :mo_root => "sample/vendor/plugins/lang_helper/locale")

  cd "test"
  sh "rake makemo"
  cd ".."
end

desc "Update pot/po files to match new version."
task :updatepo do
  require 'gettext/tools'

  GetText.update_pofiles("gettext_rails", 
			 Dir.glob("lib/**/*.rb"),
			 "gettext_rails #{PKG_VERSION}")

end


############################################################
# Package tasks
############################################################

desc "Create gem and tar.gz"
spec = Gem::Specification.new do |s|
  s.name = 'gettext_rails'
  s.version = PKG_VERSION
  s.summary = 'Localization support for Ruby on Rails(>=2.3) by Ruby-GetText-Package.'
  s.author = 'Masao Mutoh'
  s.email = 'mutomasa at gmail.com'
  s.homepage = 'http://gettext.rubyforge.org/'
  s.rubyforge_project = "gettext"
  s.files = FileList['**/*'].to_a.select{|v| v !~ /pkg|git/}
  s.add_dependency('gettext_activerecord', '>= 2.0.4')
  s.add_dependency('locale_rails', '>= 2.0.4')
  s.add_dependency('rails', '>= 2.3.2')
  s.require_path = 'lib'
  s.has_rdoc = true
  s.description = 'Localization support for Ruby on Rails(>=2.3.2) by Ruby-GetText-Package.'
end

Rake::GemPackageTask.new(spec) do |p|
  p.gem_spec = spec
  p.need_tar_gz = false
  p.need_zip = false
end

task :package => [:makemo]

############################################################
# Misc tasks
############################################################

Rake::RDocTask.new { |rdoc|
  allison = `allison --path`.chop
  rdoc.rdoc_dir = 'doc'
  rdoc.title    = "gettext_rails API Reference"
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc', 'ChangeLog')
  rdoc.rdoc_files.include('lib/**/*.rb')
  rdoc.template = allison if allison.size > 0
}

desc "Publish the release files to RubyForge."
task :release => [ :package ] do
  require 'rubyforge'

  rubyforge = RubyForge.new
  rubyforge.configure
  rubyforge.login
  rubyforge.add_release("gettext", "gettext_rails", 
                        PKG_VERSION, 
                        "pkg/gettext_rails-#{PKG_VERSION}.gem")
end


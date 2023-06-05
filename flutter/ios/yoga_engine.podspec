#
# Copyright 2020 ZUP IT SERVICOS EM TECNOLOGIA E INOVACAO SA
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint yoga_engine.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'yoga_engine'
  s.version          = '0.0.1'
  s.summary          = 'A plugin that uses yoga to implements flexbox layout in Flutter.'
  s.description      = <<-DESC
A plugin that uses yoga to implements flexbox layout in Flutter.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'RSYoga'
  s.platform = :ios, '8.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'


  # Subspec for rs yoga
  s.subspec 'RSYoga' do |ss|

  ss.version = '1.20.0'
  ss.license =  { :type => 'MIT', :file => "LICENSE" }
  ss.homepage = 'https://yogalayout.com/'
  ss.documentation_url = 'https://yogalayout.com/docs'

  ss.summary = 'Yoga is a cross-platform layout engine which implements Flexbox.'
  ss.description = 'Yoga is a cross-platform layout engine enabling maximum collaboration within your team by implementing an API many designers are familiar with, and opening it up to developers across different platforms.'

  ss.authors = 'Facebook and ZupIT and RS'
  ss.source = {
    :git => 'https://github.com/radiosphere/yoga.git',
    :tag => ss.version.to_s,
  }
  ss.platforms = { :ios => "8.0", :osx => "10.7", :tvos => "10.0", :watchos => "2.0" }
  ss.module_name = 'yoga'
  ss.requires_arc = false
  ss.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES'
  }
  ss.compiler_flags = [
      '-fno-omit-frame-pointer',
      '-fexceptions',
      '-Wall',
      '-Werror',
      '-std=c++1y',
      '-fPIC'
  ]
  ss.source_files = 'yoga/**/*.{c,h,cpp}'
  ss.public_header_files = 'yoga/{Yoga,YGEnums,YGMacros,YGNode,YGStyle,YGValue}.h'
  end
end

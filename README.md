Chef Cookie Cutter
==================
[![Gem](https://img.shields.io/gem/v/chef-cookie_cutter.svg)][gem]

[gem]: https://rubygems.org/gems/chef-cookie_cutter

Cookie Cutter is a small collection of hacks and workarounds for Chef. I
created it mostly to learn a bit more about Ruby programming and Chef internals.

Components
----------

### DSL extensions

#### Namespaces
Namespaces are inspired by and behave exactly like in the great
[Chef Sugar](https://github.com/sethvargo/chef-sugar). However, it is also
possible to access the attributes in recipes with the same syntax.

##### Examples
```ruby
# File my_cookbook/attributes/test.rb
namespace 'my_cookbook', 'test' do
  foo 'bar'
end
```

```ruby
# File my_cookbook/recipes/test.rb
namespace 'my_cookbook', 'test' do |test|
  file 'testfile' do
    content test['foo']
  end
end
```

#### Run state
- `store_state`
- `fetch_state`
- `exist_state?`

Provides some methods to easily store values in the Chef run state, so they
can be used across recipes.

##### Examples
```ruby
# File my_cookbook/recipes/test.rb
store_state(:my_cookbook, :test, :foo, 'bar')

file 'testfile' do
  content fetch_state(:my_cookbook, :test, :foo)
end
```

#### Shared blocks
- `shared`
- `include_shared`
- `shared?`

Uses the run state some methods to define blocks of attributes that are
repeatedly used across recipes and resources.

##### Examples
```ruby
shared :foo do
  content 'foo'
  mode '0644'
end

file 'testfile' do
  include_shared :foo
end
```

### LWRP extensions

#### Build Parametels
- `lwrp_run_context`
- `lwrp_cookbook_name`
- `lwrp_filename`

Patches the Lightweight Resource and Provider classes to give access to the
parameters resource or provider is built with. The three methods given above
are class methods on created LWPR class and already available while the LWRP is
built.

#### Mixins
- `lwrp_include`

Allows Lightweight Resources and Providers to mixin other resources or providers.

##### Example
```ruby
# File my_cookbook/resources/mixins/common.rb
attribute :foo, kind_of: String, default: 'foo'
```

```ruby
# File my_other_cookbook/resources/test.rb
lwrp_include 'mixin/common', cookbook: 'my_cookbook'

attribute :bar, kind_of: String, default: 'bar'
```

```ruby
# File my_other_cookbook/recipes/test.rb
my_cookbook_test 'test' do
  foo 'Hello'
  bar 'World'
end
```

#### Fancy properties
**Note:** Requires Chef >= 12.5 (currently alpha)

Chef 12.5 introduces properties to easier define resources. The FancyProperty
acts as a replacement for the original Chef property with some additional
features:

* Allows passing `*args`, `**kwargs` and `&block` arguments to properties. Since
only a single value can be assigned to an attribute, this will fail if no
coercion is provided that handles the given arguments properly.
* Adds new validation parameter `:coerce_class` takes a class name. The arguments
given to the property will be passed to the constructor of the given class, and
the value will be set to the resulting instance.
* Adds new validation parameter `:collect`. If set to `true`, the property can
be called multiple times on a resource, and all values will be collected in
an array.

##### Examples
```ruby
# File my_cookbook/resources/test.rb

class MySampleValueClass
  def initialize(foo, bar: false)
    @foo = foo
  end
end

property :foo, ::Chef::CookieCutter::FancyProperty,
         collect: true, coerce_class: MySampleValueClass
```

```ruby
# File my_cookbook/recipes/test.rb
my_cookbook_test 'test' do
  foo 'Hello'
  foo 'World', true
end
```

License & Authors
-----------------
- Author: Ole Claussen (claussen.ole@gmail.com)

```text
Copyright 2015 Ole Claussen

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
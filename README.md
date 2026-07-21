<a href="https://rubygems.org/gems/plugs" title="Install gem"><img src="https://badge.fury.io/rb/plugs.svg" alt="Gem version" height="18"></a> <a href="https://github.com/raindeer-rb/plugs" title="GitHub"><img src="https://img.shields.io/badge/github-%23121011.svg?style=for-the-badge&logo=github&logoColor=white" alt="GitHub repo" height="18"></a> <a href="https://codeberg.org/Iow/load" title="Codeberg"><img src="https://img.shields.io/badge/Codeberg-2185D0?style=for-the-badge&logo=Codeberg&logoColor=white" alt="Codeberg repo" height="18"></a>

# Plugs

Plugs are dependencies that are loosely coupled internally but externally appear as one entity such as a feature, config object or plugin. A plug is reusable, shareable and overridable.

> [!note]
> Plugs is for local dependency management. For global dependency management see [Providers](https://github.com/raindeer-rb/providers)

**Advantages:**
- Keep unit tests isolated from upstream setup/configuration
- Add plugins and config to your interfaces via a simple `:key`
- Plugs can be nested in a tree and "sliced" by key. The parent key includes its dependencies and their keys

## Example

Plugs is used by [Antlers](https://github.com/raindeer-rb/antlers) to configure which elements the Abstract Syntax Tree supports.

```ruby
require 'plugs'

# Define the dependencies.
class MyPlugs
  include Plugs

  plug(:html) do
    plug(:node) do
      require_relative '../nodes/html_node'
      HTMLNode
    end
  end

  plug(:form) do
    plug(:lexeme) do
      require_relative '../lexemes/form_lexeme'
      FormLexeme
    end

    plug(:node) do
      require_relative '../nodes/form_node'
      FormNode
    end
  end
end

# Get a top level dependency and its children:
def new(plugs: MyPlugs[:html, :form])
  plugs.to_a # => [HTMLNode, FormLexeme, FormNode].
end

# Get all "node" plugs regardless of their parent:
def new(plugs: MyPlugs[:node])
  plugs.to_a # => [HTMLNode, FormNode]
end
```

## Use Cases

### Loosely Coupled Dependencies

Imagine you have two loosely coupled components:
```ruby
FormLexeme.new
FormNode.new
```

They are unit tested individually and created at completely separate stages.

But they are both enabled or disabled at the same time depending on configuration:
```ruby
Parser.new(node_types: [:form])
```

Plugs lets you pull them together:
```ruby
plug(:form) do
  plug(:lexeme) do
    require_relative '../lexemes/form_lexeme'
    FormLexeme
  end

  plug(:node) do
    require_relative '../nodes/form_node'
    FormNode
  end
end
```

### Overriding Dependencies

Say your library uses these dependencies most of the time, but allows other users of the gem to override these dependencies:
```ruby
Parser.new(node_types: OldPlugs[:form, :html, :var] + NewPlugs[:form, :toc])
```

The "new" form will take precedence and override the "old" form, and the `:toc` plug will be added to the mix.

## API

### Nested Plugs

Plugs can be sliced out from the nested tree structure. For example you could get all plugs that are `:lexeme` or just the single that is `:form`... doesn't matter where they sit in the hierarchy. On the flip side if you slice a single plug that has children then only that plug and it's children will be included. It goes both ways.

## Installation

Add `gem 'plugs'` to your Gemfile then:
```
bundle install
```

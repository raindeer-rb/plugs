<a href="https://rubygems.org/gems/plugs" title="Install gem"><img src="https://badge.fury.io/rb/plugs.svg" alt="Gem version" height="18"></a> <a href="https://github.com/raindeer-rb/plugs" title="GitHub"><img src="https://img.shields.io/badge/github-%23121011.svg?style=for-the-badge&logo=github&logoColor=white" alt="GitHub repo" height="18"></a> <a href="https://codeberg.org/Iow/load" title="Codeberg"><img src="https://img.shields.io/badge/Codeberg-2185D0?style=for-the-badge&logo=Codeberg&logoColor=white" alt="Codeberg repo" height="18"></a>

# Plugs [UNRELEASED]

Plugs are dependencies that are loosely coupled internally but externally appear as one entity such as a feature, config object or plugin. A plug is reusable, shareable and overridable.

> [!note]
> Plugs is for local dependency management. For global dependency management see [Providers](https://github.com/raindeer-rb/providers)

**Advantages:**
- Keep unit tested classes isolated from their setup
- Add plugins via a simple `:key` that do their own setup

## Example

Plugs is used by [Antlers](https://github.com/raindeer-rb/antlers) to configure which elements the Abstract Syntax Tree supports.

```ruby
require 'plugs'

# Define the dependencies.
class Elements
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

# Require the dependencies:
def new(elements: Elements[:html, :form])
  # => HTMLNode, FormLexeme and FormNode now available.
end

# Return the dependencies:
def new(elements: Elements[:node])
  elements # => [HTMLNode, FormNode]
end
```

## Use Cases

### Loosely Coupled Dependencies

Imagine you have two loosely coupled components:


But they are both enabled or disabled at the same time in your application:

Plugs lets you pull them together.

### Overriding Dependencies

Say your library uses these dependencies most of the time, but allows other users of the gem to override these dependencies... kinda like as if they were **plug**in**s**.

## Installation

Add `gem 'plugs'` to your Gemfile then:
```
bundle install
```

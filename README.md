# GnresolverClient

[![Gem Version][gem_badge]][gem_link]
[![Continuous Integration Status][ci_badge]][ci_link]
[![Coverage Status][cov_badge]][cov_link]
[![CodeClimate][code_badge]][code_link]
[![Dependency Status][dep_badge]][dep_link]

GnresolverClient accesses API of Global Names Resolver Service

## Installation

Add this line to your application's Gemfile:

```ruby
gem "gnresolver_client"
```

And then execute:

```bash
bundle
```

Or install it yourself as:

```bash
gem install gnresolver_client
```

## Usage

TODO: Write usage instructions here

## Development

### Testing

We use docker and docker-compose as a test environment. Testing configuration
creates a development database and API for gnresolver. To run tests

1. Install [docker] and [docker-compose]
1. run ``docker-compose up`` from the project's root repository
1. run ``docker-compose run app rake``

### Publishing the gem

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org].

## Contributing

Bug reports and pull requests are welcome on [GitHub][github-repo].

## License

The gem is available as open source under the terms of the
[MIT License][license]

[gem_badge]: https://badge.fury.io/rb/gnresolver_client.svg
[gem_link]: http://badge.fury.io/rb/gnresolver_client
[ci_badge]: https://circleci.com/gh/GlobalNamesArchitecture/gnresolver_client.svg?style=svg
[ci_link]: https://circleci.com/gh/GlobalNamesArchitecture/gnresolver_client
[cov_badge]: https://coveralls.io/github/GlobalNamesArchitecture/gnresolver_client?branch=master
[cov_link]: https://coveralls.io/repos/github/GlobalNamesArchitecture/gnresolver_client/badge.svg?branch=master
[code_badge]: https://codeclimate.com/github/GlobalNamesArchitecture/gnresolver_client/badges/gpa.svg
[code_link]: https://codeclimate.com/github/GlobalNamesArchitecture/gnresolver_client
[dep_badge]: https://gemnasium.com/GlobalNamesArchitecture/gnresolver_client.svg
[dep_link]: https://gemnasium.com/GlobalNamesArchitecture/gnresolver_client
[github-repo]: https://github.com/GlobalNamesArchitecture/gnresolver_client
[license]: https://github.com/GlobalNamesArchitecture/gnresolver_client/blob/master/LICENSE
[rubygems.org]: https://rubygems.org
[docker]: https://docs.docker.com/engine/installation/
[docker-compose]: https://docs.docker.com/compose/install/

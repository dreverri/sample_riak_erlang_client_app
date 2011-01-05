# Sample Riak Erlang Application

The following is a short example of building a simple command line
utility to read and write objects to Riak.

Items covered:

* [Rebar](https://github.com/basho/rebar)
* [Riak Erlang Client](https://github.com/basho/riak-erlang-client)

## Setup project directory

### Grab the latest Rebar

    curl -O -L https://github.com/downloads/basho/rebar/rebar
    chmod a+x rebar

### Review the available Rebar commands

    ./rebar -c

### Specify Riak Erlang Client dependency

Configuration options, such as dependencies, are specified in the `rebar.config` file.

    cat > rebar.config
    {deps, [
     {riakc, "1.0.*",
      {git, "git://github.com/basho/riak-erlang-client.git", "HEAD"}}
    ]}.

You can read about the various other rebar config options
[here](https://github.com/basho/rebar/blob/master/rebar.config.sample).

### Fetch the dependency

    ./rebar get-deps

You'll notice that rebar has also pulled down the Erlang Protobuffs
application which the Riak Erlang Client depends on.

## Create a new application

    ./rebar create-app appid=sample_riak_erlang_client_app skip_deps=true

Note the use of the command line option `skip_deps=true`. By default
commands are executed on the current application and all
dependencies. If the `skip_deps` option were not specified the
`sample_riak_erlang_client_app` would have been created in our
dependencies as well as in our project directory.

For this project we didn't actually need to create an application. The
rebar application template (create-app) provides an `.app.src` file
which is required for rebar to compile the project. This file is known
as the application resource file. More information regarding this file
can be found
[here](http://www.erlang.org/doc/design_principles/applications.html#appl_res_file).

The file looks as follows:

    cat src/sample_riak_erlang_client_app.app.src 
    {application, sample_riak_erlang_client_app,
      [
        {description, ""},
        {vsn, "1"},
        {registered, []},
        {applications, [
                  kernel,
                  stdlib
                 ]},
        {mod, { sample_riak_erlang_client_app_app, []}},
        {env, []}
    ]}.

## Create a new module

    ./rebar create template=simplemod \
    modid=sample_riak_erlang_client_app skip_deps=true

Unfortunately, templates are not documented very well at the
moment. One needs to review the template
[source](https://github.com/basho/rebar/blob/master/priv/templates/simplemod.template)
to determine the valid variables.

Note the use of `skip_deps=true` again.

## Escript

We'll be building an escript compatible module for our command line
tool. Documentation regarding escript is available
[here](http://www.erlang.org/doc/man/escript.html).

Escript modules are fairly simple, command line arguments are passed to the
`main/1` function in the module. Our module simply needs to export a
`main/1` function.

For rebar to correctly build the escript we need to add an option to
our `rebar.config`.

    echo "{escript_incl_apps, [riakc, protobuffs]}." >> rebar.config

## Command Line Tool

This is a very simple command line tool to provide basic read and
write access to Riak. Two commands, get and put, will be supported.

Examples:

    sample_riak_erlang_client_app put bucket key value
    sample_riak_erlang_client_app get bucket key

## Get command

### Testing

    # Compile
    ./rebar compile

    # Build escript
    ./rebar escriptize skip_deps=true

    # Run
    ./sample_riak_erlang_client_app get bucket key

## Put command

### Testing
    
    # Compile
    ./rebar compile

    # Build escript
    ./rebar escriptize skip_deps=true

    # Run
    ./sample_riak_erlang_client_app put bucket key "hello world"


## TODO

* Accept host and port options
* Accept r, w, and dw options
        

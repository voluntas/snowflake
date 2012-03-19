###########################
Erlang Application Template
###########################

create application and module::

  ./rebar create-app appid=snowflake
  ./rebar create template=simplemod modid=snowflake

#####################
Python JSON benchmark
#####################

bench.py is depends on `simplejson <https://github.com/simplejson/simplejson>`_ and `ultrajson <https://github.com/esnme/ultrajson>`_.

If you are using pip, type following::

  $ sudo pip install -r requirements.txt

###################
Perl JSON benchmark
###################

bench.pl is depends on JSON module. Recommended to install `JSON::XS <http://search.cpan.org/dist/JSON-XS/XS.pm>`_.

If you are using CPAN shell, type following::

  % cpan JSON::XS

If you are using `cpanm <https://github.com/miyagawa/cpanminus>`_, type following::

  $ cpanm JSON::XS

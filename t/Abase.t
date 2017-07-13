use common::sense;

use Test::More tests => 1;

use MarpaX::Languages::Bash::AST;
use constant BASE => 'MarpaX::Languages::Bash::AST::Obj::';

my $grammar = MarpaX::Languages::Bash::AST->new();

my $value_ref;

$value_ref = $grammar->parse( <<'EOI' );
echo Hello World.
EOI

is_deeply $value_ref, bless(
    {
        objs => [
            bless(
                {
                    objs => [
                        bless(
                            {
                                objs => [
                                    bless(
                                        {
                                            objs => [
                                                bless(
                                                    {
                                                        column => 1,
                                                        line   => 1,
                                                        string => "echo"
                                                    },
                                                    BASE . 'Bareword'
                                                )
                                            ]
                                        },
                                        BASE . 'Field'
                                    ),
                                    bless(
                                        {
                                            objs => [
                                                bless(
                                                    {
                                                        column => 6,
                                                        line   => 1,
                                                        string => "Hello"
                                                    },
                                                    BASE . 'Bareword'
                                                )
                                            ]
                                        },
                                        BASE . 'Field'
                                    ),
                                    bless(
                                        {
                                            objs => [
                                                bless(
                                                    {
                                                        column => 12,
                                                        line   => 1,
                                                        string => "World."
                                                    },
                                                    BASE . 'Bareword'
                                                )
                                            ]
                                        },
                                        BASE . 'Field'
                                    )
                                ]
                            },
                            BASE . 'Command'
                        )
                    ]
                },
                BASE . 'Block'
              )

        ]
    },
    BASE . 'Script'
  ),
  'Simple';

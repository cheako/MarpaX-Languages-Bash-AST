use common::sense;

use Test::More tests => 1;

use MarpaX::Languages::Bash::AST;
use constant BASE => 'MarpaX::Languages::Bash::AST::Obj::';

my $grammar = MarpaX::Languages::Bash::AST->new();

my $value_ref;

my $input = <<'EOI';
echo Hello World.
echo Hello World.
EOI
chomp $input;
$value_ref = $grammar->parse($input);

is_deeply $value_ref,
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
                                            objs => [
                                                bless(
                                                    {
                                                        column => 1,
                                                        'line' => 1,
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
                                                        'line' => 1,
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
                                                        'line' => 1,
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
                        ),
                        bless(
                            {
                                objs => [
                                    bless(
                                        {
                                            objs => [
                                                bless(
                                                    {
                                                        column => 1,
                                                        'line' => 2,
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
                                                        'line' => 2,
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
                                                        'line' => 2,
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
  'Input ends at "World." instead of "World.\n"';

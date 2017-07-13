use common::sense;

use Test::More tests => 2;

use MarpaX::Languages::Bash::AST;
use constant BASE => 'MarpaX::Languages::Bash::AST::Obj::';

my $grammar = MarpaX::Languages::Bash::AST->new();

my $value_ref;

$value_ref = $grammar->parse( <<'EOI' );
#!/bin/sh
echo Hello World.
EOI

is_deeply $value_ref,
  bless(
    {
        objs => [
            bless(
                {
                    column => 3,
                    'line' => 1,
                    string => '/bin/sh'
                },
                BASE . 'Shabang'
            ),
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
  'Shabang /w single';

$value_ref = $grammar->parse( <<'EOI' );
#!/bin/sh
echo Hello World.
echo Hello World.
EOI

is_deeply $value_ref,
  bless(
    {
        objs => [
            bless(
                {
                    column => 3,
                    'line' => 1,
                    string => '/bin/sh'
                },
                BASE . 'Shabang'
            ),
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
                                                        'line' => 3,
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
                                                        'line' => 3,
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
                                                        'line' => 3,
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
  'Shabang /w double';

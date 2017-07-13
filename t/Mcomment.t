use common::sense;

use Test::More tests => 4;

use MarpaX::Languages::Bash::AST;
use constant BASE => 'MarpaX::Languages::Bash::AST::Obj::';

my $grammar = MarpaX::Languages::Bash::AST->new();

my $value_ref;

$value_ref = $grammar->parse( <<'EOI' );
echo Hello World. # A good example.
EOI

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
                                column => 19,
                                'line' => 1,
                                string => ' A good example.'
                            },
                            BASE . 'Comment'
                        )
                    ]
                },
                BASE . 'Block'
            )
        ]
    },
    BASE . 'Script'
  ),
  'Comment after code';

$value_ref = $grammar->parse( <<'EOI' );
echo Hello World.
# A good example.
EOI

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
                                column => 1,
                                'line' => 2,
                                string => ' A good example.'
                            },
                            BASE . 'Comment'
                        )
                    ]
                },
                BASE . 'Block'
            )
        ]
    },
    BASE . 'Script'
  ),
  'Comment on next line';

$value_ref = $grammar->parse( <<'EOI' );
# A good example.
echo Hello World.
EOI

is_deeply $value_ref,
  bless(
    {
        objs => [
            bless(
                {
                    column => 1,
                    'line' => 1,
                    string => ' A good example.'
                },
                BASE . 'Comment'
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
  'Comment on previous line';

$value_ref = $grammar->parse( <<'EOI' );
 # A good example.
echo Hello World.
EOI

is_deeply $value_ref,
  bless(
    {
        objs => [
            bless(
                {
                    column => 2,
                    'line' => 1,
                    string => ' A good example.'
                },
                BASE . 'Comment'
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
  'Comment indented on previous line';

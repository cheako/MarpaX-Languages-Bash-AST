use common::sense;

use Test::More tests => 4;

use MarpaX::Languages::Bash::AST;
use constant BASE => 'MarpaX::Languages::Bash::AST::Obj::';

my $grammar = MarpaX::Languages::Bash::AST->new();

my $value_ref;

$value_ref = $grammar->parse( <<'EOI' );
case hi in hi) echo Hello World. ;; esac
EOI

is_deeply $value_ref,
  bless(
    {
        'objs' => [
            bless(
                {
                    'objs' => [
                        bless(
                            {
                                'objs' => [
                                    bless(
                                        {
                                            'objs' => [
                                                bless(
                                                    {
                                                        'column' => 6,
                                                        'string' => 'hi',
                                                        'line'   => 1
                                                    },
'MarpaX::Languages::Bash::AST::Obj::Bareword'
                                                )
                                            ]
                                        },
'MarpaX::Languages::Bash::AST::Obj::Given'
                                    ),
                                    bless(
                                        {
                                            'line' => 1,
                                            'objs' => [
                                                bless(
                                                    {
                                                        'line' => 1,
                                                        'objs' => [
                                                            bless(
                                                                {
    'objs' => [
        bless(
            {
                'column' => 12,
                'string' => 'hi',
                'line'   => 1
            },
            'MarpaX::Languages::Bash::AST::Obj::Bareword'
        )
    ]
                                                                },
'MarpaX::Languages::Bash::AST::Obj::Field'
                                                            )
                                                        ],
                                                        'column' => 11
                                                    },
'MarpaX::Languages::Bash::AST::Obj::CaseCondition'
                                                ),
                                                bless(
                                                    {
                                                        'objs' => [
                                                            bless(
                                                                {
    'objs' => [
        bless(
            {
                'objs' => [
                    bless(
                        {
                            'column' => 16,
                            'string' => 'echo',
                            'line'   => 1
                        },
                        'MarpaX::Languages::Bash::AST::Obj::Bareword'
                    )
                ]
            },
            'MarpaX::Languages::Bash::AST::Obj::Field'
        ),
        bless(
            {
                'objs' => [
                    bless(
                        {
                            'column' => 21,
                            'line'   => 1,
                            'string' => 'Hello'
                        },
                        'MarpaX::Languages::Bash::AST::Obj::Bareword'
                    )
                ]
            },
            'MarpaX::Languages::Bash::AST::Obj::Field'
        ),
        bless(
            {
                'objs' => [
                    bless(
                        {
                            'column' => 27,
                            'string' => 'World.',
                            'line'   => 1
                        },
                        'MarpaX::Languages::Bash::AST::Obj::Bareword'
                    )
                ]
            },
            'MarpaX::Languages::Bash::AST::Obj::Field'
        )
    ]
                                                                },
'MarpaX::Languages::Bash::AST::Obj::Command'
                                                            )
                                                        ]
                                                    },
'MarpaX::Languages::Bash::AST::Obj::Block'
                                                )
                                            ],
                                            'column' => 11
                                        },
'MarpaX::Languages::Bash::AST::Obj::CaseBlock'
                                    )
                                ],
                                'column' => 10,
                                'line'   => 1
                            },
                            'MarpaX::Languages::Bash::AST::Obj::Case'
                        )
                    ]
                },
                'MarpaX::Languages::Bash::AST::Obj::Block'
            )
        ]
    },
    'MarpaX::Languages::Bash::AST::Obj::Script'
  ),
  'Simple case';

$value_ref = $grammar->parse( <<'EOI' );
case in in in) echo Hello World. ;; esac
EOI

is_deeply $value_ref,
  bless(
    {
        'objs' => [
            bless(
                {
                    'objs' => [
                        bless(
                            {
                                'column' => 10,
                                'line'   => 1,
                                'objs'   => [
                                    bless(
                                        {
                                            'objs' => [
                                                bless(
                                                    {
                                                        'line'   => 1,
                                                        'column' => 6,
                                                        'string' => 'in'
                                                    },
'MarpaX::Languages::Bash::AST::Obj::Bareword'
                                                )
                                            ]
                                        },
'MarpaX::Languages::Bash::AST::Obj::Given'
                                    ),
                                    bless(
                                        {
                                            'line' => 1,
                                            'objs' => [
                                                bless(
                                                    {
                                                        'column' => 11,
                                                        'line'   => 1,
                                                        'objs'   => [
                                                            bless(
                                                                {
    'objs' => [
        bless(
            {
                'column' => 12,
                'string' => 'in',
                'line'   => 1
            },
            'MarpaX::Languages::Bash::AST::Obj::Bareword'
        )
    ]
                                                                },
'MarpaX::Languages::Bash::AST::Obj::Field'
                                                            )
                                                        ]
                                                    },
'MarpaX::Languages::Bash::AST::Obj::CaseCondition'
                                                ),
                                                bless(
                                                    {
                                                        'objs' => [
                                                            bless(
                                                                {
    'objs' => [
        bless(
            {
                'objs' => [
                    bless(
                        {
                            'string' => 'echo',
                            'column' => 16,
                            'line'   => 1
                        },
                        'MarpaX::Languages::Bash::AST::Obj::Bareword'
                    )
                ]
            },
            'MarpaX::Languages::Bash::AST::Obj::Field'
        ),
        bless(
            {
                'objs' => [
                    bless(
                        {
                            'column' => 21,
                            'string' => 'Hello',
                            'line'   => 1
                        },
                        'MarpaX::Languages::Bash::AST::Obj::Bareword'
                    )
                ]
            },
            'MarpaX::Languages::Bash::AST::Obj::Field'
        ),
        bless(
            {
                'objs' => [
                    bless(
                        {
                            'column' => 27,
                            'string' => 'World.',
                            'line'   => 1
                        },
                        'MarpaX::Languages::Bash::AST::Obj::Bareword'
                    )
                ]
            },
            'MarpaX::Languages::Bash::AST::Obj::Field'
        )
    ]
                                                                },
'MarpaX::Languages::Bash::AST::Obj::Command'
                                                            )
                                                        ]
                                                    },
'MarpaX::Languages::Bash::AST::Obj::Block'
                                                )
                                            ],
                                            'column' => 11
                                        },
'MarpaX::Languages::Bash::AST::Obj::CaseBlock'
                                    )
                                ]
                            },
                            'MarpaX::Languages::Bash::AST::Obj::Case'
                        )
                    ]
                },
                'MarpaX::Languages::Bash::AST::Obj::Block'
            )
        ]
    },
    'MarpaX::Languages::Bash::AST::Obj::Script'
  ),
  'Three "in" case';

$value_ref = $grammar->parse( <<'EOI' );
case hi # Constant "hi"
  in hi) echo Hello World. ;; esac
EOI

is_deeply $value_ref,
  bless(
    {
        'objs' => [
            bless(
                {
                    'objs' => [
                        bless(
                            {
                                'objs' => [
                                    bless(
                                        {
                                            'objs' => [
                                                bless(
                                                    {
                                                        'line'   => 1,
                                                        'string' => 'hi',
                                                        'column' => 6
                                                    },
'MarpaX::Languages::Bash::AST::Obj::Bareword'
                                                )
                                            ]
                                        },
'MarpaX::Languages::Bash::AST::Obj::Given'
                                    ),
                                    bless(
                                        {
                                            'column' => 9,
                                            'string' => ' Constant "hi"',
                                            'line'   => 1
                                        },
'MarpaX::Languages::Bash::AST::Obj::Comment'
                                    ),
                                    bless(
                                        {
                                            'line'   => 2,
                                            'column' => 5,
                                            'objs'   => [
                                                bless(
                                                    {
                                                        'column' => 5,
                                                        'line'   => 2,
                                                        'objs'   => [
                                                            bless(
                                                                {
    'objs' => [
        bless(
            {
                'column' => 6,
                'line'   => 2,
                'string' => 'hi'
            },
            'MarpaX::Languages::Bash::AST::Obj::Bareword'
        )
    ]
                                                                },
'MarpaX::Languages::Bash::AST::Obj::Field'
                                                            )
                                                        ]
                                                    },
'MarpaX::Languages::Bash::AST::Obj::CaseCondition'
                                                ),
                                                bless(
                                                    {
                                                        'objs' => [
                                                            bless(
                                                                {
    'objs' => [
        bless(
            {
                'objs' => [
                    bless(
                        {
                            'line'   => 2,
                            'string' => 'echo',
                            'column' => 10
                        },
                        'MarpaX::Languages::Bash::AST::Obj::Bareword'
                    )
                ]
            },
            'MarpaX::Languages::Bash::AST::Obj::Field'
        ),
        bless(
            {
                'objs' => [
                    bless(
                        {
                            'column' => 15,
                            'string' => 'Hello',
                            'line'   => 2
                        },
                        'MarpaX::Languages::Bash::AST::Obj::Bareword'
                    )
                ]
            },
            'MarpaX::Languages::Bash::AST::Obj::Field'
        ),
        bless(
            {
                'objs' => [
                    bless(
                        {
                            'line'   => 2,
                            'string' => 'World.',
                            'column' => 21
                        },
                        'MarpaX::Languages::Bash::AST::Obj::Bareword'
                    )
                ]
            },
            'MarpaX::Languages::Bash::AST::Obj::Field'
        )
    ]
                                                                },
'MarpaX::Languages::Bash::AST::Obj::Command'
                                                            )
                                                        ]
                                                    },
'MarpaX::Languages::Bash::AST::Obj::Block'
                                                )
                                            ]
                                        },
'MarpaX::Languages::Bash::AST::Obj::CaseBlock'
                                    )
                                ],
                                'line'   => 1,
                                'column' => 10
                            },
                            'MarpaX::Languages::Bash::AST::Obj::Case'
                        )
                    ]
                },
                'MarpaX::Languages::Bash::AST::Obj::Block'
            )
        ]
    },
    'MarpaX::Languages::Bash::AST::Obj::Script'
  ),
  'Comment after given';

$value_ref = $grammar->parse( <<'EOI' );
case hi in # Is the value "hi"?
  hi) echo Hello World. ;; esac
EOI

is_deeply $value_ref,
  bless(
    {
        'objs' => [
            bless(
                {
                    'objs' => [
                        bless(
                            {
                                'column' => 10,
                                'objs'   => [
                                    bless(
                                        {
                                            'objs' => [
                                                bless(
                                                    {
                                                        'line'   => 1,
                                                        'column' => 6,
                                                        'string' => 'hi'
                                                    },
'MarpaX::Languages::Bash::AST::Obj::Bareword'
                                                )
                                            ]
                                        },
'MarpaX::Languages::Bash::AST::Obj::Given'
                                    ),
                                    bless(
                                        {
                                            'column' => 11,
                                            'objs'   => [
                                                bless(
                                                    {
                                                        'line'   => 1,
                                                        'column' => 11,
                                                        'objs'   => [
                                                            bless(
                                                                {
    'line'   => 1,
    'string' => ' Is the value "hi"?',
    'column' => 12
                                                                },
'MarpaX::Languages::Bash::AST::Obj::Comment'
                                                            ),
                                                            bless(
                                                                {
    'objs' => [
        bless(
            {
                'column' => 3,
                'string' => 'hi',
                'line'   => 2
            },
            'MarpaX::Languages::Bash::AST::Obj::Bareword'
        )
    ]
                                                                },
'MarpaX::Languages::Bash::AST::Obj::Field'
                                                            )
                                                        ]
                                                    },
'MarpaX::Languages::Bash::AST::Obj::CaseCondition'
                                                ),
                                                bless(
                                                    {
                                                        'objs' => [
                                                            bless(
                                                                {
    'objs' => [
        bless(
            {
                'objs' => [
                    bless(
                        {
                            'column' => 7,
                            'string' => 'echo',
                            'line'   => 2
                        },
                        'MarpaX::Languages::Bash::AST::Obj::Bareword'
                    )
                ]
            },
            'MarpaX::Languages::Bash::AST::Obj::Field'
        ),
        bless(
            {
                'objs' => [
                    bless(
                        {
                            'string' => 'Hello',
                            'column' => 12,
                            'line'   => 2
                        },
                        'MarpaX::Languages::Bash::AST::Obj::Bareword'
                    )
                ]
            },
            'MarpaX::Languages::Bash::AST::Obj::Field'
        ),
        bless(
            {
                'objs' => [
                    bless(
                        {
                            'string' => 'World.',
                            'column' => 18,
                            'line'   => 2
                        },
                        'MarpaX::Languages::Bash::AST::Obj::Bareword'
                    )
                ]
            },
            'MarpaX::Languages::Bash::AST::Obj::Field'
        )
    ]
                                                                },
'MarpaX::Languages::Bash::AST::Obj::Command'
                                                            )
                                                        ]
                                                    },
'MarpaX::Languages::Bash::AST::Obj::Block'
                                                )
                                            ],
                                            'line' => 1
                                        },
'MarpaX::Languages::Bash::AST::Obj::CaseBlock'
                                    )
                                ],
                                'line' => 1
                            },
                            'MarpaX::Languages::Bash::AST::Obj::Case'
                        )
                    ]
                },
                'MarpaX::Languages::Bash::AST::Obj::Block'
            )
        ]
    },
    'MarpaX::Languages::Bash::AST::Obj::Script'
  ),
  'Comment after given';

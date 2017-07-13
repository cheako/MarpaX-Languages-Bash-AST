use Test::More tests => 1;

use MarpaX::Languages::Bash::AST;
my $grammar = MarpaX::Languages::Bash::AST->new();

my $value_ref;

# This script prints "Hello World.\n"
$value_ref = $grammar->parse( <<'EOI' );
echo ${a:-  
  
    Hello  
  
  World.}
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
                                                        'column' => 1,
                                                        'line'   => 1,
                                                        'string' => 'echo'
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
                                                        'column' => 7,
                                                        'line'   => 1,
                                                        'objs'   => [
                                                            bless(
                                                                {
    'objs' => [
        bless(
            {
                'column' => 8,
                'line'   => 1,
                'string' => 'a'
            },
            'MarpaX::Languages::Bash::AST::Obj::Bareword'
        )
    ]
                                                                },
'MarpaX::Languages::Bash::AST::Obj::Field'
                                                            ),
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
                            'column' => 5,
                            'line'   => 3,
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
                            'string' => 'World.',
                            'line'   => 5,
                            'column' => 3
                        },
                        'MarpaX::Languages::Bash::AST::Obj::Bareword'
                    )
                ]
            },
            'MarpaX::Languages::Bash::AST::Obj::Field'
        )
    ]
                                                                },
'MarpaX::Languages::Bash::AST::Obj::UseDefault'
                                                            )
                                                        ]
                                                    },
'MarpaX::Languages::Bash::AST::Obj::Paramiter'
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
                BASE . 'Block'
            )
        ]
    },
    'MarpaX::Languages::Bash::AST::Obj::Script'
  ),
  'Insane parse magic activate';

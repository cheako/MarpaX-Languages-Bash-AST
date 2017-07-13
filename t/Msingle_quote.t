use common::sense;

use Test::More tests => 1;

use MarpaX::Languages::Bash::AST;
use constant BASE => 'MarpaX::Languages::Bash::AST::Obj::';

my $grammar = MarpaX::Languages::Bash::AST->new();

my $value_ref;

$value_ref = $grammar->parse( <<'EOI' );
echo H'e$$# "#r$'d.
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
                                                        'string' => 'echo',
                                                        'line'   => 1,
                                                        'column' => 1
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
                                                        'string' => 'H',
                                                        'line'   => 1,
                                                        'column' => 6
                                                    },
'MarpaX::Languages::Bash::AST::Obj::Bareword'
                                                ),
                                                bless(
                                                    {
                                                        'string' => 'e$$# "#r$'
                                                    },
'MarpaX::Languages::Bash::AST::Obj::SingleQuote'
                                                ),
                                                bless(
                                                    {
                                                        'column' => 18,
                                                        'line'   => 1,
                                                        'string' => 'd.'
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
                BASE . 'Block'
            )
        ]
    },
    'MarpaX::Languages::Bash::AST::Obj::Script'
  ),
  'Single quote';

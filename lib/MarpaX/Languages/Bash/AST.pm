use common::sense;

package MarpaX::Languages::Bash::AST;
use Carp qw( confess );
use MarpaX::Languages::Bash::AST::Obj;
use constant BASE => 'MarpaX::Languages::Bash::AST::Obj::';

sub new {
    my ( $class, $obj ) = @_;
    my %transitions;

    my $append_char = sub {
        confess('First data stack has no string')
          unless ( exists $_[0]->{dstack}->[0]->{string} );
        $_[0]->{dstack}->[0]->{string} .= $_[1];
    };

    my $append_obj = sub {
        confess('First data stack has no objs')
          unless ( exists $_[0]->{dstack}->[0]->{objs} );
        push @{ $_[0]->{dstack}->[0]->{objs} }, $_[1];
    };

    my %dfa = (
        begin => sub {
            if ( ${ $_[1] } =~ m/^#!([^\n]*)[\n](.*)/s ) {
                ${ $_[1] } = $2;
                $append_obj->(
                    $_[0],
                    bless { column => 3, line => 1, string => $1 },
                    BASE . 'Shabang'
                );
                $_[0]->{line}++;
            }
        },
        ends => {
            script => sub {
                $_[0]->{output} = shift @{ $_[0]->{dstack} };
            },
        },
    );

    my %begins = (
        script   => { class => 'Script',   objs   => 1 },
        block    => { class => 'Block',    objs   => 1 },
        _command => { class => 'Command',  objs   => 1 },
        comment  => { class => 'Comment',  string => 1, position => 1 },
        field    => { class => 'Field',    objs   => 1 },
        bareword => { class => 'Bareword', string => 1, position => 1 },
        escape   => { class => 'Escape',   string => 1, position => 1 },
        single_quote => {
            class  => 'SingleQuote',
            string => 1
        },
        _double_quote => {
            class => 'DoubleQuote',
            objs  => 1
        },
        variable => {
            class    => 'Variable',
            string   => 1,
            length   => 1,
            position => 1
        },
        _paramiter => {
            class    => 'Paramiter',
            objs     => 1,
            position => 1
        },
        substring => {
            class    => 'Substring',
            objs     => 1,
            position => 1
        },
        use_default => {
            class    => 'UseDefault',
            objs     => 1,
            position => 1
        },
        assign_default => {
            class    => 'AssignDefault',
            objs     => 1,
            position => 1
        },
        display_error => {
            class    => 'DisplayError',
            objs     => 1,
            position => 1
        },
        use_alternate => {
            class    => 'UseAlternate',
            objs     => 1,
            position => 1
        },
        _case => {
            class    => 'Case',
            objs     => 1,
            position => 1,
            length   => 5
        },
        given      => { class => 'Given', objs => 1 },
        case_block => {
            class    => 'CaseBlock',
            objs     => 1,
            position => 1
        },
        case_condition => {
            class    => 'CaseCondition',
            objs     => 1,
            position => 1
        },
        _paramiter_keys => {
            class    => 'Keys',
            objs     => 1,
            position => 1
        },
        _paramiter_length => {
            class    => 'Length',
            objs     => 1,
            position => 1
        },
    );
    while ( my ( $k, $v ) = each %begins ) {
        my $code = 'sub { unshift @{ $_[0]->{dstack} }, bless { ';
        $code .= 'column => $_[0]->{column} + ' . ( $v->{length} || 0 ) . ', '
          if ( $v->{position} );
        $code .= 'line => $_[0]->{line}, ' if ( $v->{position} );
        $code .= q/string => '', /         if ( $v->{string} );
        $code .= 'objs => [], '            if ( $v->{objs} );
        $code .= "}, BASE . '$v->{class}' }";
        $dfa{begins}->{$k} = eval $code;
    }

    $dfa{ends}->{$_} ||= sub {
        my $obj = shift @{ $_[0]->{dstack} };
        $append_obj->( $_[0], $obj )
          if ( $obj->isa( BASE . 'DoubleQuote' )
            || !exists $obj->{objs}
            || @{ $obj->{objs} } );
      }
      foreach ( keys %begins );

    my $shift = sub { $_[0]->shift() };
    my %regex = (
        any            => qr/./s,
        whitespace     => qr/[ \t\n]/,
        spacetab       => qr/[ \t]/,
        end_of_command => qr/[;\n]/,
    );

    $transitions{_9900_default} = [
        [
            ['*'],
            $regex{any},
            sub {
                my ( $s, $c ) = @_;
                $s->unshift('block')
                  if ( $s->{stack}->[0] eq 'script' );
                $s->unshift('_command')
                  if ( $s->{stack}->[0] eq 'block' );
                $s->unshift('field')
                  if ( $s->{stack}->[0] eq '_command'
                    || $s->{stack}->[0] eq '_paramiter'
                    || $s->{stack}->[0] eq 'use_default'
                    || $s->{stack}->[0] eq 'display_error'
                    || $s->{stack}->[0] eq 'assign_default'
                    || $s->{stack}->[0] eq 'use_alternate'
                    || $s->{stack}->[0] eq 'case_condition'
                    || 0 );
                $s->unshift('bareword')
                  if ( $s->{stack}->[0] eq 'field'
                    || $s->{stack}->[0] eq 'given'
                    || 0 );
                $append_char->( $s, $c );
              }
        ],
    ];

    $transitions{_1500_case} = [
        [
            [qw( case )],
            $regex{spacetab},
            sub {
                $_[0]->shift();
                $_[0]->unshift('_case');
                $_[0]->unshift('given_pre');
              }
        ],
        [
            [qw( case )],
            $regex{any},
            sub {
                my ($s) = @_;
                $s->shift();
                $s->unshift('_command')
                  if ( $s->{stack}->[0] eq 'block' );
                $s->unshift('field')
                  if ( $s->{stack}->[0] eq '_command'
                    || $s->{stack}->[0] eq '_paramiter'
                    || $s->{stack}->[0] eq 'use_default'
                    || $s->{stack}->[0] eq 'display_error'
                    || $s->{stack}->[0] eq 'assign_default'
                    || $s->{stack}->[0] eq 'use_alternate'
                    || 0 );
                $s->unshift('bareword')
                  if ( $s->{stack}->[0] eq 'field' );
                $append_char->( $s, 'case' );
            },
            1
        ],
        [
            [qw( cas )],
            qr/e/,
            sub {
                $_[0]->shift();
                $_[0]->unshift('case');
              }
        ],
        [
            [qw( cas )],
            $regex{any},
            sub {
                my ($s) = @_;
                $s->shift();
                $s->unshift('_command')
                  if ( $s->{stack}->[0] eq 'block' );
                $s->unshift('field')
                  if ( $s->{stack}->[0] eq '_command'
                    || $s->{stack}->[0] eq '_paramiter'
                    || $s->{stack}->[0] eq 'use_default'
                    || $s->{stack}->[0] eq 'display_error'
                    || $s->{stack}->[0] eq 'assign_default'
                    || $s->{stack}->[0] eq 'use_alternate'
                    || 0 );
                $s->unshift('bareword')
                  if ( $s->{stack}->[0] eq 'field' );
                $append_char->( $s, 'cas' );
            },
            1
        ],
        [
            [qw( ca )],
            qr/s/,
            sub {
                $_[0]->shift();
                $_[0]->unshift('cas');
              }
        ],
        [
            [qw( ca )],
            $regex{any},
            sub {
                my ($s) = @_;
                $s->shift();
                $s->unshift('_command')
                  if ( $s->{stack}->[0] eq 'block' );
                $s->unshift('field')
                  if ( $s->{stack}->[0] eq '_command'
                    || $s->{stack}->[0] eq '_paramiter'
                    || $s->{stack}->[0] eq 'use_default'
                    || $s->{stack}->[0] eq 'display_error'
                    || $s->{stack}->[0] eq 'assign_default'
                    || $s->{stack}->[0] eq 'use_alternate'
                    || 0 );
                $s->unshift('bareword')
                  if ( $s->{stack}->[0] eq 'field' );
                $append_char->( $s, 'ca' );
            },
            1
        ],
        [
            [qw( c )],
            qr/a/,
            sub {
                $_[0]->shift();
                $_[0]->unshift('ca');
              }
        ],
        [
            [qw( c )],
            $regex{any},
            sub {
                my ($s) = @_;
                $s->shift();
                $s->unshift('_command')
                  if ( $s->{stack}->[0] eq 'block' );
                $s->unshift('field')
                  if ( $s->{stack}->[0] eq '_command'
                    || $s->{stack}->[0] eq '_paramiter'
                    || $s->{stack}->[0] eq 'use_default'
                    || $s->{stack}->[0] eq 'display_error'
                    || $s->{stack}->[0] eq 'assign_default'
                    || $s->{stack}->[0] eq 'use_alternate'
                    || 0 );
                $s->unshift('bareword')
                  if ( $s->{stack}->[0] eq 'field' );
                $append_char->( $s, 'c' );
            },
            1
        ],
    ];

    $transitions{_1500_esac} = [
        [
            [qw( esac )],
            qr/[ \t;\n]/,
            sub {
                $_[0]->shift();
                $_[0]->shift();
                $_[0]->shift();
              }
        ],
        [
            [qw( esac )],
            $regex{any},
            sub {
                $_[0]->shift();
                $_[0]->unshift('field');
                $_[0]->unshift('bareword');
                $append_char->( $_[0], 'esac' );
            },
            1
        ],
        [
            [qw( esa )],
            qr/c/,
            sub {
                $_[0]->shift();
                $_[0]->unshift('esac');
              }
        ],
        [
            [qw( esa )],
            $regex{any},
            sub {
                $_[0]->shift();
                $_[0]->unshift('field');
                $_[0]->unshift('bareword');
                $append_char->( $_[0], 'esa' );
            },
            1
        ],
        [
            [qw( es )],
            qr/a/,
            sub {
                $_[0]->shift();
                $_[0]->unshift('esa');
              }
        ],
        [
            [qw( es )],
            $regex{any},
            sub {
                $_[0]->shift();
                $_[0]->unshift('field');
                $_[0]->unshift('bareword');
                $append_char->( $_[0], 'es' );
            },
            1
        ],
        [
            [qw( e )],
            qr/s/,
            sub {
                $_[0]->shift();
                $_[0]->unshift('es');
              }
        ],
        [
            [qw( e )],
            $regex{any},
            sub {
                $_[0]->shift();
                $_[0]->unshift('field');
                $_[0]->unshift('bareword');
                $append_char->( $_[0], 'e' );
            },
            1
        ],
        [
            [qw( is_e )],
            qr/e/,
            sub {
                $_[0]->shift();
                $_[0]->unshift('e');
              }
        ],
        [ [qw( is_e )], $regex{whitespace} ],
        [ [qw( is_e )], $regex{any}, $shift, 1 ],
    ];

    $transitions{_1500_end_condition_block} = [
        [
            [qw( is_end_condition_block )],
            qr/;/,
            sub {
                $_[0]->shift();
                $_[0]->shift();
                $_[0]->unshift('case_condition');
                $_[0]->unshift('is_e');
              }
        ],
        [ [qw( is_end_condition_block )], $regex{any}, $shift, 1 ],
    ];

    $transitions{_1500_given_pre} = [
        [ [qw( given_pre )], $regex{whitespace} ],
        [
            [qw( given_pre )],
            $regex{any},
            sub {
                $_[0]->shift();
                $_[0]->unshift('given');
            },
            1
        ],
    ];

    $transitions{_3500_given_in} = [
        [
            [qw( given_in )],
            $regex{whitespace},
            sub {
                $_[0]->shift();
                $_[0]->unshift('case_block');
                $_[0]->unshift('case_condition');
                $_[0]->unshift('is_e');
              }
        ],
        [
            [qw( given_in )],
            $regex{any},
            sub {
                confess "syntax error near unexpected token `in$_[1]'";
              }
        ],
        [
            [qw( given_i )],
            qr/n/,
            sub {
                $_[0]->shift();
                $_[0]->unshift('given_in');
              }
        ],
        [
            [qw( given_i )],
            $regex{any},
            sub {
                confess "syntax error near unexpected token `i$_[1]'";
              }
        ],
        [ [qw( given_is_i )], $regex{whitespace} ],
        [
            [qw( given_is_i )],
            qr/i/,
            sub {
                $_[0]->shift();
                $_[0]->unshift('given_i');
              }
        ],
        [
            [qw( given_is_i )],
            $regex{any},
            sub {
                confess "syntax error near unexpected token `$_[1]'";
              }
        ],
    ];

    $transitions{_7500_case} = [
        [
            [qw( script block )],
            qr/c/,
            sub {
                $_[0]->unshift('block')
                  if ( $_[0]->{stack}->[0] eq 'script' );
                $_[0]->unshift('c');
              }
        ],
    ];

    $transitions{_5000_case} = [
        [
            [qw( child:case_condition )],
            qr/\)/,
            sub {
                $_[0]->shift()
                  until ( $_[0]->{stack}->[0] eq 'case_condition' );
                $_[0]->shift();
                $_[0]->unshift('block');
              }
        ],
    ];

    $transitions{_1500_paramiter} = [
        [
            ['paramiter_first'],
            qr/!/,
            sub {
                $_[0]->shift();
                $_[0]->unshift('_paramiter_keys');
              }
        ],
        [
            ['paramiter_first'],
            qr/#/,
            sub {
                $_[0]->shift();
                $_[0]->unshift('_paramiter_length');
              }
        ],
        [
            ['paramiter_first'],
            $regex{any},
            sub {
                $_[0]->shift();
            },
            1
        ],
        [
            ['paramiter_colon'],
            qr/[0-9]/,
            sub {
                $_[0]->shift();
                $_[0]->unshift('substring');
              }
        ],
        [
            ['paramiter_colon'],
            qr/-/,
            sub {
                $_[0]->shift();
                $_[0]->unshift('use_default');
              }
        ],
        [
            ['paramiter_colon'],
            qr/=/,
            sub {
                $_[0]->shift();
                $_[0]->unshift('assign_default');
              }
        ],
        [
            ['paramiter_colon'],
            qr/\?/,
            sub {
                $_[0]->shift();
                $_[0]->unshift('display_error');
              }
        ],
        [
            ['paramiter_colon'],
            qr/\+/,
            sub {
                $_[0]->shift();
                $_[0]->unshift('use_alternate');
              }
        ],
        [
            ['child:_paramiter'],
            qr/}/,
            sub {
                my ( $s, $c ) = @_;
                $s->shift() until ( $s->{stack}->[0] eq '_paramiter' );
                $s->shift();
              }
        ],
    ];

    $transitions{_7500_paramiter} = [
        [
            ['child:_paramiter'],
            qr/:/,
            sub {
                $_[0]->shift() until ( $_[0]->{stack}->[0] eq '_paramiter' );
                $_[0]->unshift('paramiter_colon');
              }
        ],
    ];

    $transitions{_1500_variable} = [
        [ ['variable'], qr/[a-zA-Z0-9_]/, $append_char ],
        [ ['variable'], $regex{any}, $shift, 1 ],
    ];

    $transitions{_1500_dollar} = [
        [
            ['dollar'],
            qr/{/,
            sub {
                $_[0]->shift();
                $_[0]->unshift('_paramiter');
                $_[0]->unshift('paramiter_first');
              }
        ],
        [
            ['dollar'],
            qr/[a-zA-Z_]/,
            sub {
                $_[0]->shift();
                $_[0]->unshift('variable');
                $append_char->( $_[0], $_[1] );
              }
        ],
        [
            ['dollar'],
            $regex{any},
            sub {
                my ( $s, $c ) = @_;
                $s->shift();
                $s->unshift('bareword')
                  if ( $s->{stack}->[0] eq 'field'
                    || $s->{stack}->[0] eq 'given'
                    || $s->{stack}->[0] eq '_double_quote'
                    || 0 );
                $append_char->( $_[0], '$' );
            },
            1
        ],
    ];

    $transitions{_3000_dollar} = [
        [
            [
                qw(script              child:_command
                  child:_double_quote child:_paramiter
                  child:field         block
                  child:given)
            ],
            qr/\$/,
            sub {
                my ($s) = @_;
                $s->shift()
                  until ($s->{stack}->[0] eq 'script'
                      || $s->{stack}->[0] eq 'block'
                      || $s->{stack}->[0] eq '_command'
                      || $s->{stack}->[0] eq '_double_quote'
                      || $s->{stack}->[0] eq '_paramiter'
                      || $s->{stack}->[0] eq 'field'
                      || $s->{stack}->[0] eq 'given'
                      || 0 );
                $s->unshift('block')
                  if ( $s->{stack}->[0] eq 'script' );
                $s->unshift('_command')
                  if ( $s->{stack}->[0] eq 'block' );
                $s->unshift('field')
                  if ( $s->{stack}->[0] eq '_command'
                    || $s->{stack}->[0] eq '_double_quote'
                    || $s->{stack}->[0] eq '_paramiter'
                    || 0 );
                $s->unshift('dollar');
              }
        ],
    ];

    $transitions{_1500_comment} = [
        [ ['comment'], qr/\n/, $shift ],
        [ ['comment'], $regex{any}, $append_char ],
    ];

    $transitions{_3000_comment} = [
        [
            [
                qw(script block _command _paramiter is_e
                  given_is_i case_condition )
            ],
            qr/#/,
            sub {
                # Signals end of command, does not end
                # a paramiter, is_e, or given_is_i
                $_[0]->shift() if ( $_[0]->{stack}->[0] eq '_command' );
                $_[0]->unshift('comment');
              }
        ],
    ];

    $transitions{_1500_single_quote} = [
        [ ['single_quote'], qr/'/, $shift ],
        [ ['single_quote'], $regex{any}, $append_char ],
    ];

    $transitions{_7500_single_quote} = [
        [
            ['*'],
            qr/'/,
            sub {
                my ($s) = @_;
                $s->unshift('block')
                  if ( $s->{stack}->[0] eq 'script' );
                $s->unshift('_command')
                  if ( $s->{stack}->[0] eq 'block' );
                $s->unshift('field')
                  if ( $s->{stack}->[0] eq '_command'
                    || $s->{stack}->[0] eq '_paramiter'
                    || $s->{stack}->[0] eq 'use_default'
                    || $s->{stack}->[0] eq 'display_error'
                    || $s->{stack}->[0] eq 'assign_default'
                    || $s->{stack}->[0] eq 'use_alternate'
                    || $s->{stack}->[0] eq 'case_condition'
                    || 0 );
                $s->shift()
                  if ( $s->{stack}->[0] eq 'bareword' );
                $s->unshift('single_quote');
              }
        ],
    ];

    $transitions{_1500_escape} = [
        [
            ['escape'], $regex{any},
            sub { $append_char->( $_[0], $_[1] ); $_[0]->shift(); }
        ],
    ];
    $transitions{_3000_escape} = [
        [
            [
                qw(
                  script block _command field bareword
                  _double_quote _paramiter use_default
                  display_error assign_default use_alternate given )
            ],
            qr/\\/,
            sub {
                my ($s) = @_;
                $s->unshift('block')
                  if ( $s->{stack}->[0] eq 'script' );
                $s->unshift('_command')
                  if ( $s->{stack}->[0] eq 'block' );
                $s->unshift('field')
                  if ( $s->{stack}->[0] eq '_command'
                    || $s->{stack}->[0] eq '_paramiter'
                    || $s->{stack}->[0] eq 'use_default'
                    || $s->{stack}->[0] eq 'display_error'
                    || $s->{stack}->[0] eq 'assign_default'
                    || $s->{stack}->[0] eq 'use_alternate'
                    || 0 );
                $s->shift()
                  if ( $s->{stack}->[0] eq 'bareword' );
                $s->unshift('escape');
              }
        ],
    ];

    $transitions{_4000_double_quote} = [
        [
            ['child:_double_quote'],
            qr/"/,
            sub {
                $_[0]->shift() until ( $_[0]->{stack}->[0] eq '_double_quote' );
                $_[0]->shift();
              }
        ],
        [
            ['child:_double_quote'],
            $regex{any},
            sub {
                my ( $s, $c ) = @_;
                $s->unshift('field')
                  if ( $s->{stack}->[0] eq '_double_quote' );
                $s->unshift('bareword')
                  if ( $s->{stack}->[0] eq 'field' );
                $append_char->( $s, $c );
              }
        ],
    ];

    $transitions{_7500_double_quote} = [
        [
            ['*'],
            qr/"/,
            sub {
                my ($s) = @_;
                $s->unshift('block')
                  if ( $s->{stack}->[0] eq 'script' );
                $s->unshift('_command')
                  if ( $s->{stack}->[0] eq 'block' );
                $s->unshift('field')
                  if ( $s->{stack}->[0] eq '_command'
                    || $s->{stack}->[0] eq '_paramiter'
                    || $s->{stack}->[0] eq 'use_default'
                    || $s->{stack}->[0] eq 'display_error'
                    || $s->{stack}->[0] eq 'assign_default'
                    || $s->{stack}->[0] eq 'use_alternate'
                    || $s->{stack}->[0] eq 'case_condition'
                    || 0 );
                $s->shift()
                  if ( $s->{stack}->[0] eq 'bareword' );
                $s->unshift('_double_quote');
              }
        ],
    ];

    $transitions{_5000_command} = [
        [
            [qw( script block child:_command )],
            $regex{end_of_command},
            sub {
                my ($s) = @_;
                $s->shift()
                  until ($s->{stack}->[0] eq '_command'
                      || $s->{stack}->[0] eq 'block'
                      || $s->{stack}->[0] eq 'script'
                      || 0 );
                $s->shift() if ( $s->{stack}->[0] eq '_command' );
                $s->unshift('is_end_condition_block')
                  if ( $_[1] eq ';'
                    && $s->{stack}->[0] eq 'block'
                    && $s->{stack}->[1] eq 'case_block' );
              }
        ],
    ];

    $transitions{_5010_field} = [
        [
            ['*'],
            $regex{whitespace},
            sub {
                my ($s) = @_;
                $s->shift() if ( $s->{stack}->[0] eq 'bareword' );
                $s->shift() if ( $s->{stack}->[0] eq 'field' );
                if ( $s->{stack}->[0] eq 'given' ) {
                    $s->shift();
                    $s->unshift('given_is_i');
                }
              }
        ],
    ];

    push @{ $dfa{transitions} }, @{ $transitions{$_} }
      foreach ( sort keys %transitions );

    $obj ||= {};
    $obj->{dfa} ||= MarpaX::Languages::Bash::AST::DFA->new( \%dfa );
    return bless $obj, $class;
}

sub parse {
    my $ret = $_[0]->{dfa}->parse( $_[1] );
    return defined $ret->can('second_pass') ? $ret->second_pass() : $ret;
}

1;

package MarpaX::Languages::Bash::AST::DFA;

sub new {
    my ( $class, $obj ) = @_;
    $obj->{output} ||= [];
    $obj->{stack}  ||= [];
    $obj->{flags}  ||= [];
    $obj->{dstack} ||= [ [] ];
    bless $obj, $class;
    $obj->unshift( $obj->{start} || 'script' )
      unless ( @{ $obj->{stack} } );
    delete $obj->{start};
    return $obj;
}

sub parse {
    my ( $self, $input ) = @_;

    delete $self->{output};
    $self->{line} = 1;
    &{ $self->{begin} }( $self, \$input )
      if ( $self->{begin} );
    while ( $input =~ /(.)/gs ) {
        my $c = $1;
        if ( $c eq "\n" ) {
            $self->{line}++;
            $self->{column} = 0;
        } elsif ( $c eq "\t" ) {
            $self->{column} += ( $self->{tabs_at} || 8 ) -
              $self->{column} % ( $self->{tabs_at} || 8 );
        } else {
            $self->{column}++;
        }

        foreach my $t ( @{ $self->{transitions} } ) {
            next
              unless (
                grep {
                    # Start new quote if within paramiter or end previous quote
                    if (/^child:(.*)$/) {
                        my $is       = $1;
                        my $stackctr = 0;
                        (
                            sub {
                                while ( my $try =
                                    $self->{stack}->[ $stackctr++ ] )
                                {
                                    return 1 if ( $try eq $is );
                                    return 0 if ( $try =~ /^_/ );
                                }
                            }
                        )->();
                    } elsif ( $_ eq $self->{stack}->[0] ) {
                        1;
                    } elsif ( $_ eq '*' ) {
                        1;
                    } elsif ( @{ $self->{flags} } ) {
                        my $m = $_;
                        grep { $m eq $_ } @{ $self->{flags} };
                    } else {
                        0;
                    }
                } @{ $t->[0] }
              );
            next unless ( $c =~ $t->[1] );
            &{ $t->[2] }( $self, $c )
              if ( $t->[2] );
            last unless ( $t->[3] );
        }
    }

    $self->shift() while ( @{ $self->{stack} } );
    $self->unshift('script');
    return $self->{output};
}

sub shift {
    my $self = shift;
    my $str  = shift @{ $self->{stack} };
    &{ $self->{ends}->{$str} }($self)
      if ( $self->{ends}->{$str} );
}

sub unshift {
    my ( $self, $str ) = @_;
    &{ $self->{begins}->{$str} }($self)
      if ( $self->{begins}->{$str} );
    unshift @{ $self->{stack} }, $str;
}

sub fadd {
    my ( $self, $str ) = @_;
    push @{ $self->{flags} }, $str;
}

sub fdel {
    my ( $self, $str ) = @_;
    @{ $self->{flags} } = grep { $_ ne $str } @{ $self->{flags} };
}

1;

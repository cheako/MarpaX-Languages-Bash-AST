use common::sense;

package MarpaX::Languages::Bash::AST::Obj::Common;

sub second_pass {
    my ($self) = @_;
    return $self unless exists $self->{objs};
    @{ $self->{objs} } = map {
        if ( $_->can('second_pass') ) {
            my $o = $_->second_pass();
            ( $o == 0 ) ? undef : $o;
        } else {
            $_;
        }
    } @{ $self->{objs} };
    return $self;
}

1;

package MarpaX::Languages::Bash::AST::Obj::Script;
use parent qw(-norequire MarpaX::Languages::Bash::AST::Obj::Common);
1;

package MarpaX::Languages::Bash::AST::Obj::Block;
use parent qw(-norequire MarpaX::Languages::Bash::AST::Obj::Common);
1;

package MarpaX::Languages::Bash::AST::Obj::Command;
use parent qw(-norequire MarpaX::Languages::Bash::AST::Obj::Common);

sub second_pass {
    my $self = shift;
    my @objs = @{ $self->{objs} };

    if ( @objs == 1 ) {
        if ( $objs[0]->can('command_only') ) {
            my $o = $objs[0]->command_only(@_);
            return $o if ($o);
        }
    }

    for ( my $i = 0 ; $i > $#objs ; $i++ ) {
        if ( $objs[$i]->can('is_first') ) {
            if ( $objs[$i]->is_first() ) {

            }
        } else {
            last;
        }
    }

    return $self->SUPER::second_pass(@_);
}

1;

package MarpaX::Languages::Bash::AST::Obj::Comment;
use parent qw(-norequire MarpaX::Languages::Bash::AST::Obj::Common);
1;

package MarpaX::Languages::Bash::AST::Obj::Field;
use parent qw(-norequire MarpaX::Languages::Bash::AST::Obj::Common);

sub command_only {
    my $self = shift;

    if (
        $self->{objs}->[0]->isa('MarpaX::Languages::Bash::AST::Obj::Bareword') )
    {
        if ( $self->{objs}->[0]->{string} =~ /([a-zA-Z_][a-zA-Z0-9_]*)=(.*)/ ) {
            my ( $var, $val ) = ( $1, $2 );
            shift @{ $self->{objs} };
            unshift @{ $self->{objs} }, bless { string => $val },
              'MarpaX::Languages::Bash::AST::Obj::Bareword';
            return bless {
                variable => $var,
                objs     => $self->{objs},
              },
              'MarpaX::Languages::Bash::AST::Obj::Assignment';
        }
    }

    return undef;
}
1;

package MarpaX::Languages::Bash::AST::Obj::Bareword;
use parent qw(-norequire MarpaX::Languages::Bash::AST::Obj::Common);
1;

package MarpaX::Languages::Bash::AST::Obj::Shabang;
use parent qw(-norequire MarpaX::Languages::Bash::AST::Obj::Common);
1;

package MarpaX::Languages::Bash::AST::Obj::DoubleQuote;
use parent qw(-norequire MarpaX::Languages::Bash::AST::Obj::Common);
1;

package MarpaX::Languages::Bash::AST::Obj::SingleQuote;
use parent qw(-norequire MarpaX::Languages::Bash::AST::Obj::Common);
1;

package MarpaX::Languages::Bash::AST::Obj::Keys;
use parent qw(-norequire MarpaX::Languages::Bash::AST::Obj::Common);
1;

package MarpaX::Languages::Bash::AST::Obj::Paramiter;
use parent qw(-norequire MarpaX::Languages::Bash::AST::Obj::Common);
1;

package MarpaX::Languages::Bash::AST::Obj::Variable;
use parent qw(-norequire MarpaX::Languages::Bash::AST::Obj::Common);
1;

package MarpaX::Languages::Bash::AST::Obj::Length;
use parent qw(-norequire MarpaX::Languages::Bash::AST::Obj::Common);
1;

package MarpaX::Languages::Bash::AST::Obj::Substring;
use parent qw(-norequire MarpaX::Languages::Bash::AST::Obj::Common);
1;

package MarpaX::Languages::Bash::AST::Obj::UseDefault;
use parent qw(-norequire MarpaX::Languages::Bash::AST::Obj::Common);
1;

package MarpaX::Languages::Bash::AST::Obj::AssignDefault;
use parent qw(-norequire MarpaX::Languages::Bash::AST::Obj::Common);
1;

package MarpaX::Languages::Bash::AST::Obj::DisplayError;
use parent qw(-norequire MarpaX::Languages::Bash::AST::Obj::Common);
1;

package MarpaX::Languages::Bash::AST::Obj::UseAlternate;
use parent qw(-norequire MarpaX::Languages::Bash::AST::Obj::Common);
1;

package MarpaX::Languages::Bash::AST::Obj::Case;
use parent qw(-norequire MarpaX::Languages::Bash::AST::Obj::Common);
1;

package MarpaX::Languages::Bash::AST::Obj::Given;
use parent qw(-norequire MarpaX::Languages::Bash::AST::Obj::Common);
1;

package MarpaX::Languages::Bash::AST::Obj::CaseBlock;
use parent qw(-norequire MarpaX::Languages::Bash::AST::Obj::Common);
1;

package MarpaX::Languages::Bash::AST::Obj::CaseCondition;
use parent qw(-norequire MarpaX::Languages::Bash::AST::Obj::Common);
1;

package MarpaX::Languages::Bash::AST::Obj::Assignment;
use parent qw(-norequire MarpaX::Languages::Bash::AST::Obj::Common);
1;

package MarpaX::Languages::Bash::AST::Obj::Subshell;
use parent qw(-norequire MarpaX::Languages::Bash::AST::Obj::Common);
1;

package MarpaX::Languages::Bash::AST::Obj::And;
use parent qw(-norequire MarpaX::Languages::Bash::AST::Obj::Common);
1;

package MarpaX::Languages::Bash::AST::Obj::Or;
use parent qw(-norequire MarpaX::Languages::Bash::AST::Obj::Common);
1;

package MarpaX::Languages::Bash::AST::Obj::If;
use parent qw(-norequire MarpaX::Languages::Bash::AST::Obj::Common);
1;

package MarpaX::Languages::Bash::AST::Obj::Elsif;
use parent qw(-norequire MarpaX::Languages::Bash::AST::Obj::Common);
1;

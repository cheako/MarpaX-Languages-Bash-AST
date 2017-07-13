use common::sense;

use Test::More tests => 1;

use MarpaX::Languages::Bash::AST;
use constant BASE => 'MarpaX::Languages::Bash::AST::Obj::';

my $grammar = MarpaX::Languages::Bash::AST->new();

my $value_ref;

$value_ref = $grammar->parse( <<'EOI' );
echo "$PS1"
EOI

is_deeply $value_ref, undef, 'Variable in double quote';

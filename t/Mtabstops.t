use common::sense;

use Test::More tests => 7;

use MarpaX::Languages::Bash::AST;
use constant BASE => 'MarpaX::Languages::Bash::AST::Obj::';

my $grammar = MarpaX::Languages::Bash::AST->new();

my $value_ref;

$value_ref = $grammar->parse( <<'EOI' );
	:
       	:
        	:
         	:
                	:
		:
        		:
EOI

is $value_ref->{objs}->[0]->{objs}->[0]->{objs}->[0]->{objs}->[0]->{column}, 9,
  'One tab';
is $value_ref->{objs}->[0]->{objs}->[1]->{objs}->[0]->{objs}->[0]->{column}, 9,
  'Seven spaces and one tab';
is $value_ref->{objs}->[0]->{objs}->[2]->{objs}->[0]->{objs}->[0]->{column}, 17,
  'Eight spaces and one tab';
is $value_ref->{objs}->[0]->{objs}->[3]->{objs}->[0]->{objs}->[0]->{column}, 17,
  'Nine spaces and one tab';
is $value_ref->{objs}->[0]->{objs}->[4]->{objs}->[0]->{objs}->[0]->{column}, 25,
  'Sixteen spaces one tab';
is $value_ref->{objs}->[0]->{objs}->[5]->{objs}->[0]->{objs}->[0]->{column},
  17, 'Two tabs';
is $value_ref->{objs}->[0]->{objs}->[6]->{objs}->[0]->{objs}->[0]->{column}, 25,
  'Eight spaces and two tabs';

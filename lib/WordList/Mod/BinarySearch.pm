package WordList::Mod::BinarySearch;

# DATE
# VERSION

use strict 'subs', 'vars';
use warnings;

our @patches = (
    ['word_exists', 'replace', sub {
         require File::SortedSeek;

         my ($self, $word) = @_;

         my $pkg = ref($self);

         my $dyn = ${"$pkg\::DYNAMIC"};
         die "Can't binary search on a dynamic wordlist" if $dyn;

         my $fh = \*{"$pkg\::DATA"};
         my $sort = ${"$pkg\::SORT"} || "";

         my $tell;
         if ($sort && $sort =~ /num/) {
             $tell = File::SortedSeek::numeric($fh, $word);
         } elsif (!$sort) {
             $tell = File::SortedSeek::alphabetic($fh, $word);
         } else {
             die "Wordlist is not ascibetically/numerically sort (sort=$sort)";
         }

         chomp(my $line = <$fh>);
         defined($line) && $line eq $word;
     }],
);

1;
# ABSTRACT: Provide word_exists() that uses binary search

=head1 SYNOPSIS

 use WordList::Mod qw(get_mod_wordlist);
 my $wl = get_mod_wordlist("EN::Foo", "BinarySearch");
 say $wl->word_exists("foo"); # uses binary searching


=head1 DESCRIPTION

This mod provides an alternative C<word_exists()> method that performs binary
searching instead of the default linear.


=head1 SEE ALSO

L<File::SortedSeek>

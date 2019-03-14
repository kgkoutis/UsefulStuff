#!/usr/local/Cellar/perl/5.28.1/bin/perl

use strict;
use English;
use Const::Fast;
use Getopt::Long;
use Math::Random;
 
my $pwd_length = 8;
my $num_pwds = 6;
my $seed_phrase = 'TOO MANY SECRETS';
my %opts = ('password_length=i' => \$pwd_length,
            'num_passwords=i' => \$num_pwds,
            'seed_phrase=s' => \$seed_phrase,
            'help!' => sub {command_line_help(); exit 0;});
if (! GetOptions(%opts)) {command_line_help(); exit 1; }
$num_pwds >= 1 or die "Number of passwords must be at least 1";
$pwd_length >= 4 or die "Password length must be at least 4";
random_set_seed_from_phrase($seed_phrase);
 
const my @lcs    => 'a' .. 'z';
const my @ucs    => 'A' .. 'Z';
const my @digits => 0 .. 9;
const my $others => q{!"#$%&'()*+,-./:;<=>?@[]^_{|}~};
# Oh syntax highlighter, please be happy once more "
foreach my $i (1 .. $num_pwds) {
    print gen_password(), "\n";
}
exit 0;
 
sub gen_password {
    my @generators = (\&random_lc, \&random_uc, \&random_digit, \&random_other);
    my @chars = map {$ARG->()} @generators;  # At least one char of each type.
    for (my $j = 0; $j < $pwd_length - 4; $j++) {
        my $one_of_four = random_uniform_integer(1, 0, 3);
        push @chars, $generators[$one_of_four]->();
    }
    return join(q{}, random_permutation(@chars));
}
 
sub random_lc {
    my $idx = random_uniform_integer(1, 0, scalar(@lcs)-1);
    return $lcs[$idx];
}
 
sub random_uc {
    my $idx = random_uniform_integer(1, 0, scalar(@ucs)-1);
    return $ucs[$idx];
}
 
sub random_digit {
    my $idx = random_uniform_integer(1, 0, scalar(@digits)-1);
    return $digits[$idx];
}
 
sub random_other {
    my $idx = random_uniform_integer(1, 0, length($others)-1);
    return substr($others, $idx, 1);
}
 
sub command_line_help {
    print "Usage: $PROGRAM_NAME ",
          "[--password_length=<l> (default: $pwd_length)] ",
          "[--num_passwords=<n> (default: $num_pwds)] ",
          "[--seed_phrase=<s> (default: $seed_phrase)] ",
          "[--help]\n";
    return;
}

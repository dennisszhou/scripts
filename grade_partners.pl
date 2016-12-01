#!/usr/bin/perl
use strict;
use warnings;

use File::Find;

sub max ($$) { $_[$_[0] < $_[1]] }

my $handin_directory = "/u/c/s/cs537-1/handin/";

my $partners = {};
my $grades = {};
my $correct_file_loc = {};
my @student_list = ();

# deductions
my $deduc_wrong_file_loc = 3;

# limit the depth for find traversal
sub pp_depth {
  my $max_depth = shift;
  my $depth = $File::Find::dir =~ tr[/][];
  return @_ if $depth < $max_depth;
  return grep { not -d } @_ if $depth == $max_depth;
  return;
}

sub pp_partners {
  return pp_depth(9, @_);
}

sub find_partners {
  my $full_path = $File::Find::name;

  # find partner.login file in the project directory
  if (-f and $File::Find::name =~ ".*/([^/]+)/$ARGV[0](/.*)?/partner.login\$") {
    my ($partner1, $partner2) = ("", "");
    $partner1 = $1;

    $correct_file_loc->{$partner1} = 1 if (not defined $2);

    open my $file, '<', $full_path; 
    $partner2 = <$file>; 
    close $file;

    # empty partner file..
    return if (not defined $partner2 or $partner2 eq "");

    $partner2 = (split " ", $partner2)[-1];

    # index by alphabetical
    if ($partner1 gt $partner2) {
      my $temp = $partner1;
      $partner1 = $partner2;
      $partner2 = $temp;
    }

    $partners->{$partner1} = $partner2 unless (exists $partners->{$partner1});
  }
}

sub pp_students {
  return pp_depth(7, @_);
}

sub find_students {
  # depth == 6 is the depth of /u/c/s/cs537-1/handin/<section>
  my $depth = $File::Find::dir =~ tr[/][];
  if (-d and $depth == 6) {
    push @student_list, $_;
    $grades->{$_} = 0;
  }
}

find({
      preprocess  => \&pp_students,
      wanted      => \&find_students,
}, $handin_directory);

find({
      preprocess  => \&pp_partners,
      wanted      => \&find_partners,
}, $handin_directory);

@student_list = sort @student_list;

# find all points for students
foreach my $student (@student_list) {
  my $points = qx#cat ~cs537-1/handin/*/$student/$ARGV[0]/$ARGV[1]/runtests.log \\
      | grep --text Points | awk -F" " '{print \$2}'#;
  chomp $points;

  $grades->{$student} = $points;
}

# maximize each partners grade
foreach my $key (sort keys %{$partners}) {
  my $partner = $partners->{$key};

  next unless (exists $grades->{$key} and exists $grades->{$partner});

  my $grade = max($grades->{$key}, $grades->{$partner});
  $grades->{$key} = (exists $correct_file_loc->{$key})
      ? $grade : $grade - $deduc_wrong_file_loc;
  $grades->{$partner} = (exists $correct_file_loc->{$partner})
      ? $grade : $grade - $deduc_wrong_file_loc;
}

# print out scores
foreach my $student (@student_list) {
  my $roster = qx{grep -w "$student" /p/course/rosters/cs537-dusseau/cs537-001-*.roster \\
     | cut -d ":" -f2};
  chomp $roster;
  $roster =~ s/[\s]+/ /g;
  my $grade = ($grades->{$student} > 0) ? $grades->{$student} : 0;
  print $student . " " . $grade . " " . $roster . "\n";
}

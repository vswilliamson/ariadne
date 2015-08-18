#this script queries available databases for updates
use strict; 
use warnings;
# test if file has been accessed in last 30 days. 
my $directory = '/tmp';
opendir (DIR, $directory) or die $!;
if (-A $filename > 30) {
  print "$filename has not been accessed in at least 30 days\n";
}


while (my $file = readdir(DIR)) {
next if ($file =~ m/^\./);
print "$file\n";
}
closedir(DIR);

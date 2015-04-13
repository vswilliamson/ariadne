#!/usr/bin/perl
# this script acts as an interface with the desk ico to either query known databases or
#to run specific programs to determine individual SNP function
# problems?
#contact VS Williamson, Phd.
#Vernell.Williamson@vcuhealth.org

use strict;
use warnings; 
use CGI;
use CGI: Carp qw (fatals to Browser);
use Fcntl qw(:flock);

print header; 
print start_html ("Search Results")
print h2 ("Your Query")
my %form;
foreach my $p (param()){
  $form{$p} = param($p);
#insert results here:

  print "$p = $form{$p}<br>\n";
  
  }

print start_html("Upload Results");
print h2("Upload Results");

my $file = param('upfile');
unless ( $file ) {
    print "Nothing uploaded?<p>\n";
} else {
    print "Filename: $file<br>\n";
    my $ctype = uploadInfo($file)->{'Content-Type'};
    print "MIME Type: $ctype<br>\n";
    open( OUT, ">/tmp/outfile" )
      or &dienice("Can't open outfile for writing: $!");
    flock( OUT, LOCK_EX );
    my $file_len = 0;
    while ( read( $file, my $i, 1024 ) ) {
        print OUT $i;
        $file_len = $file_len + 1024;
        if ( $file_len > 1024000 ) {
            close(OUT);
            &dienice("Error - file is too large. Save aborted.<p>");
        }
    }
    close(OUT);
    print "File Size: ", $file_len / 1024, "KB<p>\n";
    print "File saved!<p>\n";
}

print end_html;

sub dienice {
    my ($msg) = @_;
    print "<h2>Error</h2>\n";
    print "$msg<p>\n";
    exit;
}
#!/usr/bin/perl -wT
use CGI qw(:standard);
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use Fcntl qw(:flock :seek);
use strict;

print header;
print start_html("Kite Catalog - Search Results");
print qq(<h2>Search Results</h2>\n);

my $keyword = param('keyword');
print qq(<p>Results for search of `$keyword':</p>\n);

open(INF,"data2.db") or &dienice("Can't open data.db: $! \n");
flock(INF, LOCK_SH);    # shared lock
seek(INF, 0, SEEK_SET); # rewind to beginning
my @data = <INF>;                # read the entire file
close(INF);

my @results = grep(/$keyword/i, @data);
my $num = @results;
if ($num) {
   print qq(<form action="order.cgi" method="POST"\n);
   foreach my $i (@results) {
       my ($stocknum,$name,$instock,$price,$category) = 
split(/\|/,$i);
       print qq(<input type="text" name="$stocknum" size=5> $name - \$$price<p>\n);
   }
   print qq(<input type="submit" value="Order!">\n);
   print qq(<p>$num kites found.</p>\n);
} else {
   print qq(<p>No kites found.</p>\n);
}

print end_html;

sub dienice {
    my($msg) = @_;
    print "<h2>Error</h2>\n";
    print $msg;
    exit;
}

  
  # subroutine to run SNV through polyphen software
  sub polyphen{
    
    }
  # subrountine to query COSMIC database
  sub cosmic {}
  
  
  #subroutine to query ESP database
  sub esp {}
  # subrountine to convert SNP location to proper build format.
  sub liftover{}
  
  

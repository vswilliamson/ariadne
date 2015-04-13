#!/usr/bin/perl
# this script acts as an interface with the desk ico to either query known databases or
#to run specific programs to determine individual SNP function
# problems?
#contact VS Williamson, Phd.
#Vernell.Williamson@vcuhealth.org

use strict;
use warnings; 
use CGI;
use CGI: Carp qw (fatals to Browser)
print header; 
print start_html ("Search Results")
print h2 ("Your Query")
my %form;
foreach my $p (param()){
  $form{$p} = param($p);
#insert results here:

  print "$p = $form{$p}<br>\n";
  
  }

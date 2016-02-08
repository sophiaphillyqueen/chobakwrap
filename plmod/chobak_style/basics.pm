package chobak_style::basics;
use strict;
use chobak_style::tmplt;
use chobak_style::dlog::cls;
use chobak_fnc;

sub load {
  my $this;
  my $lc_found;
  my $lc_dth;
  my $lc_pthvar;
  $this = shift;
  
  $lc_pthvar = $this->{'path'};
  
  
  if ( ! ( &chobak_fnc::pathfind($_[0],$lc_pthvar,$lc_found) ) )
  {
    my $lc2_ech;
    $lc_dth = "\nFATAL ERROR: '" . $_[0] . "' not found on path:\n";
    foreach $lc2_ech (@$lc_pthvar)
    {
      $lc_dth .= '   ' . $lc2_ech . "\n";
    }
    $lc_dth .= "\n";
    die $lc_dth;
  }
  
  $this->{'tmpl'}->{$_[1]} = &chobak_style::tmplt::new($lc_found);
}

sub dlog {
  my $this;
  my $lc_ret;
  $this = shift;
  
  $lc_ret = chobak_style::dlog::cls->__raw_new;
  $lc_ret->{'var'} = {};
  $lc_ret->{'tmpl'} = $this;
  
  return $lc_ret;
}

1;

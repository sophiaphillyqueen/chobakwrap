package chobxml::toolk::basics;
use strict;

#use Data::Dumper;


sub lm_start {
  my $lc_hand;
  my $lc_lem;
  my %lc_prm;
  my $lc_mth;
  my $lc_misca;
  my $lc_tagdata;  # Scratch-pad between opening and closing of the tag
  my $lc_stacklem; # The tag's stack element
  
  ($lc_hand,$lc_lem,%lc_prm) = @_;
  $lc_misca = {};
  
  $lc_mth = $lc_hand->{'chobak_inf'}->{'tagset'}->{'tag_m_on'}->{$lc_lem};
  if ( ref($lc_mth) ne "CODE" )
  {
    $lc_mth = $lc_hand->{'chobak_inf'}->{'tagset'}->{'tag_g_on'};
  }
  
  # Create the stack element:
  $lc_tagdata = {};
  $lc_stacklem = {};
  $lc_stacklem->{'type'} = 'tag';
  $lc_stacklem->{'pram'} = \%lc_prm;
  $lc_stacklem->{'data'} = $lc_tagdata;
  # Stack the stack element:
  {
    my $lc2_a;
    $lc2_a = $lc_hand->{'chobak_inf'}->{'stack'};
    @$lc2_a = (@$lc2_a,$lc_stacklem);
  }
  
  # Fill the Second Argument:
  $lc_misca->{'handle'} = $lc_hand;
  $lc_misca->{'element'} = $lc_lem;
  $lc_misca->{'param'} = \%lc_prm;
  $lc_misca->{'text'} = "";
  $lc_misca->{'tagdata'} = $lc_stacklem->{'data'};
  $lc_misca->{'toolk'} = $lc_hand->{'chobak_inf'}->{'toolk'};
  $lc_misca->{'tagset'} = $lc_hand->{'chobak_inf'}->{'tagset'};
  
  return &$lc_mth($lc_hand->{'chobak_inf'}->{'data'},$lc_misca);
}

sub lm_end {
  my $lc_hand;
  my $lc_lem;
  my $lc_mth;
  my $lc_misca;
  my $lc_stklc;
  my $lc_stacklem;
  
  ($lc_hand,$lc_lem) = @_;
  $lc_misca = {};
  
  # Retrieve the stack element:
  $lc_stklc = $lc_hand->{'chobak_inf'}->{'stack'};
  $lc_stacklem = pop(@$lc_stklc);
  while ( $lc_stacklem->{'type'} ne 'tag' )
  {
    # Here do whatever else ...
    
    if ( $lc_stacklem->{'type'} eq 'toolk' )
    {
      $lc_hand->{'chobak_inf'}->{'tagset'} = $lc_stacklem->{'tagset'};
      $lc_hand->{'chobak_inf'}->{'toolk'} = $lc_stacklem->{'toolk'};
    }
    
    
    $lc_stacklem = pop(@$lc_stklc);
  }
  
  # Pick the Method to Use
  $lc_mth = $lc_hand->{'chobak_inf'}->{'tagset'}->{'tag_m_off'}->{$lc_lem};
  if ( ref($lc_mth) ne "CODE" )
  {
    $lc_mth = $lc_hand->{'chobak_inf'}->{'tagset'}->{'tag_g_off'};
  }
  
  $lc_misca->{'handle'} = $lc_hand;
  $lc_misca->{'element'} = $lc_lem;
  $lc_misca->{'param'} = {};
  $lc_misca->{'text'} = "";
  $lc_misca->{'tagdata'} = $lc_stacklem->{'data'};
  $lc_misca->{'toolk'} = $lc_hand->{'chobak_inf'}->{'toolk'};
  $lc_misca->{'tagset'} = $lc_hand->{'chobak_inf'}->{'tagset'};
  
  return &$lc_mth($lc_hand->{'chobak_inf'}->{'data'},$lc_misca);
}

sub lm_char {
  my $lc_hand;
  my $lc_misca;
  my $lc_char;
  my $lc_mth;
  
  ($lc_hand,$lc_char) = @_;
  $lc_misca = {};
  
  $lc_mth = $lc_hand->{'chobak_inf'}->{'data'}->{'fnc'}->{'char'};
  
  $lc_misca->{'handle'} = $lc_hand;
  $lc_misca->{'element'} = "";
  $lc_misca->{'param'} = {};
  $lc_misca->{'text'} = $lc_char;
  $lc_misca->{'tagdata'} = {}; # This element is only here at all for consistency's sake
  $lc_misca->{'toolk'} = $lc_hand->{'chobak_inf'}->{'toolk'};
  $lc_misca->{'tagset'} = $lc_hand->{'chobak_inf'}->{'tagset'};
  
  return &$lc_mth($lc_hand->{'chobak_inf'}->{'data'},$lc_misca);
}

sub nosuchtag_on {
  my $lc_msg;
  $lc_msg = "\nNO SUCH TAG: ";
  $lc_msg .= $_[1]->{'element'};
  $lc_msg .= ": (can not open)\n\n";
  die $lc_msg;
}

sub nosuchtag_off {
  my $lc_msg;
  $lc_msg = "\nNO SUCH TAG: ";
  $lc_msg .= $_[1]->{'element'};
  $lc_msg .= ": (can not close)\n\n";
  die $lc_msg;
}

sub parse_init {
  # Argument 0 to an init function: The tagset element of the toolk object:
  # Argument 1 to an init function: The input (be it scalar or reference)
  my $lc_a;
  $lc_a = {};
  
  # The $X->{'fnc'}->{'char'} must be defined by every init function.
  $lc_a->{'fnc'} = {}; # Dynamic method's hash
  $lc_a->{'fnc'}->{'char'} = $_[0]->{'char'}->{'dflt'};
  
  return $lc_a;
}

sub parse_flush {
  # Arg #0 = The parser object itself
}


1;

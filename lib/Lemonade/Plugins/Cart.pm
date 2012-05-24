package Lemonade::Plugins::Cart;

use strict;
use warnings;
use Moose;


=head2 juice

Contains lemonade session object.
  
=cut 

has 'juice' => (
    is => 'rw',
    lazy => 1,
    default => ''
);


sub BUILD{
  my ($class, $params) = @_;

  $class->juice($params->{session});

  #create cart ref in session on build
  $class->juice->{carts} = {
    default => {}
  };

  return;
}

no Moose;

=head2 add

Retrieve's cart ref from $self->session.
Params:
    fetch_all - returns hashref containing all carts
    name - fetch specifc cart from $self->session
    
=cut 

sub retrieve {
  my ($self, $params) = @_;
  my $carts = $self->juice->{carts};
  
  return $carts if $params->{fetch_all};
  $carts->{$params->{name} or 'default'};
}

=head2 add

Adds an item to the cart.

=cut 


sub add {
  my ($self, $params) = @_;

  return unless $params->{sku};

  $params->{name} or $params->{name} = 'default';

  return delete $params->{sku} unless $params->{quantity};

  $self->retrieve({ name => $params->{name} })->{$params->{sku}}->{quantity} += 
      $params->{quantity};
}

=head2 delete

Deletes an item from the cart. 
Wrapper to add method force appending
a quantity of zero.

=cut 

sub delete {
  shift->add({ sku => shift->{sku}, quantity => 0 });
}

=head2 subtotal

Returns subtotal of all items.
Params:
    name: Name of the cart to total
    price_scheme: The pricing value to use
    
=cut 

sub cart_subtotal {
  my ($self, $params) = @_;
  
  my $cart = $self->retrieve({ name => $params->{name} || 'default' });
  
  my $subtotal = 0;
  
  my $schema = $params->{price_scheme} || 'retail_price';
  
  $subtotal += $_->{$schema} * $_->{quantity}
       for (@$cart);
  return sprintf("%.02f", $subtotal);
}

sub test{
  my ($cart, $lemonade)  = @_;

  return $cart->juice->{id};
}

=head1 AUTHOR

Nick Piscitelli (oddesey) <mail@nickpiscitelli.com>

=head1 LICENSE AND COPYRIGHT

Copyright 2010-2011 Lemonade Stand <lemonade@lemonade-stand.com>.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

1;
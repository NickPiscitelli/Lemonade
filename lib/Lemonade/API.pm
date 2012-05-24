# Lemonade::API
# 
# Copyright (C) 2012 Lemonade-Stand Development Group
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public
# License along with this program; if not, write to the Free
# Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston,
# MA  02110-1301  USA.

package Lemonade::API;
use strict;
no warnings qw(uninitialized numeric);

use Moose;
use Lemonade::Plugin;

=head1 cart

cart namespace for lemonade object.
Gives access to cart object. 

($?)lemonade->cart

=cut

has 'cart' => (
    isa => 'Lemonade::Plugins::Cart',
    is => 'ro',
    lazy => 1,
    default => sub {
        require Lemonade::Plugins::Cart;
        Lemonade::Plugins::Cart->new( session => $_[0]->session );
    }
);

=head1 session

Session namespace for lemonade object.
session was taken. Gives access to
session module. 

($?)lemonade->session

=cut

has 'session' => (
    is => 'rw',
    lazy => 1,
    default => sub {
        #this probably needs to be changed
        #it works for now. 
        shift; return shift;
    }
);

=head1 dbh

Database namespace for lemonade object.
Gives access to active DBH.

($?)lemonade->dbh

=cut

has 'dbh' => (
    is => 'ro',
    lazy => 1,
    default => sub {
        #this probably needs to be changed
        #it works for now. 
        shift; shift;
    },
);

=head1 account

User namespace for lemonade object.

($?)lemonade->account

=cut

has 'account' => (
    isa => 'Lemonade::Plugins::Account',
    is => 'ro',
    lazy => 1,
    default => sub {
        require Lemonade::Plugins::Account;
        Lemonade::Plugins::Account->new( session => $_[0]->session );
    },
);

sub initialize_plugins {
    has $_->attribute_definition for (Lemonade::Plugin->list);
    return 1;
}

no Moose;

1;

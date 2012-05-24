=head1 NAME

Lemonade::Plugins::Account - Default account plugin for Lemonade Platform.

Provides basic functionality to access and modify user data within Lemonade
namespace. 

=cut

package Lemonade::Plugins::Account;

use strict;
use warnings;
use Moose;

=head2 session

Contains lemonade session object.
  
=cut 

has 'session' => (
  is => 'rw',
  lazy => 1,
  default => ''
);

=head2 logged_in

Boolean containing active
account state.
  
=cut 

has 'logged_in' => (
  is => 'rw',
  lazy => 1,
  default => ''
);

=head2 user_attributes

HashRef containing keys
to initialize for user
session.
  
=cut 

has 'user_attributes' =>(
  is => 'rw',
  isa => 'HashRef',
  lazy => 1,
  default => sub {
    return {
      map{
        $_ => ''
      } (qw/
        first_name 
        last_name 
        address 
        address2 
        city 
        state 
        zip 
        phone 
      /)
    }
  }
);

sub BUILD{
  my ($class, $params) = @_;

  $class->session($params->{session});

  #create user ref in session on build
  $class->session->{user} = $class->user_attributes;

  return;
}

no Moose;

=head2 add

Retrieve's user ref from $self->session
Params:
  key: Return specific value corresponding 
  to key

=cut 

sub retrieve {
  my ($self, $key) = @_;
  return $key ? 
    $self->session->{user} :
    $self->session->{user}->{$key};
}

=head2 update

Update user values

Params:
  opt:
    HashRef:
      overrides all existing 
      keys with corresponding 
      values

    Array:
      Treated as list as key value
      pairs

Usage Examples:

  $self->update('first_name', 'nick');

  $self->update('first_name', 'nick', 'address', 'ok');

  $self->update({
    first_name => 'nick',
    city => 'Timbucktoo'
  });

=cut 


sub update {
  my ($self, $opt) = (shift, shift);

  if (ref $opt and ref $opt eq 'HASH'){
    for (keys %$opt){
      $self->session->{user}->{$_} = $opt->{$_}
        if exists $self->session->{user}->{$_};
    }
  }else{
    for (my @new = @_){
      last unless $opt;
       $self->session->{user}->{$opt} = shift
        if exists $self->session->{user}->{$opt};
      $opt = shift;
    }
  }

  return;
}

=head2 login

Login the current user.

Awaiting DBH and DB to complete.

Usage Examples:

  $self->login('nick', 'oh so secret');

  $self->login({
    username => 'nick',
    password => 'oh so secret'
  });


=cut

sub login{
  my ($self, $opt) = (shift, shift);

  #NOTE: Funciton will not function until
  #account model exists!
  
  if (ref $opt and ref $opt eq 'HASH'){
    return unless $opt->{name} && $opt->{password};
    return $self->logged_in(
      $self->account_model->check_user($opt)
    );
  }
  
  my $passwd;
  return unless $opt and $passwd = shift;

  $self->logged_in(
    $self->account_model->check_user({
      name => $opt,
      password => $passwd,
    })
  );

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
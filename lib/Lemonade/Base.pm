# Lemonade::Base
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

package Lemonade::Base;
use strict;
no warnings qw(uninitialized numeric);

use Moose;
use Lemonade::Plugin;

sub initialize_plugins {
    has $_->attribute_definition for (Lemonade::Plugin->list);
    return 1;
}

no Moose;

1;

# Lemonade::Plugin
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

package Lemonade::Plugin;

use strict;
use warnings;
use File::Spec;
use Cwd ();

sub search_path {
    #doesn't actually work yet
    return Cwd::realpath( File::Spec->catfile('root', 'lib') );
}

use Module::Pluggable search_dirs => [__PACKAGE__->search_path], search_path => ['Lemonade::Plugin'], 'require' => 1, inner => 0;

my $test_mode;

sub list {
    return $test_mode ? map { $_->test_class } shift->plugins : shift->plugins;
}

sub activate_test_mode {
    return $test_mode = 1;
}

1;

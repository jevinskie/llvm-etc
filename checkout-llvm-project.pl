#!/usr/bin/env perl

use Modern::Perl;
use Cwd;
use Data::Dumper;

use constant LLVM_GIT_BASE => "http://llvm.org/git/";

use constant MY_GIT_BASE => "git\@github.com:jevinskie/llvm-";

use constant REPOS => [
	["llvm", ""],
	["compiler-rt", "/projects/compiler-rt"],
	["libcxx", "/projects/libcxx"],
	["libcxxabi", "/projects/libcxxabi"],
	["test-suite", "/projects/test-suite"],
	["lld", "/tools/lld"],
	["lldb", "/tools/lldb"],
	["polly", "/tools/polly"],
	["clang", "/tools/clang"],
	["clang-tools-extra", "/tools/clang/tools/extra"],
];

my $cmd;

my $basename = $ARGV[0];

say "basename: $basename";

for my $repo (@{&REPOS}) {
	my $name = @$repo[0];
	my $location = @$repo[1];
	say "name: $name location: $location";
	$cmd = "git clone " . MY_GIT_BASE . "$name.git $basename$location";
	say "cmd: $cmd";
	system($cmd) == 0 or die "system failed: $?";
	$cmd = "git --git-dir=$basename$location/.git remote add upstream " . LLVM_GIT_BASE . "$name.git";
	say "cmd: $cmd";
	system($cmd) == 0 or die "system failed: $?";
	$cmd = "git --git-dir=$basename$location/.git config branch.master.rebase true";
	say "cmd: $cmd";
	system($cmd) == 0 or die "system failed: $?";
	$cmd = "git --git-dir=$basename$location/.git fetch --all";
	say "cmd: $cmd";
	system($cmd) == 0 or die "system failed: $?";
}


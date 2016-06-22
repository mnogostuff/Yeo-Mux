# This is specific to fedora, please add to it
@NORMAL_LIBS=("libc.so.6",
	      "linux-vdso.so.1",
	      "/lib64/ld-linux-x86-64.so.2");

@NORMAL_PATH = ("/usr/local/bin",
		"/usr/bin",
		"/bin",
		"/usr/local/games",
		"/usr/games",
		"/usr/local/sbin",
		"/usr/sbin");

@LOADED_LIBS = split('\n',`ldd \$(which gzip)`);
@LOADED_PATH = split(':', $ENV{"PATH"});
my %params = map { $_ => 1 } @NORMAL_LIBS;

foreach(@LOADED_LIBS) {
    $_ =~ s/^\s+//;
    $_ =~ s/(.*?)\s.*/\1/;
    if(!exists($params{$_})) {
	print "SUSPICIOUS LIB: $_\n";
    }
}

my %params = map { $_ => 1 } @NORMAL_PATH;
foreach(@LOADED_PATH) {
    if(!exists($params{$_})) {
	print "SUSPICIOUS PATH: $_\n";
    }
}

if ($ENV{"LD_PRELOAD"}) {
    print "<!> LD_PRELOAD IS SET TO: ",$ENV{"LD_PRELOAD"}, "\n";
}

if (-e "/etc/ld.so.preload") {
    print "<!> /etc/ld.so.preload EXISTS\n";
}

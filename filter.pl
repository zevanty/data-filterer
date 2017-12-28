use Getopt::Long;
use Pod::Usage;

my $NAME = "Data Filterer";
my $VERSION = "1.0.0";

my $file;
my %keep;
my %filter;
my @inputFilters = ();
my @inputKeep = ();
my $ignoreRows = 0;
my $caseInsensitive = 0;
my $help = 0;

GetOptions(
	"file:s" => \$file,
	"filter:s" => \@inputFilters,
	"keep:s" => \@inputKeep,
	"ignoreheaders:s" => \$ignoreRows,
	"caseinsensitive" => \$caseInsensitive,
	"help" => \$help
);

if ($help) {
	print $NAME . ", version " . $VERSION . "\n";
	pod2usage(
		-input   => "man.pod",
		-verbose => 1,
		-exitval => 0
	);
	exit(0);
}
elsif (!$file) {
	die "Please provide a file\n";
}
elsif ($ignoreRows && $ignoreRows !~ /^[1-9]\d*$/) {
	die "ignoreheaders must be a number\n";
}

if (scalar(@inputFilters)) {
	foreach (@inputFilters) {
		$filter{$_} = 1;
	}
}
else {
	die "No filter specified. Nothing to do.\n";
}

if (scalar(@inputKeep)) {
	foreach (@inputKeep) {
		$keep{$_} = 1;
	}
}
$file =~ /(.+)\.([^\.]*)$/i;
my $newFile = $1."-filtered.".$2;
open FILE, "< $file"  || die "please provide a file";
open OUTFILE, "> $newFile";

my $i = 0;
my $fullLine = "";
while (my $line = <FILE>) {
	if ($ignoreRows && $i < $ignoreRows) {
		print OUTFILE "$line";
		$i++;
		next;
	}

	#If line starts with a space, assume it is continuation of previous line.
	if ($line =~ /^\s/) {
		$fullLine .= $line;
	}
	else {
		#If this is the very first line read, just store it.
		if ($fullLine eq "") {
			$fullLine = $line;
		}
		#Else if we reached a "new line", just evaluate the previous "full line", then store the current new line and start processing.
		else {
			print OUTFILE "$fullLine" if isValid($fullLine);
			$fullLine = $line;
		}
	}
	
	if (eof && isValid($fullLine)) {
		print OUTFILE "$fullLine";
	}
}
close(FILE);
close(OUTFILE);

sub regexEscape {
	my $str = shift;
	$str =~ s/([\.\^\$\*\+\?\(\)\[\]\{\}\\\/\|])/\\$1/g;
	return $str;
}

sub isValid {
	my $line = shift;
	my $valid = 1;
	foreach my $currFilter (keys %filter) {
		$currFilter = regexEscape($currFilter);
		if (($caseInsensitive && $line =~ /$currFilter/i) || (!$caseInsensitive && $line =~ /$currFilter/)) {
			$valid = 0;
			last;
		}
	}
	foreach my $currKeep (keys %keep) {
		if (($caseInsensitive && $line =~ /$currKeep/i) || (!$caseInsensitive && $line =~ /$currKeep/)) {
			$valid = 1;
			last;
		}
	}
	
	return $valid;
}

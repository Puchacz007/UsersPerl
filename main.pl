package main;

use strict;
use warnings;
use Tk;
use Digest::SHA qw(sha512_base64);
use Tie::File;
use Scalar::Util qw( looks_like_number);
use constant USERS_DB   => 'UsersDB';

my $mw      = MainWindow->new;

my @lines = load_records(USERS_DB);
    my $lb    = $mw->Listbox(
        -relief  => 'sunken',
        -height  => 5,
        -width   => 50,
        -setgrid => 1,
    )->pack( -side => 'left', -padx => 1 );
    foreach (@lines) {
        $lb->insert( 'end', $_ );

    }
    my $scroll = $mw->Scrollbar( -command => [ 'yview', $lb ] );
    $lb->configure( -yscrollcommand => [ 'set', $scroll ] );
    $lb->pack( -side => 'left', -fill => 'both', -expand => 1 );
    $scroll->pack( -side => 'left', -fill => 'y' );


my $top;
my $button1 = $mw->Button(
    -text    => 'Create New User',
    -command => sub {
       
       if ( !Exists($top) ) {
           $top = $mw->Toplevel;
        newUser($top);
         }
    }
)->pack( -padx => 10, -pady => 5 );
my $button2 = $mw->Button(
    -text    => 'Modify user groups',
    -command => sub {
       
       if ( !Exists($top) ) {
           $top = $mw->Toplevel;
        modifyUserGroups($top);
         }
    }
    )->pack( -padx => 10, -pady => 5 );
  my $button3 = $mw->Button(
    -text    => "Copy file to home catalogue",
    -command => sub {
       
    if ( !Exists($top) ) {
           $top = $mw->Toplevel;
        copyFile($top);
         }
         }
    
     
    
    )->pack( -padx => 10, -pady => 5 );
my $button4 = $mw->Button(
    -text    => 'Delete user',
    -command => sub {
       
       if ( !Exists($top) ) {
           $top = $mw->Toplevel;
        
         }
    }
)->pack( -padx => 10, -pady => 5 );
my $quit = $mw->Button(
    -text    => 'Quit',
    -command => sub { exit },
)->pack( -padx => 10, -pady => 5 );
MainLoop;

sub newUser {
    my ($top) = @_;
    $top->Label(
        -text => "Please write down user UID\nor leave empty to generate it" )
      ->pack( -padx => 40 );
    my $uid = $top->Entry()->pack( -padx => 40 );
    $top->Label( -text => "Please write down your login" )->pack( -padx => 40 );
    my $login = $top->Entry()->pack( -padx => 40 );
    $top->Label( -text => "Please write down your password" )
      ->pack( -padx => 40 );
      my $password="";
    my $passwordEntry = $top->Entry()->pack( -padx => 40 );
    
    
    
    
    
    
     $button1 = $top->Button(
        -text    => 'Generate password',
        -command => sub {
		$password="";
	for (my $i=0; $i <= 9; $i++)
        {
		 my @generator = ('a'..'z','A'..'Z','0'..'9');
		
		$password =join("",$password,$generator[int rand @generator]);
		
		}    
		$passwordEntry->configure(-textvariable =>$password );
        }
    )->pack( -padx => 40, -pady => 5 );
    
    
    
    
    
    $top->Button(
        -text    => 'Save user',
        -command => sub {
	if(add_new_record(USERS_DB,$uid->get,$login->get,$password) && $password ne "" && $login->get ne "")
            {
            $top->destroy;
    }else
    {
           my  $errorMessage = $top->Toplevel;
               $errorMessage->Label( -text => "Not Unique UID or no password or no login" )->pack( -padx => 40 );
               my $close= $errorMessage->Button(
    -text    => 'close',
    -command => sub {$errorMessage->destroy; },
)->pack( -padx => 40, -pady => 5 );
	    }
        }
    )->pack( -padx => 40, -pady => 5 );
 
}

sub saveNewUser{
     my ($uid,$login,$password) = @_;
    
    
    }
    
    
    
    sub modifyUserGroups{
	     my ($top) = @_;
	    
	    	    
	    	    my $top2;
	    	      my $topLb    = $top->Listbox(
        -relief  => 'sunken',
        -height  => 5,
        -width   => 20,
        -setgrid => 1,
    )->pack( -side => 'left', -padx => 1 );
    foreach (@lines) {
       $topLb->insert( 'end', $_ );

    }
    my $TopScroll = $top->Scrollbar( -command => [ 'yview', $topLb ] );
   $topLb->configure( -yscrollcommand => [ 'set',$TopScroll] );
    $topLb->pack( -side => 'left', -fill => 'both', -expand => 1 );
   $TopScroll->pack( -side => 'left', -fill => 'y' );
	    	    
	 
	 my $button1 = $top->Button(
    -text    => 'Add new user group',
    -command => sub {
       
       if ( !Exists($top2) ) {
           $top2 = $top->Toplevel;
        newUserGroup($top2);
         }
    }
)->pack( -padx => 10, -pady => 5 );   	
my $button2 = $top->Button(
    -text    => 'Delete group',
    -command => sub {
       
    }
)->pack( -padx => 10, -pady => 5 );   	   
	    }
    
 sub   newUserGroup{
	     my ($top) = @_;
	     $top->Label( -text => "Please write down new user group" )->pack( -padx => 40 );
    my $userGroup = $top->Entry()->pack( -padx => 40 );
   
	    
	  $button1 = $top->Button(
        -text    => 'Save user group',
        -command => sub {
	
            
            $top->destroy;
    
	    })->pack( -padx => 40, -pady => 5 );
    }
    
    
    
    sub copyFile{
	    my ($top) = @_;
	    $top->Label( -text => "Please write down file adress to copy file from" )->pack( -padx => 40 );
	      my $fileToCopy = $top->Entry()->pack( -padx => 40 );
	    $button1 = $top->Button(
        -text    => 'Apply',
        -command => sub {
	
            
            $top->destroy;
    
	    })->pack( -padx => 40, -pady => 5 );
    }
	    
    
    
    
    
    
    
    
    
    
    sub new_db {
    my ($db) = @_;
    if ( not -f $db ) {
        open my $out, '>', $db or die "Database $db opening failed\n";
        print  $out 0;
        close $out;
        return (0);
    }
    return (1);
}


sub add_new_record {
    my ( $db, $uid,$login,$password  ) = @_;
    my $bool = new_db($db);
    tie my @lines, "Tie::File", $db;
    my $temp=0;

   if($uid eq "")
   {
	     my $isUnique = 0;
	 
	  while(!$isUnique)
	 {
          $uid=$lines[0];
	 $lines[0]=$lines[0]+1;
		 $isUnique=1;
	   for my $line (@lines) {
                    my @data =split( '=>', $line );
		   if($data[0] == $uid)
		   {
			   $isUnique=0;
			   last;
			   }
		   }
		    
	   }
   }
	   else
	   {
		      for my $line (@lines) {
                    my @data =split( '=>', $line );
		   if($data[0] == $uid)
		   {
			   return(0);
			   }
		   }
}
  $password = sha512_base64($password);
   my $record;
       $record = join( '=>', $uid,$login,$password);  
    push @lines, "$record";
    untie @lines;
return(1);
}

##  TO CHANGE OR REMOVE
sub modify_record {
    my ( $db, $login, $status, $row ) = @_;

    tie my @lines, "Tie::File", $db;
    my @record = split( '=>', $lines[$row] );
    my $record = join( '=>',
        $record[0], $status, $record[2], $record[3], $record[4], $record[5] );
    $lines[$row] = $record;

    # my $date = strftime "%d/%m/%Y", localtime;
    #my $data = join( '=>', $login, $row, $status, $date );
    untie @lines;

    #add_new_record( CHANGES_DB, $data );

}

sub load_records {
    my ($db) = @_;
	my @lines=();
    if(not -f $db)
	{
	return @lines;
	}
    open my $file, '<', $db or die "Database $db opening failed";
    @lines = <$file>;
    close $file;
    chomp @lines;
    return @lines;
}

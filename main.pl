#!/usr/bin/perl 
package main;

use strict;
use warnings;
use Tk;
use Digest::SHA qw(sha512_base64);
use Tie::File;
use Scalar::Util qw( looks_like_number);

if ($#ARGV>=0 )

{
my $uid;
my $user;
my $password;
my $group;


for (my $i=0; $i <= $#ARGV; $i++) {
    
    if($i+1<=$#ARGV && $ARGV[$i] eq "-u")
    {
        $user=$ARGV[$i+1];
        $i++;
    }
    elsif($i+1<=$#ARGV && $ARGV[$i] eq "-p")
    {
        $password=$ARGV[$i+1];
        $i++;
    } elsif($i+1<=$#ARGV && $ARGV[$i] eq "-g")
    {
        $group=$ARGV[$i+1];
        $i++;
    }
     elsif($i+1<=$#ARGV && $ARGV[$i] eq "-uid")
    {
        $uid=$ARGV[$i+1];
        $i++;
    }
    elsif($ARGV[$i] eq "-userAdd")
    {
        if($user ne "")
        {
            if($password eq "")
            {
                for (my $i=0; $i <= 9; $i++)
                {
		        my @generator = ('a'..'z','A'..'Z','0'..'9');
		
		        $password =join("",$password,$generator[int rand @generator]);
		
		        }    
            }
            saveNewUser($uid,$user,$password);
        }
    } elsif($ARGV[$i] eq "-userDel" && $user ne "")
    {
        deleteUser($user);
    }elsif($i+1<=$#ARGV && $ARGV[$i] eq "-cp")
    {
        my $cmd =$ARGV[$i+1];
        system("cp $cmd /home/$user");
        $i++;
    }elsif($ARGV[$i] eq "-groupAdd" && $user ne "" && $group ne "")
    {
                my $cmd = "getent group $group";
                my $record = `$cmd`;
                if($record eq "")
                {
              system "groupadd $group";
                }
            system("usermod -a -G $group $user");
            
    }elsif($ARGV[$i] eq "-groupDel" && $user ne "" && $group ne "")
    {
    deleteFromGroup($user,$group);
    }elsif($ARGV[$i] eq "-showGroups")
    {
        system("getent group");
    }elsif($ARGV[$i] eq "-showUsers")
    {
        system("getent users");
    }else
    {
        print "All arguments to use :\n
        -u[USER] : user name\n
        -p[PASSWORD] : user password\n    
        -uid[UID] : user uid\n
        -g[GROUP] : user group\n
        -cp[FILE ADDRESS] : copy file to user home directory\n
        -userAdd : add new user(needs -u before) \n
        -userDel : del user(needs -u before)\n
        -groupAdd : add user to group(needs -u and -g before)\n
        -groupDel : delete group(needs -g)\n
        -showGroups : show groups\n
        -showUsers : show users\n";
        last;
    }
}

}else
{
my $mw      = MainWindow->new;

    my $lb    = $mw->Listbox(
        -relief  => 'sunken',
        -height  => 5,
        -width   => 50,
        -setgrid => 1,
    )->pack( -side => 'left', -padx => 1 );

    $lb->insert('end',"UID  USER");
    loadUsers($lb);
    my $scroll = $mw->Scrollbar( -command => [ 'yview', $lb ] );
    $lb->configure( -yscrollcommand => [ 'set', $scroll ] );
    $lb->pack( -side => 'left', -fill => 'both', -expand => 1 );
    $scroll->pack( -side => 'left', -fill => 'y' );


my $top;
my $button1 = $mw->Button(
    -text    => 'Create New User',
    -command => sub {
       
       if ( !Exists($top)) {
           $top = $mw->Toplevel;
        newUser($top,$lb);
         }
    }
)->pack( -padx => 10, -pady => 5 );
my $button2 = $mw->Button(
    -text    => 'Modify user groups',
    -command => sub {
     my @row = $lb->curselection;  
       if (defined $row[0] &&  !Exists($top)) {
           $top = $mw->Toplevel;
           tie my @lines, "Tie::File","/etc/passwd";
        my @record=split(':',$lines[$row[0]-1]);
        modifyUserGroups($top,$record[0]);
        untie @lines;
         }
    }
    )->pack( -padx => 10, -pady => 5 );
  my $button3 = $mw->Button(
    -text    => "Copy file to home catalogue",
    -command => sub {
     my @row = $lb->curselection;    
    if ( defined $row[0] && !Exists($top) ) {
        tie my @lines, "Tie::File","/etc/passwd";
        my @record=split(':',$lines[$row[0]-1]);
           $top = $mw->Toplevel;
        copyFile($top,$record[0]);
        untie @lines;
         }
         }
    
     
    
    )->pack( -padx => 10, -pady => 5 );
my $button4 = $mw->Button(
    -text    => 'Delete user',
    -command => sub {
        
     my @row = $lb->curselection;
     if(defined $row[0] && !Exists($top) )
     {
         
          tie my @lines, "Tie::File","/etc/passwd";
        my @record=split(':',$lines[$row[0]-1]);
                
                  deleteUser($record[0]);
                   untie @lines;
                refreshUsers($lb);
    }
    }
)->pack( -padx => 10, -pady => 5 );
my $quit = $mw->Button(
    -text    => 'Quit',
    -command => sub { exit },
)->pack( -padx => 10, -pady => 5 );
MainLoop;
}
sub newUser {
    my ($top,$lb) = @_;
    $top->Label(
        -text => "Please write down user UID\nor leave empty to generate it" )
      ->pack( -padx => 40 );
    my $uid = $top->Entry()->pack( -padx => 40 );
    $top->Label( -text => "Please write down your login" )->pack( -padx => 40 );
    my $user = $top->Entry()->pack( -padx => 40 );
    $top->Label( -text => "Please write down your password" )
      ->pack( -padx => 40 );
      my $password="";
    my $passwordEntry = $top->Entry()->pack( -padx => 40 );
    
    
    
    
    
    
   my  $button1 = $top->Button(
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
	if(checkUID($uid->get) && $password ne "" && $user->get ne "")
            {
            saveNewUser($uid->get,$user->get,$password);
            $top->destroy;
            refreshUsers($lb);
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
     my ($uid,$user,$password) = @_;
      $password = sha512_base64($password);
       my $cmd;
       if($uid ne "")
       {
      $cmd = qq(useradd -G cdrom,plugdev,shadow -m -s /bin/bash -u $uid -p $password $user);
       }else
       {
          my $temp = "getent group $user";
                my $record = `$temp`;
                if($record eq "")
                {
                    $cmd = qq(useradd -G cdrom,plugdev,shadow -m -s /bin/bash -p $password $user);
                }else
                {
                    $cmd = qq(useradd -g $user -G cdrom,plugdev,shadow -m -s /bin/bash -p $password $user);
                }
       }
       system $cmd;
    }
    
    
    
    sub modifyUserGroups{
	     my ($top,$user) = @_;
	    
	    	 my @lines;   
	    	    my $top2;
	    	      my $topLb    = $top->Listbox(
        -relief  => 'sunken',
        -height  => 5,
        -width   => 20,
        -setgrid => 1,
    )->pack( -side => 'left', -padx => 1 );
    

    
    my $TopScroll = $top->Scrollbar( -command => [ 'yview', $topLb ] );
   $topLb->configure( -yscrollcommand => [ 'set',$TopScroll] );
    $topLb->pack( -side => 'left', -fill => 'both', -expand => 1 );
   $TopScroll->pack( -side => 'left', -fill => 'y' );
	    loadGroups($topLb,$user);	    
	 
	 my $button1 = $top->Button(
    -text    => 'Add new group',
    -command => sub {
       
       if ( !Exists($top2) ) {
           $top2 = $top->Toplevel;
        addToGroup($top2,$user,$topLb);
         }
    }
)->pack( -padx => 10, -pady => 5 );   	
my $button2 = $top->Button(
    -text    => 'Delete from group',
    -command => sub {
        my @row = $topLb->curselection;
        if(defined $row[0])
        { 
       deleteFromGroup($user,$topLb->get($row[0]));
       refreshGroups($topLb,$user);
        }
    }
)->pack( -padx => 10, -pady => 5 );   	   
	    }    
    sub copyFile{
	    my ($top,$user) = @_;
	    $top->Label( -text => "Please write down file adress to copy file from" )->pack( -padx => 40 );
	      my $fileToCopy = $top->Entry()->pack( -padx => 40 );
	  my  $button1 = $top->Button(
        -text    => 'Apply',
        -command => sub {
            if($fileToCopy->get ne "" &&  -e $fileToCopy->get)
            {
            my $cmd = $fileToCopy->get;
            system("cp $cmd /home/$user");
            $top->destroy;
            }else
            {
           my  $errorMessage = $top->Toplevel;
               $errorMessage->Label( -text => "There is no such file" )->pack( -padx => 40 );
               my $close= $errorMessage->Button(
    -text    => 'close',
    -command => sub {$errorMessage->destroy; },
)->pack( -padx => 40, -pady => 5 );
            }
	    })->pack( -padx => 40, -pady => 5 );
    }
	    
    
    sub loadUsers {
        my ($lb)=@_;
    if(!open PASSWD, "/etc/passwd")
	{
		die "Problem with /etc/passwd!";
	}else
	{
		while(<PASSWD>)
		{
			chomp;
			my @array = split /:/, $_;
			my $data = "$array[2]     $array[0]";
			$lb -> insert("end",$data);		
		}
	}
	close PASSWD;
    }
    sub deleteUser
    {
        my($user)=@_;
        my $cmd = qq(userdel $user);
				system($cmd);
                system("rm -R /home/$user");
              
    }
    
    
    sub refreshUsers
    {
        my ($lb)=@_;
         $lb->delete( 0, 'end' );
         $lb->insert('end',"UID  USER");
        loadUsers($lb);
    }
    
sub checkUID
{
my ($uid)=@_;

if(!open PASSWD, "/etc/passwd")
		{
			die "Problem with /etc/passwd!";
		}
        else
        {
            if($uid eq "")
            {
                return(1);
            }
            while(<PASSWD>)
			{
				chomp;
				my @array = split /:/, $_;
				if($array[2] eq $uid)
                {
                    return (0);
                }			
			}


        }
        return (1);
}

sub loadGroups
{
    my ($lb,$user)=@_;
    my $groups = `groups $user`;
    my @array =split(':',$groups);
    @array=split(' ',$array[1]); 
    foreach (@array)
   { 
        $lb -> insert("end",$_);	
    }
}


sub addToGroup
{

my ($top,$user,$lb) = @_;
	    $top->Label( -text => "Please write down group name" )->pack( -padx => 40 );
	      my $groupEntry = $top->Entry()->pack( -padx => 40 );
	   my $button1 = $top->Button(
        -text    => 'Apply',
        -command => sub {
          my $groupName= $groupEntry->get;
            if($groupName ne "" )
            {
                my $cmd = "getent group $groupName";
                my $record = `$cmd`;
                if($record eq "")
                {
              system "groupadd $groupName";
                }
            system("usermod -a -G $groupName $user");
            refreshGroups($lb,$user);
            $top->destroy;
            
            }

            }
	    )->pack( -padx => 40, -pady => 5 );
     
}
sub deleteFromGroup
{
 my ($user,$group)=@_;
    system("deluser $user $group");
    my $cmd = "getent group $group";
    my $record = `$cmd`;
    my @array = split(":",$record);
    if($array[0] ne $group && $array[3] eq "\n")
    {
        system("groupdel $group");
    }
}
sub refreshGroups
{
my ($lb,$user)=@_;
 $lb->delete( 0, 'end' );
 loadGroups($lb,$user);
}
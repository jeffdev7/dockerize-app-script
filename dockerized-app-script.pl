#!/usr/bin/perl
use strict;
use warnings;
use File::Path qw(make_path);
use Cwd;

my $base_dir = getcwd();
my $dockerfile_local = "$base_dir/projects/therapy-clinic-api"; #yours might be different here
chdir $dockerfile_local;
my $path = '"$PATH:/root/.dotnet/tools"';

print "\n--------------------------------\n";
print "\n";
print "# 1 - Starting docker...\n";
print "\n";
print "---------------------------------\n";
system('"C:\\Program Files\\Docker\\Docker\\Docker Desktop.exe"');
sleep(20);

print "\n--------------------------------\n";
print "\n";
print "# 2 - Applying migration...\n";
print "\n";
print "---------------------------------\n";
system("dotnet ef migrations add scriptMigration --project clinic.data --startup-project clinic.MVC");
sleep(5);

print "\n--------------------------------\n";
print "\n";
print "# 3 - docker build...\n";
print "\n";
print "---------------------------------\n";
system("docker-compose build --no-cache");
sleep(5);

print "\n--------------------------------\n";
print "\n";
print "# 4 - Updating database... This step takes longer.\n";
print "# Since Perl waits for the command to complete you should type Ctrl+C so it skips to the next\n";
print "\n";
print "---------------------------------\n";
system("docker-compose run --rm clinic.mvc bash -c 'export PATH=$path && dotnet ef database update --project clinic.data --startup-project clinic.MVC'");

print "\n--------------------------------\n";
print "\n";
print "# 5 - docker compose... \n";
print "\n";
print "---------------------------------\n";
system("docker-compose up");

print "\n✅ Solution dockerized successfully!\n";
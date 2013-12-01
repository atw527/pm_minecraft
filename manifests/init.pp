class minecraft {
	group { 'bukkit':
		ensure => 'present',
		gid    => '1001',
	}

	user { 'bukkit':
		ensure           => 'present',
		gid              => '1001',
		home             => '/home/bukkit',
		password_max_age => '99999',
		password_min_age => '0',
		shell            => '/bin/bash',
		uid              => '1001',
		require          => Group["bukkit"],
		managehome       => true,
	}
	
	if ! defined(Package['openjdk-7-jre']) {
		package { 'openjdk-7-jre':
			ensure => installed,
		}
	}
	
	if ! defined(Package['screen']) {
		package { 'screen':
			ensure => installed,
		}
	}
	
	if ! defined(Package['rdiff-backup']) {
		package { 'rdiff-backup':
			ensure => installed,
		}
	}
	
	file { '/etc/init/bukkit.conf':
		ensure	=> file,
		source	=> 'puppet:///modules/minecraft/bukkit.conf',
		group   => '0',
		mode    => '644',
		owner   => '0',
	}
	
	file { '/etc/sudoers.d/bukkit':
		ensure  => 'file',
		source	=> 'puppet:///modules/minecraft/bukkit.sudo',
		group   => '0',
		mode    => '440',
		owner   => '0',
	}
	
	file { '/home/bukkit/minecraft':
		ensure => 'directory',
		group  => '1001',
		mode   => '775',
		owner  => '1001',
		require => User["bukkit"],
	}
	
	file { '/home/bukkit/mcbackup':
		ensure => 'directory',
		group  => '1001',
		mode   => '775',
		owner  => '1001',
		require => User["bukkit"],
	}
	
	file { '/home/bukkit/scripts':
		ensure => 'directory',
		group  => '1001',
		mode   => '775',
		owner  => '1001',
		require => User["bukkit"],
	}
	
	file { '/home/bukkit/scripts/mcbackup.sh':
		ensure  => 'file',
		source	=> 'puppet:///modules/minecraft/mcbackup.sh',
		group   => '1001',
		mode    => '775',
		owner   => '1001',
		require => File['/home/bukkit/scripts'],
	}
	
	file { '/home/bukkit/minecraft/minecraft_server.1.7.2.jar':
		ensure  => 'file',
		source	=> 'puppet:///modules/minecraft/minecraft_server.1.7.2.jar',
		group   => '1001',
		mode    => '664',
		owner   => '1001',
		require => File['/home/bukkit/minecraft'],
	}
	
	file { '/home/bukkit/minecraft/minecraft_server.jar':
		ensure => 'link',
		target => '/home/bukkit/minecraft/minecraft_server.1.7.2.jar',
		require => File['/home/bukkit/minecraft/minecraft_server.1.7.2.jar'],
	}
	
	file { '/home/bukkit/minecraft/ops.txt':
		ensure  => 'file',
		source	=> 'puppet:///modules/minecraft/ops.txt',
		group   => '1001',
		mode    => '664',
		owner   => '1001',
		require => File['/home/bukkit/minecraft'],
		notify  => Service['bukkit'],
	}
	
	file { '/home/bukkit/minecraft/server.properties':
		ensure  => 'file',
		source	=> 'puppet:///modules/minecraft/server.properties',
		group   => '1001',
		mode    => '664',
		owner   => '1001',
		require => File['/home/bukkit/minecraft'],
		notify  => Service['bukkit'],
	}
	
	file { '/var/spool/cron/crontabs/bukkit':
		ensure  => 'file',
		source	=> 'puppet:///modules/minecraft/bukkit.crontab',
		group   => '102',
		mode    => '600',
		owner   => '1001',
	}
	
	service { 'bukkit':
		ensure => 'running',
		enable => 'true',
		require => [ File['/home/bukkit/minecraft/minecraft_server.jar'],
		             Package['openjdk-7-jre'],
		             Package['screen'],
		             User['bukkit'],
		           ]
	}
}

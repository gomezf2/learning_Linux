
### Linux directories and their descriptions

/bin—Contains common Linux user commands, such as ls, sort, date, and chmod. 

/boot—Has the bootable Linux kernel and boot loader configuration fi les (GRUB). 

/dev—Contains fi les representing access points to devices on your systems. These include terminal devices (tty*), fl oppy disks (fd*), hard disks (hd* or sd*), RAM (ram*), and CD-ROM (cd*). Users can access these devices directly through these device fi les; however, applications often hide the actual device names from end users. 

/etc—Contains administrative configuration fi les. Most of these fi les are plaintext files that can be edited with any text editor if the user has proper permission. 

/home—Contains directories assigned to each regular user with a login account. (The root user is an exception, using /root as his or her home directory.) 

/media—Provides a standard location for automounting devices (removable media in particular). If the medium has a volume name, that name is typically used as the mount point. For example, a USB drive with a volume name of myusb would be mounted on /media/myusb. 

/lib—Contains shared libraries needed by applications in /bin and /sbin to boot the system. 

/mnt—A common mount point for many devices before it was supplanted by the stan dard 

/media directory. Some bootable Linux systems still use this directory to mount hard disk partitions and remote fi lesystems. Many people still use this directory to temporarily mount local or remote filesystems that are not mounted permanently. 

/misc—A directory sometimes used to automount filesystems upon request. 

/opt—Directory structure available to store add-on application software. 98 99 Chapter 4: Moving around the Filesystem 4 

/proc—Contains information about system resources. 

/root—Represents the root user’s home directory. The home directory for root does not reside beneath /home for security reasons. 

/sbin—Contains administrative commands and daemon processes. 

/tmp—Contains temporary fi les used by applications. 

/usr—Contains user documentation, games, graphical fi les (X11), libraries (lib), and a variety of other commands and fi les that are not needed during the boot process. The /usr directory is meant for fi les that don’t change after installation (in theory, /usr could be mounted read-only).

/var—Contains directories of data used by various applications. In particular, this is where you would place fi les that you share as an FTP server (/var/ftp) or a web server (/var/www). It also contains all system log fi les (/var/log) and spool files in /var/spool (such as mail, cups, and news). The /var directory contains directories and fi les that are meant to change often. On server computers, it is common to create the /var directory as a separate filesystem, using a filesystem type that can be easily expanded.


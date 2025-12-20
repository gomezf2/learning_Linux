
Use these exercises to test your knowledge and build confidence.  


1. List all processes running on your system, showing a full set of columns. Pipe that
output to the less command so that you can page through the list of processes.

2. List all processes running on the system and sort those processes by the name of
the user running each process.

3. List all processes running on the system, and display the following columns of
information: process ID, username, group name, virtual memory size, resident memory size, and the command.

4. Run the top command to view processes running on your system. Go back and
forth between sorting by CPU usage and memory consumption.

5. Start the `gedit` process from your desktop. Make sure that you run it as the user
you are logged in as. Use the System Monitor window to kill that process.

6. Run the `gedit` process again. This time, using the kill command, send a signal
to the `gedit` process that causes it to pause (stop). Try typing some text into the
`gedit` window and make sure that no text appears yet.

7. Use the `killall` command to tell the `gedit` command that you paused in the
previous exercise to continue working. Make sure that the text you type in after
`gedit` was paused now appears on the window.

8. Install the `xeyes` command (in Fedora, it is in the `xorg-x11`-apps package). Run
the `xeyes` command about 20 times in the background so that 20 `xeyes` windows appear on the screen. Move the mouse around and watch the eyes watch your
mouse pointer. When you have had enough fun, kill all `xeyes` processes in one
command using `killall`.

9. As a regular user, run the `gedit` command so that it starts with a nice value of 5.

10. Using the renice command, change the nice value of the `gedit` command you
just started to 7. Use any command you like to verify that the current nice value
for the `gedit` command is now set to 7.
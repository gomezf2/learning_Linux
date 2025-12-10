#learning #linux 

## Summary of what was learned
I have learned so far about different vi shortcuts which were pretty useful [[command line editing shortcuts]], you can see the screenshots here it has the vi keyboard shortcuts for navigation. Next, I am also learning about generally the power of command lines; the different combo’s, how they can be added together to make different outputs and things like pipes and stuff, but need to make another section for that. 


### Example of combined commands
This example, searches in a particular directory the output is piped into grep, which grep then searches for all instances of the file that you specify. Finally, it is then opened up in vi. Pretty sure you can add whichever text editor you want. 

`` vi $(find /home | grep xyzzyx) ``

### Creating command line shortcuts (Aliases)
you can create command line shortcuts by using the ``alias`` command, this can apply to different commands such ``pwd`` and ls by attaching them to different keys with different combinations. For example; ``alias p= 'pwd ; ls -CF`` assigns the letter p to the command pwd then runs ls, which prints the working directory and lists the contents in a column format. 

another example is the shortcut ``alias rm= 'rm -i'`` , this assign the rm command to rm -i which prompts the user about each file that will be removed sequentially, so that mistakes are avoided if rm is accidently entered. 

##### checking which aliases are set
you can check which aliases are currently active by typing the ``alias`` command. 

##### Removing aliases
aliases can be removed if you type the ``unalias`` command, if the alias is set in a config file then it will appear again if you start a new shell session. 





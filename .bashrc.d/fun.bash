richard_stallman() {
	DEF_KERNEL='Linux'
	DEF_OS='GNU'

	OS=${1-${OS-$DEF_OS}}
	KERNEL=${2-${KERNEL-$DEF_KERNEL}}

	echo "I'd just like to interject for a moment. What you're referring to as $KERNEL, is in fact, $OS/$KERNEL, or as I've recently taken to calling it, $OS plus $KERNEL. $KERNEL is not an operating system unto itself, but rather another free component of a fully functioning $OS system made useful by the $OS corelibs, shell utilities and vital system components comprising a full OS as defined by POSIX. Many computer users run a modified version of the $OS system every day, without realizing it. Through a peculiar turn of events, the version of $OS which is widely used today is often called \"$KERNEL\", and many of its users are not aware that it is basically the $OS system, developed by the $OS Project. There really is a $KERNEL, and these people are using it, but it is just a part of the system they use. $KERNEL is the kernel: the program in the system that allocates the machine's resources to the other programs that you run. The kernel is an essential part of an operating system, but useless by itself; it can only function in the context of a complete operating system. $KERNEL is normally used in combination with the $OS operating system: the whole system is basically $OS with $KERNEL added, or $OS/$KERNEL. All the so-called \"$KERNEL\" distributions are really distributions of $OS/$KERNEL."
}

peach() {
	echo -e "Dear Mario:\nPlease Come to the\ncastle. I've baked\na cake for you.\nYours truely--\nPrincess Toadstool"
}
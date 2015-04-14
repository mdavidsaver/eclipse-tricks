eclipse hacks
=============

Install Debian packages

* libgtk-3-dev
* libgnomevfs2-dev
* libgnomeui-dev

Clone
-----

    $ git clone --recursive https://github.com/mdavidsaver/eclipse-tricks.git


Building SWT C libraries from source
------------------------------------

Use when libraries fail to load.
May also help with random SIGSEGV due to ABI problems with pre-compiled libraries.

    $ ./build-swt.sh
    $ rm /eclipse/dir/configuration/org.eclipse.osgi/375/0/.cp/*.so
    $ cp result-swt/*.so /eclipse/dir/configuration/org.eclipse.osgi/375/0/.cp/


Building Eclipse launcher from source
-------------------------------------

Fix eclipse bug #386995 with openFile on multi-user linux and/or remote X.

https://bugs.eclipse.org/bugs/show_bug.cgi?id=386995

    $ ./build-launcher.sh
    $ cp result-launcher/eclipse_*.so /eclipse/dir/plugins/org.eclipse.equinox.launcher.gtk.linux.*/

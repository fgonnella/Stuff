#! /bin/bash
sshfs root@pcna62-1:/home/cc/ ~/home-cc -oauto_cache,reconnect,defer_permissions,negative_vncache,volname=somename

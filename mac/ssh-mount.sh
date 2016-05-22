#! /bin/bash
sshfs $1 $2 -oauto_cache,reconnect,defer_permissions,negative_vncache,volname=somename
===============================
Container images for libass' CI
===============================

At the moment the only image is *“oldlibs”*.


Containers
==========

oldlibs
-------

This container has the minimum version of all of libass' dependencies installed 
and otherwise an old'ish toolchain.


Releases
========

Releases are created automatically at every push to master
to workaround the ``download-artifacts`` action only being
able to use artifcats from (a different job of) the same workflow
(see `action's issue <https://github.com/actions/download-artifact/issues/3>`_).

As the releases only serve as a public asset storage,
they may be deleted after some time.
Tracking tags is a bad idea in this repo.

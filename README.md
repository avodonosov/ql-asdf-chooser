This is an attempt to provide an easy way of trivially switching to any ASDF version.

This would be useful when working with old releases of lisp implementations which
supply outdated ASDF unable to load current versions of libraries.

To simplify switching ASDF version as much as possible
we tried to utilize Quicklisp for download of the ASDF file,
giving each fasl unique name per lisp implementation,
and downloading the code that does that (the ql-asdf-chooser itself).

The solution relies on ASDF's ability to upgrade.

Usage:

```common-lisp
        (ql:quickload :ql-asdf-chooser)
        (qach:require-asdf "3.1.7")
```

The above is suitable for the init file of your lisp implementation.

Command line example:
```
ccl-1.11/lx86cl64 --no-init \
                  --load ~/quicklisp/setup.lisp \
                  --eval '(ql:quickload :ql-asdf-chooser)' \
                  --eval '(qach:require-asdf "3.1.7")'
```

Unfortunately, ASDF's upgrade functionality is not as flexible as we hoped,
so this approach is not viable.
More details:: https://bugs.launchpad.net/asdf/+bug/1704679


So currently, if you want to switch to another ASDF, you need
to manually download the desired ASDF release, compile it,
and load *before* loading Quicklisp. If ASDF > 2.26 is loaded,
Quicklisp doesn't try to `(require :asdf)` nor to load its own
copy from ~/quicklisp/asdf.lisp.
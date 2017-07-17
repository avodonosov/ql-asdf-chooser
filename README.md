Use any ASDF version by doing 

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

This tool is useful when working with old releases of lisp implementations which supply outdated ASDF unable to load current versions of libraries.


Notes: https://bugs.launchpad.net/asdf/+bug/1704679

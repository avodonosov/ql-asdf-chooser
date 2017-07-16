;;; -*- Mode: LISP; Syntax: COMMON-LISP; indent-tabs-mode: nil; show-trailing-whitespace: t; coding: utf-8;  -*-
;;; Copyright (C) 2017 Anton Vodonosov (avodonosov@yandex.ru)
;;; See LICENSE for details.

(asdf:defsystem #:ql-asdf-chooser
  :description "Use any ASDF version by doing (ql:quickload :ql-asdf-chooser) (qach:require-asdf \"3.2.1\")"
  :license "MIT"
  :author "Anton Vodonosov <avodonosov@yandex.ru>"
  :version "1.0.0"
  :serial t
  :depends-on (#:quicklisp #:asdf)
  :components ((:file "ql-asdf-chooser")))


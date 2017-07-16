;;; -*- Mode: LISP; Syntax: COMMON-LISP; indent-tabs-mode: nil; coding: utf-8;  -*-
;;; Copyright (C) 2017 Anton Vodonosov (avodonosov@yandex.ru)
;;; See LICENSE for details.

(asdf:defsystem #:qach-proxy
  :description "An internal tool for https://github.com/avodonosov/ql-asdf-loader/."
  :license "MIT"
  :author "Anton Vodonosov <avodonosov@yandex.ru>"
  :version "1.0.0"
  :serial t
  :depends-on (#:hunchentoot #:drakma)
  :components ((:file "qach-proxy")))


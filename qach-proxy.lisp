;;; -*- Mode: LISP; Syntax: COMMON-LISP; indent-tabs-mode: nil; coding: utf-8;  -*-
;;; Copyright (c) 2017 Anton Vodonosov (avodonosov@yandex.ru)
;;; The parts copied from quicklisp/setup.lisp are copyright (c) 2014 Zachary Beane <zach@quicklisp.org>
;;; See LICENSE for details.

(defpackage :qach-proxy
  (:use :cl)
  (:export :start))

(in-package :qach-proxy)

(defun starts-with (str prefix &key (test #'char=))
  (let ((mismatch (mismatch str prefix :test test)))
    (or (null mismatch)
        (>= mismatch (length prefix)))))

(assert (starts-with "abc" "a"))

(defclass acceptor (hunchentoot:acceptor) ())

(defmethod hunchentoot:acceptor-dispatch-request ((acceptor acceptor) request)
  (cond ((starts-with (hunchentoot:script-name request)
                      "/asdf/archives/")
         (multiple-value-bind (body code)
             (drakma:http-request (format nil "https://common-lisp.net/project~A"
                                          (hunchentoot:script-name request))
                                  :force-binary t)
           (setf (hunchentoot:return-code hunchentoot:*reply*) code
                 (hunchentoot:content-type* hunchentoot:*reply*) nil)
           body))
        ((string= (hunchentoot:script-name request)
                  "/")
         "An internal tool for https://github.com/avodonosov/ql-asdf-loader/.")
        
      (progn
        (setf (hunchentoot:return-code hunchentoot:*reply*)
              hunchentoot:+http-not-found+)
        "Not Found"))) 

(defun start (&key port)
  ;; (setf hunchentoot:*show-lisp-errors-p* t
  ;;       *show-lisp-backtraces-p* t)
  (hunchentoot:start (make-instance 'acceptor :port port)))



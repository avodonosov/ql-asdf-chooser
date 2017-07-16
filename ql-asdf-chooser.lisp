;;; -*- Mode: LISP; Syntax: COMMON-LISP; indent-tabs-mode: nil; show-trailing-whitespace: t; coding: utf-8;  -*-
;;; Copyright (c) 2017 Anton Vodonosov (avodonosov@yandex.ru)
;;; The parts copied from quicklisp/setup.lisp are copyright (c) 2014 Zachary Beane <zach@quicklisp.org>
;;; See LICENSE for details.

(defpackage :ql-asdf-chooser
  (:nicknames :qach)
  (:use :cl)
  (:export :require-asdf
           :require-asdf-satisfies
           :*workdir*
           :*asdf-download-url-template*))

(in-package :ql-asdf-chooser)

(defparameter *workdir*
  (ql:qmerge "asdf-chooser/"))

(defparameter *asdf-download-url-template*
  "http://qach-proxy.herokuapp.com/asdf/archives/asdf-~A.lisp"
  "A FORMAT control string with a single parameter
to be replaced by ASDF version - a string like \"3.21.1\".")

(defun asdf-source-file (version &key (workdir *workdir*))
  (merge-pathnames (format nil "asdf-~A.lisp" version)
                   workdir))

(defun ensure-asdf-source (version &key (workdir *workdir*))
  (let ((file (asdf-source-file version :workdir workdir)))
    (or (probe-file file)
        (and (ql-http:http-fetch (format nil
                                         *asdf-download-url-template*
                                         version)
                                 file)
             (probe-file file)))))


;;; The logic of unique fasl generation is copied
;;; from ql-setup:asdf-fasl-pathname. It is spread
;;; between ql-asdf-chooser::asdf-fasl-file
;;;     and ql-asdf-chooser::ensure-asdf-fasl

(defun asdf-fasl-file (version &key (workdir *workdir*))
  (let* ((implementation-signature (ql-setup::implementation-signature))
         (signature-hash (ql-setup::dumb-string-hash implementation-signature))
         (source (asdf-source-file version :workdir workdir))
         (original-fasl (compile-file-pathname source)))
    (merge-pathnames (make-pathname :defaults original-fasl
                                    :directory `(:relative "cache"
                                                           "asdf-fasls"
                                                           ,signature-hash))
                     *workdir*)))

(defun ensure-asdf-fasl (version &key (workdir *workdir*))
  (let ((fasl (asdf-fasl-file version :workdir workdir)))
    (or (probe-file fasl)
        (let ((source (ensure-asdf-source version :workdir workdir))
              (signature-file (merge-pathnames "signature.txt" fasl)))
          (ensure-directories-exist fasl)
          (unless (probe-file signature-file)
            (with-open-file (stream signature-file :direction :output)
              (write-string (ql-setup::implementation-signature) stream)))
          (or (compile-file source :output-file fasl)
              (error "compilation failed: ~A" source))))))

(defun require-asdf (version &key (workdir *workdir*))
  (unless (string= (asdf:asdf-version) version)
   (load (ensure-asdf-fasl version :workdir workdir))))

(defun require-asdf-satisfies (version &key (workdir *workdir*))
  (unless (asdf:version-satisfies (asdf:asdf-version) version)
    (load (ensure-asdf-fasl version :workdir workdir))))

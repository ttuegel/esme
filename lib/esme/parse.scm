;; esme - Shell inspired by Scheme
;; Copyright (C) 2017  Thomas Tuegel
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

(define (parse-return a)
  (lambda (src ix succeed fail) (succeed a src ix fail)))

(define (parse-bind parse a->parse)
  (lambda (src ix succeed fail)
    (let ((next (lambda (a src ix fail) ((a->parse a) src ix succeed fail))))
      (parse src ix next fail))))

(define-syntax parse-do
  (syntax-rules (<-)
    ;; terminal statement is unmodified
    ((_ e) e)

    ;; bind var in e2 to result of e1
    ((_ (<- var e1) e2 ...)
     (parse-bind e1 (lambda (var) (parse-do e2 ...))))

    ;; sequence e1 and e2, ignoring the result of e1
    ((_ e1 e2 ...)
     (parse-bind e1 (lambda (_) (parse-do e2 ...))))))

(define (char-word? c)
  (not (or
        (char-whitespace? c)
        (char=? c #\$)
        (char=? c #\\)
        (char=? c #\()
        (char=? c #\))
        (char=? c #\{)
        (char=? c #\})
        (char=? c #\|)
        (char=? c #\;)
        (char=? c #\&))))

(define parse-word
  (parse-token char-word?))

(define (parse-optional parse) (parse-or parse (parse-return '())))

(define parse-whitespace
  (parse-token char-whitespace?))

(define parse-optional-whitespace (parse-optional parse-whitespace))

(define (parse-surround before parse after)
  (parse-do
   before
   (<- a parse)
   after
   (parse-return a)))

(define (parse-braces parse-body)
  (parse-surround
   (parse-trim (parse-char #\{))
   parse-body
   (parse-char #\})))

(define (parse-parens parse-body)
  (parse-surround
   (parse-trim (parse-char #\())
   parse-body
   (parse-char #\))))

(define (parse-sep-by+ elem sep)
  (parse-do
   (<- e elem)
   (let loop ((result (list e)))
     (parse-or
      (parse-do
       sep
       (<- e elem)
       (loop (cons e result)))
      (parse-return (reverse result))))))

(define (parse-sep-by elem sep)
  (parse-or
   (parse-sep-by+ elem sep)
   (parse-return '())))

(define (parse-trim parse)
  (parse-do
   (<- a parse)
   parse-optional-whitespace
   (parse-return a)))

(define parse-semicolon (parse-trim (parse-char #\;)))

(define parse-words
  (parse-trim (parse-sep-by parse-word parse-whitespace)))

(define parse-words+
  (parse-trim (parse-sep-by+ parse-word parse-whitespace)))

(define parse-progn
  (parse-trim (parse-braces (parse-sep-by parse-words parse-semicolon))))

(define parse-list
  (parse-trim (parse-parens parse-words)))

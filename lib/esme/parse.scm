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

(define (char-word? c)
  (not (or
        (char-whitespace? c)
        (= c #\$)
        (= c #\\)
        (= c #\()
        (= c #\))
        (= c #\{)
        (= c #\})
        (= c #\|)
        (= c #\;)
        (= c #\&))))

(define parse-word
  (parse-token char-word?))

(define skip-whitespace
  (parse-ignore (parse-token char-whitespace?)))

(define (parse-sep-by f sep)
  (parse-optional f (parse-repeat (parse-seq sep f))))

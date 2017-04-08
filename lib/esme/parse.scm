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

(define skip-whitespace
  (parse-ignore (parse-token char-whitespace?)))

(define (parse-sep-by+ elem sep)
  (lambda (src ix succ fail-top)
    (elem src ix
          (lambda (result src ix fail)
            (let loop
                 ((result (list result))
                  ;; backtrack to this source and index if we fail to parse another elem
                  (src-back src)
                  (ix-back ix))
              (let
                  ((end
                    ;; succeed with backtracking upon allowed failure
                    (lambda (src ix reason)
                      (succ (reverse result) src-back ix-back fail-top)))
                   (next
                    ;; store result and iterate upon success
                    (lambda (r src ix fail)
                      (loop (cons r result) src ix))))

                (sep src-back ix-back
                     (lambda (r src ix fail-sep) (elem src ix next end))
                     end))))
            ;; failure: parsed no element
            fail-top)))

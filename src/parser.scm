(define char-word? (c)
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

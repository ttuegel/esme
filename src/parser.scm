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

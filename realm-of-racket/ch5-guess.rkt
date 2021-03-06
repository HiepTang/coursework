#lang racket

(require 2htdp/universe
         2htdp/image)

(struct interval (small big guesses))

(define WIDTH 800)
(define HEIGHT 600)
(define COLOR "red")
(define TEXT-X 10)
(define TEXT-UPPER-Y 50)
(define TEXT-LOWER-Y 500)
(define TEXT-SIZE 20)
(define SIZE 40)

(define HELP-TEXT
  (text "[up] for larger numbers, [down] for smaller ones"
        TEXT-SIZE
        "blue"))

(define HELP-TEXT2
  (text "Press = when your number is guess; q to quit."
        TEXT-SIZE
        "blue"))

(define (single? w)
  (= (interval-small w) (interval-big w)))

(define MT-SC
  (place-image/align
   HELP-TEXT TEXT-X TEXT-UPPER-Y "left" "top"
   (place-image/align
    HELP-TEXT2 TEXT-X TEXT-LOWER-Y "left" "bottom"
    (empty-scene WIDTH HEIGHT))))

(define (start lower upper)
  (big-bang (interval lower upper 0)
            (on-key deal-with-guess)
            (to-draw render)
            (stop-when single? render-last-scene)))

(define (deal-with-guess w key)
  (cond [(key=? key "up") (bigger w)]
        {(key=? key "down") (smaller w)}
        [(key=? key "q") (stop-with w)]
        [(key=? key "=") (stop-with w)]
        [else w]))

(define (guess w)
  (quotient (+ (interval-small w) (interval-big w)) 2))

(define (smaller w)
  (interval (interval-small w)
            (max (interval-small w) (sub1 (guess w)))
            (add1 (interval-guesses w))))

(define (bigger w)
  (interval (min (interval-big w) (add1 (guess w)))
            (interval-big w)
            (add1 (interval-guesses w))))

(define (render w)
  (overlay (text (number->string (interval-guesses w)) SIZE COLOR)
           (overlay (text (number->string (guess w)) SIZE COLOR)
                    MT-SC)))

(define (render-last-scene w)
  (overlay (text "End" SIZE COLOR) MT-SC))
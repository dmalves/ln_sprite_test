;; helloworld example

(define ahooga #f)
(define sprites (list monster0.img monster1.img monster2.img monster3.img))
(define gui #f)
(define idx 0)
(define prv #f)
(define now #f)

(define timewheel #f)

(define (animate gui wgt)
  (begin
    (set! now (time->seconds (current-time)))
    (cond ((> (- now prv) 0.5)
           (glgui-widget-set! gui wgt 'image (list-ref sprites idx))
           (set! idx (+ idx 1))
           (set! idx (modulo idx 3))
           (set! prv now)))))

(define (button-callback g w t x y)
  (let ((oldcolor (glgui-widget-get g w 'color)))
    (if ahooga (audiofile-play ahooga))
    (glgui-widget-set! g w 'color (if (= oldcolor White) Red White))
    )
  )

(main
 ;; initialization
 (lambda (w h)
   (make-window 320 480)
   (glgui-orientation-set! GUI_PORTRAIT)
   (set! gui (make-glgui))
   (set! prv (time->seconds (current-time)))
   (set! now prv)
   (glgui-sprite  gui 'x 0 'y 0 'image monster0.img 'rendercallback animate))
 ;; events
 (lambda (t x y)
   (if (= t EVENT_KEYPRESS) (begin
                              (if (= x EVENT_KEYESCAPE) (terminate))))
   (glgui-event gui t x y))
 ;; termination
 (lambda () #t)
 ;; suspend
 (lambda () (glgui-suspend))
 ;; resume
 (lambda () (glgui-resume))
 )

;; eof

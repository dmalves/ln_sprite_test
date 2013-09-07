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
           (set! idx (+ idx 1))
           (set! idx (modulo idx 3))
           (set! prv now)
	   (glgui-widget-set! gui wgt 'image (list-ref sprites idx))))))

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
   (glgui-sprite  gui 'x 0 'y 0 'image monster0.img 'rendercallback animate)
   (let ((bw 150) (bh 50))
     (let ((bx (/ (- (glgui-width-get) bw) 2.))
           (by (/ (- (glgui-height-get) bh) 2.)))
       (glgui-button-string gui bx by bw bh "Me too!!!" ascii_18.fnt button-callback))
     (let ((bx (- (glgui-width-get) bw 10)) (by (+ 44 10)))
       (glgui-button-string gui bx by bw bh "And me!!" ascii_18.fnt button-callback))
     (let ((bx 10) (by (- (glgui-height-get) 44 10 bh)))
       (glgui-button-string gui bx by bw bh "Push me!" ascii_18.fnt button-callback))
     )
   (audiofile-init)
   (set! ahooga (audiofile-load "ahooga"))
   )
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

(defun  c:to_0 ( / a b c d x)
(command "zoom" "e")
(setq b (getvar "viewsize")
      c (car (getvar "screensize"))
      d (cadr (getvar "screensize"))
      a (* b (/ c d))
      x (setq x (getvar "viewctr"))
      x (trans x 1 2)
      c (list (- (car x)  (/ a 2.000000))
              (- (cadr x) (/ b 2.000000))
              0.00000
        );list
      d (list (+ (car x)  (/ a 2.000000))
              (+ (cadr x) (/ b 2.000000))
              0.00000
        );list
      c (trans c 2 1)
      d (trans d 2 1) 
);setq

(list c d)
(setq mid_pnt
       (list  (/ (+ (car c) (car d)) 2)
	      (/ (+ (cadr c) (cadr d)) 2)
	      )
      )
  (command "move" "all" "" mid_pnt "0,0")
)
(print "input to_0 to run")



























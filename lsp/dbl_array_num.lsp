(defun c:dbltxt ()
  (defun get_dt_vl (item dt)
    (cdr (assoc item dt))
  )
  (command "layer" "m" "text" "")
  (prompt "\nselect the down num:")
  (if t
    (progn
      (setq xn 34)
      (setq yn 88)
      (setq x_val 2.57)
      (setq y_val 1.05)     
      (if t
	(progn
	  (setq txt_high 0.18)
	  (setq d_ist_pnt '(0 0))
	  ;(setq u_ist_pnt (get_dt_vl 10 u_detail))
	  (setq af "01")
	  (repeat yn
	    (setq nu "01")
	    (setq d_ist_pnt1 d_ist_pnt)
	    (repeat xn
	      (setq t_dt (strcat af nu))
	      (setq t_dt (list
			   (cons 0 "TEXT")
			   (cons 1 t_dt)
			   (cons 40 txt_high)
			   (cons 10 d_ist_pnt)
			 )
	      )
	      (entmake t_dt)
	      (setq d_ist_pnt
		     (list (+ (car d_ist_pnt) x_val)
			   (cadr d_ist_pnt)
			   0
		     )
	      )
	      (setq nu (itoa (+(atoi nu) 1)))
	      (if (= (strlen nu) 1)
		(setq nu (strcat "0" nu))
		)
	    )
	    (setq d_ist_pnt (list (car d_ist_pnt1)
				  (- (cadr d_ist_pnt1) y_val)
				  0
			    )
	    )
	    (setq af (itoa (+ (atoi af) 1)))
	    (if (= (strlen af) 1)
		(setq af (strcat "0" af))
		)
	  )
	  ;(setq af "B")
;	  (repeat yn
;	    (setq nu "1")
;	    (setq u_ist_pnt1 u_ist_pnt)
;	    (repeat xn
;	      (setq t_dt (strcat af nu))
;	      (setq t_dt (list
;			   (cons 0 "TEXT")
;			   (cons 1 t_dt)
;			   (cons 40 txt_high)
;			   (cons 10 u_ist_pnt)
;			   (cons 50 pi)
;			 )
;	      )
;	      (entmake t_dt)
;	      (setq u_ist_pnt
;		     (list (+ (car u_ist_pnt) x_val)
;			   (cadr u_ist_pnt)
;			   0
;		     )
;	      )
;	      (setq nu (chr (+ (ascii nu) 1)))
;	    )
;	    (setq u_ist_pnt (list (car u_ist_pnt1)
;				  (+ (cadr u_ist_pnt1) y_val)
;				  0
;			    )
;	    )
;	    (setq af (chr (+ (ascii af) 2)))
;
;
;	  )
	)
	(prompt "\ntext hight is not 1.0, please confirm it!")
      )

    )
    (prompt "\nselect text error")
  )
)
(prompt "\ninput dbltxt to run")
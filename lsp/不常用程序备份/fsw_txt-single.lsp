(defun c:fsw ()
  (defun get_dt_vl (item dt)
    (cdr (assoc item dt))
  )
  (command "layer" "m" "text" "")
  (prompt "\nselect the down num:")
  (setq dwn_txt (ssget))
  ;(prompt "\nselect the up num:")
  ;(setq up_txt (ssget))
  (if (and
	(= (sslength dwn_txt) 1)
	;(= (sslength up_txt) 1)
      )
    (progn
      (setq xn (getint "\n X方向的排版个数:"))
      (setq yn (getint "\n Y方向的排版个数:"))
      (setq x_val (getreal "\n X方向的排版尺寸:"))
      (setq y_val (getreal "\n Y方向的排版尺寸:"))
      (setq D_detail (entget (ssname dwn_txt 0)))
      ;(setq u_detail (entget (ssname up_txt 0)))
      (if (and (= (get_dt_vl 40 d_detail) 1)
	       ;(= (get_dt_vl 40 u_detail) 1)
	  )
	(progn
	  (setq txt_high 1.0)
	  (setq d_ist_pnt (get_dt_vl 10 d_detail))
	  ;(setq u_ist_pnt (get_dt_vl 10 u_detail))
	  (setq af "A")
	  (repeat yn
	    (setq nu "1")
	    (setq d_ist_pnt1 d_ist_pnt)
	    (repeat xn
	      (setq t_dt (strcat nu " " af))
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
	      (setq nu (chr (+ (ascii nu) 1)))
	    )
	    (setq d_ist_pnt (list (car d_ist_pnt1)
				  (+ (cadr d_ist_pnt1) y_val)
				  0
			    )
	    )
	    (setq af (chr (+ (ascii af) 1)))


	  )
	  ;(setq af "B")
;	  (repeat yn
;	    (setq nu "1")
;	    (setq u_ist_pnt1 u_ist_pnt)
;	    (repeat xn
;	      (setq t_dt (strcat nu " " af))
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
(prompt "\ninput fsw to run")
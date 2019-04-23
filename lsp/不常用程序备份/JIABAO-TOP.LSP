
					;(defun C:CELLS()
(defun C:jb (/	e_input	g_input	h_input	f_input	i_input	j_input
		r_input	a_pi	b_pi	c_pi	d_pi	el	fl
		mk_pi	m_pi	m1_pi	n_pi	n1_pi	o_pi	o1_pi
		p_pi	p1_pi	e_pi	g_pi	h_pi	en_pi	f_pi
		i_pi	j_pi	fn_pi	r_pi	p1	p2	p3
		p4	p5	p6	p7	p8	o1	o2
		o3	o4	offset_e	ss1	ss2	ss3
		ss4	x_pitch	y_pitch	x_ss1	y_ss1	x_ss2	y_ss2
		x_ss3	y_ss3	x_ss4	y_ss4	glass_x	glass_y
		etotal_pi	ftotal_pi	w	ke1	ce1
		kf1	cf1
	       )
  (defun df () 
        (command "pline" (list -130.0 -175.5) "w" 0 0 
                         (list -130.0 -174.5) 
                         (list -149.5 -174.5) 
                         (list -149.5 -155.0) 
                         (list -150.5 -155.0) 
                         (list -150.5 -174.5) 
                         (list -170.0 -174.5) 
                         (list -170.0 -175.5) 
                         (list -150.5 -175.5) 
                         (list -150.5 -195.0) 
                         (list -149.5 -195.0) 
                         (list -149.5 -175.5) 
                         "c"
         )
        (command "pline" (list -130.0 174.5) "w" 0 0 
                         (list -130.0 175.5) 
                         (list -149.5 175.5) 
                         (list -149.5 195.0) 
                         (list -150.5 195.0) 
                         (list -150.5 175.5) 
                         (list -170.0 175.5) 
                         (list -170.0 174.5) 
                         (list -150.5 174.5) 
                         (list -150.5 155.0) 
                         (list -149.5 155.0) 
                         (list -149.5 174.5) 
                         "c"
         )
        (command "pline" (list 170.0 -175.5) "w" 0 0 
                         (list 170.0 -174.5) 
                         (list 150.5 -174.5) 
                         (list 150.5 -155.0) 
                         (list 149.5 -155.0) 
                         (list 149.5 -174.5) 
                         (list 130.0 -174.5) 
                         (list 130.0 -175.5) 
                         (list 149.5 -175.5) 
                         (list 149.5 -195.0) 
                         (list 150.5 -195.0) 
                         (list 150.5 -175.5) 
                         "c"
         )
        (command "pline" (list 170.0 174.5) "w" 0 0 
                         (list 170.0 175.5) 
                         (list 150.5 175.5) 
                         (list 150.5 195.0) 
                         (list 149.5 195.0) 
                         (list 149.5 175.5) 
                         (list 130.0 175.5) 
                         (list 130.0 174.5) 
                         (list 149.5 174.5) 
                         (list 149.5 155.0) 
                         (list 150.5 155.0) 
                         (list 150.5 174.5) 
                         "c"
         )
        (command "pline" (list 202.5 217.5) "w" 0 0 
                         (list 202.5 164.907) 
                         (list 200.5 164.907) 
                         (list 200.5 215.5) 
                         (list 111.664 215.5) 
                         (list 111.664 217.5) 
                         "c"
         )

	(command "pline" (list 202.5 -217.5) "w" 0 0 
                         (list 111.664 -217.5) 
                         (list 111.664 -215.5) 
                         (list 200.5 -215.5) 
                         (list 200.5 -156.625) 
                         (list 202.5 -156.625) 
                         "c"
         )

       (command "pline" (list -202.5 -217.5) "w" 0 0 
                         (list -202.5 -156.625) 
                         (list -200.5 -156.625) 
                         (list -200.5 -215.5) 
                         (list -124.934 -215.5) 
                         (list -124.934 -217.5) 
                         "c"
         )
        (command "pline" (list -200.5 215.5) "w" 0 0 
                         (list -124.934 215.5) 
                         (list -124.934 217.5) 
                         (list -202.5 217.5) 
                         (list -202.5 164.907) 
                         (list -200.5 164.907) 
                         "c"
         )

  )
					;Enter Truly PI plate data
  (setq e_input (getreal "Please input E: "))
  (setq g_input (getreal "Please input G: "))
  (setq h_input (getreal "Please input H: "))
  (setq en_pi (getint "Please input EN: "))
  (setq f_input (getreal "Please input F: "))
  (setq i_input (getreal "Please input I: "))
  (setq j_input (getreal "Please input J: "))
  (setq fn_pi (getint "Please input FN: "))
  (setq r_input (getreal "Please input R: "))
					;Jing Bi formula
  (setq	kf1 0.0
	cf1 0.50
	ke1 0.982
	ce1 0.50
  )
  ;(cond
   ; ((> e_input 80)
;	 (progn					
(setq Ds 0.2)
(setq De 0.2)
;	 )
;	)
;   ((and (> e_input 50) (<= e_input 80))
;	 (progn					
;	   (setq Ds 0.2)
;	   (setq De 0.2)
;;	 )
;	)
;	((and (<= e_input 50) (> e_input 40))
;;	 (progn					
;	   (setq Ds 0.1)
;	   (setq De 0.1)
;	 )
;	)
;	((<= e_input 40) 
;	 (progn					
;	   (setq Ds 0.0)
;	   (setq De 0.0)
;	 )
;	)
 ; )
  (setq e_pi (* ke1 (- e_input ce1)))
  (setq g_pi (* ke1 (+ g_input ce1)))
  (setq h_pi (* ke1 (+ h_input ce1)))
  (setq f_pi (- f_input (+ cf1 (* kf1 f_input))))
  (setq i_pi (+ i_input (+ cf1 (* kf1 f_input))))
  (setq j_pi (+ j_input (+ cf1 (* kf1 f_input))))
  (cond	((> r_input 0.4)
	 (setq r_pi (- r_input 0.001))
	)
	(t (setq r_pi 0.001))		;r_pi must be nozero
  )

  (command "limits" (list -300 -300) (list 300 300))
  (command "zoom" "a")

					;Align the center of pi drawing with one of glass
  (setq	glass_x	0
	glass_y	0
  )
   (setq x_pitch (+ f_pi f_pi i_pi j_pi))
   (setq y_pitch (+ e_pi e_pi g_pi h_pi))  
  (cond	((and (= 0 (rem en_pi 2)) ;evalue etotal_pi
	      (= 0 (rem fn_pi 2))
	 )
	 (setq ftotal_pi (- (* (/ fn_pi 2) x_pitch) j_pi)
	       etotal_pi (- (* (/ en_pi 2) y_pitch) h_pi)
	 )
	)
	((and (= 0 (rem en_pi 2))
	      (= 1 (rem fn_pi 2))
	 )
	 (setq ftotal_pi (+ (* (/ fn_pi 2) x_pitch) f_pi)
	       etotal_pi (- (* (/ en_pi 2) y_pitch) h_pi)
	 )
	)
	((and (= 1 (rem en_pi 2))
	      (= 0 (rem fn_pi 2))
	 )
	 (setq ftotal_pi (- (* (/ fn_pi 2) x_pitch) j_pi)
	       etotal_pi (+ (* (/ en_pi 2) y_pitch) e_pi)
	 )
	)
	((and (= 1 (rem en_pi 2))
	      (= 1 (rem fn_pi 2))
	 )
	 (setq ftotal_pi (+ (* (/ fn_pi 2) x_pitch) f_pi)
	       etotal_pi (+ (* (/ en_pi 2) y_pitch) e_pi)
	 )
	)
  )
  (setq etotal_pi (+ etotal_pi (- de ds)))
  (setq e_pi (+ e_pi de))
  (setq deta (/ (+ ds de) (1- en_pi)))

  (setq	origin_x (- glass_x (/ ftotal_pi 2))
	origin_y (- glass_y (/ etotal_pi 2))
  )
  (print
    "Align the center of pi drawing with one of glass ok!"
  )
  (setq loop_e 0)
  (setq loop_f 0)
  (repeat en_pi
    (repeat fn_pi
      (setq p1 (list (+ r_pi origin_x) (+ 0 origin_y))
	    p2 (list (+ (- f_pi r_pi) origin_x) (+ 0 origin_y))
	    p3 (list (+ f_pi origin_x) (+ r_pi origin_y))
	    p4 (list (+ f_pi origin_x) (+ (- e_pi r_pi) origin_y))
	    p5 (list (+ (- f_pi r_pi) origin_x) (+ e_pi origin_y))
	    p6 (list (+ r_pi origin_x) (+ e_pi origin_y))
	    p7 (list (+ 0 origin_x) (+ (- e_pi r_pi) origin_y))
	    p8 (list (+ 0 origin_x) (+ r_pi origin_y))
	    o1 (list (+ r_pi origin_x) (+ r_pi origin_y))
	    o2 (list (+ (- f_pi r_pi) origin_x) (+ r_pi origin_y))
	    o3 (list (+ (- f_pi r_pi) origin_x) (+ (- e_pi r_pi) origin_y))
	    o4 (list (+ r_pi origin_x) (+ (- e_pi r_pi) origin_y))
      )
      (command "pline"	   p1	 "w"   0     0	   p2 ;down edge
	       "a"   "r"   r_pi	 p3	;down right conner
	       "l"   p4			;right edge
	       "a"   "r"   r_pi	 p5	;upon right conner
	       "l"   p6			;upon edge
	       "a"   "r"   r_pi	 p7	;upon left conner
	       "l"   p8			;left edge
	       "a"   "r"   r_pi	 p1	;down left conner
	       "close"
	      )
      (setq loop_f (1+ loop_f))
      (setq
	gap_f (+ (* i_pi (* (- (/ loop_f 2.0) (/ loop_f 2)) 2))
		 (* j_pi
		    (* (- (/ (+ loop_f 1) 2.0) (/ (+ loop_f 1) 2)) 2)
		 )
	      )
      )
      (setq origin_x (+ origin_x (+ gap_f f_pi)))
    )
    (setq loop_e (1+ loop_e))
    (setq loop_f 0)
    (setq gap_e
	   (+ (* g_pi (* (- (/ loop_e 2.0) (/ loop_e 2)) 2))
	      (* h_pi (* (- (/ (+ loop_e 1) 2.0) (/ (+ loop_e 1) 2)) 2))
	   )
    )
    (setq origin_y (+ origin_y (+ gap_e e_pi)))
    (setq e_pi (- e_pi deta))
    (setq	origin_x (- glass_x (/ ftotal_pi 2)))
  )
  (df)
  (setq txt (getstring T "输入ID:"))
  (command "text" "-185,110" "5" "270" txt)
  ;(setq ent_dt (list (cons 0 "TEXT") (cons 1 txt) (cons 10 (list -130 150))))
  ;(entmake ent_dt)
  (terpri)
)
(prompt "\输入JB运行")

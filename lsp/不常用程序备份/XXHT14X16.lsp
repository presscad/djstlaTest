(defun C:xxht (/       e_input g_input h_input f_input i_input j_input
	       r_input a_pi    b_pi    c_pi    d_pi    el      fl
	       mk_pi   m_pi    m1_pi   n_pi    n1_pi   o_pi    o1_pi
	       p_pi    p1_pi   e_pi    g_pi    h_pi    en_pi   f_pi
	       i_pi    j_pi    fn_pi   r_pi    p1      p2      p3
	       p4      p5      p6      p7      p8      o1      o2
	       o3      o4      offset_e	       ss1     ss2     ss3
	       ss4     x_pitch y_pitch x_ss1   y_ss1   x_ss2   y_ss2
	       x_ss3   y_ss3   x_ss4   y_ss4   glass_x glass_y etotal_pi
	       ftotal_pi       w       ke1     ce1     kf1     cf1
	      )
  (defun df ()
    (command "pline" (list -210.0 -262.8) "w" 0 0 
                         (list -210.0 -261.8) 
                         (list 210.0 -261.8) 
                         (list 210.0 -262.8) 
                         "c"
         )
        (command "pline" (list -210.0 -260.3) "w" 0 0 
                         (list -210.0 -259.3) 
                         (list 210.0 -259.3) 
                         (list 210.0 -260.3) 
                         "c"
         )
        (command "pline" (list -210.0 -257.8) "w" 0 0 
                         (list -210.0 -256.8) 
                         (list 210.0 -256.8) 
                         (list 210.0 -257.8) 
                         "c"
         )
        (command "pline" (list -210.0 -255.3) "w" 0 0 
                         (list -210.0 -254.3) 
                         (list 210.0 -254.3) 
                         (list 210.0 -255.3) 
                         "c"
         )
        (command "pline" (list -210.0 -252.8) "w" 0 0 
                         (list -210.0 -251.8) 
                         (list 210.0 -251.8) 
                         (list 210.0 -252.8) 
                         "c"
         )
        (command "pline" (list -210.0 -250.3) "w" 0 0 
                         (list -210.0 -249.3) 
                         (list 210.0 -249.3) 
                         (list 210.0 -250.3) 
                         "c"
         )
        (command "pline" (list -210.0 -247.8) "w" 0 0 
                         (list -210.0 -246.8) 
                         (list 210.0 -246.8) 
                         (list 210.0 -247.8) 
                         "c"
         )
        (command "pline" (list -210.0 244.2) "w" 0 0 
                         (list -210.0 243.2) 
                         (list 210.0 243.2) 
                         (list 210.0 244.2) 
                         "c"
         )
        (command "pline" (list -210.0 246.7) "w" 0 0 
                         (list -210.0 245.7) 
                         (list 210.0 245.7) 
                         (list 210.0 246.7) 
                         "c"
         )
        (command "pline" (list -210.0 249.2) "w" 0 0 
                         (list -210.0 248.2) 
                         (list 210.0 248.2) 
                         (list 210.0 249.2) 
                         "c"
         )
        (command "pline" (list -210.0 251.7) "w" 0 0 
                         (list -210.0 250.7) 
                         (list 210.0 250.7) 
                         (list 210.0 251.7) 
                         "c"
         )
        (command "pline" (list -210.0 254.2) "w" 0 0 
                         (list -210.0 253.2) 
                         (list 210.0 253.2) 
                         (list 210.0 254.2) 
                         "c"
         )
        (command "pline" (list -210.0 256.7) "w" 0 0 
                         (list -210.0 255.7) 
                         (list 210.0 255.7) 
                         (list 210.0 256.7) 
                         "c"
         )
        (command "pline" (list -210.0 259.2) "w" 0 0 
                         (list -210.0 258.2) 
                         (list 210.0 258.2) 
                         (list 210.0 259.2) 
                         "c"
         )
        (command "pline" (list 194.5 -202.3) "w" 0 0 
                         (list 194.5 -201.3) 
                         (list 207.5 -201.3) 
                         (list 207.5 -202.3) 
                         "c"
         )
        (command "pline" (list 201.5 191.7) "w" 0 0 
                         (list 201.5 204.7) 
                         (list 200.5 204.7) 
                         (list 200.5 191.7) 
                         "c"
         )
        (command "pline" (list 200.5 48.2) "w" 0 0 
                         (list 201.5 48.2) 
                         (list 201.5 -51.8) 
                         (list 200.5 -51.8) 
                         "c"
         )
        (command "pline" (list 207.5 197.7) "w" 0 0 
                         (list 194.5 197.7) 
                         (list 194.5 198.7) 
                         (list 207.5 198.7) 
                         "c"
         )
        (command "pline" (list 200.5 -195.3) "w" 0 0 
                         (list 201.5 -195.3) 
                         (list 201.5 -208.3) 
                         (list 200.5 -208.3) 
                         "c"
         )
        (command "pline" (list 210.0 237.959) "w" 0 0 
                         (list 210.0 -266.8) 
                         (list -210.0 -266.8) 
                         (list -210.0 263.2) 
                         (list 210.0 263.2) 
                         (list 210.0 237.959) 
                         (list 212.0 237.959) 
                         (list 212.0 265.2) 
                         (list -212.0 265.2) 
                         (list -212.0 -268.8) 
                         (list 212.0 -268.8) 
                         (list 212.0 237.959) 
                         "c"
         )
        (command "pline" (list -200.5 48.2) "w" 0 0 
                         (list -201.5 48.2) 
                         (list -201.5 -51.8) 
                         (list -200.5 -51.8) 
                         "c"
         )
        (command "pline" (list -194.5 -202.3) "w" 0 0 
                         (list -194.5 -201.3) 
                         (list -207.5 -201.3) 
                         (list -207.5 -202.3) 
                         "c"
         )
        (command "pline" (list -200.5 -195.3) "w" 0 0 
                         (list -201.5 -195.3) 
                         (list -201.5 -208.3) 
                         (list -200.5 -208.3) 
                         "c"
         )
        (command "pline" (list -207.5 197.7) "w" 0 0 
                         (list -194.5 197.7) 
                         (list -194.5 198.7) 
                         (list -207.5 198.7) 
                         "c"
         )
        (command "pline" (list -201.5 191.7) "w" 0 0 
                         (list -201.5 204.7) 
                         (list -200.5 204.7) 
                         (list -200.5 191.7) 
                         "c"
         )
  )					;Enter Truly PI plate data
  (setq e_input (getreal "Please input E: "))
  (setq g_input (getreal "Please input G: "))
  (setq h_input (getreal "Please input H: "))
  (setq en_pi (getint "Please input EN: "))
  (setq f_input (getreal "Please input F: "))
  (setq i_input (getreal "Please input I: "))
  (setq j_input (getreal "Please input J: "))
  (setq fn_pi (getint "Please input FN: "))
  (setq r_input (getreal "Please input R: "))
  (if (= (rem en_pi 2) 1)
    (progn
    (setq tmp g_input)
    (setq g_input h_input)
    (setq h_input tmp)
    )
    )
  (if (= (rem fn_pi 2) 1)
    (progn
    (setq tmp i_input)
    (setq i_input j_input)
    (setq j_input tmp)
    )
    )					;Jing Bi formula
  (setq
    ke1	0.98
    ce1	0.0
    kf1	0.0
    cf1	0.0
  )
  (cond
    ((> e_input 50)
     (progn
       (setq head_fst_blk_add -0.4)
       (setq trail_fst_blk_add 0.2)
       (setq head_scd_blk_add 0)
       (setq trail_scd_blk_add 0)
       (setq head_gap_add -0.1)
       (setq trail_gap_add 0.05)
     )
    )
    ((and (> e_input 30) (<= e_input 50))
     (progn
       (setq head_fst_blk_add -0.3)
       (setq trail_fst_blk_add 0.2)
       (setq head_scd_blk_add -0.2)
       (setq trail_scd_blk_add 0.1)
       (setq head_gap_add -0.05)
       (setq trail_gap_add 0.05)
     )
    )
    ((and (<= e_input 30) (> e_input 10))
     (progn
       (setq head_fst_blk_add -0.2)
       (setq trail_fst_blk_add 0.15)
       (setq head_scd_blk_add -0.1)
       (setq trail_scd_blk_add 0.05)
       (setq head_gap_add -0.05)
       (setq trail_gap_add 0.05)
     )
    )
    ((<= e_input 10)
     (progn
       (setq head_fst_blk_add 0)
       (setq trail_fst_blk_add 0)
       (setq head_scd_blk_add 0)
       (setq trail_scd_blk_add 0)
       (setq head_gap_add 0)
       (setq trail_gap_add 0)
     )
    )
  )
  (setq e_pi (* ke1 (- e_input ce1)))
  (setq g_pi (* ke1 (+ g_input ce1)))
  (setq h_pi (* ke1 (+ h_input ce1)))
  (setq f_pi (- f_input (+ cf1 (* kf1 f_input))))
  (setq i_pi (+ i_input (+ cf1 (* kf1 f_input))))
  (setq j_pi (+ j_input (+ cf1 (* kf1 f_input))))
  (if (> r_input 0)
    (setq r_pi r_input)
    (setq r_pi 0.001)
  )
  (command "limits" (list -300 -300) (list 300 300))
  (command "zoom" "a")			;Align the center of pi drawing with one of glass
  (setq	glass_x	0
	glass_y	0
  )
  (setq x_pitch (+ f_pi f_pi i_pi j_pi))
  (setq y_pitch (+ e_pi e_pi g_pi h_pi))
  (cond	((and (= 0 (rem en_pi 2))	;evalue etotal_pi
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
  (setq	etotal_pi (+ etotal_pi
		     (+	head_fst_blk_add       trail_fst_blk_add
			head_scd_blk_add       trail_scd_blk_add
			head_gap_add	       trail_gap_add
		       )
		  )
  )
  (setq	origin_x (- glass_x (/ ftotal_pi 2))
	origin_y (- glass_y (/ etotal_pi 2))
  )
  (print
    "Align the center of pi drawing with one of glass ok!"
  )
  (setq loop_e 0)
  (setq loop_f 0)
  (setq e_pi_rv e_pi)
  (repeat en_pi
    (repeat fn_pi
      (setq e_pi e_pi_rv)
      (if (= loop_e 0)
	(setq e_pi (+ e_pi trail_fst_blk_add))
      )
      (if (= loop_e (- en_pi 1))
	(setq e_pi (+ e_pi head_fst_blk_add))
      )
      (if (= loop_e 1)
	(setq e_pi (+ e_pi trail_scd_blk_add))
      )
      (if (= loop_e (- en_pi 2))
	(setq e_pi (+ e_pi head_scd_blk_add))
      )

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
    (if	(= loop_e 1)
      (setq gap_e (+ gap_e trail_gap_add))
    )
    (if	(= loop_e (- en_pi 1))
      (setq gap_e (+ gap_e head_gap_add))
    )
    (setq origin_y (+ origin_y (+ gap_e e_pi)))
    (setq origin_x (- glass_x (/ ftotal_pi 2)))
  )
  (df)
  (setq txt (getstring "输入客户的MODEL号与日期:" T))
  (setq txt (strcat txt " QINGYI " (itoa  (Fix (getvar "CDATE")))))
  (setq txt (strcase txt))
  (setq txt_dt (list (cons 0 "TEXT")
		     (cons 1 txt)
		     (cons 10 '(123 -230 0))
		     (cons 40 7)
		     (cons 71 2)))
  (entmake txt_dt)
  ;(command "text" "-130,227" "6.5" "0" txt)
  (terpri)
)
(prompt "\n输入xxht运行，箭头向上，从左上角读数。")
  
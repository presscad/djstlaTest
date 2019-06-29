					;last modify 2001/2/13 改为按正常读数方法读数。
					;(defun C:CELLS()
(defun C:XW (/	     e_input g_input h_input f_input i_input j_input
	     r_input a_pi    b_pi    c_pi    d_pi    el	     fl
	     mk_pi   m_pi    m1_pi   n_pi    n1_pi   o_pi    o1_pi
	     p_pi    p1_pi   e_pi    g_pi    h_pi    en_pi   f_pi
	     i_pi    j_pi    fn_pi   r_pi    p1	     p2	     p3
	     p4	     p5	     p6	     p7	     p8	     o1	     o2
	     o3	     o4	     offset_e	     ss1     ss2     ss3
	     ss4     x_pitch y_pitch x_ss1   y_ss1   x_ss2   y_ss2
	     x_ss3   y_ss3   x_ss4   y_ss4   glass_x glass_y etotal_pi
	     ftotal_pi	     w	     ke1     ce1     kf1     cf1
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
  (setq sh_xw (getstring "图形是否是要收缩Y/N(N)"))
  (if (/= (strcase sh_xw) "Y")
    (progn				;Jing Bi formula
      (setq ke1	1.0
	    ce1	0.0
	    kf1	0.0
	    cf1	0.0
      )
    )
    (progn
      (setq ke1	0.979
	    ce1	0.25
	    kf1	0.0
	    cf1	0.25
      )
    )
  )
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
  )					;the center of glass
  (setq x_pitch (+ f_pi f_pi i_pi j_pi)) ;x axis step size
  (setq y_pitch (+ e_pi e_pi g_pi h_pi)) ;y axis step size
  (cond	((and (= 0 (rem en_pi (fix (/ en_pi 2)))) ;evalue etotal_pi
	      (= 0 (rem fn_pi (fix (/ fn_pi 2))))
	 )
	 (setq ftotal_pi (- (* (/ fn_pi 2) x_pitch) j_pi)
	       etotal_pi (- (* (/ en_pi 2) y_pitch) h_pi)
	 )
	)
	((and (= 0 (rem en_pi (fix (/ en_pi 2))))
	      (= 1 (rem fn_pi (fix (/ fn_pi 2))))
	 )
	 (setq ftotal_pi (+ (* (/ fn_pi 2) x_pitch) f_pi)
	       etotal_pi (- (* (/ en_pi 2) y_pitch) h_pi)
	 )
	)
	((and (= 1 (rem en_pi (fix (/ en_pi 2))))
	      (= 0 (rem fn_pi (fix (/ fn_pi 2))))
	 )
	 (setq ftotal_pi (- (* (/ fn_pi 2) x_pitch) j_pi)
	       etotal_pi (+ (* (/ en_pi 2) y_pitch) e_pi)
	 )
	)
	((and (= 1 (rem en_pi (fix (/ en_pi 2))))
	      (= 1 (rem fn_pi (fix (/ fn_pi 2))))
	 )
	 (setq ftotal_pi (+ (* (/ fn_pi 2) x_pitch) f_pi)
	       etotal_pi (+ (* (/ en_pi 2) y_pitch) e_pi)
	 )
	)
  )
  (setq	origin_x (- glass_x (/ ftotal_pi 2))
	origin_y (- glass_y (/ etotal_pi 2))
  )
  (print
    "Align the center of pi drawing with one of glass ok!"
  )

					;Draw a pi cell
  (setq	p1 (list (+ r_pi origin_x) (+ 0 origin_y))
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
  (command "pline"     p1    "w"   0	 0     p2 ;down edge
	   "a"	 "r"   r_pi  p3		;down right conner
	   "l"	 p4			;right edge
	   "a"	 "r"   r_pi  p5		;upon right conner
	   "l"	 p6			;upon edge
	   "a"	 "r"   r_pi  p7		;upon left conner
	   "l"	 p8			;left edge
	   "a"	 "r"   r_pi  p1		;down left conner
	   ""
	  )
  (print "Draw a pi cell ok!")

					;Get four repeat cells
  (setq ss1 (ssget "l"))
  (cond	((= 0 (rem en_pi (fix (/ en_pi 2))))
	 (setq offset_e (+ e_pi g_pi))
	)				;offset_e
	((= 1 (rem en_pi (fix (/ en_pi 2))))
	 (setq offset_e (+ e_pi h_pi))
	)				;is g or h 
	(t (print "Error: EN is not a int type!")) ;because 
  )					;the distance from ss1 to ss2 depends on whether EN is odd or even  ;the cell 
  (command "copy" ss1 "" (list 0 0) (list 0 offset_e)) ;is at down
  (setq ss2 (ssget "l"))		;upon left cell                             ;left conner
  (command "copy" ss1 "" (list 0 0) (list (+ f_pi i_pi) 0))
  (setq ss3 (ssget "l"))		;down right cell
  (command "copy" ss2 "" (list 0 0) (list (+ f_pi i_pi) 0))
  (setq ss4 (ssget "l"))		;upon right cell
  (cond	((and (= 0 (rem en_pi (fix (/ en_pi 2))))
	      (= 0 (rem fn_pi (fix (/ fn_pi 2))))
	 )
	 (setq x_ss1 (/ fn_pi 2)
	       y_ss1 (/ en_pi 2)	;ss1's x,y step number
	       x_ss2 (/ fn_pi 2)
	       y_ss2 (/ en_pi 2)	;ss2's x,y step number                
	       x_ss3 (/ fn_pi 2)
	       y_ss3 (/ en_pi 2)	;ss3's x,y step number 
	       x_ss4 (/ fn_pi 2)
	       y_ss4 (/ en_pi 2)	;ss4's x,y step number
	 )
	)
	((and (= 0 (rem en_pi (fix (/ en_pi 2))))
	      (= 1 (rem fn_pi (fix (/ fn_pi 2))))
	 )
	 (setq x_ss1 (1+ (/ fn_pi 2))
	       y_ss1 (/ en_pi 2)	;ss1's x,y step number
	       x_ss2 (1+ (/ fn_pi 2))
	       y_ss2 (/ en_pi 2)	;ss2's x,y step number                
	       x_ss3 (/ fn_pi 2)
	       y_ss3 (/ en_pi 2)	;ss3's x,y step number 
	       x_ss4 (/ fn_pi 2)
	       y_ss4 (/ en_pi 2)	;ss4's x,y step number
	 )
	)
	((and (= 1 (rem en_pi (fix (/ en_pi 2))))
	      (= 0 (rem fn_pi (fix (/ fn_pi 2))))
	 )
	 (setq x_ss1 (/ fn_pi 2)
	       y_ss1 (1+ (/ en_pi 2))	;ss1's x,y step number
	       x_ss2 (/ fn_pi 2)
	       y_ss2 (/ en_pi 2)	;ss2's x,y step number                
	       x_ss3 (/ fn_pi 2)
	       y_ss3 (1+ (/ en_pi 2))	;ss3's x,y step number 
	       x_ss4 (/ fn_pi 2)
	       y_ss4 (/ en_pi 2)	;ss4's x,y step number
	 )
	)
	((and (= 1 (rem en_pi (fix (/ en_pi 2))))
	      (= 1 (rem fn_pi (fix (/ fn_pi 2))))
	 )
	 (setq x_ss1 (1+ (/ fn_pi 2))
	       y_ss1 (1+ (/ en_pi 2))	;ss1's x,y step number
	       x_ss2 (1+ (/ fn_pi 2))
	       y_ss2 (/ en_pi 2)	;ss2's x,y step number                
	       x_ss3 (/ fn_pi 2)
	       y_ss3 (1+ (/ en_pi 2))	;ss3's x,y step number 
	       x_ss4 (/ fn_pi 2)
	       y_ss4 (/ en_pi 2)	;ss4's x,y step number
	 )
	)
  )
  (print "Get four repeat cells selected and cond() ok!")
  (command "array" ss1 "" "r" y_ss1 x_ss1 y_pitch x_pitch)
  (command "array" ss2 "" "r" y_ss2 x_ss2 y_pitch x_pitch)
  (command "array" ss3 "" "r" y_ss3 x_ss3 y_pitch x_pitch)
  (command "array" ss4 "" "r" y_ss4 x_ss4 y_pitch x_pitch)
  (print "Get four repeat cells ok!")
  (command "pline"
	   (list 154.9 -120.9)
	   "w"
	   0
	   0
	   (list 154.9 -121.0)
	   (list -154.9 -121.0)
	   (list -154.9 -120.9)
	   "c"
  )
  (command "pline"
	   (list 154.9 -121.9)
	   "w"
	   0
	   0
	   (list 154.9 -122.0)
	   (list -154.9 -122.0)
	   (list -154.9 -121.9)
	   "c"
  )
  (command "pline"
	   (list 154.9 -122.9)
	   "w"
	   0
	   0
	   (list 154.9 -123.0)
	   (list -154.9 -123.0)
	   (list -154.9 -122.9)
	   "c"
  )
  (command "pline"
	   (list 154.9 -123.9)
	   "w"
	   0
	   0
	   (list 154.9 -124.0)
	   (list -154.9 -124.0)
	   (list -154.9 -123.9)
	   "c"
  )
  (command "pline"
	   (list 154.9 -124.9)
	   "w"
	   0
	   0
	   (list 154.9 -125.0)
	   (list -154.9 -125.0)
	   (list -154.9 -124.9)
	   "c"
  )
  (command "pline"
	   (list 154.9 -125.9)
	   "w"
	   0
	   0
	   (list 154.9 -126.0)
	   (list -154.9 -126.0)
	   (list -154.9 -125.9)
	   "c"
  )
  (command "pline"
	   (list 154.9 -126.9)
	   "w"
	   0
	   0
	   (list 154.9 -127.0)
	   (list -154.9 -127.0)
	   (list -154.9 -126.9)
	   "c"
  )
  (command "pline"
	   (list 154.9 -127.9)
	   "w"
	   0
	   0
	   (list 154.9 -128.0)
	   (list -154.9 -128.0)
	   (list -154.9 -127.9)
	   "c"
  )
  (command "pline"
	   (list 154.9 -128.9)
	   "w"
	   0
	   0
	   (list 154.9 -129.0)
	   (list -154.9 -129.0)
	   (list -154.9 -128.9)
	   "c"
  )
  (command "pline"
	   (list 154.9 -129.9)
	   "w"
	   0
	   0
	   (list 154.9 -130.0)
	   (list -154.9 -130.0)
	   (list -154.9 -129.9)
	   "c"
  )
  (command "pline"
	   (list 154.9 -130.9)
	   "w"
	   0
	   0
	   (list 154.9 -131.0)
	   (list -154.9 -131.0)
	   (list -154.9 -130.9)
	   "c"
  )
  (command "pline"
	   (list 154.9 -131.9)
	   "w"
	   0
	   0
	   (list 154.9 -132.0)
	   (list -154.9 -132.0)
	   (list -154.9 -131.9)
	   "c"
  )
  (command "pline"
	   (list 154.9 -132.9)
	   "w"
	   0
	   0
	   (list 154.9 -133.0)
	   (list -154.9 -133.0)
	   (list -154.9 -132.9)
	   "c"
  )
  (command "pline"
	   (list 154.9 -133.9)
	   "w"
	   0
	   0
	   (list 154.9 -134.0)
	   (list -154.9 -134.0)
	   (list -154.9 -133.9)
	   "c"
  )
  (command "pline"
	   (list 154.9 -134.9)
	   "w"
	   0
	   0
	   (list 154.9 -135.0)
	   (list -154.9 -135.0)
	   (list -154.9 -134.9)
	   "c"
  )
  (command "pline"
	   (list 154.9 -135.9)
	   "w"
	   0
	   0
	   (list 154.9 -136.0)
	   (list -154.9 -136.0)
	   (list -154.9 -135.9)
	   "c"
  )
  (command "pline"
	   (list 154.9 -136.9)
	   "w"
	   0
	   0
	   (list 154.9 -137.0)
	   (list -154.9 -137.0)
	   (list -154.9 -136.9)
	   "c"
  )
  (command "pline"
	   (list 154.9 -137.9)
	   "w"
	   0
	   0
	   (list 154.9 -138.0)
	   (list -154.9 -138.0)
	   (list -154.9 -137.9)
	   "c"
  )
  (command "pline"
	   (list 154.9 -138.9)
	   "w"
	   0
	   0
	   (list 154.9 -139.0)
	   (list -154.9 -139.0)
	   (list -154.9 -138.9)
	   "c"
  )
  (command "pline"
	   (list 154.9 -139.9)
	   "w"
	   0
	   0
	   (list 154.9 -140.0)
	   (list -154.9 -140.0)
	   (list -154.9 -139.9)
	   "c"
  )
  (command "pline"
	   (list 154.9 -140.9)
	   "w"
	   0
	   0
	   (list 154.9 -141.0)
	   (list -154.9 -141.0)
	   (list -154.9 -140.9)
	   "c"
  )
  (command "pline"
	   (list 154.9 -141.9)
	   "w"
	   0
	   0
	   (list 154.9 -142.0)
	   (list -154.9 -142.0)
	   (list -154.9 -141.9)
	   "c"
  )
  (command "pline"
	   (list 154.9 -142.9)
	   "w"
	   0
	   0
	   (list 154.9 -143.0)
	   (list -154.9 -143.0)
	   (list -154.9 -142.9)
	   "c"
  )
  (command "pline"
	   (list 154.9 -143.9)
	   "w"
	   0
	   0
	   (list 154.9 -144.0)
	   (list -154.9 -144.0)
	   (list -154.9 -143.9)
	   "c"
  )
  (command "pline"
	   (list 154.9 -144.9)
	   "w"
	   0
	   0
	   (list 154.9 -145.0)
	   (list -154.9 -145.0)
	   (list -154.9 -144.9)
	   "c"
  )
  (command "pline"
	   (list 154.9 -145.9)
	   "w"
	   0
	   0
	   (list 154.9 -146.0)
	   (list -154.9 -146.0)
	   (list -154.9 -145.9)
	   "c"
  )
  (command "pline"
	   (list 154.9 -146.9)
	   "w"
	   0
	   0
	   (list 154.9 -147.0)
	   (list -154.9 -147.0)
	   (list -154.9 -146.9)
	   "c"
  )
  (command "pline"
	   (list 154.9 -147.9)
	   "w"
	   0
	   0
	   (list 154.9 -148.0)
	   (list -154.9 -148.0)
	   (list -154.9 -147.9)
	   "c"
  )
  (command "pline"
	   (list 154.9 -148.9)
	   "w"
	   0
	   0
	   (list 154.9 -149.0)
	   (list -154.9 -149.0)
	   (list -154.9 -148.9)
	   "c"
  )
  (command "pline"
	   (list 154.9 -149.9)
	   "w"
	   0
	   0
	   (list 154.9 -150.0)
	   (list -154.9 -150.0)
	   (list -154.9 -149.9)
	   "c"
  )
  (command "pline"
	   (list 154.9 -150.9)
	   "w"
	   0
	   0
	   (list 154.9 -151.0)
	   (list -154.9 -151.0)
	   (list -154.9 -150.9)
	   "c"
  )
  (command "pline"
	   (list 154.9 -151.9)
	   "w"
	   0
	   0
	   (list 154.9 -152.0)
	   (list -154.9 -152.0)
	   (list -154.9 -151.9)
	   "c"
  )
  (command "pline"
	   (list 154.9 -152.9)
	   "w"
	   0
	   0
	   (list 154.9 -153.0)
	   (list -154.9 -153.0)
	   (list -154.9 -152.9)
	   "c"
  )
  (command "pline"
	   (list 154.9 -153.9)
	   "w"
	   0
	   0
	   (list 154.9 -154.0)
	   (list -154.9 -154.0)
	   (list -154.9 -153.9)
	   "c"
  )
  (command "pline"
	   (list 154.9 -154.9)
	   "w"
	   0
	   0
	   (list 154.9 -155.0)
	   (list -154.9 -155.0)
	   (list -154.9 -154.9)
	   "c"
  )
  (command "pline"
	   (list 154.9 -155.9)
	   "w"
	   0
	   0
	   (list 154.9 -156.0)
	   (list -154.9 -156.0)
	   (list -154.9 -155.9)
	   "c"
  )
  (command "pline"
	   (list 154.9 -156.9)
	   "w"
	   0
	   0
	   (list 154.9 -157.0)
	   (list -154.9 -157.0)
	   (list -154.9 -156.9)
	   "c"
  )
  (command "pline"
	   (list 154.9 -157.9)
	   "w"
	   0
	   0
	   (list 154.9 -158.0)
	   (list -154.9 -158.0)
	   (list -154.9 -157.9)
	   "c"
  )
  (command "pline"
	   (list 154.9 -158.9)
	   "w"
	   0
	   0
	   (list 154.9 -159.0)
	   (list -154.9 -159.0)
	   (list -154.9 -158.9)
	   "c"
  )
  (command "pline"
	   (list 154.9 -159.9)
	   "w"
	   0
	   0
	   (list 154.9 -160.0)
	   (list -154.9 -160.0)
	   (list -154.9 -159.9)
	   "c"
  )
  (command "pline"
	   (list 154.8 126.0)
	   "w"
	   0
	   0
	   (list 154.8 125.9)
	   (list -155.0 125.9)
	   (list -155.0 126.0)
	   "c"
  )
  (command "pline"
	   (list 154.8 127.0)
	   "w"
	   0
	   0
	   (list 154.8 126.9)
	   (list -155.0 126.9)
	   (list -155.0 127.0)
	   "c"
  )
  (command "pline"
	   (list 154.8 128.0)
	   "w"
	   0
	   0
	   (list 154.8 127.9)
	   (list -155.0 127.9)
	   (list -155.0 128.0)
	   "c"
  )
  (command "pline"
	   (list 154.8 129.0)
	   "w"
	   0
	   0
	   (list 154.8 128.9)
	   (list -155.0 128.9)
	   (list -155.0 129.0)
	   "c"
  )
  (command "pline"
	   (list 154.8 130.0)
	   "w"
	   0
	   0
	   (list 154.8 129.9)
	   (list -155.0 129.9)
	   (list -155.0 130.0)
	   "c"
  )
  (command "pline"
	   (list 154.8 131.0)
	   "w"
	   0
	   0
	   (list 154.8 130.9)
	   (list -155.0 130.9)
	   (list -155.0 131.0)
	   "c"
  )
  (command "pline"
	   (list 154.8 132.0)
	   "w"
	   0
	   0
	   (list 154.8 131.9)
	   (list -155.0 131.9)
	   (list -155.0 132.0)
	   "c"
  )
  (command "pline"
	   (list 154.8 133.0)
	   "w"
	   0
	   0
	   (list 154.8 132.9)
	   (list -155.0 132.9)
	   (list -155.0 133.0)
	   "c"
  )
  (command "pline"
	   (list 154.8 134.0)
	   "w"
	   0
	   0
	   (list 154.8 133.9)
	   (list -155.0 133.9)
	   (list -155.0 134.0)
	   "c"
  )
  (command "pline"
	   (list 154.8 135.0)
	   "w"
	   0
	   0
	   (list 154.8 134.9)
	   (list -155.0 134.9)
	   (list -155.0 135.0)
	   "c"
  )
  (command "pline"
	   (list 154.8 136.0)
	   "w"
	   0
	   0
	   (list 154.8 135.9)
	   (list -155.0 135.9)
	   (list -155.0 136.0)
	   "c"
  )
  (command "pline"
	   (list 154.8 137.0)
	   "w"
	   0
	   0
	   (list 154.8 136.9)
	   (list -155.0 136.9)
	   (list -155.0 137.0)
	   "c"
  )
  (command "pline"
	   (list 154.8 138.0)
	   "w"
	   0
	   0
	   (list 154.8 137.9)
	   (list -155.0 137.9)
	   (list -155.0 138.0)
	   "c"
  )
  (command "pline"
	   (list 154.8 139.0)
	   "w"
	   0
	   0
	   (list 154.8 138.9)
	   (list -155.0 138.9)
	   (list -155.0 139.0)
	   "c"
  )
  (command "pline"
	   (list 154.8 140.0)
	   "w"
	   0
	   0
	   (list 154.8 139.9)
	   (list -155.0 139.9)
	   (list -155.0 140.0)
	   "c"
  )
  (command "pline"
	   (list 154.8 141.0)
	   "w"
	   0
	   0
	   (list 154.8 140.9)
	   (list -155.0 140.9)
	   (list -155.0 141.0)
	   "c"
  )
  (command "pline"
	   (list 154.8 142.0)
	   "w"
	   0
	   0
	   (list 154.8 141.9)
	   (list -155.0 141.9)
	   (list -155.0 142.0)
	   "c"
  )
  (command "pline"
	   (list 154.8 143.0)
	   "w"
	   0
	   0
	   (list 154.8 142.9)
	   (list -155.0 142.9)
	   (list -155.0 143.0)
	   "c"
  )
  (command "pline"
	   (list 154.8 144.0)
	   "w"
	   0
	   0
	   (list 154.8 143.9)
	   (list -155.0 143.9)
	   (list -155.0 144.0)
	   "c"
  )
  (command "pline"
	   (list 154.8 145.0)
	   "w"
	   0
	   0
	   (list 154.8 144.9)
	   (list -155.0 144.9)
	   (list -155.0 145.0)
	   "c"
  )
  (command "pline"
	   (list 154.8 146.0)
	   "w"
	   0
	   0
	   (list 154.8 145.9)
	   (list -155.0 145.9)
	   (list -155.0 146.0)
	   "c"
  )
  (command "pline"
	   (list 154.8 147.0)
	   "w"
	   0
	   0
	   (list 154.8 146.9)
	   (list -155.0 146.9)
	   (list -155.0 147.0)
	   "c"
  )
  (command "pline"
	   (list 154.8 148.0)
	   "w"
	   0
	   0
	   (list 154.8 147.9)
	   (list -155.0 147.9)
	   (list -155.0 148.0)
	   "c"
  )
  (command "pline"
	   (list 154.8 149.0)
	   "w"
	   0
	   0
	   (list 154.8 148.9)
	   (list -155.0 148.9)
	   (list -155.0 149.0)
	   "c"
  )
  (command "pline"
	   (list 154.8 150.0)
	   "w"
	   0
	   0
	   (list 154.8 149.9)
	   (list -155.0 149.9)
	   (list -155.0 150.0)
	   "c"
  )
  (command "pline"
	   (list 154.8 151.0)
	   "w"
	   0
	   0
	   (list 154.8 150.9)
	   (list -155.0 150.9)
	   (list -155.0 151.0)
	   "c"
  )
  (command "pline"
	   (list 154.8 152.0)
	   "w"
	   0
	   0
	   (list 154.8 151.9)
	   (list -155.0 151.9)
	   (list -155.0 152.0)
	   "c"
  )
  (command "pline"
	   (list 154.8 153.0)
	   "w"
	   0
	   0
	   (list 154.8 152.9)
	   (list -155.0 152.9)
	   (list -155.0 153.0)
	   "c"
  )
  (command "pline"
	   (list 154.8 154.0)
	   "w"
	   0
	   0
	   (list 154.8 153.9)
	   (list -155.0 153.9)
	   (list -155.0 154.0)
	   "c"
  )
  (command "pline"
	   (list 154.8 155.0)
	   "w"
	   0
	   0
	   (list 154.8 154.9)
	   (list -155.0 154.9)
	   (list -155.0 155.0)
	   "c"
  )
  (command "pline"
	   (list 154.8 156.0)
	   "w"
	   0
	   0
	   (list 154.8 155.9)
	   (list -155.0 155.9)
	   (list -155.0 156.0)
	   "c"
  )
  (command "pline"
	   (list 154.8 157.0)
	   "w"
	   0
	   0
	   (list 154.8 156.9)
	   (list -155.0 156.9)
	   (list -155.0 157.0)
	   "c"
  )
  (command "pline"
	   (list 154.8 158.0)
	   "w"
	   0
	   0
	   (list 154.8 157.9)
	   (list -155.0 157.9)
	   (list -155.0 158.0)
	   "c"
  )
  (command "pline"
	   (list 154.8 159.0)
	   "w"
	   0
	   0
	   (list 154.8 158.9)
	   (list -155.0 158.9)
	   (list -155.0 159.0)
	   "c"
  )
  (command "pline"
	   (list 154.8 160.0)
	   "w"
	   0
	   0
	   (list 154.8 159.9)
	   (list -155.0 159.9)
	   (list -155.0 160.0)
	   "c"
  )
  (command "pline"
	   (list 154.8 161.0)
	   "w"
	   0
	   0
	   (list 154.8 160.9)
	   (list -155.0 160.9)
	   (list -155.0 161.0)
	   "c"
  )
  (command "pline"
	   (list 154.8 162.0)
	   "w"
	   0
	   0
	   (list 154.8 161.9)
	   (list -155.0 161.9)
	   (list -155.0 162.0)
	   "c"
  )
  (command "pline"
	   (list 154.8 163.0)
	   "w"
	   0
	   0
	   (list 154.8 162.9)
	   (list -155.0 162.9)
	   (list -155.0 163.0)
	   "c"
  )
  (command "pline"
	   (list 154.8 164.0)
	   "w"
	   0
	   0
	   (list 154.8 163.9)
	   (list -155.0 163.9)
	   (list -155.0 164.0)
	   "c"
  )
  (command "pline"
	   (list 154.8 165.0)
	   "w"
	   0
	   0
	   (list 154.8 164.9)
	   (list -155.0 164.9)
	   (list -155.0 165.0)
	   "c"
  )
  (command "pline"
	   (list -119.863 167.0)
	   "w"
	   0
	   0
	   (list -157.0 167.0)
	   (list -157.0 92.5531)
	   (list -155.0 92.5531)
	   (list -155.0 165.0)
	   (list -119.863 165.0)
	   "c"
  )
  (command "pline"
	   (list 97.3078 -160.0)
	   "w"
	   0
	   0
	   (list 155.0 -160.0)
	   (list 155.0 -89.0293)
	   (list 157.0 -89.0293)
	   (list 157.0 -162.0)
	   (list 97.3078 -162.0)
	   "c"
  )
  (command "pline"
	   (list 135.25 -105.0)
	   "w"
	   0
	   0
	   (list 135.25 -115.0)
	   (list 134.75 -115.0)
	   (list 134.75 -105.0)
	   "c"
  )
  (command "pline"
	   (list 130.0 -109.75)
	   "w"
	   0
	   0
	   (list 140.0 -109.75)
	   (list 140.0 -110.25)
	   (list 130.0 -110.25)
	   "c"
  )
  (command "pline"
	   (list 130.0 -109.75)
	   "w"
	   0
	   0
	   (list 130.0 -110.25)
	   (list 140.0 -110.25)
	   (list 140.0 -109.75)
	   "c"
  )
  (command "pline"
	   (list 135.25 -105.0)
	   "w"
	   0
	   0
	   (list 134.75 -105.0)
	   (list 134.75 -115.0)
	   (list 135.25 -115.0)
	   "c"
  )
  (command "pline"
	   (list 135.25 125.0)
	   "w"
	   0
	   0
	   (list 135.25 115.0)
	   (list 134.75 115.0)
	   (list 134.75 125.0)
	   "c"
  )
  (command "pline"
	   (list 134.75 125.0)
	   "w"
	   0
	   0
	   (list 135.25 125.0)
	   (list 135.25 115.0)
	   (list 134.75 115.0)
	   "c"
  )
  (command "pline"
	   (list -140.0 -109.75)
	   "w"
	   0
	   0
	   (list -130.0 -109.75)
	   (list -130.0 -110.25)
	   (list -140.0 -110.25)
	   "c"
  )
  (command "pline"
	   (list -135.25 -105.0)
	   "w"
	   0
	   0
	   (list -135.25 -115.0)
	   (list -134.75 -115.0)
	   (list -134.75 -105.0)
	   "c"
  )
  (command "pline"
	   (list -135.25 -105.0)
	   "w"
	   0
	   0
	   (list -134.75 -105.0)
	   (list -134.75 -115.0)
	   (list -135.25 -115.0)
	   "c"
  )
  (command "pline"
	   (list -130.0 -109.75)
	   "w"
	   0
	   0
	   (list -130.0 -110.25)
	   (list -140.0 -110.25)
	   (list -140.0 -109.75)
	   "c"
  )
  (command "pline"
	   (list -135.25 125.0)
	   "w"
	   0
	   0
	   (list -135.25 115.0)
	   (list -134.75 115.0)
	   (list -134.75 125.0)
	   "c"
  )
  (command "pline"
	   (list -134.75 125.0)
	   "w"
	   0
	   0
	   (list -135.25 125.0)
	   (list -135.25 115.0)
	   (list -134.75 115.0)
	   "c"
  )
  (command "pline"
	   (list -119.863 -160.0)
	   "w"
	   0
	   0
	   (list -155.0 -160.0)
	   (list -155.0 -89.0293)
	   (list -157.0 -89.0293)
	   (list -157.0 -162.0)
	   (list -119.863 -162.0)
	   "c"
  )
  (command "pline"
	   (list 97.3078 167.0)
	   "w"
	   0
	   0
	   (list 157.0 167.0)
	   (list 157.0 92.5531)
	   (list 155.0 92.5531)
	   (list 155.0 165.0)
	   (list 97.3078 165.0)
	   "c"
  )
  (command "-style" "txt" "txt" "4" "1.0" "" "" "" "")
  (setq text (strcase (getstring T "请输入产品型号和公司标记及日期: ")))
  (command "text" (list -71.13 -105.6) 0 text)
  (terpri)
)
(PROMPT
  "\n 请运行命令'xw' 注：箭头向下，从左上角按常规方法读数"
)


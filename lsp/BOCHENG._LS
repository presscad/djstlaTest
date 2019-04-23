;(setq	ke1 0.981
;	ce1 0.3
;	kf1 0.0
;	cf1 0.3
;  )
;2001/6/7


(defun set_var ()
  (setq osnap_old (getvar "osmode"))
  (setq orthomode_old (getvar "orthomode"))
  (setvar "osmode" 0)
  (setvar "orthomode" 0)
  (list osnap_old orthomode_old)
)
(defun reset_var (var_list)
  (setvar "osmode" (car var_list))
  (setvar "orthomode" (cadr var_list))
)
(defun get_dt_vl (item dt)
  (cdr (assoc item dt))
)					;(defun C:CELLS()
(defun C:bch ()
  (setvar "gridmode" 0)			;Enter Truly PI plate data
  (setq e_input (getreal "Please input E: "))
  (setq g_input (getreal "Please input G: "))
  (setq h_input (getreal "Please input H: "))
  (setq en_pi (getint "Please input EN: "))
  (setq f_input (getreal "Please input F: "))
  (setq i_input (getreal "Please input I: "))
  (setq j_input (getreal "Please input J: "))
  (setq fn_pi (getint "Please input FN: "))
  (setq r_input (getreal "Please input R: "))
  (setq dis (getreal "请输入单粒的上边距十字标中心的距离:"))
					;Jing Bi formula
  (setq	ke1 0.982
	ce1 0.15
	kf1 0.0
	cf1 0.15
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
  (setq var_list (set_var))		;Draw a pi cell
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
  (command "mirror" "all" "" (list 0 0) (list 0 1) "y")
  (setq
    pl_ss
     (ssget "x"
	    (list (cons 0 "LWPOLYLINE")
	    )
     )
  )
  (if pl_ss
    (progn
      (setq total (sslength pl_ss))
      (setq count 0)
      (setq x_min (cadr (assoc 10 (entget (ssname pl_ss 0)))))
      (setq y_min (caddr (assoc 10 (entget (ssname pl_ss 0)))))
      (setq x_max x_min)
      (setq y_max y_min)
      (while (< count total)
	(setq pl_detail (entget (ssname pl_ss count)))
	(setq dt pl_detail)
	(while dt
	  (if (= (caar dt) 10)
	    (progn
	      (setq v_point (get_dt_vl 10 dt))
	      (setq y_max (max y_max (cadr v_point)))
	    )
	  )
	  (setq dt (cdr dt))
	)
	(setq count (1+ count))
      )
    )
  )
  (setq d (- 118.15 y_max))
  (setq y_dis (- d dis))
  (command "move" "all" "" (list 0 0) (list 0 y_dis))
  (command "pline"
	   (list -170.0 158.0)
	   "w"
	   0
	   0
	   (list -200.0 158.0)
	   (list -200.0 128.0)
	   (list -202.0 128.0)
	   (list -202.0 160.0)
	   (list -170.0 160.0)
	   "c"
  )
  (command "pline"
	   (list 202.0 128.0)
	   "w"
	   0
	   0
	   (list 202.0 160.0)
	   (list 166.0 160.0)
	   (list 166.0 158.0)
	   (list 200.0 158.0)
	   (list 200.0 128.0)
	   "c"
  )
  (command "pline"
	   (list 166.0 -160.0)
	   "w"
	   0
	   0
	   (list 202.0 -160.0)
	   (list 202.0 -128.0)
	   (list 200.0 -128.0)
	   (list 200.0 -158.0)
	   (list 166.0 -158.0)
	   "c"
  )
  (command "pline"
	   (list 180.3 -88.0)
	   "w"
	   0
	   0
	   (list 180.3 -78.0)
	   (list 180.0 -78.0)
	   (list 180.0 -88.0)
	   "c"
  )
  (command "pline"
	   (list -180.3 -88.0)
	   "w"
	   0
	   0
	   (list -180.3 -78.0)
	   (list -180.0 -78.0)
	   (list -180.0 -88.0)
	   "c"
  )
  (command "pline"
	   (list 185.15 118.3)
	   "w"
	   0
	   0
	   (list 180.3 118.3)
	   (list 180.3 123.15)
	   (list 180.0 123.15)
	   (list 180.0 118.3)
	   (list 175.15 118.3)
	   (list 175.15 118.0)
	   (list 180.0 118.0)
	   (list 180.0 113.15)
	   (list 180.3 113.15)
	   (list 180.3 118.0)
	   (list 185.15 118.0)
	   "c"
  )
  (command "pline"
	   (list -202.0 -128.0)
	   "w"
	   0
	   0
	   (list -202.0 -160.0)
	   (list -170.0 -160.0)
	   (list -170.0 -158.0)
	   (list -200.0 -158.0)
	   (list -200.0 -128.0)
	   "c"
  )
  (command "pline"
	   (list -185.15 118.3)
	   "w"
	   0
	   0
	   (list -180.3 118.3)
	   (list -180.3 123.15)
	   (list -180.0 123.15)
	   (list -180.0 118.3)
	   (list -175.15 118.3)
	   (list -175.15 118.0)
	   (list -180.0 118.0)
	   (list -180.0 113.15)
	   (list -180.3 113.15)
	   (list -180.3 118.0)
	   (list -185.15 118.0)
	   "c"
  )
  (reset_var var_list)
  (command "-style" "txt" "txt" "6" "1.0" "" "" "" "")
  (setq text (strcase (getstring T "请输入产品型号和公司标记及日期: ")))
  (command "text" (list 197.533 -92.1001) 90 text)
  (terpri)
)
(PROMPT "\n 请运行命令'bch'")

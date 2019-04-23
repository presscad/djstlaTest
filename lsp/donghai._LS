					;(defun C:CELLS()
(defun C:donghai()
  (setvar "gridmode" 0)					;Enter Truly PI plate data
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
  (setq	ke1 1.0
	ce1 0.0
	kf1 0.0
	cf1 0.0
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
	   "cl"
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
  (command "mirror" "all" "" (list 0 0)  (list 0 1) "y")
  (setq str_jg (getstring "a 点的座标是(0.00,159.181)吗？Y/N(Y)"))
  (if (/= (strcase str_jg) "N")
    (progn
      (command "pline"
	       (list 2.0 -157.18)
	       "w"
	       0
	       0
	       (list 2.0 -161.18)
	       (list -2.0 -161.18)
	       (list -2.0 -157.18)
	       (list -1.675 -157.18)
	       (list 1.3 -157.88)
	       (list -1.3 -157.88)
	       (list -1.3 -160.48)
	       (list 1.3 -160.48)
	       (list 1.3 -157.88)
	       (list -1.675 -157.18)
	       "c"
      )
      (command "pline"
	       (list 2.0 161.18)
	       "w"
	       0
	       0
	       (list 2.0 157.18)
	       (list -2.0 157.18)
	       (list -2.0 161.18)
	       (list -1.675 161.18)
	       (list 1.3 160.48)
	       (list -1.3 160.48)
	       (list -1.3 157.88)
	       (list 1.3 157.88)
	       (list 1.3 160.48)
	       (list -1.675 161.18)
	       "c"
      )
    )
    (progn
      (command "pline"
	       (list 2.0 (- 63.87 157.18))
	       "w"
	       0
	       0
	       (list 2.0 (- 63.87 161.18))
	       (list -2.0 (- 63.87 161.18))
	       (list -2.0 (- 63.87 157.18))
	       (list -1.675 (- 63.87 157.180))
	       (list 1.3 (- 63.87 157.88))
	       (list -1.3 (- 63.87 157.88))
	       (list -1.3 (- 63.87 160.48))
	       (list 1.3 (- 63.87 160.48))
	       (list 1.3 (- 63.87 157.88))
	       (list -1.675 (- 63.87 157.18))
	       "c"
      )
      (command "pline"
	       (list 2.0 (- 161.18 63.87))
	       "w"
	       0
	       0
	       (list 2.0 (- 157.18 63.87))
	       (list -2.0 (- 157.18 63.87))
	       (list -2.0 (- 161.18 63.87))
	       (list -1.675 (- 161.18 63.87))
	       (list 1.3 (- 160.48 63.87))
	       (list -1.3 (- 160.48 63.87))
	       (list -1.3 (- 157.88 63.87))
	       (list 1.3 (- 157.88 63.87))
	       (list 1.3 (- 160.48 63.87))
	       (list -1.675 (- 161.18 63.87))
	       "c"
      )

    )
  )
  (command "pline"
	   (list 149.0 2.0)
	   "w"
	   0
	   0
	   (list 149.0 -2.0)
	   (list 145.0 -2.0)
	   (list 145.0 2.0)
	   (list 145.325 2.0)
	   (list 148.3 1.3)
	   (list 145.7 1.3)
	   (list 145.7 -1.3)
	   (list 148.3 -1.3)
	   (list 148.3 1.3)
	   (list 145.325 2.0)
	   "c"
  )
  (command "pline"
	   (list -145.0 2.0)
	   "w"
	   0
	   0
	   (list -145.0 -2.0)
	   (list -149.0 -2.0)
	   (list -149.0 2.0)
	   (list -148.675 2.0)
	   (list -145.7 1.3)
	   (list -148.3 1.3)
	   (list -148.3 -1.3)
	   (list -145.7 -1.3)
	   (list -145.7 1.3)
	   (list -148.675 2.0)
	   "c"
  )
  (command "pline"
	   (list 202.0 189.39)
	   "w"
	   0
	   0
	   (list 202.0 169.39)
	   (list 200.0 169.39)
	   (list 200.0 187.39)
	   (list 182.0 187.39)
	   (list 182.0 189.39)
	   "c"
  )
  (command "pline"
	   (list -202.0 189.39)
	   "w"
	   0
	   0
	   (list -182.0 189.39)
	   (list -182.0 187.39)
	   (list -200.0 187.39)
	   (list -200.0 169.39)
	   (list -202.0 169.39)
	   "c"
  )
  (command "pline"
	   (list -202.0 -229.61)
	   "w"
	   0
	   0
	   (list -202.0 -209.61)
	   (list -200.0 -209.61)
	   (list -200.0 -227.61)
	   (list -182.0 -227.61)
	   (list -182.0 -229.61)
	   "c"
  )
  (command "pline"
	   (list 202.0 -229.61)
	   "w"
	   0
	   0
	   (list 182.0 -229.61)
	   (list 182.0 -227.61)
	   (list 200.0 -227.61)
	   (list 200.0 -209.61)
	   (list 202.0 -209.61)
	   "c"
  )
  (command "pline"
	   (list 150.25 147.14)
	   "w"
	   0
	   0
	   (list 150.25 143.39)
	   (list 149.75 143.39)
	   (list 149.75 147.14)
	   (list 146.0 147.14)
	   (list 146.0 147.64)
	   (list 149.75 147.64)
	   (list 149.75 151.39)
	   (list 150.25 151.39)
	   (list 150.25 147.64)
	   (list 154.0 147.64)
	   (list 154.0 147.14)
	   "c"
  )
  (command "pline"
	   (list 150.25 -147.64)
	   "w"
	   0
	   0
	   (list 150.25 -151.39)
	   (list 149.75 -151.39)
	   (list 149.75 -147.64)
	   (list 146.0 -147.64)
	   (list 146.0 -147.14)
	   (list 149.75 -147.14)
	   (list 149.75 -143.39)
	   (list 150.25 -143.39)
	   (list 150.25 -147.14)
	   (list 154.0 -147.14)
	   (list 154.0 -147.64)
	   "c"
  )
  (command "pline"
	   (list -149.75 -147.64)
	   "w"
	   0
	   0
	   (list -149.75 -151.39)
	   (list -150.25 -151.39)
	   (list -150.25 -147.64)
	   (list -154.0 -147.64)
	   (list -154.0 -147.14)
	   (list -150.25 -147.14)
	   (list -150.25 -143.39)
	   (list -149.75 -143.39)
	   (list -149.75 -147.14)
	   (list -146.0 -147.14)
	   (list -146.0 -147.64)
	   "c"
  )
  (command "pline"
	   (list -149.75 147.14)
	   "w"
	   0
	   0
	   (list -149.75 143.39)
	   (list -150.25 143.39)
	   (list -150.25 147.14)
	   (list -154.0 147.14)
	   (list -154.0 147.64)
	   (list -150.25 147.64)
	   (list -150.25 151.39)
	   (list -149.75 151.39)
	   (list -149.75 147.64)
	   (list -146.0 147.64)
	   (list -146.0 147.14)
	   "c"
  )
;dummy
(command "pline" (list 200.0 -227.61) "w" 0 0 
                         (list 200.0 -227.51) 
                         (list -200.0 -227.51) 
                         (list -200.0 -227.61) 
                         "c"
         )
        (command "pline" (list 200.0 -226.61) "w" 0 0 
                         (list 200.0 -226.51) 
                         (list -200.0 -226.51) 
                         (list -200.0 -226.61) 
                         "c"
         )
        (command "pline" (list 200.0 -225.61) "w" 0 0 
                         (list 200.0 -225.51) 
                         (list -200.0 -225.51) 
                         (list -200.0 -225.61) 
                         "c"
         )
        (command "pline" (list 200.0 -224.61) "w" 0 0 
                         (list 200.0 -224.51) 
                         (list -200.0 -224.51) 
                         (list -200.0 -224.61) 
                         "c"
         )
        (command "pline" (list 200.0 -223.61) "w" 0 0 
                         (list 200.0 -223.51) 
                         (list -200.0 -223.51) 
                         (list -200.0 -223.61) 
                         "c"
         )
        (command "pline" (list 200.0 -222.61) "w" 0 0 
                         (list 200.0 -222.51) 
                         (list -200.0 -222.51) 
                         (list -200.0 -222.61) 
                         "c"
         )
        (command "pline" (list 200.0 -221.61) "w" 0 0 
                         (list 200.0 -221.51) 
                         (list -200.0 -221.51) 
                         (list -200.0 -221.61) 
                         "c"
         )
        (command "pline" (list 200.0 -220.61) "w" 0 0 
                         (list 200.0 -220.51) 
                         (list -200.0 -220.51) 
                         (list -200.0 -220.61) 
                         "c"
         )
        (command "pline" (list 200.0 -219.61) "w" 0 0 
                         (list 200.0 -219.51) 
                         (list -200.0 -219.51) 
                         (list -200.0 -219.61) 
                         "c"
         )
        (command "pline" (list 200.0 -218.61) "w" 0 0 
                         (list 200.0 -218.51) 
                         (list -200.0 -218.51) 
                         (list -200.0 -218.61) 
                         "c"
         )
        (command "pline" (list 200.0 187.29) "w" 0 0 
                         (list 200.0 187.39) 
                         (list -200.0 187.39) 
                         (list -200.0 187.29) 
                         "c"
         )
        (command "pline" (list 200.0 186.29) "w" 0 0 
                         (list 200.0 186.39) 
                         (list -200.0 186.39) 
                         (list -200.0 186.29) 
                         "c"
         )
        (command "pline" (list 200.0 185.29) "w" 0 0 
                         (list 200.0 185.39) 
                         (list -200.0 185.39) 
                         (list -200.0 185.29) 
                         "c"
         )
        (command "pline" (list 200.0 184.29) "w" 0 0 
                         (list 200.0 184.39) 
                         (list -200.0 184.39) 
                         (list -200.0 184.29) 
                         "c"
         )
        (command "pline" (list 200.0 183.29) "w" 0 0 
                         (list 200.0 183.39) 
                         (list -200.0 183.39) 
                         (list -200.0 183.29) 
                         "c"
         )
        (command "pline" (list 200.0 182.29) "w" 0 0 
                         (list 200.0 182.39) 
                         (list -200.0 182.39) 
                         (list -200.0 182.29) 
                         "c"
         )
        (command "pline" (list 200.0 181.29) "w" 0 0 
                         (list 200.0 181.39) 
                         (list -200.0 181.39) 
                         (list -200.0 181.29) 
                         "c"
         )
        (command "pline" (list 200.0 180.29) "w" 0 0 
                         (list 200.0 180.39) 
                         (list -200.0 180.39) 
                         (list -200.0 180.29) 
                         "c"
         )
        (command "pline" (list 200.0 179.29) "w" 0 0 
                         (list 200.0 179.39) 
                         (list -200.0 179.39) 
                         (list -200.0 179.29) 
                         "c"
         )
        (command "pline" (list 200.0 178.29) "w" 0 0 
                         (list 200.0 178.39) 
                         (list -200.0 178.39) 
                         (list -200.0 178.29) 
                         "c"
         )

  
  (command "-style" "txt" "txt" "6" "1" "" "" "" "")
  ;(setq 1_text (strcase (getstring T "输入公司标记和日期: ")))
  (setq c_date (getvar "CDATE"))
  (setq apr_id (strcat " QINGYI " (itoa (fix c_date))))
  (command "text" (list -47.3562 -209.032) 0 apr_id)
  (command "-style" "txt" "txt" "11" "0.7" "" "" "" "")
  (setq 2_text (strcase (getstring T "输入产品型号: ")))
  (command "text" (list 177.059 148.397) 270 2_text)
  (terpri)
)
(PROMPT "\n 请运行命令'donghai'\n")
(alert "此客户原来是广州精工")
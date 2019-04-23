
(defun dg () 
        (command "pline" (list -260.0 255.0) "w" 0 0 
                         (list -260.0 257.0) 
                         (list 260.0 257.0) 
                         (list 260.0 255.0) 
                         "c"
         )
        (command "pline" (list 260.0 -257.0) "w" 0 0 
                         (list 260.0 -255.0) 
                         (list -260.0 -255.0) 
                         (list -260.0 -257.0) 
                         "c"
         )
        (command "pline" (list 272.0 -245.0) "w" 0 0 
                         (list 272.0 245.0) 
                         (list 270.0 245.0) 
                         (list 270.0 -245.0) 
                         "c"
         )
        (command "pline" (list -270.0 -245.0) "w" 0 0 
                         (list -270.0 245.0) 
                         (list -272.0 245.0) 
                         (list -272.0 -245.0) 
                         "c"
         )
        (command "pline" (list 202.121 -202.142) "w" 0 0 
                         (list 187.121 -202.142) 
                         (list 187.121 -201.942) 
                         (list 202.121 -201.942) 
                         "c"
         )
        (command "pline" (list 4.99992 -201.942) "w" 0 0 
                         (list -5.00008 -201.942) 
                         (list -5.00008 -202.142) 
                         (list -0.100085 -202.142) 
                         (list -0.100085 -207.042) 
                         (list 0.099915 -207.042) 
                         (list 0.099915 -202.142) 
                         (list 4.99992 -202.142) 
                         "c"
         )
        (command "pline" (list -194.521 -207.042) "w" 0 0 
                         (list -194.721 -207.042) 
                         (list -194.721 -202.142) 
                         (list -199.671 -202.142) 
                         (list -199.671 -201.942) 
                         (list -194.721 -201.942) 
                         (list -194.721 -197.042) 
                         (list -194.521 -197.042) 
                         (list -194.521 -201.942) 
                         (list -189.621 -201.942) 
                         (list -189.621 -202.142) 
                         (list -194.521 -202.142) 
                         "c"
         )
        (command "pline" (list -194.521 207.042) "w" 0 0 
                         (list -194.521 202.142) 
                         (list -189.621 202.142) 
                         (list -189.621 201.942) 
                         (list -194.521 201.942) 
                         (list -194.521 197.042) 
                         (list -194.721 197.042) 
                         (list -194.721 201.942) 
                         (list -199.671 201.942) 
                         (list -199.671 202.142) 
                         (list -194.721 202.142) 
                         (list -194.721 207.042) 
                         "c"
         )
        (command "pline" (list 0.099915 202.142) "w" 0 0 
                         (list 4.99992 202.142) 
                         (list 4.99992 201.942) 
                         (list -5.00008 201.942) 
                         (list -5.00008 202.142) 
                         (list -0.100085 202.142) 
                         (list -0.100085 207.042) 
                         (list 0.099915 207.042) 
                         "c"
         )
        (command "pline" (list 187.121 202.142) "w" 0 0 
                         (list 187.121 201.942) 
                         (list 202.121 201.942) 
                         (list 202.121 202.142) 
                         "c"
         )
        (command "pline" (list 272.0 245.0) "w" 0 0 
                         (list 272.0 257.0) 
                         (list 260.0 257.0) 
                         (list 260.0 255.0) 
                         (list 270.0 255.0) 
                         (list 270.0 245.0) 
                         "c"
         )
        (command "pline" (list -260.0 257.0) "w" 0 0 
                         (list -272.0 257.0) 
                         (list -272.0 245.0) 
                         (list -270.0 245.0) 
                         (list -270.0 255.0) 
                         (list -260.0 255.0) 
                         "c"
         )
        (command "pline" (list -272.0 -245.0) "w" 0 0 
                         (list -272.0 -257.0) 
                         (list -260.0 -257.0) 
                         (list -260.0 -255.0) 
                         (list -270.0 -255.0) 
                         (list -270.0 -245.0) 
                         "c"
         )
        (command "pline" (list 270.0 -255.0) "w" 0 0 
                         (list 270.0 -245.0) 
                         (list 272.0 -245.0) 
                         (list 272.0 -257.0) 
                         (list 260.0 -257.0) 
                         (list 260.0 -255.0) 
                         "c"
         )
          (command "pline" (list 263.128 99.0193) "w" 0 0 
                         (list 262.568 99.0193) 
                         (list 262.568 163.974) 
                         (list 260.558 153.093) 
                         (list 260.007 153.195) 
                         (list 262.863 168.649) 
                         (list 265.718 153.195) 
                         (list 265.167 153.093) 
                         (list 263.128 164.13) 
                         "c"
         )
  )	
(defun C:dldf()       
	(setq e_input (* (getreal "Please input E （英寸/510方向）: ") 25.4))
	(setq g_input (* (getreal "Please input G （英寸）: ") 25.4))
	(setq h_input (* (getreal "Please input H （英寸）: ") 25.4))
	(setq en_pi (getint "Please input EN: "))
	(setq f_input (* (getreal "Please input F （英寸）: ") 25.4))
	(setq i_input (* (getreal "Please input I （英寸）: ") 25.4))
	(setq j_input (* (getreal "Please input J （英寸）: ") 25.4))
	(setq fn_pi (getint "Please input FN: "))
	(setq r_input (* (getreal "Please input R （英寸）: ") 25.4))
	(setq ke1 0.9968
	      ce1 0.7018
	      kf1 0.0
	      cf1 0.3
	)
  (setq e_pi (* ke1 (- e_input ce1)))
  (setq g_pi (* ke1 (+ g_input ce1)))
  (setq h_pi (* ke1 (+ h_input ce1)))
  (setq f_pi (- f_input (+ cf1 (* kf1 f_input))))
  (setq i_pi (+ i_input (+ cf1 (* kf1 f_input))))
  (setq j_pi (+ j_input (+ cf1 (* kf1 f_input))))
  (if(> r_input 0.4)
     (setq r_pi r_input)
     (setq r_pi 0.01)		;r_pi must be nozero
  )
  (command "limits" (list -1000 -1000) (list 1000 800))
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
  (dg)
  (command "-style" "txt" "txt" "8" "1" "" "" "" "")
  (setq 1_text (strcase (getstring T "输入公司标记和日期: ")))
  
  (command "text" (list 262 -104) 90 1_text)
  (terpri)
)
(PROMPT "\n 请运行命令'dldf'")

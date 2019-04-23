;1 last modified 2003/7/20, customer change thire dummy(up and down).

;2 2004-05-20周华刚修改此程序的收缩系数及补偿值:
;             Ke = 0.987  ce = 0.25  cf = 0.2 (之前最近参数为 Ke = 0.987  ce = 0.2  cf = 0.2)
;            液体版专用，若有固体版再同贾工联系)

;2 2004-10-15周华刚修改此程序的收缩系数及补偿值:
;             Ke = 0.987  ce = 0.25  cf = 0.2 (之前最近参数为 Ke = 0.987  ce = 0.2  cf = 0.2)
;            液体版专用，若有固体版再同贾工联系)

(defun c:jic ()
  (defun chk_total (e g h n et_input str_drct)
    (if	(= (rem n 2) 1)
      (setq et_cul (+ (* e n)
		      (* g (/ (- n 1) 2))
		      (* h (/ (- n 1) 2))
		   )
      )
      (setq et_cul (+ (* e n)
		      (* g (/ n 2))
		      (* h (- (/ n 2) 1))
		   )
      )
    )
    (if	(not (equal et_input et_cul 0.001))
      (progn
	(getstring (strcat "输入的"	     str_drct
			   "T与计算出的"     str_drct
			   "Total不同请确认！"
			  )
	)
	(quit)
      )
    )
  )
  (initget "Yes No")
  (setq	apr_type
	 (getKword
	   "\n是TOP COATING吗(model号中有'TOP COAT'时，只在'-'号方向加两个小十字)? (Y/N)"
	 )
  )
  (setq A_in (getreal "\n请输入A:"))
  (setq B_in (getreal "\n请输入B:"))
  (setq C_in (getreal "\n请输入C:"))
  (setq D_in (getreal "\n请输入D:"))
  (setq e_input (getreal "Please input E: "))
  (setq et_input (getreal (strcat "请输入E方向总长E_total:")))
  (setq en_pi (getint "Please input EN: "))
  (setq f_input (getreal "Please input F: "))
  (setq ft_input (getreal (strcat "请输入F方向总长F_total:")))
  (setq fn_pi (getint "Please input FN: "))
  (setq g_input (getreal "Please input G: "))
  (setq h_input (getreal "Please input H: "))
  (chk_total e_input g_input h_input en_pi et_input "E")
  (setq i_input (getreal "Please input I: "))
  (setq j_input (getreal "Please input J: "))
  (chk_total f_input i_input j_input fn_pi ft_input "F")
  (setq r_input (getreal "Please input R: "))
  (setq EL_in (getreal "\n请输入EL:"))
  (setq FL_in (getreal "\n请输入FL:"))
  (setq M_in (getreal "\n请输入M:"))
  (setq M1_in (getreal "\n请输入M1:"))
  (setq N_in (getreal "\n请输入N:"))
  (setq N1_in (getreal "\n请输入N1:"))
  (setq O_in (getreal "\n请输入O:"))
  (setq O1_in (getreal "\n请输入O1:"))
  (setq P_in (getreal "\n请输入P:"))
  (setq P1_in (getreal "\n请输入P1:"))
					;(setq	A_in  16.25
					;	B_in  16.25
					;	C_in  10.8
					;	D_in  10.8
					;	M_in  2
					;	M1_in 4.5
					;	N_in  2
					;	N1_in 4.5
					;	O_in  3.05
					;	O1_in 4.5
					;	p_in  3.05
					;	P1_in 4.5
					;	EL_in 406.4
					;	Fl_in 355.6
					; )
  (setq	ke1 0.987
	ce1 0.25
	kf1 0.0000
	cf1 0.2
  )
(getstring (strcat "请确认系数是：Ke=" (rtos ke1) "; Ce=" (rtos ce1) "; Cf=" (rtos cf1)))					;draw left frame
(alert"液体版专用，若有固体版再同贾工联系")
  (command "zoom" "w" (list -300 -300) (list 300 300))
  (setq left_frm_width (- C_in P_in P1_in))
  (setq right_frm_width (- D_in O_in O1_in))
  (setq left_frm_high (- EL_in 13.2 13.2))
  (setq left_frm_high (* left_frm_high ke1))
  (setq fl_in (/ fl_in 2))
  (setq frm_high (/ left_frm_high 2))
  (setq Half_el (/ el_in 2))
  (if (> C_in (+ P_in P1_in))
    (progn
      (command
	"pline"
	(list (- (- fl_in p1_in)) (- frm_high))
	(list (- (- fl_in p1_in left_frm_width)) (- frm_high))
	(list (- (- fl_in p1_in left_frm_width)) (+ frm_high))
	(list (- (- fl_in p1_in)) (+ frm_high))
	(list (- (- fl_in p1_in)) (* (+ 136.85 11.65) ke1))
	(list (- (- fl_in p1_in 2.5)) (* (+ 136.85 11.65) ke1))
	(list (- (- fl_in p1_in 2.5))
	      (* 136.85 ke1)
	)
	(list (- (- fl_in p1_in)) (* 136.85 ke1))
	(list (- (- fl_in p1_in)) (* 20 ke1))
	(list (- (- fl_in p1_in 2)) (* 20 ke1))
	(list (- (- fl_in p1_in 2)) (* -20 ke1))
	(list (- (- fl_in p1_in)) (* -20 ke1))
	(list (- (- fl_in p1_in))
	      (* (- 136.85) ke1)
	)
	(list (- (- fl_in p1_in 2.5))
	      (* (- 136.85) ke1)
	)
	(list (- (- fl_in p1_in 2.5)) (* (- (+ 136.85 11.65)) ke1))
	(list (- (- fl_in p1_in)) (* (- (+ 136.85 11.65)) ke1))
	"C"
      )
    )
  )
  (if (> D_in (+ O_in O1_in))		;Draw right protective edge
    (progn
      (command "pline"
	       (list (- fl_in o1_in) (- frm_high))
	       (list (- fl_in o1_in right_frm_width) (- frm_high))
	       (list (- fl_in o1_in right_frm_width) frm_high)
	       (list (- fl_in o1_in) frm_high)
	       (list (- fl_in o1_in) (* (+ 136.85 11.65) ke1))
	       (list (- fl_in o1_in 2.5) (* (+ 136.85 11.65) ke1))
	       (list (- fl_in o1_in 2.5) (* 136.85 ke1))
	       (list (- fl_in o1_in) (* 136.85 ke1))
	       (list (- fl_in o1_in) (* 20 ke1))
	       (list (- fl_in o1_in 2) (* 20 ke1))
	       (list (- fl_in o1_in 2) (* -20 ke1))
	       (list (- fl_in o1_in) (* -20 ke1))
	       (list (- fl_in o1_in) (- (* 136.85 ke1)))
	       (list (- fl_in o1_in 2.5)
		     (- (* 136.85 ke1))
	       )
	       (list (- fl_in o1_in 2.5) (- (* (+ 136.85 11.65) ke1)))
	       (list (- fl_in o1_in) (- (* (+ 136.85 11.65) ke1)))
	       "C"
      )
    )
  )
					;Draw upon protective edge
  (if (> A_in (+ M_in M1_in))
    (progn
      (setq up_frm_width (- A_in m_in m1_in))
      (setq p1 (list (- (- fl_in p1_in left_frm_width 4))
		     (* (- half_el m1_in up_frm_width) ke1)
	       )
      )
      (setq p2 (list (- fl_in o1_in right_frm_width 4)
		     (* (- half_el m1_in up_frm_width) ke1)
	       )
      )
      (setq p3 (list (- fl_in o1_in right_frm_width 4)
		     (* (- half_el m1_in) ke1)
	       )
      )
      (setq p4 (list (- (- fl_in p1_in left_frm_width 4))
		     (* (- half_el m1_in) ke1)
	       )
      )
      (command "pline"
	       p1
	       p2
	       p3
	       (list 20 (cadr p3))
	       (list 20 (- (cadr p3) 2))
	       (list -20 (- (cadr p3) 2))
	       (list -20 (cadr p3))
	       (list -92.8 (cadr P3))
	       (list -92.8  (- (cadr P3) 2))
	       (list -102.8 (- (cadr P3) 2))
	       (list -102.8 (cadr P3))
	       P4
	       "c"
      )
    )
  )


					;Draw down protective edge
  (if (> B_in (+ N_in N1_in))
    (progn
      (setq down_frm_width (- B_in n_in n1_in))
      (setq p1 (list (- (- fl_in p1_in left_frm_width 4))
		     (- (* (- half_el n1_in down_frm_width) ke1))
	       )
      )
      (setq p2 (list (- fl_in o1_in right_frm_width 4)
		     (- (* (- half_el n1_in down_frm_width) ke1))
	       )
      )
      (setq p3 (list (- fl_in o1_in right_frm_width 4)
		     (- (* (- half_el n1_in) ke1))
	       )
      )
      (setq p4 (list (- (- fl_in p1_in left_frm_width 4))
		     (- (* (- half_el n1_in) ke1))
	       )
      )
      (command "pline"
	       p1
	       p2
	       p3
	       ;(list 102.8 (cadr P3))
	       ;(list 102.8 (+ (cadr P3) 2))
	       ;(list 92.8 (+ (cadr P3) 2))
	       ;(list 92.8 (cadr P3))
		     
	       (list 27.5 (cadr p3))
	       (list 27.5 (+ (cadr p3) 2))
	       (list -27.5 (+ (cadr p3) 2))
	       (list -27.5 (cadr p3))
	       ;(list -92.8 (cadr P3))
	       ;(list -92.8 (+ (cadr P3) 2))
	       ;(list -102.8 (+ (cadr P3) 2))
	       ;(list -102.8 (cadr P3))
					;(list (- (- fl_in 80)) (cadr p3))
					;(list (- (- fl_in 80)) (+ (cadr p3) 5))
					;(list (- (- fl_in 70)) (+ (cadr p3) 5))
					;(list (- (- fl_in 70)) (cadr p3))
	       P4
	       "c"
      )
    )
  )
  (if (= apr_type "No")
    (progn
      (command "pline"
	       (list (- fl_in 3.95) (* 69.05 ke1))
	       "@1.9,0"
	       "@0,1.9"
	       "@-1.9,0"
	       "@0,-1.9"
	       "@0.2,0.2"
	       "@1.5,0"
	       "@0,1.5"
	       "@-1.5,0"
	       "@0,-1.5"
	       "c"
      )
      (command "pline"
	       (list (- fl_in 3.25) (* 69.95 ke1))
	       "@0.2,0"
	       "@0,-0.2"
	       "@0.1,0"
	       "@0,0.2"
	       "@0.2,0"
	       "@0,0.1"
	       "@-0.2,0"
	       "@0,0.2"
	       "@-0.1,0"
	       "@0,-0.2"
	       "@-0.2,0"
	       "c"
      )
      (command "pline"
	       (list (- (- fl_in 2.05)) (* 69.05 ke1))
	       "@1.9,0"
	       "@0,1.9"
	       "@-1.9,0"
	       "@0,-1.9"
	       "@0.2,0.2"
	       "@1.5,0"
	       "@0,1.5"
	       "@-1.5,0"
	       "@0,-1.5"
	       "c"
      )
      (command "pline"
	       (list (- (- fl_in 2.75)) (* 69.95 ke1))
	       "@0.2,0"
	       "@0,-0.2"
	       "@0.1,0"
	       "@0,0.2"
	       "@0.2,0"
	       "@0,0.1"
	       "@-0.2,0"
	       "@0,0.2"
	       "@-0.1,0"
	       "@0,-0.2"
	       "@-0.2,0"
	       "c"
      )
    )
  )
      (command "pline"
	       (list (- fl_in 3.95) (* -70.975 ke1))
	       "@1.9,0"
	       "@0,1.9"
	       "@-1.9,0"
	       "@0,-1.9"
	       "@0.2,0.2"
	       "@1.5,0"
	       "@0,1.5"
	       "@-1.5,0"
	       "@0,-1.5"
	       "c"
      )
      (command "pline"
	       (list (- fl_in 3.25) (* -70.05 ke1))
	       "@0.2,0"
	       "@0,-0.2"
	       "@0.1,0"
	       "@0,0.2"
	       "@0.2,0"
	       "@0,0.1"
	       "@-0.2,0"
	       "@0,0.2"
	       "@-0.1,0"
	       "@0,-0.2"
	       "@-0.2,0"
	       "c"
      )
      (command "pline"
	       (list (- (- fl_in 2.05)) (* -70.975 ke1))
	       "@1.9,0"
	       "@0,1.9"
	       "@-1.9,0"
	       "@0,-1.9"
	       "@0.2,0.2"
	       "@1.5,0"
	       "@0,1.5"
	       "@-1.5,0"
	       "@0,-1.5"
	       "c"
      )
      (command "pline"
	       (list (- (- fl_in 2.75)) (* -70.05 ke1))
	       "@0.2,0"
	       "@0,-0.2"
	       "@0.1,0"
	       "@0,0.2"
	       "@0.2,0"
	       "@0,0.1"
	       "@-0.2,0"
	       "@0,0.2"
	       "@-0.1,0"
	       "@0,-0.2"
	       "@-0.2,0"
	       "c"
      )
  (draw_edge)				;Enter Truly PI plate data
					;Jing Bi formul
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

  (command "limits" (list -300 -300) (list 1000 800))
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
	   "CLOSE"
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
  (terpri)
  (command "mirror" "all" "" (list 0 0) (list 0 100) "Y")
  (setq input_text (getstring T "请输入标识ID:"))
  (command "text" "j" "c" (list 0 217) 8 0 input_text)  
)
(defun draw_edge ()
  (command "pline"
	   (list 219.0 -257.5)
	   "w"
	   0
	   0
	   (list 209.0 -257.5)
	   (list 209.0 -259.5)
	   (list 221.0 -259.5)
	   (list 221.0 -247.5)
	   (list 219.0 -247.5)
	   "c"
  )
  (command "pline"
	   (list -219.0 -257.5)
	   "w"
	   0
	   0
	   (list -209.0 -257.5)
	   (list -209.0 -259.5)
	   (list -221.0 -259.5)
	   (list -221.0 -247.5)
	   (list -219.0 -247.5)
	   "c"
  )
  (command "pline"
	   (list 219.0 260.5)
	   "w"
	   0
	   0
	   (list 209.0 260.5)
	   (list 209.0 262.5)
	   (list 221.0 262.5)
	   (list 221.0 250.5)
	   (list 219.0 250.5)
	   "c"
  )
  (command "pline"
	   (list -219.0 260.5)
	   "w"
	   0
	   0
	   (list -209.0 260.5)
	   (list -209.0 262.5)
	   (list -221.0 262.5)
	   (list -221.0 250.5)
	   (list -219.0 250.5)
	   "c"
  )
  (command "pline"
	   (list 219.0 260.5)
	   "w"
	   0
	   0
	   (list 219.0 260.4)
	   (list -219.0 260.4)
	   (list -219.0 260.5)
	   "c"
  )
  (command "pline"
	   (list 219.0 258.5)
	   "w"
	   0
	   0
	   (list 219.0 258.4)
	   (list -219.0 258.4)
	   (list -219.0 258.5)
	   "c"
  )
  (command "pline"
	   (list 219.0 256.5)
	   "w"
	   0
	   0
	   (list 219.0 256.4)
	   (list -219.0 256.4)
	   (list -219.0 256.5)
	   "c"
  )
  (command "pline"
	   (list 219.0 254.5)
	   "w"
	   0
	   0
	   (list 219.0 254.4)
	   (list -219.0 254.4)
	   (list -219.0 254.5)
	   "c"
  )
  (command "pline"
	   (list 219.0 252.5)
	   "w"
	   0
	   0
	   (list 219.0 252.4)
	   (list -219.0 252.4)
	   (list -219.0 252.5)
	   "c"
  )
  (command "pline"
	   (list 219.0 250.5)
	   "w"
	   0
	   0
	   (list 219.0 250.4)
	   (list -219.0 250.4)
	   (list -219.0 250.5)
	   "c"
  )
  (command "pline"
	   (list 219.0 248.5)
	   "w"
	   0
	   0
	   (list 219.0 248.4)
	   (list -219.0 248.4)
	   (list -219.0 248.5)
	   "c"
  )
  (command "pline"
	   (list 219.0 246.5)
	   "w"
	   0
	   0
	   (list 219.0 246.4)
	   (list -219.0 246.4)
	   (list -219.0 246.5)
	   "c"
  )
  (command "pline"
	   (list 219.0 244.5)
	   "w"
	   0
	   0
	   (list 219.0 244.4)
	   (list -219.0 244.4)
	   (list -219.0 244.5)
	   "c"
  )
  (command "pline"
	   (list 219.0 242.5)
	   "w"
	   0
	   0
	   (list 219.0 242.4)
	   (list -219.0 242.4)
	   (list -219.0 242.5)
	   "c"
  )
  (command "pline"
	   (list 219.0 240.5)
	   "w"
	   0
	   0
	   (list 219.0 240.4)
	   (list -219.0 240.4)
	   (list -219.0 240.5)
	   "c"
  )
  (command "pline"
	   (list 219.0 238.5)
	   "w"
	   0
	   0
	   (list 219.0 238.4)
	   (list -219.0 238.4)
	   (list -219.0 238.5)
	   "c"
  )
  (command "pline"
	   (list 219.0 236.5)
	   "w"
	   0
	   0
	   (list 219.0 236.4)
	   (list -219.0 236.4)
	   (list -219.0 236.5)
	   "c"
  )
  (command "pline"
	   (list -219.0 -233.5)
	   "w"
	   0
	   0
	   (list -219.0 -233.4)
	   (list 219.0 -233.4)
	   (list 219.0 -233.5)
	   "c"
  )
  (command "pline"
	   (list -219.0 -235.5)
	   "w"
	   0
	   0
	   (list -219.0 -235.4)
	   (list 219.0 -235.4)
	   (list 219.0 -235.5)
	   "c"
  )
  (command "pline"
	   (list -219.0 -237.5)
	   "w"
	   0
	   0
	   (list -219.0 -237.4)
	   (list 219.0 -237.4)
	   (list 219.0 -237.5)
	   "c"
  )
  (command "pline"
	   (list -219.0 -239.5)
	   "w"
	   0
	   0
	   (list -219.0 -239.4)
	   (list 219.0 -239.4)
	   (list 219.0 -239.5)
	   "c"
  )
  (command "pline"
	   (list -219.0 -241.5)
	   "w"
	   0
	   0
	   (list -219.0 -241.4)
	   (list 219.0 -241.4)
	   (list 219.0 -241.5)
	   "c"
  )
  (command "pline"
	   (list -219.0 -243.5)
	   "w"
	   0
	   0
	   (list -219.0 -243.4)
	   (list 219.0 -243.4)
	   (list 219.0 -243.5)
	   "c"
  )
  (command "pline"
	   (list -219.0 -245.5)
	   "w"
	   0
	   0
	   (list -219.0 -245.4)
	   (list 219.0 -245.4)
	   (list 219.0 -245.5)
	   "c"
  )
  (command "pline"
	   (list -219.0 -247.5)
	   "w"
	   0
	   0
	   (list -219.0 -247.4)
	   (list 219.0 -247.4)
	   (list 219.0 -247.5)
	   "c"
  )
  (command "pline"
	   (list -219.0 -249.5)
	   "w"
	   0
	   0
	   (list -219.0 -249.4)
	   (list 219.0 -249.4)
	   (list 219.0 -249.5)
	   "c"
  )
  (command "pline"
	   (list -219.0 -251.5)
	   "w"
	   0
	   0
	   (list -219.0 -251.4)
	   (list 219.0 -251.4)
	   (list 219.0 -251.5)
	   "c"
  )
  (command "pline"
	   (list -219.0 -253.5)
	   "w"
	   0
	   0
	   (list -219.0 -253.4)
	   (list 219.0 -253.4)
	   (list 219.0 -253.5)
	   "c"
  )
  (command "pline"
	   (list -219.0 -255.5)
	   "w"
	   0
	   0
	   (list -219.0 -255.4)
	   (list 219.0 -255.4)
	   (list 219.0 -255.5)
	   "c"
  )
  (command "pline"
	   (list -219.0 -257.5)
	   "w"
	   0
	   0
	   (list -219.0 -257.4)
	   (list 219.0 -257.4)
	   (list 219.0 -257.5)
	   "c"
  )
  (command "pline"
	   (list -199.75 190.0)
	   "w"
	   0
	   0
	   (list -200.25 190.0)
	   (list -200.25 197.25)
	   (list -207.5 197.25)
	   (list -207.5 197.75)
	   (list -200.25 197.75)
	   (list -200.25 205.0)
	   (list -199.75 205.0)
	   (list -199.75 197.75)
	   (list -192.5 197.75)
	   (list -192.5 197.25)
	   (list -199.75 197.25)
	   "c"
  )
  (command "pline"
	   (list -200.25 7.5)
	   "w"
	   0
	   0
	   (list -199.75 7.5)
	   (list -199.75 -7.5)
	   (list -200.25 -7.5)
	   (list -200.25 -0.25)
	   (list -207.5 -0.25)
	   (list -207.5 0.25)
	   (list -200.25 0.25)
	   "c"
  )
  (command "pline"
	   (list -200.25 -190.0)
	   "w"
	   0
	   0
	   (list -199.75 -190.0)
	   (list -199.75 -205.0)
	   (list -200.25 -205.0)
	   "c"
  )
  (command "pline"
	   (list 199.75 190.0)
	   "w"
	   0
	   0
	   (list 200.25 190.0)
	   (list 200.25 197.25)
	   (list 207.5 197.25)
	   (list 207.5 197.75)
	   (list 200.25 197.75)
	   (list 200.25 205.0)
	   (list 199.75 205.0)
	   (list 199.75 197.75)
	   (list 192.5 197.75)
	   (list 192.5 197.25)
	   (list 199.75 197.25)
	   "c"
  )
  (command "pline"
	   (list 200.25 7.5)
	   "w"
	   0
	   0
	   (list 199.75 7.5)
	   (list 199.75 -7.5)
	   (list 200.25 -7.5)
	   (list 200.25 -0.25)
	   (list 207.5 -0.25)
	   (list 207.5 0.25)
	   (list 200.25 0.25)
	   "c"
  )
  (command "pline"
	   (list 200.25 -190.0)
	   "w"
	   0
	   0
	   (list 199.75 -190.0)
	   (list 199.75 -205.0)
	   (list 200.25 -205.0)
	   "c"
  )
)

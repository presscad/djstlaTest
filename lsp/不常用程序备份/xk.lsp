 ;THis program fitted for TRULY TN MIXED PI PRINT PLATE
 ;r_pi=r_input - 0.4
 ;Jibi change  0.67 to 0.77
 ;after 97/07/03 ke1=0.9868 ce1=0.7700 kf1=0.0014 cf1=0.5060
 ;after 97/07/16 ke1=0.9873 ce1=0.7300 kf1=0.0014 cf1=0.5560
 ;after 97/07/18 ke1=0.9868 ce1=0.3400 kf1=0.0014 cf1=0.3500
 ;after 97/07/18 ke1=0.9868 ce1=0.5500 kf1=0.0014 cf1=0.4400
 ;after 97/09/24 ke1=0.9868 ce1=0.2800 kf1=0.0014 cf1=0.1800 
 ;after 97/10/13 ke1=0.9868 ce1=0.2200 kf1=0.0014 cf1=0.1800
 ;after 98/03/10 ke1=0.9827 ce1=0.3800 kf1=0.0008 cf1=0.4400
 ;after 99/07/22 ke1=0.9613 ce1=0.1000 kf1=0.0000 cf1=0.2600

 ;(defun C:CELLS()
( defun C:CELLS( / e_input g_input h_input f_input i_input j_input r_input
                    a_pi b_pi c_pi d_pi el fl mk_pi m_pi m1_pi n_pi n1_pi o_pi o1_pi p_pi p1_pi                  
                    e_pi g_pi h_pi en_pi f_pi i_pi j_pi fn_pi r_pi
                    p1 p2 p3 p4 p5 p6 p7 p8 o1 o2 o3 o4 
                    offset_e ss1 ss2 ss3 ss4 x_pitch y_pitch
                    x_ss1 y_ss1 x_ss2 y_ss2 x_ss3 y_ss3 x_ss4 y_ss4
                    glass_x glass_y etotal_pi ftotal_pi w ke1 ce1 kf1 cf1
                 ) 
  ;Enter Truly PI plate data
  (setq e_input (getreal "Please input E: "))
  (setq g_input (getreal "Please input G: "))
  (setq h_input (getreal "Please input H: "))
  (setq en_pi  (getint "Please input EN: "))
  (setq f_input (getreal "Please input F: "))
  (setq i_input (getreal "Please input I: "))
  (setq j_input (getreal "Please input J: "))
  (setq fn_pi  (getint "Please input FN: "))
  (setq r_input (getreal "Please input R: ")) 
 
 
 ;Jing Bi formula
  (setq ke1 0.9613 ce1 0.1000 kf1 0.0000 cf1 0.2600)
  (setq e_pi (* ke1 (- e_input ce1)))
  (setq g_pi (* ke1 (+ g_input ce1)))
  (setq h_pi (* ke1 (+ h_input ce1)))
  (setq f_pi (- f_input (+ cf1 (* kf1 f_input))))
  (setq i_pi (+ i_input (+ cf1 (* kf1 f_input))))
  (setq j_pi (+ j_input (+ cf1 (* kf1 f_input))))
  (cond ((> r_input 0.4)
         (setq r_pi (- r_input 0.4))
        )
        (t (setq r_pi 0.001)) ;r_pi must be nozero
  )

  (command "limits" (list -100 -100) (list 1000 800))
  (command "zoom" "a")

  ;Align the center of pi drawing with one of glass
   (setq glass_x 214.3 glass_y 259.4) ;the center of glass
   (setq x_pitch (+ f_pi f_pi i_pi j_pi)) ;x axis step size
   (setq y_pitch (+ e_pi e_pi g_pi h_pi)) ;y axis step size
   (cond ( (and (= 0 (rem en_pi (fix (/ en_pi 2))))   ;evalue etotal_pi
                (= 0 (rem fn_pi (fix (/ fn_pi 2))))
           ) 
           (setq ftotal_pi (- (* (/ fn_pi 2) x_pitch) j_pi)
                 etotal_pi (- (* (/ en_pi 2) y_pitch) h_pi)
           )             
         )
         ( (and (= 0 (rem en_pi (fix (/ en_pi 2)))) 
                (= 1 (rem fn_pi (fix (/ fn_pi 2))))
           ) 
           (setq ftotal_pi (+ (* (/ fn_pi 2) x_pitch) f_pi)
                 etotal_pi (- (* (/ en_pi 2) y_pitch) h_pi)
           )             
         )
         ( (and (= 1 (rem en_pi (fix (/ en_pi 2)))) 
                (= 0 (rem fn_pi (fix (/ fn_pi 2))))
           ) 
           (setq ftotal_pi (- (* (/ fn_pi 2) x_pitch) j_pi)
                 etotal_pi (+ (* (/ en_pi 2) y_pitch) e_pi)
           )             
         )
         ( (and (= 1 (rem en_pi (fix (/ en_pi 2)))) 
                (= 1 (rem fn_pi (fix (/ fn_pi 2))))
           ) 
           (setq ftotal_pi (+ (* (/ fn_pi 2) x_pitch) f_pi)
                 etotal_pi (+ (* (/ en_pi 2) y_pitch) e_pi)
           )             
         )
   )
   (setq origin_x (- glass_x (/ ftotal_pi 2))
         origin_y (- glass_y (/ etotal_pi 2))         
   )
   (print "Align the center of pi drawing with one of glass ok!")

  ;Draw a pi cell
  (setq p1 (list (+ r_pi origin_x) (+ 0 origin_y)) 
        p2 (list (+ (- f_pi r_pi) origin_x) (+ 0 origin_y ))
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
  (command "pline" p1 "w" 0 0 p2   ;down edge
                   "a" "r" r_pi p3 ;down right conner
                   "l" p4          ;right edge
                   "a" "r" r_pi p5 ;upon right conner
                   "l" p6          ;upon edge
                   "a" "r" r_pi p7 ;upon left conner
                   "l" p8          ;left edge
                   "a" "r" r_pi p1 ;down left conner
                   ""
   )
   (print "Draw a pi cell ok!")

   ;Get four repeat cells
   (setq ss1 (ssget "l"))
   (cond ((= 0 (rem en_pi (fix (/ en_pi 2)))) (setq offset_e (+ e_pi g_pi)))  ;offset_e
         ((= 1 (rem en_pi (fix (/ en_pi 2)))) (setq offset_e (+ e_pi h_pi)))  ;is g or h 
         (t (print "Error: EN is not a int type!"))                     ;because 
   );the distance from ss1 to ss2 depends on whether EN is odd or even  ;the cell 
   (command "copy" ss1 "" (list 0 0) (list 0 offset_e))                 ;is at down
   (setq ss2 (ssget "l"))   ;upon left cell                             ;left conner
   (command "copy" ss1 "" (list 0 0) (list (+ f_pi i_pi) 0))
   (setq ss3 (ssget "l"))   ;down right cell
   (command "copy" ss2 "" (list 0 0) (list (+ f_pi i_pi) 0))
   (setq ss4 (ssget "l"))   ;upon right cell
   (cond ( (and (= 0 (rem en_pi (fix (/ en_pi 2)))) 
                (= 0 (rem fn_pi (fix (/ fn_pi 2))))
           ) 
           (setq x_ss1 (/ fn_pi 2) y_ss1 (/ en_pi 2) ;ss1's x,y step number
                 x_ss2 (/ fn_pi 2) y_ss2 (/ en_pi 2) ;ss2's x,y step number                
                 x_ss3 (/ fn_pi 2) y_ss3 (/ en_pi 2) ;ss3's x,y step number 
                 x_ss4 (/ fn_pi 2) y_ss4 (/ en_pi 2) ;ss4's x,y step number
           )             
         )
         ( (and (= 0 (rem en_pi (fix (/ en_pi 2)))) 
                (= 1 (rem fn_pi (fix (/ fn_pi 2))))
           ) 
           (setq x_ss1 (1+ (/ fn_pi 2)) y_ss1 (/ en_pi 2) ;ss1's x,y step number
                 x_ss2 (1+ (/ fn_pi 2)) y_ss2 (/ en_pi 2) ;ss2's x,y step number                
                 x_ss3 (/ fn_pi 2) y_ss3 (/ en_pi 2)      ;ss3's x,y step number 
                 x_ss4 (/ fn_pi 2) y_ss4 (/ en_pi 2)      ;ss4's x,y step number
           )             
         )
         ( (and (= 1 (rem en_pi (fix (/ en_pi 2)))) 
                (= 0 (rem fn_pi (fix (/ fn_pi 2))))
           ) 
           (setq x_ss1 (/ fn_pi 2) y_ss1 (1+ (/ en_pi 2)) ;ss1's x,y step number
                 x_ss2 (/ fn_pi 2) y_ss2 (/ en_pi 2)      ;ss2's x,y step number                
                 x_ss3 (/ fn_pi 2) y_ss3 (1+ (/ en_pi 2)) ;ss3's x,y step number 
                 x_ss4 (/ fn_pi 2) y_ss4 (/ en_pi 2)      ;ss4's x,y step number
           )             
         )
         ( (and (= 1 (rem en_pi (fix (/ en_pi 2)))) 
                (= 1 (rem fn_pi (fix (/ fn_pi 2))))
           ) 
           (setq x_ss1 (1+ (/ fn_pi 2)) y_ss1 (1+ (/ en_pi 2)) ;ss1's x,y step number
                 x_ss2 (1+ (/ fn_pi 2)) y_ss2 (/ en_pi 2)      ;ss2's x,y step number                
                 x_ss3 (/ fn_pi 2) y_ss3 (1+ (/ en_pi 2))      ;ss3's x,y step number 
                 x_ss4 (/ fn_pi 2) y_ss4 (/ en_pi 2)           ;ss4's x,y step number
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
)


(defun chk_total (e g h n str_drct)
  (setq et_input (getreal (strcat "请输入" str_drct "方向总长" str_drct " total: ")))
  (if (= (rem n 2) 1)
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
  (if (not (equal et_input et_cul 0.001))
    (progn
      (getstring (strcat "输入的" str_drct "T与计算出的" str_drct "Total不同请确认！"))
      (quit)
    )
  )
)

(defun c:chk ()
  (setq e_input (getreal "Please input E: "))
  (setq g_input (getreal "Please input G: "))
  (setq h_input (getreal "Please input H: "))
  (setq en_pi (getint "Please input EN: "))
  (chk_total e_input g_input h_input en_pi "E")
  (setq f_input (getreal "Please input F: "))
  (setq i_input (getreal "Please input I: "))
  (setq j_input (getreal "Please input J: "))
  (setq fn_pi (getint "Please input FN: "))
  (chk_total f_input i_input j_input fn_pi "F")
  (setq r_input (getreal "Please input R: "))

;   check etotal and ftotal
  

;check total end

  
;check f total 
; (setq ft_input (getreal "Please input f total: "));;

  ;(if (= (rem fn_pi 2) 1)
  ;  (setq ft_cul (+ (* f_input fn_pi);
;		    (* i_input (/ (- fn_pi 1) 2))
;		    (* j_input (/ (- fn_pi 1) 2))
;		 )
 ;   )
  ;  (setq ft_cul (+ (* f_input fn_pi)
;		    (* i_input (/ fn_pi 2))
;		    (* j_input (- (/ fn_pi 2) 1))
;		 )
 ;   )
  ;)
  ;(if (not (equal ft_input ft_cul 0.001))
  ;  (progn
  ;    (getstring "输入的FT与计算出的FT不同请确认！")
  ;    (quit)
  ;  )
  ;)
;check ftotal end
  
  (prompt "OK!")
)

























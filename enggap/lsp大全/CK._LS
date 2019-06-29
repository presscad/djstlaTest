
(defun c:chk()  
  (setq e_input (getreal "Please input E: "))
  (setq g_input (getreal "Please input G: "))
  (setq h_input (getreal "Please input H: "))
  (setq en_pi (getint "Please input EN: "))
  (setq f_input (getreal "Please input F: "))
  (setq i_input (getreal "Please input I: "))
  (setq j_input (getreal "Please input J: "))
  (setq fn_pi (getint "Please input FN: "))
  (setq r_input (getreal "Please input R: "))

  ;   check etotal and ftotal
  (setq et_input (getreal "Please input E total: "))
  (setq ft_input (getreal "Please input f total: "))
  (if (= (rem en_pi) 1)
    (setq et_cul (+ (* e_input en_pi)
		    (* g_input (/ (- en_pi 1) 2))
		    (* h_input (/ (- en_pi 1) 2))
		 )
    )
    (setq et_cul (+ (* e_input en_pi)
		    (* g_input (/ en_pi 2))
		    (* h_input (- (/ en_pi 2) 1))
		 )
    )
  )
  (if (= (rem fn_pi) 1)
    (setq ft_cul (+ (* f_input fn_pi)
		    (* i_input (/ (- fn_pi 1) 2))
		    (* j_input (/ (- fn_pi 1) 2))
		 )
    )
    (setq ft_cul (+ (* f_input fn_pi)
		    (* i_input (/ fn_pi 2))
		    (* j_input (- (/ fn_pi 2) 1))
		 )
    )
  )
  (if (/= et_input et_cul)
    (getstring "输入的ET与计算出的ET不同请确认！")
    (quit)
  )
  (if (/= ft_input ft_cul)
    (getstring "输入的FT与计算出的FT不同请确认！")
    (quit)
  )
  (prompt "OK!")
)


















  
   
  
 
 
 

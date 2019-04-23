;通华J-V型凸版制作程序
;1999年6月22日前，参数：e1 = 0.964  g1 = 1.05  h1 = 1.05  fd = 0.2

 ( defun initialize (/ no_para)
         (command "limits" (list -100 -100) (list 1000 800))
         (command "zoom" "a")
         ;( setq ke 0.9665  ce 0.03857  cf 0 fd 0.2)
  )


( defun draw_mark ()
        (command "pline" (list -12.2796 -105.863) "w" 0 0 
                         (list -6.35948 -108.139) 
                         (list -6.35948 -106.766) 
                         (list 5.92382 -106.766) 
                         (list 5.92382 -104.725) 
                         (list -6.34774 -104.725) 
                         (list -6.34774 -103.273) 
                         (list -12.2796 -105.863) 
                        ""
         )
        (command "pline" (list -95.5 108.5) "w" 0 0 
                         (list -80.5 108.5) 
                         (list -80.5 110.5) 
                         (list -97.5 110.5) 
                         (list -97.5 93.5) 
                         (list -95.5 93.5) 
                         "c"
         )
        (command "pline" (list 95.5 108.5) "w" 0 0 
                         (list 80.5 108.5) 
                         (list 80.5 110.5) 
                         (list 97.5 110.5) 
                         (list 97.5 93.5) 
                         (list 95.5 93.5) 
                         "c"
         )
        (command "pline" (list 95.5 -108.5) "w" 0 0 
                         (list 80.5 -108.5) 
                         (list 80.5 -110.5) 
                         (list 97.5 -110.5) 
                         (list 97.5 -93.5) 
                         (list 95.5 -93.5) 
                         "c"
         )
        (command "pline" (list -95.5 -108.5) "w" 0 0 
                         (list -80.5 -108.5) 
                         (list -80.5 -110.5) 
                         (list -97.5 -110.5) 
                         (list -97.5 -93.5) 
                         (list -95.5 -93.5) 
                         "c"
         )
  )


  ( defun get_off_set ( number width jj1 jj2 / number1 number2)
                      ( setq number1 ( fix ( / number 2)))
                      ( setq number2 ( rem number 2))
                      (+ ( * number1 ( + jj1 jj2 )) ( * number2 jj1  ) ( * number width ))
   )

  ( defun copy_many_cells ( copy_ss1 start_x start_y width_x width_y number_x number_y jj_x_1                             jj_x_2 jj_y_1 jj_y_2 / count_x count_y offset_x offset_y)
                          ( setq count_y 0)
                          ( while ( < count_y number_y)
                                  ( setq count_x 0)
                                  ( while ( < count_x number_x)
                                          ( if ( and (= count_y 0) (= count_x 0))
                                               ( print "")
                                               ( progn
                                                 ( setq offset_x ( get_off_set count_x
                                                                   width_x jj_x_1 jj_x_2))
                                                 ( setq offset_y ( get_off_set count_y
                                                                   width_y jj_y_1 jj_y_2))
                                                 ( command "copy" copy_ss1 "" 
                                                            ( list start_x start_y)
                                                            ( list ( + start_x offset_x) 
                                                                   ( + start_y offset_y)
                                                             )
                                                  )
                                                )
                                            )
                                           ( setq count_x (1+ count_x))
                                   )
                                  ( setq count_y (1+ count_y))
                            )
   )

  (defun draw_many_cells (start_x start_y f_pi e_pi number_x number_y
                          i_pi j_pi g_pi h_pi / p1 p2  p3 p4 ss1)
               ;Draw a pi cell
               (setq p1 (list start_x start_y) 
                     p2 (list (+ start_x f_pi) start_y)
                     p3 (list (+ start_x f_pi) (+ start_y e_pi))
                     p4 (list start_x (+ start_y e_pi)) 
                )
               (command "pline" p1 "w" 0 0 p2 p3 p4 "c")
               (setq ss1 (ssget "l"))
               (setvar "filletrad" r_pi)
               (command "fillet" "P" ss1)
               (copy_many_cells ss1 start_x start_y f_pi e_pi number_x
                                number_y i_pi j_pi g_pi h_pi)
   )
  
  ( defun get_input( / e_input g_input h_input f_input i_input j_input tmp)
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
               ( setq e_input ( getreal "\n输入印刷方向粒长E: ")
                      g_input ( getreal "\n输入印刷方向间空G: ")
                      h_input ( getreal "\n输入印刷方向间空H: ")
                      number_y ( getint "\n输入印刷方向粒数EN: ")
	       )
    		(chk_total e_input g_input h_input number_y "E")
    
		(setq f_input ( getreal "\n输入非印刷方向粒宽F: ")
                      i_input ( getreal "\n输入非印刷方向间空I: ")
                      j_input ( getreal "\n输入非印刷方向间空J: ")
                      number_x ( getint "\n输入非印刷方向粒数FN: ")
		 )
    		(chk_total f_input i_input j_input number_x "F")
    
    		(setq r_pi ( getreal "\n输入圆角弧半径R: ")
                )

    		(setq gh_max (max g_input h_input))
    	        (if (>= (/ e_input gh_max) 10)
		  ( setq ke 0.9664  ce 0.1128  cf 0 fd 0.15)
		  (if (> gh_max 5)
		    ( setq ke 0.9665  ce 0.185   fd 0.15)
		    ( setq ke 0.966   ce 0.096  fd 0.15)
		    )
		  )
               (if (= (rem number_y 2) 1)
                 (progn
                    (setq tmp g_input)
                    (setq g_input h_input)
                    (setq h_input tmp)
                  )
                )

                ( setq e_pi (* ke (- e_input ce)) ; Change the data to fit Jing bi formula ...
                       g_pi (* ke (+ g_input ce) )
                       h_pi (* ke (+ h_input ce) )
                       f_pi (- f_input fd)
                       i_pi (+ i_input fd)
                       j_pi (+ j_input fd)
                 )
               (setq total_y ( + e_pi ( get_off_set (1- number_y) e_pi g_pi h_pi)))
               (setq total_x ( + f_pi ( get_off_set (1- number_x) f_pi i_pi j_pi)))
   )
  
  (initialize)
  (get_input)

  (draw_many_cells 0 0 f_pi e_pi number_x number_y i_pi j_pi g_pi h_pi)
  (command "move" "ALL" "" (list (/ total_x 2) (/ total_y 2))
                           (list 0 0) )
  (command "rotate" "all" "" (list 0 0) 90)
  (draw_mark)
  (setq input_text (strcase (getstring T "\n输入产品编号、机器型号和公司标记(中间留15空格):")))
  (command "text" "j" "c"  (list -3 -107) 3 0 input_text)
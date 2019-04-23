;深圳广贸公司凸版制作程序
;before 1999/7/3    ke1=0.9822   ce1=0.33   kf1=0.00  cf1=0.25
;before 1999/7/12   ke1=0.9840   ce1=0.38   kf1=0.00  cf1=0.25
;before 1999/7/21   ke1=0.9845   ce1=0.35   kf1=0.00  cf1=0.22
;before 1999/9/8    ke1=0.9854   ce1=0.35   kf1=0.00  cf1=0.22
;before 2001/8/5    ke1=0.988  ce1=0.35   kf1=0.00  cf1=0.22

 ( defun initialize (/ no_para)
         (command "limits" (list -100 -100) (list 1000 800))
         (command "zoom" "a")
         ( setq ke1 0.9880
                ce1 0.20
                kf1 0.00
                cf1 0.10
                number_x 0
                number_y 0
                total_x 0
                total_y 0
                glass_x 354
                glass_y 464
                e_pi 0
                g_pi 0
                h_pi 0
                f_pi 0
                i_pi 0
                j_pi 0
                r_pi 0 
          )
  )

( defun get_stretch_distance (total now)
        ( cond ( (= total 1)    ;Only one need to be stretched
                 ( if (> now 1)
                   ( prompt "Fatal error found !")
                   ( setq dst 0.05) ;You can change the constant to any suitable number 
                  )
                )
               ( (= total 2)  ;Two 
                 ( if (> now 2)
                   ( prompt "Fatal error found !")
                   ( cond ( (= now 2)
                            ( setq dst 0.02)
                           )
                          ( (= now 1)
                            ( setq dst 0.04)
                           )
                    )
                  )
                )
               ( (= total 3)    ;Three
                 ( if (> now 3)
                   ( prompt "Fatal error found !")
                   ( cond ( (= now 3)
                            ( setq dst 0.01)
                           )
                          ( (= now 2)
                            ( setq dst 0.02)
                           )
                          ( (= now 1)
                            ( setq dst 0.05)
                           )
                    )
                  )
                )
               ( T
                 ( prompt "Fatal error found !")
                )
         )
 )

 (defun draw_edge () 
        (command "pline" (list 529.0 264.0) "w" 0 0 
                         (list 529.0 234.0) 
                         (list 499.0 234.0) 
                         (list 499.0 232.0) 
                         (list 531.0 232.0) 
                         (list 531.0 264.0) 
                         "c"
         )
        (command "pline" (list 209.0 232.0) "w" 0 0 
                         (list 177.0 232.0) 
                         (list 177.0 264.0) 
                         (list 179.0 264.0) 
                         (list 179.0 234.0) 
                         (list 209.0 234.0) 
                         "c"
         )
        (command "pline" (list 499.0 694.0) "w" 0 0 
                         (list 529.0 694.0) 
                         (list 529.0 664.0) 
                         (list 531.0 664.0) 
                         (list 531.0 696.0) 
                         (list 499.0 696.0) 
                         "c"
         )
        (command "pline" (list 177.0 664.0) "w" 0 0 
                         (list 177.0 696.0) 
                         (list 209.0 696.0) 
                         (list 209.0 694.0) 
                         (list 179.0 694.0) 
                         (list 179.0 664.0) 
                         "c"
         )
        (command "pline" (list 503.75 676.75) "w" 0 0 
                         (list 503.75 681.5) 
                         (list 504.25 681.5) 
                         (list 504.25 676.75) 
                         (list 509.0 676.75) 
                         (list 509.0 676.25) 
                         (list 504.25 676.25) 
                         (list 504.25 671.5) 
                         (list 503.75 671.5) 
                         (list 503.75 676.25) 
                         (list 499.0 676.25) 
                         (list 499.0 676.75) 
                         "c"
         )
        (command "pline" (list 503.75 251.75) "w" 0 0 
                         (list 503.75 256.5) 
                         (list 504.25 256.5) 
                         (list 504.25 251.75) 
                         (list 509.0 251.75) 
                         (list 509.0 251.25) 
                         (list 504.25 251.25) 
                         (list 504.25 246.5) 
                         (list 503.75 246.5) 
                         (list 503.75 251.25) 
                         (list 499.0 251.25) 
                         (list 499.0 251.75) 
                         "c"
         )
        (command "pline" (list 203.75 251.75) "w" 0 0 
                         (list 203.75 256.5) 
                         (list 204.25 256.5) 
                         (list 204.25 251.75) 
                         (list 209.0 251.75) 
                         (list 209.0 251.25) 
                         (list 204.25 251.25) 
                         (list 204.25 246.5) 
                         (list 203.75 246.5) 
                         (list 203.75 251.25) 
                         (list 199.0 251.25) 
                         (list 199.0 251.75) 
                         "c"
         )
        (command "pline" (list 203.75 676.75) "w" 0 0 
                         (list 203.75 681.5) 
                         (list 204.25 681.5) 
                         (list 204.25 676.75) 
                         (list 209.0 676.75) 
                         (list 209.0 676.25) 
                         (list 204.25 676.25) 
                         (list 204.25 671.5) 
                         (list 203.75 671.5) 
                         (list 203.75 676.25) 
                         (list 199.0 676.25) 
                         (list 199.0 676.75) 
                         "c"
         )
        (command "pline" (list 494.0 676.75) "w" 0 0 
                         (list 214.0 676.75) 
                         (list 214.0 676.25) 
                         (list 494.0 676.25) 
                         "c"
         )
        (command "pline" (list 494.0 251.75) "w" 0 0 
                         (list 214.0 251.75) 
                         (list 214.0 251.25) 
                         (list 494.0 251.25) 
                         "c"
         )
        (command "pline" (list 203.75 261.5) "w" 0 0 
                         (list 204.25 261.5) 
                         (list 204.25 666.5) 
                         (list 203.75 666.5) 
                         "c"
         )
        (command "pline" (list 503.75 261.5) "w" 0 0 
                         (list 504.25 261.5) 
                         (list 504.25 666.5) 
                         (list 503.75 666.5) 
                         "c"
         )
  )

 ( defun auto_fix ( / move_step handle_number count
                      now_y all dst stretch_number
                      stretch_start_count
                   )
                  (setq handle_number (/ number_y 4))
                  ( if (< (* handle_number 4) number_y)
                    ( setq handle_number (1+ handle_number))
                    ( setq handle_number handle_number)
                   )

                  (if (>= handle_number 3)
                      (setq stretch_number 3)
                      (setq stretch_number handle_number)
                   )

                  (setq move_step (getreal "Input total moving distance : "))
                  (if (> handle_number 0)
                     (setq move_step (/ move_step handle_number)) 
                   )

                  (setq count 0)
                  (while (< count handle_number)
                         (setq now_y ( get_off_set count e_pi g_pi h_pi))
                         (setq all (ssget "c" (list -1 (1+ now_y)) (list (1+ total_x) (+ now_y (/ e_pi 2)))))
                         (if (< count stretch_number)
                             ( progn
                               (command "erase" all "")
                               (setq dst (get_stretch_distance stretch_number (1+ count)))
                               (draw_many_cells 0 (- now_y dst) f_pi (+ e_pi dst) number_x 1 i_pi j_pi g_pi h_pi)
                               (setq all (ssget "c" (list -1 (1+ now_y)) (list (1+ total_x) (+ now_y (/ e_pi 2)))))
                              )
                          )
                         (command "move" all "" (list 0 now_y) (list 0 (- now_y (* move_step (- handle_number count)))))
                         (setq count (1+ count))
                   )
  )

  ( defun get_off_set ( number width jj1 jj2 / number1 number2)
                      ( setq number1 ( fix ( / number 2)))
                      ( setq number2 ( rem number 2))
                      (+ ( * number1 ( + jj1 jj2 )) ( * number2 jj1  ) ( * number width ))
   )

  ( defun copy_many_cells ( copy_ss1 start_x start_y width_x width_y number_x number_y jj_x_1 jj_x_2 jj_y_1 jj_y_2 / count_x count_y offset_x offset_y)
                          ( setq count_y 0)
                          ( while ( < count_y number_y)
                                  ( setq count_x 0)
                                  ( while ( < count_x number_x)
                                          ( if ( and (= count_y 0) (= count_x 0))
                                               ( print "")
                                               ( progn
                                                 ( setq offset_x ( get_off_set count_x width_x jj_x_1 jj_x_2))
                                                 ( setq offset_y ( get_off_set count_y width_y jj_y_1 jj_y_2))
                                                 ( command "copy" copy_ss1 "" ( list start_x start_y) ( list ( + start_x offset_x) ( + start_y offset_y)))
                                                )
                                            )
                                           ( setq count_x (1+ count_x))
                                   )
                                  ( setq count_y (1+ count_y))
                            )
   )

  (defun draw_many_cells (start_x start_y f_pi e_pi number_x number_y i_pi j_pi g_pi h_pi / p1 p2  p3 p4 ss1)
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
               (copy_many_cells ss1 start_x start_y f_pi e_pi number_x number_y i_pi j_pi g_pi h_pi)
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
    
    		(setq 
                      r_pi 0
                )

                ( setq e_pi (* ke1 (- e_input ce1)) ; Change the data to fit Jing bi formula ...
                       g_pi (* ke1 (+ g_input ce1))
                       h_pi (* ke1 (+ h_input ce1))
                       f_pi (- f_input (+ cf1 (* kf1 f_input)))
                       i_pi (+ i_input (+ cf1 (* kf1 f_input)))
                       j_pi (+ j_input (+ cf1 (* kf1 f_input)))
                 )
                
               (setq total_y ( + e_pi ( get_off_set (1- number_y) e_pi g_pi h_pi)))
               (setq total_x ( + f_pi ( get_off_set (1- number_x) f_pi i_pi j_pi)))
   )
  


;Main Program

  (initialize)
  (get_input)

  (draw_many_cells 0 0 f_pi e_pi number_x number_y i_pi j_pi g_pi h_pi)
; (command "mirror" "ALL" "" (list (/ total_x 2) 0) (list (/ total_x 2) 1) "Y")
  (command "move" "ALL" "" (list (/ total_x 2) (/ total_y 2)) (list glass_x glass_y))
  (draw_edge)
  (setq input_text ( strcase ( getstring T "输入产品编号和公司标记: ")))
  (command "text" "j" "c"(list 354 289) 6.3 0 input_text)


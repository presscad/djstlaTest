;伊丽安达凸版制作程序
;参数修改记录：
;Before 1999/4/3 ke1= 0.9866 ce1=0.3500 kf1=0.0010 cf1=0.1800
;before 1999/8/18 ke1=0.9855 ce1=0.3500 kf1=0.0010 cf1=0.4600
 
( defun initialize (/ no_para)
         (command "limits" (list -100 -100) (list 1000 800))
         (command "zoom" "a")
         ( setq ke1 0.9860
                ce1 0.5000
                kf1 0.0000
                cf1 0.5000
                number_x 0
                number_y 0
                total_x 0
                total_y 0
                glass_x 232.5
                glass_y 278
               ; el_pi 406.4
               ; fl_pi 355.6
               ; mk_pi 450
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

                  (setq move_step 0 ) ;(getreal "Input total moving distance : ")
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

 (defun draw_edge () 
        (command "pline" (list 463.0 2.05) "w" 0 0 
                         (list 463.0 2.0) 
                         (list 2.0 2.0) 
                         (list 2.0 2.05) 
                         "c"
         )
        (command "pline" (list 463.0 4.05) "w" 0 0 
                         (list 463.0 4.0) 
                         (list 2.0 4.0) 
                         (list 2.0 4.05) 
                         "c"
         )
        (command "pline" (list 463.0 6.05) "w" 0 0 
                         (list 463.0 6.0) 
                         (list 2.0 6.0) 
                         (list 2.0 6.05) 
                         "c"
         )
        (command "pline" (list 463.0 8.05) "w" 0 0 
                         (list 463.0 8.0) 
                         (list 2.0 8.0) 
                         (list 2.0 8.05) 
                         "c"
         )
        (command "pline" (list 463.0 10.05) "w" 0 0 
                         (list 463.0 10.0) 
                         (list 2.0 10.0) 
                         (list 2.0 10.05) 
                         "c"
         )
        (command "pline" (list 463.0 12.05) "w" 0 0 
                         (list 463.0 12.0) 
                         (list 2.0 12.0) 
                         (list 2.0 12.05) 
                         "c"
         )
        (command "pline" (list 463.0 14.05) "w" 0 0 
                         (list 463.0 14.0) 
                         (list 2.0 14.0) 
                         (list 2.0 14.05) 
                         "c"
         )
        (command "pline" (list 463.0 16.05) "w" 0 0 
                         (list 463.0 16.0) 
                         (list 2.0 16.0) 
                         (list 2.0 16.05) 
                         "c"
         )
        (command "pline" (list 463.0 18.05) "w" 0 0 
                         (list 463.0 18.0) 
                         (list 2.0 18.0) 
                         (list 2.0 18.05) 
                         "c"
         )
        (command "pline" (list 463.0 20.05) "w" 0 0 
                         (list 463.0 20.0) 
                         (list 2.0 20.0) 
                         (list 2.0 20.05) 
                         "c"
         )
        (command "pline" (list 463.0 22.05) "w" 0 0 
                         (list 463.0 22.0) 
                         (list 2.0 22.0) 
                         (list 2.0 22.05) 
                         "c"
         )
        (command "pline" (list 463.0 24.05) "w" 0 0 
                         (list 463.0 24.0) 
                         (list 2.0 24.0) 
                         (list 2.0 24.05) 
                         "c"
         )
        (command "pline" (list 463.0 26.05) "w" 0 0 
                         (list 463.0 26.0) 
                         (list 2.0 26.0) 
                         (list 2.0 26.05) 
                         "c"
         )
        (command "pline" (list 463.0 573.0) "w" 0 0 
                         (list 463.0 572.95) 
                         (list 2.0 572.95) 
                         (list 2.0 573.0) 
                         "c"
         )
        (command "pline" (list 463.0 571.0) "w" 0 0 
                         (list 463.0 570.95) 
                         (list 2.0 570.95) 
                         (list 2.0 571.0) 
                         "c"
         )
        (command "pline" (list 463.0 569.0) "w" 0 0 
                         (list 463.0 568.95) 
                         (list 2.0 568.95) 
                         (list 2.0 569.0) 
                         "c"
         )
        (command "pline" (list 463.0 567.0) "w" 0 0 
                         (list 463.0 566.95) 
                         (list 2.0 566.95) 
                         (list 2.0 567.0) 
                         "c"
         )
        (command "pline" (list 463.0 565.0) "w" 0 0 
                         (list 463.0 564.95) 
                         (list 2.0 564.95) 
                         (list 2.0 565.0) 
                         "c"
         )
        (command "pline" (list 463.0 563.0) "w" 0 0 
                         (list 463.0 562.95) 
                         (list 2.0 562.95) 
                         (list 2.0 563.0) 
                         "c"
         )
        (command "pline" (list 463.0 561.0) "w" 0 0 
                         (list 463.0 560.95) 
                         (list 2.0 560.95) 
                         (list 2.0 561.0) 
                         "c"
         )
        (command "pline" (list 463.0 559.0) "w" 0 0 
                         (list 463.0 558.95) 
                         (list 2.0 558.95) 
                         (list 2.0 559.0) 
                         "c"
         )
        (command "pline" (list 463.0 557.0) "w" 0 0 
                         (list 463.0 556.95) 
                         (list 2.0 556.95) 
                         (list 2.0 557.0) 
                         "c"
         )
        (command "pline" (list 463.0 555.0) "w" 0 0 
                         (list 463.0 554.95) 
                         (list 2.0 554.95) 
                         (list 2.0 555.0) 
                         "c"
         )
        (command "pline" (list 463.0 553.0) "w" 0 0 
                         (list 463.0 552.95) 
                         (list 2.0 552.95) 
                         (list 2.0 553.0) 
                         "c"
         )
        (command "pline" (list 463.0 551.0) "w" 0 0 
                         (list 463.0 550.95) 
                         (list 2.0 550.95) 
                         (list 2.0 551.0) 
                         "c"
         )
        (command "pline" (list 463.0 549.0) "w" 0 0 
                         (list 463.0 548.95) 
                         (list 2.0 548.95) 
                         (list 2.0 549.0) 
                         "c"
         )
        (command "pline" (list 433.0 503.0) "w" 0 0 
                         (list 433.0 498.5) 
                         (list 437.5 498.5) 
                         (list 437.5 497.5) 
                         (list 433.0 497.5) 
                         (list 433.0 493.0) 
                         (list 432.0 493.0) 
                         (list 432.0 497.5) 
                         (list 427.5 497.5) 
                         (list 427.5 498.5) 
                         (list 432.0 498.5) 
                         (list 432.0 503.0) 
                         "c"
         )
        (command "pline" (list 432.0 273.0) "w" 0 0 
                         (list 432.0 283.0) 
                         (list 433.0 283.0) 
                         (list 433.0 273.0) 
                         "c"
         )
        (command "pline" (list 432.0 53.0) "w" 0 0 
                         (list 432.0 63.0) 
                         (list 433.0 63.0) 
                         (list 433.0 53.0) 
                         "c"
         )
        (command "pline" (list 32.0 273.0) "w" 0 0 
                         (list 32.0 283.0) 
                         (list 33.0 283.0) 
                         (list 33.0 273.0) 
                         "c"
         )
        (command "pline" (list 32.0 53.0) "w" 0 0 
                         (list 32.0 63.0) 
                         (list 33.0 63.0) 
                         (list 33.0 53.0) 
                         "c"
         )
        (command "pline" (list 33.0 503.0) "w" 0 0 
                         (list 33.0 498.5) 
                         (list 37.5 498.5) 
                         (list 37.5 497.5) 
                         (list 33.0 497.5) 
                         (list 33.0 493.0) 
                         (list 32.0 493.0) 
                         (list 32.0 497.5) 
                         (list 27.5 497.5) 
                         (list 27.5 498.5) 
                         (list 32.0 498.5) 
                         (list 32.0 503.0) 
                         "c"
         )
        (command "pline" (list 463.0 2.0) "w" 0 0 
                         (list 453.0 2.0) 
                         (list 453.0 0.0) 
                         (list 465.0 0.0) 
                         (list 465.0 12.0) 
                         (list 463.0 12.0) 
                         "c"
         )
        (command "pline" (list 2.0 2.0) "w" 0 0 
                         (list 12.0 2.0) 
                         (list 12.0 0.0) 
                         (list 0.0 0.0) 
                         (list 0.0 12.0) 
                         (list 2.0 12.0) 
                         "c"
         )
        (command "pline" (list 2.0 573.0) "w" 0 0 
                         (list 12.0 573.0) 
                         (list 12.0 575.0) 
                         (list 0.0 575.0) 
                         (list 0.0 563.0) 
                         (list 2.0 563.0) 
                         "c"
         )
        (command "pline" (list 463.0 573.0) "w" 0 0 
                         (list 453.0 573.0) 
                         (list 453.0 575.0) 
                         (list 465.0 575.0) 
                         (list 465.0 563.0) 
                         (list 463.0 563.0) 
                         "c"
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
               ( setq e_input ( getreal "输入E方向粒长E: ")
                      g_input ( getreal "输入E方向间长G: ")
                      h_input ( getreal "输入E方向间长H: ")
                      number_y ( getint "输入E方向粒数EN: ")
                      f_input ( getreal "输入F方向粒长F: ")
                      i_input ( getreal "输入F方向间长I: ")
                      j_input ( getreal "输入F方向间长J: ")
                      number_x ( getint "输入F方向粒数FN: ")
                      r_pi ( getreal "输入圆角孤半径R: ")
                )
               ( setq ke1 (+ ke1 (* 0.00003 number_y) ) )
               (if (= (rem number_y 2) 1)
                 (progn
                    (setq tmp g_input)
                    (setq g_input h_input)
                    (setq h_input tmp)
                  )
                )

               ;(setq ;a_pi (getreal "Please input A: ")
                     ;b_pi (getreal "Please input B: ")
                     ;c_pi (getreal "Please input C: ")
                     ;d_pi (getreal "Please input D: ")
                     ;el_pi (getreal "Please input EL: ")
                     ;fl_pi (getreal "Please input FL: ")
                     ;mk_pi (getreal "Please input MK: ")
                     ;m_pi (getreal "Please input M: ")
                     ;m1_pi (getreal "Please input M1: ")
                     ;n_pi (getreal "Please input N: ")
                     ;n1_pi (getreal "Please input N1: ")
                     ;o_pi (getreal "Please input O: ")
                     ;o1_pi (getreal "Please input O1: ")
                     ;p_pi (getreal "Please input P: ")
                     ;p1_pi (getreal "Please input P1: ")
                ;)
                ( setq e_pi (* ke1 (- e_input ce1)) ; Change the data to fit Jing bi formula ...
                       g_pi (* ke1 (+ g_input ce1))
                       h_pi (* ke1 (+ h_input ce1))
                       f_pi (- f_input (+ cf1 (* kf1 f_input)))
                       i_pi (+ i_input (+ cf1 (* kf1 f_input)))
                       j_pi (+ j_input (+ cf1 (* kf1 f_input)))
                 )
                ;( if (> r_pi 0.4)
                ;     (setq r_pi (- r_pi 0.4))
                ;     (setq r_pi 0.01)
                ;)
               (setq total_y ( + e_pi ( get_off_set (1- number_y) e_pi g_pi h_pi)))
               (setq total_x ( + f_pi ( get_off_set (1- number_x) f_pi i_pi j_pi)))
   )
  
  (initialize)
  (get_input)
  (draw_many_cells 0 0 f_pi e_pi number_x number_y i_pi j_pi g_pi h_pi)
  ;(auto_fix)
  (command "move" "ALL" "" (list (/ total_x 2) (/ total_y 2)) (list glass_x glass_y))
  (draw_edge) 
  ;(command "mirror" "ALL" "" (list glass_x 0) (list glass_x 2) "Y")
  (setq input_text ( strcase ( getstring T "输入产品编号和公司标记: ")))
  (command "text" (list 100 515) 8 0 input_text)


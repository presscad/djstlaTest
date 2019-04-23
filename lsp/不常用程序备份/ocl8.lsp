;傲卓立8X14英寸凸版制作程序

 ( defun initialize (/ no_para)
         (command "limits" (list -100 -100) (list 1000 800))
         (command "zoom" "a")
         ( setq ke1 0.9550
                ce1 0.15
                kf1 0
                cf1 0
                align_point_x 382.6
                align_point_y 235.2
                align_x 0
                align_y 0
                number_x 0
                number_y 0
                total_x 0
                total_y 0
                e_pi 0
                g_pi 0
                h_pi 0
                f_pi 0
                i_pi 0
                j_pi 0
                r_pi 0 
          )
  )

 ( defun get_off_set ( number width jj1 jj2 / number1 number2 result)
                      (setq number1 (fix ( / number 2)))
                      (setq number2 (rem number 2))
                      (setq result (+ ( * number1 (+ jj1 jj2 )) (* number2 jj1  ) (* number width )))
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
               ( setq e_input ( getreal "输入Y方向粒长E: ")
                      g_input ( getreal "输入Y方向间长G: ")
                      h_input ( getreal "输入Y方向间长H: ")
                      number_y ( getint "输入Y方向粒数EN: ")
                      f_input ( getreal "输入X方向粒长F: ")
                      i_input ( getreal "输入X方向间长I: ")
                      j_input ( getreal "输入X方向间长J: ")
                      number_x ( getint "输入X方向粒数FN: ")
                      r_pi 0
                      align_x (getreal "输入X方向距右上角十字标距离: ")
                      align_y (getreal "输入Y方向距右上角十字标距离: ")
                 )

               (if (= (rem number_y 2) 1)
                 (progn
                    (setq tmp g_input)
                    (setq g_input h_input)
                    (setq h_input tmp)
                  )
                )

               ( setq e_pi (* ke1 (- e_input ce1)) ; Change the data to fit Jing bi formula ...
                      g_pi (* ke1 (+ g_input ce1))
                      h_pi (* ke1 (+ h_input ce1))
                      f_pi (- f_input (+ cf1 (* kf1 f_input)))
                      i_pi (+ i_input (+ cf1 (* kf1 f_input)))
                      j_pi (+ j_input (+ cf1 (* kf1 f_input)))
                      align_x (+ align_x (+ cf1 (* kf1 f_input)))
                      align_y (* ke1 (+ align_y ce1))
                )
               (setq total_y ( + e_pi ( get_off_set (1- number_y) e_pi g_pi h_pi)))
               (setq total_x ( + f_pi ( get_off_set (1- number_x) f_pi i_pi j_pi)))
   )

 (defun draw_edge () 
        (command "pline" (list 27.0 240.7) "w" 0 0 
                         (list 27.0 236.2) 
                         (list 31.5 236.2) 
                         (list 31.5 235.7) 
                         (list 31.5 235.2) 
                         (list 27.0 235.2) 
                         (list 27.0 230.7) 
                         (list 26.0 230.7) 
                         (list 26.0 235.2) 
                         (list 21.5 235.2) 
                         (list 21.5 236.2) 
                         (list 26.0 236.2) 
                         (list 26.0 240.7) 
                         "c"
         )
        (command "pline" (list 382.6 235.2) "w" 0 0 
                         (list 378.1 235.2) 
                         (list 378.1 236.2) 
                         (list 382.6 236.2) 
                         (list 382.6 240.7) 
                         (list 383.6 240.7) 
                         (list 383.6 236.2) 
                         (list 388.1 236.2) 
                         (list 388.1 235.2) 
                         (list 383.6 235.2) 
                         (list 383.6 230.7) 
                         (list 382.6 230.7) 
                         "c"
         )
        (command "pline" (list 33.4737 267.2) "w" 0 0 
                         (list 3.55271e-015 267.2) 
                         (list 3.55271e-015 235.469) 
                         (list 2.0 235.469) 
                         (list 2.0 265.2) 
                         (list 33.4737 265.2) 
                         "c"
         )
        (command "pline" (list 409.6 235.469) "w" 0 0 
                         (list 409.6 267.2) 
                         (list 377.638 267.2) 
                         (list 377.638 265.2) 
                         (list 407.6 265.2) 
                         (list 407.6 235.469) 
                         "c"
         )
        (command "pline" (list 382.6 32.0) "w" 0 0 
                         (list 382.6 36.5) 
                         (list 383.6 36.5) 
                         (list 383.6 32.0) 
                         (list 388.1 32.0) 
                         (list 388.1 31.0) 
                         (list 383.6 31.0) 
                         (list 383.6 26.5) 
                         (list 382.6 26.5) 
                         (list 382.6 31.0) 
                         (list 378.1 31.0) 
                         (list 378.1 32.0) 
                         "c"
         )
        (command "pline" (list 26.0 26.5) "w" 0 0 
                         (list 26.0 31.0) 
                         (list 21.5 31.0) 
                         (list 21.5 32.0) 
                         (list 26.0 32.0) 
                         (list 26.0 36.5) 
                         (list 27.0 36.5) 
                         (list 27.0 32.0) 
                         (list 31.5 32.0) 
                         (list 31.5 31.5) 
                         (list 31.5 31.0) 
                         (list 27.0 31.0) 
                         (list 27.0 26.5) 
                         "c"
         )
        (command "pline" (list 26.0 133.1) "w" 0 0 
                         (list 21.5 133.1) 
                         (list 21.5 134.1) 
                         (list 26.0 134.1) 
                         (list 26.0 138.6) 
                         (list 27.0 138.6) 
                         (list 27.0 128.6) 
                         (list 26.0 128.6) 
                         "c"
         )
        (command "pline" (list 33.4737 0.0) "w" 0 0 
                         (list 3.55271e-015 0.0) 
                         (list 3.55271e-015 31.7311) 
                         (list 2.0 31.7311) 
                         (list 2.0 2.0) 
                         (list 33.4737 2.0) 
                         "c"
         )
        (command "pline" (list 409.6 31.7311) "w" 0 0 
                         (list 409.6 0.0) 
                         (list 377.638 0.0) 
                         (list 377.638 2.0) 
                         (list 407.6 2.0) 
                         (list 407.6 31.7311) 
                         "c"
         )
        (command "pline" (list 383.6 138.6) "w" 0 0 
                         (list 383.6 134.1) 
                         (list 388.1 134.1) 
                         (list 388.1 133.1) 
                         (list 383.6 133.1) 
                         (list 383.6 128.6) 
                         (list 382.6 128.6) 
                         (list 382.6 138.6) 
                         "c"
         )

  )

  (initialize)
  (get_input)
  (draw_many_cells 0 0 f_pi e_pi number_x number_y i_pi j_pi g_pi h_pi)
  (command "move" "ALL" "" (list total_x total_y) (list (- align_point_x align_x) (- align_point_y align_y)))
  (draw_edge)
  (setq input_text ( strcase ( getstring T "输入产品编号和公司标记: ")))
  (command "text" (list 100 241) 6 0 input_text)



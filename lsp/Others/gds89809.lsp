
            ;THis program fitted for TRULY TN MIXED PI PRINT PLATE

 ( defun initialize (/ no_para)
         (command "limits" (list -100 -100) (list 1000 800))
         (command "zoom" "a")
         ( setq ke1 0.9809
                ce1 0
                kf1 0
                cf1 0
                align_point_x 171
                align_point_y 213.5
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
               ( setq e_input ( getreal "Please input E: ")
                      g_input ( getreal "Please input G: ")
                      h_input ( getreal "Please input H: ")
                      number_y ( getint "Please input EN: ")
                      f_input ( getreal "Please input F: ")
                      i_input ( getreal "Please input I: ")
                      j_input ( getreal "Please input J: ")
                      number_x ( getint "Please input FN: ")
                      r_pi ( getreal "Please input R: ")
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
                )
               (setq total_y ( + e_pi ( get_off_set (1- number_y) e_pi g_pi h_pi)))
               (setq total_x ( + f_pi ( get_off_set (1- number_x) f_pi i_pi j_pi)))
   )

 (defun draw_edge () 
        (command "pline" (list 255.65 311.9) "w" 0 0 
                         (list 257.65 311.9) 
                         (list 257.65 311.4) 
                         (list 255.65 311.4) 
                         (list 255.65 309.4) 
                         (list 255.15 309.4) 
                         (list 255.15 311.4) 
                         (list 253.15 311.4) 
                         (list 253.15 311.9) 
                         (list 255.15 311.9) 
                         (list 255.15 313.9) 
                         (list 255.65 313.9) 
                         "c"
         )
        (command "pline" (list 86.35 311.9) "w" 0 0 
                         (list 84.35 311.9) 
                         (list 84.35 311.4) 
                         (list 86.35 311.4) 
                         (list 86.35 309.4) 
                         (list 86.85 309.4) 
                         (list 86.85 311.4) 
                         (list 88.85 311.4) 
                         (list 88.85 311.9) 
                         (list 86.85 311.9) 
                         (list 86.85 313.9) 
                         (list 86.35 313.9) 
                         "c"
         )
        (command "pline" (list 255.65 115.1) "w" 0 0 
                         (list 257.65 115.1) 
                         (list 257.65 115.6) 
                         (list 255.65 115.6) 
                         (list 255.65 117.6) 
                         (list 255.15 117.6) 
                         (list 255.15 115.6) 
                         (list 253.15 115.6) 
                         (list 253.15 115.1) 
                         (list 255.15 115.1) 
                         (list 255.15 113.1) 
                         (list 255.65 113.1) 
                         "c"
         )
        (command "pline" (list 321.1 363.6) "w" 0 0 
                         (list 321.1 363.6) 
                         (list 321.1 357.6) 
                         (list 320.9 357.6) 
                         (list 320.9 363.4) 
                         (list 315.1 363.4) 
                         (list 315.1 363.6) 
                         (list 321.1 363.6) 
                         (list 321.1 363.6) 
                         "c"
         )
        (command "pline" (list 321.1 63.4) "w" 0 0 
                         (list 321.1 63.4) 
                         (list 321.1 69.4) 
                         (list 320.9 69.4) 
                         (list 320.9 63.6) 
                         (list 315.1 63.6) 
                         (list 315.1 63.4) 
                         (list 321.1 63.4) 
                         (list 321.1 63.4) 
                         "c"
         )
        (command "pline" (list 20.9 363.6) "w" 0 0 
                         (list 20.9 363.6) 
                         (list 20.9 357.6) 
                         (list 21.1 357.6) 
                         (list 21.1 363.4) 
                         (list 26.9 363.4) 
                         (list 26.9 363.6) 
                         (list 20.9 363.6) 
                         (list 20.9 363.6) 
                         "c"
         )
        (command "pline" (list 263.9 315.2) "w" 0 0 
                         (list 263.9 315.0) 
                         (list 260.0 315.0) 
                         (list 260.0 311.1) 
                         (list 259.8 311.1) 
                         (list 259.8 315.0) 
                         (list 255.9 315.0) 
                         (list 255.9 315.2) 
                         (list 259.8 315.2) 
                         (list 259.8 319.1) 
                         (list 260.0 319.1) 
                         (list 260.0 315.2) 
                         "c"
         )
        (command "pline" (list 78.1 315.2) "w" 0 0 
                         (list 78.1 315.0) 
                         (list 82.0 315.0) 
                         (list 82.0 311.1) 
                         (list 82.2 311.1) 
                         (list 82.2 315.0) 
                         (list 86.1 315.0) 
                         (list 86.1 315.2) 
                         (list 82.2 315.2) 
                         (list 82.2 319.1) 
                         (list 82.0 319.1) 
                         (list 82.0 315.2) 
                         "c"
         )
        (command "pline" (list 263.9 111.8) "w" 0 0 
                         (list 263.9 112.0) 
                         (list 260.0 112.0) 
                         (list 260.0 115.9) 
                         (list 259.8 115.9) 
                         (list 259.8 112.0) 
                         (list 255.9 112.0) 
                         (list 255.9 111.8) 
                         (list 259.8 111.8) 
                         (list 259.8 107.9) 
                         (list 260.0 107.9) 
                         (list 260.0 111.8) 
                         "c"
         )
        (command "pline" (list 342.0 427.0) "w" 0 0 
                         (list 342.0 427.0) 
                         (list 322.0 427.0) 
                         (list 322.0 426.0) 
                         (list 341.0 426.0) 
                         (list 341.0 407.0) 
                         (list 342.0 407.0) 
                         (list 342.0 427.0) 
                         (list 342.0 427.0) 
                         "c"
         )
        (command "pline" (list 0.0 427.0) "w" 0 0 
                         (list 0.0 427.0) 
                         (list 20.0 427.0) 
                         (list 20.0 426.0) 
                         (list 1.0 426.0) 
                         (list 1.0 407.0) 
                         (list 0.0 407.0) 
                         (list 0.0 427.0) 
                         (list 0.0 427.0) 
                         "c"
         )
        (command "pline" (list 342.0 0.0) "w" 0 0 
                         (list 342.0 0.0) 
                         (list 322.0 0.0) 
                         (list 322.0 1.0) 
                         (list 341.0 1.0) 
                         (list 341.0 20.0) 
                         (list 342.0 20.0) 
                         (list 342.0 0.0) 
                         (list 342.0 0.0) 
                         "c"
         )
        (command "pline" (list 86.35 115.1) "w" 0 0 
                         (list 84.35 115.1) 
                         (list 84.35 115.6) 
                         (list 86.35 115.6) 
                         (list 86.35 117.6) 
                         (list 86.85 117.6) 
                         (list 86.85 115.6) 
                         (list 88.85 115.6) 
                         (list 88.85 115.1) 
                         (list 86.85 115.1) 
                         (list 86.85 113.1) 
                         (list 86.35 113.1) 
                         "c"
         )
        (command "pline" (list 78.1 111.8) "w" 0 0 
                         (list 78.1 112.0) 
                         (list 82.0 112.0) 
                         (list 82.0 115.9) 
                         (list 82.2 115.9) 
                         (list 82.2 112.0) 
                         (list 86.1 112.0) 
                         (list 86.1 111.8) 
                         (list 82.2 111.8) 
                         (list 82.2 107.9) 
                         (list 82.0 107.9) 
                         (list 82.0 111.8) 
                         "c"
         )
        (command "pline" (list 20.9 63.4) "w" 0 0 
                         (list 20.9 63.4) 
                         (list 20.9 69.4) 
                         (list 21.1 69.4) 
                         (list 21.1 63.6) 
                         (list 26.9 63.6) 
                         (list 26.9 63.4) 
                         (list 20.9 63.4) 
                         (list 20.9 63.4) 
                         "c"
         )
        (command "pline" (list 0.0 0.0) "w" 0 0 
                         (list 0.0 0.0) 
                         (list 20.0 0.0) 
                         (list 20.0 1.0) 
                         (list 1.0 1.0) 
                         (list 1.0 20.0) 
                         (list 0.0 20.0) 
                         (list 0.0 0.0) 
                         (list 0.0 0.0) 
                         "c"
         )
  )

  (initialize)
  (get_input)
  (draw_many_cells 0 0 f_pi e_pi number_x number_y i_pi j_pi g_pi h_pi)
  (command "move" "ALL" "" (list (/ total_x 2) (/ total_y 2)) (list align_point_x  align_point_y))
  (draw_edge)
  (setq input_text ( getstring T "Input QY mark: "))
  (command "text" (list 100 28) 7 0 input_text)

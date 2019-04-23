

            ;THis program fitted for TRULY TN MIXED PI PRINT PLATE


  (defun initialize_factor ( / no_para)
         ( setq ke1 0.9827
                ce1 0.38
                kf1 0.0008
                cf1 0.44
                called_times 0
                start_x 0
                start_y 0
                total_x 0
                total_y 0
           )
   )

  ( defun draw_stn_mark(/ a_pi b_pi c_pi d_pi el_pi fl_pi m_pi
                          m1_pi n_pi n1_pi o_pi o1_pi p_pi p1_pi
                          input_text
                  )
   ;Drawing Truly PI printing plate's marks
   ;w is the half width of the marks ,w=0.25mm
   ;upon left '+' mark ,it's center is (30 520)
   (setq w 0.25)
   (command "pline" (list (- 30 w) (- 520 5))   "w" 0 0 
                    (list (+ 30 w) (- 520 5))
                    (list (+ 30 w) (- 520 w))
                    (list (+ 30 5) (- 520 w))
                    (list (+ 30 5) (+ 520 w))
                    (list (+ 30 w) (+ 520 w))
                    (list (+ 30 w) (+ 520 5))
                    (list (- 30 w) (+ 520 5))
                    (list (- 30 w) (+ 520 w))
                    (list (- 30 5) (+ 520 w))
                    (list (- 30 5) (- 520 w))
                    (list (- 30 w) (- 520 w))
                    "c"
   )
   (print "upon left '+' mark ok!")
   ;upon right '+' mark,it's center is (410 520)
   (command "pline" (list (- 410 w) (- 520 5))   "w" 0 0 
                    (list (+ 410 w) (- 520 5))
                    (list (+ 410 w) (- 520 w))
                    (list (+ 410 5) (- 520 w))
                    (list (+ 410 5) (+ 520 w))
                    (list (+ 410 w) (+ 520 w))
                    (list (+ 410 w) (+ 520 5))
                    (list (- 410 w) (+ 520 5))
                    (list (- 410 w) (+ 520 w))
                    (list (- 410 5) (+ 520 w))
                    (list (- 410 5) (- 520 w))
                    (list (- 410 w) (- 520 w))
                    "c"
   )
   (print "upon right '+' mark ok!")
   ;down left '-' mark, it's top middle point is (30 60)
   (command "pline" (list (- 30 w) (+ 60 5))   "w" 0 0
                    (list (+ 30 w) (+ 60 5))
                    (list (+ 30 w) (- 60 5))
                    (list (- 30 w) (- 60 5))
                    "c"
   )
   (print "down left '-' mark ok!" )
   ;down right '-' mark, it's top middle point is (410 60)
   (command "pline" (list (- 410 w) (+ 60 5))   "w" 0 0
                    (list (+ 410 w) (+ 60 5))
                    (list (+ 410 w) (- 60 5))
                    (list (- 410 w) (- 60 5))
                    "c"
   )
   (print "down right '-' mark ok!" )


   ;upon left pi plate range mark,it's center is (0 580)
   (command "pline" (list 0 580)   "w" 0 0 
                    (list 10 580)
                    (list 10 582)
                    (list -2 582)
                    (list -2 570)
                    (list 0 570)
                    "c"
   )
   ;upon right pi plate range mark,it's center is (440 580)
   (command "pline" (list 440 580)   "w" 0 0 
                    (list 430 580)
                    (list 430 582)
                    (list 442 582)
                    (list 442 570)
                    (list 440 570)
                    "c"
   )
   ;down right pi plate range mark,it's center is (440 0)
   (command "pline" (list 440 0)   "w" 0 0 
                    (list 430 0)
                    (list 430 -2)
                    (list 442 -2)
                    (list 442 10)
                    (list 440 10)
                    "c"
   )
   ;down left pi plate range mark,it's center is (0 0)
   (command "pline" (list 0 0)   "w" 0 0 
                    (list 10 0)
                    (list 10 -2)
                    (list -2 -2)
                    (list -2 10)
                    (list 0 10)
                    "c"
   )
   ( setq input_text (getstring T "Input QY mark: "))
   ( command "text" (list 125 25.7 ) 8 0 input_text)

   ;Draw the down hold edge
   (command "pline" (list 0.1 0.1) "w" 0 0
                    (list 439.9 0.1)
                    (list 439.9 0.13)
                    (list 0.1 0.13)
                    "c"
   )
   (setq ss5 (ssget "l"))
   (command "array" ss5 "" "r" 25 1 1)
   
   ;Draw the upon hold edge
   (command "pline" (list 0.1 579.87) "w" 0 0
                    (list 439.9 579.87)
                    (list 439.9 579.9)
                    (list 0.1 579.9)
                    "c"
   )
   (setq ss6 (ssget "l"))
   (command "array" ss6 "" "r" 25 1 -1)

   ( command "redraw")
)



  (defun move_to_center ( / all glass_x glass_y)     
         ( setq glass_x 220)
         ( setq glass_y 290)
         ( setq all (ssget "c" (list -10 -10) (list (+ total_x 10 ) (+ total_y 10))))
         ( command "move" all "" (list (/ total_x 2) (/ total_y 2)) (list glass_x  glass_y ))
         ( command "mirror" all "" (list 0 glass_y) (list 2 glass_y) "Y")
         (draw_stn_mark)
         (command "redraw")
    )

  ( defun get_off_set ( number width jj1 jj2 / number1 number2)
                      ( setq number1 ( fix ( / number 2)))
                      ( setq number2 ( rem number 2))
                      ( + ( * number1 ( + jj1 jj2 )) ( * number2 jj1  ) ( * number width ))
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

  ( defun start( / e_input g_input h_input f_input i_input j_input r_input
                   e_pi g_pi h_pi f_pi i_pi j_pi r_pi number_x number_y p1 p2 p3 p4 ss1
                   between_y_input temp_total_x temp_total_y 
                )
               ( setq e_input ( getreal "Please input E: ")
                      g_input ( getreal "Please input G: ")
                      h_input ( getreal "Please input H: ")
                      number_y ( getint "Please input EN: ")
                      f_input ( getreal "Please input F: ")
                      i_input ( getreal "Please input I: ")
                      j_input ( getreal "Please input J: ")
                      number_x ( getint "Please input FN: ")
                      r_input ( getreal "Please input R: ")
                )     
               ( setq e_pi (* ke1 (- e_input ce1)) ; Change the data to fit Jing bi formula ...
                      g_pi (* ke1 (+ g_input ce1))
                      h_pi (* ke1 (+ h_input ce1))
                      f_pi (- f_input (+ cf1 (* kf1 f_input)))
                      i_pi (+ i_input (+ cf1 (* kf1 f_input)))
                      j_pi (+ j_input (+ cf1 (* kf1 f_input)))
                      r_pi (* ke1 (- r_input ce1))
                )
               ( if (<= r_pi 0)
                    (setq r_pi 0.01)
                    (setq r_pi r_pi)
                )
               ( setq temp_total_y ( + e_pi ( get_off_set (1- number_y) e_pi g_pi h_pi)))
               ( setq temp_total_x ( + f_pi ( get_off_set (1- number_x) f_pi i_pi j_pi)))

               ( setq called_times ( 1+ called_times))
               ( if ( > called_times 1)
                    ( progn
                      ( setq between_y_input  ( getreal "Input the distance between two kinds of cell: "))
                      ( setq between_y (* ke1 (+ between_y_input ce1)))
                      ( setq start_y (+ total_y between_y))
                      ( setq total_y ( + between_y total_y  temp_total_y))
                      ( setq start_x  ( / ( - total_x temp_total_x) 2)) 
                     )
                    (setq total_x temp_total_x
                          total_y temp_total_y
                     )
                    )

               ;Draw a pi cell
               ( setq p1 (list start_x start_y) 
                      p2 (list (+ start_x f_pi) start_y)
                      p3 (list (+ start_x f_pi) (+ start_y e_pi))
                      p4 (list start_x (+ start_y e_pi)) 
                )
               ( command "pline" p1 "w" 0 0 p2 p3 p4 "c")
               ( setq ss1 (ssget "l"))
               ( setvar "filletrad" r_pi)
               ( command "fillet" "P" ss1)
               ( copy_many_cells ss1 start_x start_y f_pi e_pi number_x number_y i_pi j_pi g_pi h_pi)
   )
  
  ( command "limits" (list -100 -100) (list 1000 800))
  ( command "zoom" "a")
  (initialize_factor)
  (prompt " Big cells ?! ")
  (start)
  (prompt " Small cells ?! ")
  (start)
  (move_to_center)


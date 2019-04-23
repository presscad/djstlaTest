;THis program fitted for TRULY STN MIXED PI PRINT PLATE

 (defun initialize ()
        (setq ke1 0.9827
              ce1 0.38
              kf1 0.0008
              cf1 0.44
              f_input 0
              glass_x 440
              glass_y 580
              center_x 0
              center_y 0
              total_x 0
              total_y 0
              start_x 0
              start_y 0
         )
        (command "limits" (list -100 -100) (list 1000 800))
        (command "zoom" "a")
 )

 (defun e_t (x)

        (setq x (* ke1 (- x ce1)))
  )

 (defun e_o (x)

        (setq x (* ke1 (+ x ce1)))
  )

 (defun f_t (x)

        (setq x (- x (+ cf1 (* kf1 f_input))))
  )

 (defun f_o (x)

        (setq x (+ x (+ cf1 (* kf1 f_input))))
  )

 (defun get_input () 
        ( setq e_input ( getreal "Please input E: ")
               g_input ( getreal "Please input G: ")
               h_input ( getreal "Please input H: ")
               number_y ( getint "Please input EN: ")
               f_input ( getreal "Please input F: ")
               i_input ( getreal "Please input I: ")
               j_input ( getreal "Please input J: ")
               number_x ( getint "Please input FN: ")
               r_input ( getreal "Please input R: ")
               a_pi (getreal "Please input A: ")
               b_pi (getreal "Please input B: ")
               c_pi (getreal "Please input C: ")
               d_pi (getreal "Please input D: ")
               el_pi (getreal "Please input EL: ")
               fl_pi (getreal "Please input FL: ")
               m_pi (getreal "Please input M: ")
               m1_pi (getreal "Please input M1: ")
               n_pi  (getreal "Please input N: ")
               n1_pi (getreal "Please input N1: ")
               o_pi  (getreal "Please input O: ")
               o1_pi (getreal "Please input O1: ")
               p_pi  (getreal "Please input P: ")
               p1_pi (getreal "Please input P1: ")
         )
        ( setq e_pi (* ke1 (- e_input ce1)) ; Change the data to fit Jing bi formula ...
               g_pi (* ke1 (+ g_input ce1))
               h_pi (* ke1 (+ h_input ce1))
               f_pi (- f_input (+ cf1 (* kf1 f_input)))
               i_pi (+ i_input (+ cf1 (* kf1 f_input)))
               j_pi (+ j_input (+ cf1 (* kf1 f_input)))
               r_pi r_input
         )
        ( setq center_x (/ glass_x 2)
               center_y (- glass_y 90 (/ el_pi 2))
         )
        ( setq total_y ( + e_pi ( get_off_set (1- number_y) e_pi g_pi h_pi)))
        ( setq total_x ( + f_pi ( get_off_set (1- number_x) f_pi i_pi j_pi)))
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

  ( defun draw_mark ( / p1 p2 p3 p4 ss1 )
         ;Draw four protective edges 
         ;Draw left protective edge
         (setq tmp_chang1 (- a_pi n_pi n1_pi))
         (setq tmp_kuan (- el_pi p1_pi o1_pi))
         (setq tmp_chang (f_t tmp_chang1))
         (setq tmp_kuan (e_t tmp_kuan))
         (setq tmp_start_y (/ (- total_y tmp_kuan) 2))
         (setq n_pi_tmp (- 0 (f_o n_pi)))
         (command "pline" (list n_pi_tmp tmp_start_y)  "w" 0 0
                          (list (- n_pi_tmp tmp_chang) tmp_start_y)
                          (list (- n_pi_tmp tmp_chang) (+ tmp_start_y tmp_kuan))
                          (list n_pi_tmp (+ tmp_start_y tmp_kuan))
                          "c"
          )

         ;Draw right protective edge 
         (setq tmp_chang2 (- b_pi m_pi m1_pi))
         (setq tmp_chang (f_t tmp_chang2))
         (setq tmp_start_y tmp_start_y)
         (setq tmp_start_x (+ (f_o m_pi) total_x))
         (command "pline" (list tmp_start_x tmp_start_y)  "w" 0 0
                          (list (+ tmp_start_x tmp_chang) tmp_start_y)
                          (list (+ tmp_start_x tmp_chang) (+ tmp_start_y tmp_kuan))
                          (list tmp_start_x (+ tmp_start_y tmp_kuan))
                          "c"
          )

         ;Draw upon protective edge
         (setq jian_ju (f_o 1.5))
         (setq tmp_chang3 (- fl_pi n1_pi m1_pi tmp_chang1 tmp_chang2 3))
         (setq tmp_kuan (- c_pi p1_pi p_pi))
         (setq tmp_chang (f_t tmp_chang3))
         (setq tmp_kuan (e_t tmp_kuan))
         (setq tmp_start_x (/ (- total_x tmp_chang) 2))
         (setq tmp_start_y (+ total_y (e_o p_pi)))
         (command "pline" (list tmp_start_x tmp_start_y)  "w" 0 0
                          (list (+ tmp_start_x tmp_chang) tmp_start_y)
                          (list (+ tmp_start_x tmp_chang) (+ tmp_start_y tmp_kuan))
                          (list tmp_start_x (+ tmp_start_y tmp_kuan))
                          "c"
          )

         ;Draw down protective edge
         (setq tmp_kuan (- d_pi o1_pi o_pi))
         (setq tmp_kuan (e_t tmp_kuan))
         (setq tmp_start_x tmp_start_x)
         (setq tmp_start_y (- 0 (e_o o_pi)))
         (command "pline" (list tmp_start_x tmp_start_y)  "w" 0 0
                          (list (+ tmp_start_x tmp_chang) tmp_start_y)
                          (list (+ tmp_start_x tmp_chang) (- tmp_start_y tmp_kuan))
                          (list tmp_start_x (- tmp_start_y tmp_kuan))
                          "c"
          )
         (command "move" "ALL" "" (list (/ total_x 2) (/ total_y 2)) (list center_x  center_y))

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
  
         ;Draw the down hold edge
         (command "pline" (list 0.1 0.1) "w" 0 0
                    (list 439.9 0.1)
                    (list 439.9 0.15)
                    (list 0.1 0.15)
                    "c"
                )

         (setq ss5 (ssget "l"))
         (command "array" ss5 "" "r" 25 1 1)
         ;Draw the upon hold edge  
         (command "pline" (list 0.1 579.85) "w" 0 0
                    (list 439.9 579.85)
                    (list 439.9 579.9)
                    (list 0.1 579.9)
                    "c"
                )
         (setq ss6 (ssget "l"))
         (command "array" ss6 "" "r" 25 1 -1)
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
                         (command "move" all "" (list 0 now_y) (list 0 (- now_y (* move_step (- handle_number count)))))
                         (setq count (1+ count))
                   )
  )
 
 (initialize)
 (get_input)
 (draw_many_cells 0 0 f_pi e_pi number_x number_y i_pi j_pi g_pi h_pi)
 (auto_fix)
 (draw_mark)
 (setq input_text (getstring T "Input QY mark: "))
 (command "text" (list 125 27.5) 8 0 input_text)


            ;THis program fitted for TRULY TN MIXED PI PRINT PLATE

 ( defun initialize (/ no_para)
         (command "limits" (list -100 -100) (list 1000 800))
         (command "zoom" "a")
         ( setq ke1 0.9868
                ce1 0.4200
                kf1 0.0014
                cf1 0.2800
                number_x 0
                number_y 0
                total_x 0
                total_y 0
                glass_x 214.3
                glass_y 259.4
                el_pi 406.4
                fl_pi 355.6
                mk_pi 450
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

( defun draw_mark ( / now w length height ratio)
                     (setq w 0.1)
                     (command "pline" (list (- 24.3 w) (- 462.6 5))   "w" 0 0
                                      (list (+ 24.3 w) (- 462.6 5))
                                      (list (+ 24.3 w) (- 462.6 w))
                                      (list (+ 24.3 5) (- 462.6 w))
                                      (list (+ 24.3 5) (+ 462.6 w))
                                      (list (+ 24.3 w) (+ 462.6 w))
                                      (list (+ 24.3 w) (+ 462.6 10))
                                      (list (- 24.3 w) (+ 462.6 10))
                                      (list (- 24.3 w) (+ 462.6 w))
                                      (list (- 24.3 5) (+ 462.6 w))
                                      (list (- 24.3 5) (- 462.6 w))
                                      (list (- 24.3 w) (- 462.6 w))
                                      "c"
                      )
                     (setq now (ssget "L"))
                     (command "pline" (list (- 24.3 5) (- 259.4 w))   "w" 0 0 
                                      (list (- 24.3 w) (- 259.4 w))
                                      (list (- 24.3 w) (- 259.4 5))
                                      (list (+ 24.3 w) (- 259.4 5))
                                      (list (+ 24.3 w) (+ 259.4 5))
                                      (list (- 24.3 w) (+ 259.4 5))
                                      (list (- 24.3 w) (+ 259.4 w))
                                      (list (- 24.3 5) (+ 259.4 w))
                                      "c"
                       )
                      ( ssadd (entlast) now)
                      ( command "pline" (list (- 24.3 w) 56.2)   "w" 0 0                   (list (+ 24.3 w) 56.2)
                                        (list (+ 24.3 w) (- 56.2 25))
                                        (list (- 24.3 w) (- 56.2 25))
                                        "c"
                        )
                       ( ssadd (entlast) now)
                       ( command "mirror" now "" (list 214.3 0) (list 214.3 4) "n")

                      ( command "pline" (list (+ n1_pi 36.5) (+ o1_pi 56.2))  "w" 0 0
                     (list (+ (- a_pi n_pi) 36.5) (+ o1_pi 56.2))
                     (list (+ (- a_pi n_pi) 36.5) (+ (- el_pi p1_pi) 56.2))
                     (list (+ n1_pi 36.5) (+ (- el_pi p1_pi) 56.2))
                     "c"
                       )
   

   ;Draw right protective edge 
   (cond ((< o1_pi 5)
          (command "pline" (list (+ 36.5 m_pi (- fl_pi b_pi)) (+ 5 56.2))  "w" 0 0
                    (list (+ (- fl_pi m1_pi) 36.5) (+ 5 56.2))
                    (list (+ (- fl_pi m1_pi) 36.5) (+ (- el_pi p1_pi) 56.2))
                    (list (+ 36.5 m_pi (- fl_pi b_pi)) (+ (- el_pi p1_pi) 56.2))
                    "c"
          )
         )
         (t
          (command "pline" (list (+ 36.5 m_pi (- fl_pi b_pi)) (+ o1_pi 56.2))  "w" 0 0
                    (list (+ (- fl_pi m1_pi) 36.5) (+ o1_pi 56.2))
                    (list (+ (- fl_pi m1_pi) 36.5) (+ (- el_pi p1_pi) 56.2))
                    (list (+ 36.5 m_pi (- fl_pi b_pi)) (+ (- el_pi p1_pi) 56.2))
                    "c"
          )
         )

   )

   ;Draw upon protective edge 
   (cond ((< p1_pi (/ (- el_pi mk_pi) 2))
          (command "pline" (list (- (+ 36.5 1.5 a_pi) n_pi) (- (+ 56.2 el_pi) p1_pi))  "w" 0 0
                    (list (- (+ 36.5 fl_pi m_pi) (+ b_pi 1.5)) (- (+ 56.2 el_pi) p1_pi))
                    (list (- (+ 36.5 fl_pi m_pi) (+ b_pi 1.5)) (- (+ 56.2 el_pi p_pi) c_pi))
                    (list (+ 36.5 2.75 (/ fl_pi 2)) (- (+ 56.2 el_pi p_pi) c_pi))
                    (list (+ 36.5 2.75 (/ fl_pi 2)) (+ 56.2 (/ (+ el_pi mk_pi) 2)))
                    (list (- (+ 36.5 (/ fl_pi 2)) 2.75) (+ 56.2 (/ (+ el_pi mk_pi) 2)))
                    (list (- (+ 36.5 (/ fl_pi 2)) 2.75) (- (+ 56.2 el_pi p_pi) c_pi))
                    (list (- (+ 36.5 1.5 a_pi) n_pi) (- (+ 56.2 el_pi p_pi) c_pi))
                    "c"
          )
         )
         (t
          (progn
            (command "pline" (list  (- (+ 36.5 1.5 a_pi) n_pi) (- (+ 56.2 el_pi) p1_pi))  "w" 0 0
                    (list (- (+ 36.5 (/ fl_pi 2)) 2.75) (- (+ 56.2 el_pi) p1_pi))
                    (list (- (+ 36.5 (/ fl_pi 2)) 2.75) (- (+ 56.2 el_pi p_pi) c_pi))
                    (list (- (+ 36.5 1.5 a_pi) n_pi) (- (+ 56.2 el_pi p_pi) c_pi))
                    "c"
            )
            (command "pline" (list (+ 36.5 2.75 (/ fl_pi 2)) (- (+ 56.2 el_pi) p1_pi))  "w" 0 0
                      (list (- (+ 36.5 fl_pi m_pi) (+ b_pi 1.5)) (- (+ 56.2 el_pi) p1_pi))
                      (list (- (+ 36.5 fl_pi m_pi) (+ b_pi 1.5)) (- (+ 56.2 el_pi p_pi) c_pi))
                      (list (+ 36.5 2.75 (/ fl_pi 2)) (- (+ 56.2 el_pi p_pi) c_pi))
                      "c"
            )
          )
         )
   )

   ;Draw down protective edge
   (cond ((and (< o1_pi (/ (- el_pi mk_pi) 2)) (< o1_pi 5))
          (command "pline" (list (- (+ 36.5 a_pi 1.5) n_pi) (- (+ 56.2 d_pi) o_pi)) "w" 0 0
                    (list (- (+ 36.5 (/ fl_pi 2)) 2.75) (- (+ 56.2 d_pi) o_pi))
                    (list (- (+ 36.5 (/ fl_pi 2)) 2.75) (+ 56.2 (/ (- el_pi mk_pi) 2)))
                    (list (+ (+ 36.5 (/ fl_pi 2)) 2.75) (+ 56.2 (/ (- el_pi mk_pi) 2)))
                    (list (+ (+ 36.5 (/ fl_pi 2)) 2.75) (- (+ 56.2 d_pi) o_pi))
                    (list (- (+ 36.5 fl_pi m_pi) (+ b_pi 1.5)) (- (+ 56.2 d_pi) o_pi))
                    (list (- (+ 36.5 fl_pi m_pi) (+ b_pi 1.5)) (+ 56.2 5))
                    (list (- (+ 36.5 fl_pi) 130) (+ 56.2 5))
                    (list (- (+ 36.5 fl_pi) 130 ) (+ 56.2 o1_pi))
                    (list (- (+ 36.5 a_pi 1.5) n_pi) (+ 56.2 o1_pi))
                    "c"
          )
         )
         ((and (>= o1_pi (/ (- el_pi mk_pi) 2)) (< o1_pi 5))
          (progn
           (command "pline" (list (- (+ 36.5 a_pi 1.5) n_pi) (- (+ 56.2 d_pi) o_pi)) "w" 0 0
                    (list (- (+ 36.5 (/ fl_pi 2)) 2.75) (- (+ 56.2 d_pi) o_pi))
                    (list (- (+ 36.5 (/ fl_pi 2)) 2.75) (+ 56.2 o1_pi))
                    (list (- (+ 36.5 a_pi 1.5) n_pi) (+ 56.2 o1_pi))
                    "c"
           )
           (command "pline" (list (+ (+ 36.5 (/ fl_pi 2)) 2.75) (- (+ 56.2 d_pi) o_pi)) "w" 0 0
                    (list (- (+ 36.5 fl_pi m_pi) (+ b_pi 1.5)) (- (+ 56.2 d_pi) o_pi))
                    (list (- (+ 36.5 fl_pi m_pi) (+ b_pi 1.5)) (+ 56.2 5))
                    (list (- (+ 36.5 fl_pi) 130) (+ 56.2 5))
                    (list (- (+ 36.5 fl_pi) 130 ) (+ 56.2 o1_pi))
                    (list (+ (+ 36.5 (/ fl_pi 2)) 2.75) (+ 56.2 o1_pi))
                    "c"
           )
          )
         )

         ((and (>= o1_pi 5) (< o1_pi (/ (- el_pi mk_pi) 2)))
          (command "pline" (list (- (+ 36.5 a_pi 1.5) n_pi) (- (+ 56.2 d_pi) o_pi)) "w" 0 0
                   (list (- (+ 36.5 (/ fl_pi 2)) 2.75) (- (+ 56.2 d_pi) o_pi))
                   (list (- (+ 36.5 (/ fl_pi 2)) 2.75) (+ 56.2 (/ (- el_pi mk_pi) 2)))
                   (list (+ (+ 36.5 (/ fl_pi 2)) 2.75) (+ 56.2 (/ (- el_pi mk_pi) 2)))
                   (list (+ (+ 36.5 (/ fl_pi 2)) 2.75) (- (+ 56.2 d_pi) o_pi))
                   (list (- (+ 36.5 fl_pi m_pi) (+ b_pi 1.5)) (- (+ 56.2 d_pi) o_pi))
                   (list (- (+ 36.5 fl_pi m_pi) (+ b_pi 1.5)) (+ 56.2 o1_pi))
                   (list (- (+ 36.5 a_pi 1.5) n_pi) (+ 56.2 o1_pi))
                    "c"
          )
         )
 
         (t
          (progn
           (command "pline" (list (- (+ 36.5 a_pi 1.5) n_pi) (- (+ 56.2 d_pi) o_pi)) "w" 0 0
                    (list (- (+ 36.5 (/ fl_pi 2)) 2.75) (- (+ 56.2 d_pi) o_pi))
                    (list (- (+ 36.5 (/ fl_pi 2)) 2.75) (+ 56.2 o1_pi))
                    (list (- (+ 36.5 a_pi 1.5) n_pi) (+ 56.2 o1_pi))
                    "c"
           )
           (command "pline" (list (+ (+ 36.5 (/ fl_pi 2)) 2.75) (- (+ 56.2 d_pi) o_pi)) "w" 0 0
                    (list (- (+ 36.5 fl_pi m_pi) (+ b_pi 1.5)) (- (+ 56.2 d_pi) o_pi))
                    (list (- (+ 36.5 fl_pi m_pi) (+ b_pi 1.5)) (+ 56.2 o1_pi))
                    (list (+ (+ 36.5 (/ fl_pi 2)) 2.75) (+ 56.2 o1_pi))
                    "c"
           )
          )
         )
   )

   ;upon left pi plate range mark,it's center is (0 528.8)
   (command "pline" (list 0 528.8)   "w" 0 0 
                    (list 10 528.8)
                    (list 10 530.8)
                    (list -2 530.8)
                    (list -2 518.8)
                    (list 0 518.8)
                    "c"
    )

   ;upon right pi plate range mark,it's center is (428.6 528.8)
   (command "pline" (list 428.6 528.8)   "w" 0 0 
                    (list 418.6 528.8)
                    (list 418.6 530.8)
                    (list 430.6 530.8)
                    (list 430.6 518.8)
                    (list 428.6 518.8)
                    "c"
    )

   ;down right pi plate range mark,it's center is (428.6 0)
   (command "pline" (list 428.6 0)   "w" 0 0 
                    (list 418.6 0)
                    (list 418.6 -2)
                    (list 430.6 -2)
                    (list 430.6 10)
                    (list 428.6 10)
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

               (setq a_pi (getreal "Please input A: ")
                     b_pi (getreal "Please input B: ")
                     c_pi (getreal "Please input C: ")
                     d_pi (getreal "Please input D: ")
                     ;el_pi (getreal "Please input EL: ")
                     ;fl_pi (getreal "Please input FL: ")
                     ;mk_pi (getreal "Please input MK: ")
                     m_pi (getreal "Please input M: ")
                     m1_pi (getreal "Please input M1: ")
                     n_pi (getreal "Please input N: ")
                     n1_pi (getreal "Please input N1: ")
                     o_pi (getreal "Please input O: ")
                     o1_pi (getreal "Please input O1: ")
                     p_pi (getreal "Please input P: ")
                     p1_pi (getreal "Please input P1: ")
                )
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
  (auto_fix)
  (command "move" "ALL" "" (list (/ total_x 2) (/ total_y 2)) (list glass_x glass_y))
  (draw_mark)
  (command "mirror" "ALL" "" (list glass_x 0) (list glass_x 2) "Y")
  (setq input_text ( getstring T "Input QY mark: "))
  (command "text" (list 100 20) 8 0 input_text)
 

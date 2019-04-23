;傲卓立14X14英寸凸版制作程序
(defun c:OCL14()
 ( defun initialize (/ no_para)
         (command "limits" (list -100 -100) (list 1000 800))
         (command "zoom" "a")
         ( setq ke1 0.9815
                ce1 0.2
                kf1 0
                cf1 0.2
                align_point_x 381
                align_point_y 395
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
		      YT_input (getReal "输入Y方向拼版长度: ")
		)
    		(if (not (or (equal (+ e_input e_input g_input h_input) Yt_input 0.001)
			(equal (+ e_input g_input) Yt_input 0.001)))
		  (progn
		  (prompt "\nY方向图形标注意尺寸与客户提供拼版尺寸有矛盾，请确认！")
		  (exit)
		  )
		  )
    		(setq
                      f_input ( getreal "输入X方向粒长F: ")
                      i_input ( getreal "输入X方向间长I: ")
                      j_input ( getreal "输入X方向间长J: ")
                      number_x ( getint "输入X方向粒数FN: ")
		      XT_input (getReal "输入X方向拼版长度:")
		)
    		(if (not (or (equal (+ f_input f_input i_input j_input) Xt_input 0.001)
			(equal (+ f_input i_input) Xt_input 0.001)))
		  (progn
		  (prompt "\nX方向图形标注意尺寸与客户提供拼版尺寸有矛盾，请确认！")
		  (exit)
		  )
		  )
    		(setq
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
;        (command "pline" (list 381.0 293.9) "w" 0 0 
;                         (list 376.5 293.9) 
;                         (list 376.5 292.9) 
;                         (list 381.0 292.9) 
;                         (list 381.0 288.4) 
;                         (list 382.0 288.4) 
;                         (list 382.0 292.9) 
;                         (list 386.5 292.9) 
;                         (list 386.5 293.9) 
;                         (list 382.0 293.9) 
;                         (list 382.0 298.4) 
;                         (list 381.0 298.4) 
;                         (list 381.0 293.9) 
;                         "c"
;         )
        (command "pline" (list 21.0 396.0) "w" 0 0 
                         (list 21.0 400.5) 
                         (list 22.0 400.5) 
                         (list 22.0 396.0) 
                         (list 26.5 396.0) 
                         (list 26.5 395.5) 
                         (list 26.5 395.0) 
                         (list 22.0 395.0) 
                         (list 22.0 390.5) 
                         (list 21.0 390.5) 
                         (list 21.0 395.0) 
                         (list 16.5 395.0) 
                         (list 16.5 396.0) 
                         "c"
         )
        (command "pline" (list 386.5 395.0) "w" 0 0 
                         (list 386.5 396.0) 
                         (list 382.0 396.0) 
                         (list 382.0 400.5) 
                         (list 381.0 400.5) 
                         (list 381.0 396.0) 
                         (list 376.5 396.0) 
                         (list 376.5 395.0) 
                         (list 381.0 395.0) 
                         (list 381.0 390.5) 
                         (list 382.0 390.5) 
                         (list 382.0 395.0) 
                         "c"
         )
        (command "pline" (list 21.0 33.8999) "w" 0 0 
                         (list 21.0 38.3999) 
                         (list 16.5 38.3999) 
                         (list 16.5 39.3999) 
                         (list 21.0 39.3999) 
                         (list 21.0 43.8999) 
                         (list 22.0 43.8999) 
                         (list 22.0 39.3999) 
                         (list 26.5 39.3999) 
                         (list 26.5 38.8999) 
                         (list 26.5 38.3999) 
                         (list 22.0 38.3999) 
                         (list 22.0 33.8999) 
                         "c"
         )
        (command "pline" (list 381.0 43.8999) "w" 0 0 
                         (list 382.0 43.8999) 
                         (list 382.0 39.3999) 
                         (list 386.5 39.3999) 
                         (list 386.5 38.3999) 
                         (list 382.0 38.3999) 
                         (list 382.0 33.8999) 
                         (list 381.0 33.8999) 
                         (list 381.0 38.3999) 
                         (list 376.5 38.3999) 
                         (list 376.5 39.3999) 
                         (list 381.0 39.3999) 
                         "c"
         )
;        (command "pline" (list 21.9999 298.4) "w" 0 0 
;                         (list 20.9999 298.4) 
;                         (list 20.9999 293.9) 
;                         (list 16.4999 293.9) 
;                         (list 16.4999 292.9) 
;                         (list 20.9999 292.9) 
;                         (list 20.9999 288.4) 
;                         (list 21.9999 288.4) 
;                         (list 21.9999 292.9) 
;                         (list 26.4999 292.9) 
;                         (list 26.4999 293.9) 
;                         (list 21.9999 293.9) 
;                         "c"
;         )
        (command "pline" (list 0.0 405.269) "w" 0 0 
                         (list 0.0 437.0) 
                         (list 33.4737 437.0) 
                         (list 33.4737 435.0) 
                         (list 2.0 435.0) 
                         (list 2.0 405.269) 
                         "c"
         )
        (command "pline" (list 371.038 435.0) "w" 0 0 
                         (list 401.0 435.0) 
                         (list 401.0 405.269) 
                         (list 403.0 405.269) 
                         (list 403.0 437.0) 
                         (list 371.038 437.0) 
                         "c"
         )
        (command "pline" (list 33.4737 0.0) "w" 0 0 
                         (list 0.0 0.0) 
                         (list 0.0 29.9023) 
                         (list 2.0 29.9023) 
                         (list 2.0 2.0) 
                         (list 33.4737 2.0) 
                         "c"
         )
        (command "pline" (list 371.038 2.0) "w" 0 0 
                         (list 401.0 2.0) 
                         (list 401.0 29.9023) 
                         (list 403.0 29.9023) 
                         (list 403.0 0.0) 
                         (list 371.038 0.0) 
                         "c"
         )
  )

  (initialize)
  (get_input)
  (draw_many_cells 0 0 f_pi e_pi number_x number_y i_pi j_pi g_pi h_pi)
  (command "move" "ALL" "" (list total_x total_y) (list (- align_point_x align_x) (- align_point_y align_y)))
  (draw_edge)
  (setq c_date (getvar "CDATE"))
  (setq apr_id (strcat " QINGYI " (itoa (fix c_date))))  
  (setq input_text ( strcase ( getstring T "输入产品编号: ")))
  (setq input_text (strcat (strcase input_text) apr_id))
  (command "text" (list 100 404) 6 0 input_text)
 )
(prompt "run ocl14")


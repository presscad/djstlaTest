;傲卓立14X16英寸凸版制作程序
(defun c:ocl16()
 ( defun initialize (/ no_para)
         (command "limits" (list -100 -100) (list 1000 800))
         (command "zoom" "a")
         ( setq align_point_x 177.8
                align_point_y 203.5
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
		      du_e (getreal "\n 请输入上DUMMY的宽度:")
		      du_g (getreal "\n 请输入上DUMMY的缝:")
		      dd_e (getreal "\n 请输入下DUMMY的宽度:")
		      dd_g (getreal "\n 请输入下DUMMY的缝:")
		      dl_e (getreal "\n 请输入左DUMMY的宽度:")
		      dl_i (getreal "\n 请输入左DUMMY的缝:")
		      dr_e (getreal "\n 请输入右DUMMY的宽度:")
		      dr_i (getreal "\n 请输入右DUMMY的缝:")
                 )
		      (if (< (* number_x number_y) 150)
		     	 (setq ke1 0.9858
			       ce1 0.250
			       kf1 0.000
			       cf1 0.250)    
		   	(setq  ke1 0.9875
			       ce1 0.150
			       kf1 0.000
			       cf1 0.150)
		    )
    		(setq no_x number_x)
    		(setq no_y number_y)
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
                      align_x (+ align_x (+ (/ cf1 2) (* kf1 f_input)))
                      align_y (* ke1 (+ align_y ce1))
                )
               (setq total_y ( + e_pi ( get_off_set (1- number_y) e_pi g_pi h_pi)))
               (setq total_x ( + f_pi ( get_off_set (1- number_x) f_pi i_pi j_pi)))
   )

 (defun draw_edge () 
        (command "pline" (list 210.0 265.5) "w" 0 0 
                         (list -212.0 265.5) 
                         (list -212.0 265.5) 
                         (list -212.0 -265.5) 
                         (list 212.0 -265.5) 
                         (list 212.0 265.5) 
                         (list 210.0 265.5) 
                         (list 210.0 263.5) 
                         (list 210.0 263.5) 
                         (list 210.0 263.5) 
                         (list -210.0 263.5) 
                         (list -210.0 -263.5) 
                         (list 210.0 -263.5) 
                         (list 210.0 263.5) 
                         "c"
         )
        (command "pline" (list -172.8 -202.4) "w" 0 0 
                         (list -177.3 -202.4) 
                         (list -177.3 -197.9) 
                         (list -178.3 -197.9) 
                         (list -178.3 -202.4) 
                         (list -182.8 -202.4) 
                         (list -182.8 -203.4) 
                         (list -178.3 -203.4) 
                         (list -178.3 -207.9) 
                         (list -177.3 -207.9) 
                         (list -177.3 -203.4) 
                         (list -172.8 -203.4) 
                         "c"
         )
        (command "pline" (list 178.3 -197.9) "w" 0 0 
                         (list 177.3 -197.9) 
                         (list 177.3 -202.4) 
                         (list 172.8 -202.4) 
                         (list 172.8 -203.4) 
                         (list 177.3 -203.4) 
                         (list 177.3 -207.9) 
                         (list 178.3 -207.9) 
                         (list 178.3 -203.4) 
                         (list 182.8 -203.4) 
                         (list 182.8 -202.4) 
                         (list 178.3 -202.4) 
                         "c"
         )
        (command "pline" (list 172.8 203.0) "w" 0 0 
                         (list 172.8 204.0) 
                         (list 177.3 204.0) 
                         (list 177.3 208.5) 
                         (list 178.3 208.5) 
                         (list 178.3 204.0) 
                         (list 182.8 204.0) 
                         (list 182.8 203.0) 
                         (list 178.3 203.0) 
                         (list 178.3 198.5) 
                         (list 177.3 198.5) 
                         (list 177.3 203.0) 
                         "c"
         )
        (command "pline" (list -177.3 198.5) "w" 0 0 
                         (list -178.3 198.5) 
                         (list -178.3 203.0) 
                         (list -182.8 203.0) 
                         (list -182.8 204.0) 
                         (list -178.3 204.0) 
                         (list -178.3 208.5) 
                         (list -177.3 208.5) 
                         (list -177.3 204.0) 
                         (list -172.8 204.0) 
                         (list -172.8 203.0) 
                         (list -177.3 203.0) 
                         "c"
         )
        (command "pline" (list 200.25 -200.5) "w" 0 0 
                         (list 199.75 -200.5) 
                         (list 199.75 -190.5) 
                         (list 200.25 -190.5) 
                         "c"
         )
        (command "pline" (list -199.75 -190.5) "w" 0 0 
                         (list -200.25 -190.5) 
                         (list -200.25 -200.5) 
                         (list -199.75 -200.5) 
                         "c"
         )
        (command "pline" (list 200.25 203.5) "w" 0 0 
                         (list 199.75 203.5) 
                         (list 199.75 198.75) 
                         (list 194.75 198.75) 
                         (list 194.75 198.25) 
                         (list 199.75 198.25) 
                         (list 199.75 193.5) 
                         (list 200.25 193.5) 
                         (list 200.25 198.25) 
                         (list 205.25 198.25) 
                         (list 205.25 198.75) 
                         (list 200.25 198.75) 
                         "c"
         )
        (command "pline" (list -205.0 198.75) "w" 0 0 
                         (list -200.25 198.75) 
                         (list -200.25 203.5) 
                         (list -199.75 203.5) 
                         (list -199.75 198.75) 
                         (list -195.0 198.75) 
                         (list -195.0 198.25) 
                         (list -199.75 198.25) 
                         (list -199.75 193.5) 
                         (list -200.25 193.5) 
                         (list -200.25 198.25) 
                         (list -205.0 198.25) 
                         "c"
         )
  )
  (defun draw_dummy(f_pi e_pi number_x number_y i_pi j_pi g_pi h_pi total_x total_y
		    du_e du_g dd_e dd_g dl_e dl_i dr_e dr_i )
    (setq p1 (list (- (- cf1) dl_i) 0))
    (setq p2 (list (- (- cf1) dl_i) e_pi))
    (setq p3 (list (- (- dl_i) dl_e ) e_pi))
    (setq p4 (list (- (- dl_i) dl_e ) 0))
    (command "pline" p1 p2 p3 p4 "c")
    (setq last_ss (ssget "L"))
    (setq cp_cn 1)
    (while (< cp_cn number_y)
      (setq dst_pnt (list (- (- cf1) dl_i) (get_off_set cp_cn e_pi g_pi h_pi)))
      (command "copy" last_ss "" p1 dst_pnt)
      (setq cp_cn (1+ cp_cn))
      )

    (setq p1 (list 0 (* ke1 (- (- ce1) dd_g))))
    (setq p2 (list 0 (* ke1 (- (- dd_e) dd_g))))
    (setq p3 (list f_pi (* ke1 (- (- dd_e) dd_g))))
    (setq p4 (list f_pi (* ke1 (- (- ce1) dd_g))))
    (command "pline" p1 p2 p3 p4 "c")
    (setq last_ss (ssget "L"))
    (setq cp_cn 1)
    (while (< cp_cn number_x)
      (setq dst_pnt (list (get_off_set cp_cn f_pi i_pi j_pi) (* ke1 (- (- ce1) dd_g))))
      (command "copy" last_ss "" p1 dst_pnt)
      (setq cp_cn (1+ cp_cn))
      )

    (setq p1 (list (+ cf1 dr_i total_x) 0))
    (setq p2 (list (+ cf1 dr_i total_x) e_pi))
    (setq p3 (list (+ total_x dr_i dr_e) e_pi))
    (setq p4 (list (+ total_x dr_i dr_e) 0))
    (command "pline" p1 p2 p3 p4 "c")
    (setq last_ss (ssget "L"))
    (setq cp_cn 1)
    (while (< cp_cn number_y)
      (setq dst_pnt (list (+ cf1 dr_i total_x) (get_off_set cp_cn e_pi g_pi h_pi)))
      (command "copy" last_ss "" p1 dst_pnt)
      (setq cp_cn (1+ cp_cn))
      )
    
    (setq p1 (list 0 (+ total_y (* ke1 (+ ce1 du_g)))))
    (setq p2 (list 0 (+ total_y (* ke1 (+  du_e du_g)))))
    (setq p3 (list f_pi (+ total_y (* ke1 (+ du_e du_g)))))
    (setq p4 (list f_pi (+ total_y (* ke1 (+ ce1 du_g)))))
    (command "pline" p1 p2 p3 p4 "c")
    (setq last_ss (ssget "L"))
    (setq cp_cn 1)
    (while (< cp_cn number_x)
      (setq dst_pnt (list (get_off_set cp_cn f_pi i_pi j_pi) (+ total_y (* ke1 (+ ce1 du_g)))))
      (command "copy" last_ss "" p1 dst_pnt)
      (setq cp_cn (1+ cp_cn))
      ) 
    
    )
  (initialize)
  (get_input)
  (draw_many_cells 0 0 f_pi e_pi number_x number_y i_pi j_pi g_pi h_pi)
  (draw_dummy f_pi e_pi no_x no_y i_pi j_pi g_pi h_pi total_x total_y
		    du_e du_g dd_e dd_g dl_e dl_i dr_e dr_i)
  (command "move" "ALL" "" (list total_x total_y) (list (- align_point_x align_x) (- align_point_y align_y)))
  (draw_edge)
  (setq c_date (getvar "CDATE"))
  (setq apr_id (strcat " QINGYI " (itoa (fix c_date))))  
  (setq input_text ( strcase ( getstring T "输入产品编号: ")))
  (setq input_text (strcat (strcase input_text) apr_id))
  (command "text" (list -90 -240) 6 0 input_text)
  )




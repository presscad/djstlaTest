					;(defun C:CELLS()
(defun C:huatai()                           			;输入数据
  (setq e_input (getreal "Please input E: "))
  (setq g_input (getreal "Please input G: "))
  (setq h_input (getreal "Please input H: "))
  (setq en_pi (getint "Please input EN: "))
  (setq f_input (getreal "Please input F: "))
  (setq i_input (getreal "Please input I: "))
  (setq j_input (getreal "Please input J: "))
  (setq fn_pi (getint "Please input FN: "))
  (setq r_input (getreal "Please input R: "))
					;设置系数
  ( setq ke1 0.98
                ce1 0.32
                kf1 0.0
                cf1 0.35
          )
  ;公式计算
  (setq e_pi (* ke1 (- e_input ce1)))
  (setq g_pi (* ke1 (+ g_input ce1)))
  (setq h_pi (* ke1 (+ h_input ce1)))
  (setq f_pi (- f_input (+ cf1 (* kf1 f_input))))
  (setq i_pi (+ i_input (+ cf1 (* kf1 f_input))))
  (setq j_pi (+ j_input (+ cf1 (* kf1 f_input))))
  (if (< r_input 0.001)
      (setq r_pi 0.001)
      (setq r_pi r_input)
  )		;半径不能为0
  ;如果EN为奇数则,对g,h进行值交换。
  (if (/= (- (/ en_pi 2.0) (/ en_pi 2)) 0)
    (progn
      (setq tmp g_pi)
      (setq g_pi h_pi)
      (setq h_pi tmp)
      )
    )
;设置图形边界
  (command "limits" (list -500 -500) (list 500 500))
  (command "zoom" "a")
;设置CELL放置的中心
  (setq	glass_x	0
	glass_y	0
  )
;求双粒排版的步距
   (setq x_pitch (+ f_pi f_pi i_pi j_pi))
   (setq y_pitch (+ e_pi e_pi g_pi h_pi))

;求E_TOTAL,F_TOTAL
  (if (or (= en_pi 1) (= fn_pi 1))
    (progn
      (prompt "\n程序不能处理一行或一列的情况，请将EN或FN改为3,然后将多余的删除!")
      (exit)
    )
    (progn
      (cond ((and (= 0 (rem en_pi 2))
		  (= 0 (rem fn_pi 2))
	     )				;en与fn都是偶数
	     (setq ftotal_pi (- (* (/ fn_pi 2) x_pitch) j_pi)
		   etotal_pi (- (* (/ en_pi 2) y_pitch) h_pi)
	     )
	    )
	    ((and (= 0 (rem en_pi 2))
		  (= 1 (rem fn_pi 2))
	     )				;en是偶数，fn是奇数
	     (setq ftotal_pi (+ (* (/ fn_pi 2) x_pitch) f_pi)
		   etotal_pi (- (* (/ en_pi 2) y_pitch) h_pi)
	     )
	    )
	    ((and (= 1 (rem en_pi 2))
		  (= 0 (rem fn_pi 2))
	     )				;fn是偶数，en是奇数
	     (setq ftotal_pi (- (* (/ fn_pi 2) x_pitch) j_pi)
		   etotal_pi (+ (* (/ en_pi 2) y_pitch) e_pi)
	     )
	    )
	    ((and (= 1 (rem en_pi 2))
		  (= 1 (rem fn_pi 2))
	     )				;en与fn都是奇数
	     (setq ftotal_pi (+ (* (/ fn_pi 2) x_pitch) f_pi)
		   etotal_pi (+ (* (/ en_pi 2) y_pitch) e_pi)
	     )
	    )
      )
    )
  )
 ;求左下角第一粒的左下角座标  
  (setq	origin_x (- glass_x (/ ftotal_pi 2))
	origin_y (- glass_y (/ etotal_pi 2))
  )
;初始化循环变量
  (setq loop_e 0)
  (setq loop_f 0)
  (repeat en_pi
    ;印刷方向
    (repeat fn_pi
      ;非印刷方向

      ;求八个顶点与四个倒角的半径
      (setq p1 (list (+ r_pi origin_x) (+ 0 origin_y))
	    p2 (list (+ (- f_pi r_pi) origin_x) (+ 0 origin_y))
	    p3 (list (+ f_pi origin_x) (+ r_pi origin_y))
	    p4 (list (+ f_pi origin_x) (+ (- e_pi r_pi) origin_y))
	    p5 (list (+ (- f_pi r_pi) origin_x) (+ e_pi origin_y))
	    p6 (list (+ r_pi origin_x) (+ e_pi origin_y))
	    p7 (list (+ 0 origin_x) (+ (- e_pi r_pi) origin_y))
	    p8 (list (+ 0 origin_x) (+ r_pi origin_y))
	    o1 (list (+ r_pi origin_x) (+ r_pi origin_y))
	    o2 (list (+ (- f_pi r_pi) origin_x) (+ r_pi origin_y))
	    o3 (list (+ (- f_pi r_pi) origin_x) (+ (- e_pi r_pi) origin_y))
	    o4 (list (+ r_pi origin_x) (+ (- e_pi r_pi) origin_y))
      )
      ;划单粒
      (command "pline"	   p1	 "w"   0     0	   p2 ;down edge
	       "a"   "r"   r_pi	 p3	;down right conner
	       "l"   p4			;right edge
	       "a"   "r"   r_pi	 p5	;upon right conner
	       "l"   p6			;upon edge
	       "a"   "r"   r_pi	 p7	;upon left conner
	       "l"   p8			;left edge
	       "a"   "r"   r_pi	 p1	;down left conner
	       "close"
	      )
      (setq loop_f (1+ loop_f))
      (setq
	gap_f (+ (* i_pi (* (- (/ loop_f 2.0) (/ loop_f 2)) 2))
		 (* j_pi
		    (* (- (/ (+ loop_f 1) 2.0) (/ (+ loop_f 1) 2)) 2)
		 )
	      )
      )
      (setq origin_x (+ origin_x (+ gap_f f_pi)))
    )
    (setq loop_f 0)
    (setq loop_e (1+ loop_e))
    (setq gap_e
	   (+ (* g_pi (* (- (/ loop_e 2.0) (/ loop_e 2)) 2))
	      (* h_pi (* (- (/ (+ loop_e 1) 2.0) (/ (+ loop_e 1) 2)) 2))
	   )
    )
    (setq origin_y (+ origin_y (+ gap_e e_pi)))
    (setq origin_x (- glass_x (/ ftotal_pi 2)))
  )
  (command "mirror" "all" "" '(0 0) '(0 100) "Y")
  (command "pline" (list -114.3 99.9) "w" 0 0 
                         (list 114.3 99.9) 
                         (list 114.3 98.9) 
                         (list -114.3 98.9) 
                         "c"
         )
        (command "pline" (list -114.3 133.4) "w" 0 0 
                         (list 114.3 133.4) 
                         (list 114.3 132.4) 
                         (list -114.3 132.4) 
                         "c"
         )
        (command "pline" (list -114.3 135.4) "w" 0 0 
                         (list 114.3 135.4) 
                         (list 114.3 134.4) 
                         (list -114.3 134.4) 
                         "c"
         )
        (command "pline" (list -114.3 137.4) "w" 0 0 
                         (list 114.3 137.4) 
                         (list 114.3 136.4) 
                         (list -114.3 136.4) 
                         "c"
         )
        (command "pline" (list -114.3 139.4) "w" 0 0 
                         (list 114.3 139.4) 
                         (list 114.3 138.4) 
                         (list -114.3 138.4) 
                         "c"
         )
        (command "pline" (list -114.3 141.4) "w" 0 0 
                         (list 114.3 141.4) 
                         (list 114.3 140.4) 
                         (list -114.3 140.4) 
                         "c"
         )
        (command "pline" (list -114.3 143.4) "w" 0 0 
                         (list 114.3 143.4) 
                         (list 114.3 142.4) 
                         (list -114.3 142.4) 
                         "c"
         )
        (command "pline" (list 110.6 -97.9) "w" 0 0 
                         (list 2.1 -97.9) 
                         (list 2.1 -89.9) 
                         (list 102.6 -89.9) 
                         (list 102.6 -2.0) 
                         (list 110.6 -2.0) 
                         "c"
         )
        (command "pline" (list 110.6 97.9) "w" 0 0 
                         (list 2.1 97.9) 
                         (list 2.1 89.9) 
                         (list 102.6 89.9) 
                         (list 102.6 2.0) 
                         (list 110.6 2.0) 
                         "c"
         )
        (command "pline" (list -110.6 -97.9) "w" 0 0 
                         (list -2.1 -97.9) 
                         (list -2.1 -89.9) 
                         (list -102.6 -89.9) 
                         (list -102.6 -2.0) 
                         (list -110.6 -2.0) 
                         "c"
         )
        (command "pline" (list -110.6 97.9) "w" 0 0 
                         (list -2.1 97.9) 
                         (list -2.1 89.9) 
                         (list -102.6 89.9) 
                         (list -102.6 2.0) 
                         (list -110.6 2.0) 
                         "c"
         )
        (command "pline" (list 118.3 -180.6) "w" 0 0 
                         (list 106.3 -180.6) 
                         (list 106.3 -178.6) 
                         (list 116.3 -178.6) 
                         (list 116.3 -168.6) 
                         (list 118.3 -168.6) 
                         "c"
         )
        (command "pline" (list 118.3 148.4) "w" 0 0 
                         (list 106.3 148.4) 
                         (list 106.3 146.4) 
                         (list 116.3 146.4) 
                         (list 116.3 136.4) 
                         (list 118.3 136.4) 
                         "c"
         )
        (command "pline" (list -118.3 -180.6) "w" 0 0 
                         (list -106.3 -180.6) 
                         (list -106.3 -178.6) 
                         (list -116.3 -178.6) 
                         (list -116.3 -168.6) 
                         (list -118.3 -168.6) 
                         "c"
         )
        (command "pline" (list -118.3 148.4) "w" 0 0 
                         (list -106.3 148.4) 
                         (list -106.3 146.4) 
                         (list -116.3 146.4) 
                         (list -116.3 136.4) 
                         (list -118.3 136.4) 
                         "c"
         )
  ;标识输入
  (command "-style" "txt" "txt" "5" "1.0" "" "y" "" "")
  (setq txt (strcase (getstring T "请输入产品型号和客户日期: ")))
  (setq txt (strcat txt " QINGYI " (itoa  (Fix (getvar "CDATE")))))
  (setq text (strcase txt))
  (command "text" (list 82.95 -156.158) 0 text)
  (terpri)
)
(prompt "\输入huatai运行程序")

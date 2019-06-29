					;(defun C:CELLS()
(defun C:HAIJING ()
          (alert    "请注意:程序做出来的最终图形与客户来的图纸上的图形以Y轴镜像的效果相同,
               F,I,J的值按图纸顺序输即可.");20070111与李菊凤确认过后加入此句话,
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
					;输入数据
  (setq e_input (getreal "Please input E: "))
  (setq g_input (getreal "Please input G: "))
  (setq h_input (getreal "Please input H: "))
  (setq en_pi (getint "Please input EN: "))
  (chk_total e_input g_input h_input en_pi "E")
  (setq f_input (getreal "Please input F: "))
  (setq i_input (getreal "Please input I: "))
  (setq j_input (getreal "Please input J: "))
  (setq fn_pi (getint "Please input FN: "))
  (chk_total f_input i_input j_input fn_pi "F")
  (setq r_input (getreal "Please input R: "))
					;设置系数
  (setq	ke1 0.982
	ce1 0.1
	kf1 0.0
	cf1 0.1
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
  )					;半径不能为0
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
      (prompt
	"\n程序不能处理一行或一列的情况，请将EN或FN改为3,然后将多余的删除!"
      )
      (exit)
    )
    (progn
      (cond ((and (= 0 (rem en_pi (fix (/ en_pi 2))))
		  (= 0 (rem fn_pi (fix (/ fn_pi 2))))
	     )				;en与fn都是偶数
	     (setq ftotal_pi (- (* (/ fn_pi 2) x_pitch) j_pi)
		   etotal_pi (- (* (/ en_pi 2) y_pitch) h_pi)
	     )
	    )
	    ((and (= 0 (rem en_pi (fix (/ en_pi 2))))
		  (= 1 (rem fn_pi (fix (/ fn_pi 2))))
	     )				;en是偶数，fn是奇数
	     (setq ftotal_pi (+ (* (/ fn_pi 2) x_pitch) f_pi)
		   etotal_pi (- (* (/ en_pi 2) y_pitch) h_pi)
	     )
	    )
	    ((and (= 1 (rem en_pi (fix (/ en_pi 2))))
		  (= 0 (rem fn_pi (fix (/ fn_pi 2))))
	     )				;fn是偶数，en是奇数
	     (setq ftotal_pi (- (* (/ fn_pi 2) x_pitch) j_pi)
		   etotal_pi (+ (* (/ en_pi 2) y_pitch) e_pi)
	     )
	    )
	    ((and (= 1 (rem en_pi (fix (/ en_pi 2))))
		  (= 1 (rem fn_pi (fix (/ fn_pi 2))))
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

  (command "pline"
	   (list -202.0 -232.0)
	   "w"
	   0
	   0
	   (list 202.0 -232.0)
	   (list 202.0 201.993)
	   (list 200.0 199.843)
	   (list 200.0 -230.0)
	   (list -200.0 -230.0)
	   (list -200.0 200.0)
	   (list 200.0 200.0)
	   (list 200.0 199.843)
	   (list 202.0 201.993)
	   (list 202.0 202.0)
	   (list -202.0 202.0)
	   "c"
  )
  (command "pline"
	   (list -185.0 162.3)
	   "w"
	   0
	   0
	   (list -180.3 162.3)
	   (list -180.3 167.0)
	   (list -179.7 167.0)
	   (list -179.7 162.3)
	   (list -175.0 162.3)
	   (list -175.0 161.7)
	   (list -179.7 161.7)
	   (list -179.7 157.0)
	   (list -180.3 157.0)
	   (list -180.3 161.7)
	   (list -185.0 161.7)
	   "c"
  )
  (command "pline"
	   (list 175.0 162.3)
	   "w"
	   0
	   0
	   (list 179.7 162.3)
	   (list 179.7 167.0)
	   (list 180.3 167.0)
	   (list 180.3 162.3)
	   (list 185.0 162.3)
	   (list 185.0 161.7)
	   (list 180.3 161.7)
	   (list 180.3 157.0)
	   (list 179.7 157.0)
	   (list 179.7 161.7)
	   (list 175.0 161.7)
	   "c"
  )
  (command "pline"
	   (list -180.3 -182.8)
	   "w"
	   0
	   0
	   (list -180.3 -172.8)
	   (list -179.7 -172.8)
	   (list -179.7 -182.8)
	   "c"
  )
  (command "pline"
	   (list 179.7 -182.8)
	   "w"
	   0
	   0
	   (list 179.7 -172.8)
	   (list 180.3 -172.8)
	   (list 180.3 -182.8)
	   "c"
  )
  (command "pline"
	   (list -177.5 181.95)
	   "w"
	   0
	   0
	   (list 177.5 181.95)
	   (list 177.5 182.05)
	   (list -177.5 182.05)
	   "c"
  )
  (command "pline"
	   (list -177.5 198.891)
	   "w"
	   0
	   0
	   (list 177.5 198.891)
	   (list 177.5 198.991)
	   (list -177.5 198.991)
	   "c"
  )
  (command "pline"
	   (list -177.5 197.832)
	   "w"
	   0
	   0
	   (list 177.5 197.832)
	   (list 177.5 197.932)
	   (list -177.5 197.932)
	   "c"
  )
  (command "pline"
	   (list -177.5 196.774)
	   "w"
	   0
	   0
	   (list 177.5 196.774)
	   (list 177.5 196.874)
	   (list -177.5 196.874)
	   "c"
  )
  (command "pline"
	   (list -177.5 195.715)
	   "w"
	   0
	   0
	   (list 177.5 195.715)
	   (list 177.5 195.815)
	   (list -177.5 195.815)
	   "c"
  )
  (command "pline"
	   (list -177.5 192.538)
	   "w"
	   0
	   0
	   (list 177.5 192.538)
	   (list 177.5 192.638)
	   (list -177.5 192.638)
	   "c"
  )
  (command "pline"
	   (list -177.5 191.479)
	   "w"
	   0
	   0
	   (list 177.5 191.479)
	   (list 177.5 191.579)
	   (list -177.5 191.579)
	   "c"
  )
  (command "pline"
	   (list -177.5 193.597)
	   "w"
	   0
	   0
	   (list 177.5 193.597)
	   (list 177.5 193.697)
	   (list -177.5 193.697)
	   "c"
  )
  (command "pline"
	   (list -177.5 194.656)
	   "w"
	   0
	   0
	   (list 177.5 194.656)
	   (list 177.5 194.756)
	   (list -177.5 194.756)
	   "c"
  )
  (command "pline"
	   (list -177.5 185.126)
	   "w"
	   0
	   0
	   (list 177.5 185.126)
	   (list 177.5 185.226)
	   (list -177.5 185.226)
	   "c"
  )
  (command "pline"
	   (list -177.5 183.009)
	   "w"
	   0
	   0
	   (list 177.5 183.009)
	   (list 177.5 183.109)
	   (list -177.5 183.109)
	   "c"
  )
  (command "pline"
	   (list -177.5 184.068)
	   "w"
	   0
	   0
	   (list 177.5 184.068)
	   (list 177.5 184.168)
	   (list -177.5 184.168)
	   "c"
  )
  (command "pline"
	   (list -177.5 186.185)
	   "w"
	   0
	   0
	   (list 177.5 186.185)
	   (list 177.5 186.285)
	   (list -177.5 186.285)
	   "c"
  )
  (command "pline"
	   (list -177.5 187.244)
	   "w"
	   0
	   0
	   (list 177.5 187.244)
	   (list 177.5 187.344)
	   (list -177.5 187.344)
	   "c"
  )
  (command "pline"
	   (list -177.5 188.303)
	   "w"
	   0
	   0
	   (list 177.5 188.303)
	   (list 177.5 188.403)
	   (list -177.5 188.403)
	   "c"
  )
  (command "pline"
	   (list -177.5 189.362)
	   "w"
	   0
	   0
	   (list 177.5 189.362)
	   (list 177.5 189.462)
	   (list -177.5 189.462)
	   "c"
  )
  (command "pline"
	   (list -177.5 190.421)
	   "w"
	   0
	   0
	   (list 177.5 190.421)
	   (list 177.5 190.521)
	   (list -177.5 190.521)
	   "c"
  )
  (prompt "\n 请选中程序做好的左下角和右上角的单粒 ")
  (setq ss (ssget))
  (setq num (sslength ss))
  (setq count 0)
  (setq max_x 0.0)
  (setq max_y 0.0)
  (setq min_x 0.0)
  (setq min_y 0.0)
  (vl-load-com)
  (while (< count num)
    (setq pl_name (ssname ss count))
    (setq ent_obj (vlax-ename->vla-object pl_name))
    (vla-getboundingbox ent_obj 'ld 'rd)
    (setq ld (vlax-safearray->list ld))
    (setq rd (vlax-safearray->list rd))
    (setq max_x (max (car rd) max_x))
    (setq max_y (max (cadr rd) max_y))
    (setq min_x (min (car ld) min_x))
    (setq min_y (min (cadr ld) min_y))
    (setq count (1+ count))
  )
  (vlax-release-object ent_obj)
  (setq ud_input (getreal "上下两个DUMMY距单粒的距离:"))
  (setq w_input (getreal "DUMMY的宽度:"))
;;;  画出上下两个DUMMY
  (setq ud_hj (getstring "上下两个DUMMY是否分段? Y/N(N)"))
  (if (/= (strcase ud_hj) "N")
    (progn
;;;  画出分成两段时的上下两个DUMMY
      (command "rectang"
	       (list min_x (+ max_y ud_input))
	       (list -10.0 (+ (+ max_y ud_input) w_input))
      )
      (command "rectang"
	       (list 10.0 (+ max_y ud_input))
	       (list max_x (+ (+ max_y ud_input) w_input))
      )
      (command "rectang"
	       (list min_x (- (- min_y ud_input) w_input))
	       (list -10.0 (- min_y ud_input))
      )
      (command "rectang"
	       (list 10.0 (- (- min_y ud_input) w_input))
	       (list max_x (- min_y ud_input))
      )
    )
;;;  画出不分段时的上下两个DUMMY 
    (progn
      (command "rectang"
	       (list min_x (+ max_y ud_input))
	       (list max_x (+ (+ max_y ud_input) w_input))
      )
      (command "rectang"
	       (list min_x (- (- min_y ud_input) w_input))
	       (list max_x (- min_y ud_input))
      )
    )
  )
;;;  画出左右两个DUMMY
  (setq lr_input (getreal "左右两个DUMMY距单粒的距离:"))
  (setq d_hj (getstring "DUMMY是否与单粒长度相等? Y/N(Y)"))
  (if (/= (strcase d_hj) "Y")
    (progn
      (setq dis (getreal "如果不相等请输入DUMMY上边距十字加号的距离:"))
      (setq lr1_hj (getstring "左右两个DUMMY是否分段? Y/N(N)"))
      (if (/= (strcase lr1_hj) "N")
;;;  画出长度不等时分成两段时的左右两个DUMMY
	(progn
	  (command "rectang"
		   (list (- (- min_x lr_input) w_input) min_y)
		   (list (- min_x lr_input) -10.0)
	  )
	  (command "rectang"
		   (list (- min_x lr_input) 10.0)
		   (list (- (- min_x lr_input) w_input) (- 157.0 dis))
	  )
	  (command "rectang"
		   (list (+ max_x lr_input) min_y)
		   (list (+ (+ max_x lr_input) w_input) -10.0)
	  )
	  (command
	    "rectang"
	    (list (+ max_x lr_input) 10.0)
	    (list (+ (+ max_x lr_input) w_input) (- 157.0 dis))
	  )
	)
;;;  画出长度不等时不分段时的左右两个DUMMY
	(progn
	  (command "rectang"
		   (list (- (- min_x lr_input) w_input) min_y)
		   (list (- min_x lr_input) (- 157.0 dis))
	  )
	  (command "rectang"
		   (list (+ max_x lr_input) min_y)
		   (list (+ (+ max_x lr_input) w_input) (- 157.0 dis))
	  )
	)
      )
    )
    (progn
      (setq lr2_hj (getstring "左右两个DUMMY是否分段? Y/N(N)"))
;;;  画出长度相等时分成两段时的左右两个DUMMY  
      (if (/= (strcase lr2_hj) "N")
	(progn
	  (command "rectang"
		   (list (- (- min_x lr_input) w_input) min_y)
		   (list (- min_x lr_input) -10.0)
	  )
	  (command "rectang"
		   (list (- (- min_x lr_input) w_input) 10.0)
		   (list (- min_x lr_input) max_y)
	  )
	  (command "rectang"
		   (list (+ max_x lr_input) min_y)
		   (list (+ (+ max_x lr_input) w_input) -10.0)
	  )
	  (command "rectang"
		   (list (+ max_x lr_input) 10.0)
		   (list (+ (+ max_x lr_input) w_input) max_y)
	  )
	)
;;;  画出长度相等时不分段时的左右两个DUMMY  
	(progn
	  (command "rectang"
		   (list (- (- min_x lr_input) w_input) min_y)
		   (list (- min_x lr_input) max_y)
	  )
	  (command "rectang"
		   (list (+ max_x lr_input) min_y)
		   (list (+ (+ max_x lr_input) w_input) max_y)
	  )
	)
      )
    )
  )
					;标识输入
  (command "-style" "txt" "txt" "10" "1.0" "" "y" "" "")
  (setq txt (strcase (getstring T "请输入产品型号与版号(如果有版号的话): ")))
  (setq txt (strcat txt " QINGYI"))
  (setq text (strcase txt))
  (command "text" (list 129.75 -209.5) 0 text)
  (terpri)
(getstring (strcat "请确认系数是：Ke="
	         (rtos ke1) "; Ce=" (rtos ce1) "; Cf=" (rtos  cf1) )
      )
  )

      
      
      
(prompt "\输入HAIJING运行程序")

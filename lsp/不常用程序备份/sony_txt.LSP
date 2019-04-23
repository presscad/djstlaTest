

(defun mirr_x_y (txt_m  ss  txt_p_x  txt_p_y / )

  (setvar "mirrtext" 1)
  
  (if (equal (strcase txt_m) "Y")
    (command "mirror"
	     ss
	     ""
	     (list txt_p_x txt_p_y)
	     (list txt_p_x (+ txt_p_y 1))
	     "y"
    )
  )
  
  (if (= (strcase txt_m) "X")
    (command "mirror"
	     ss
	     ""
	     (list txt_p_x txt_p_y)
	     (list (+ txt_p_x 1) txt_p_y)
	     "y"
    )
  )

  (if(equal txt_m nil)
     ;(setq a 1)
     (prompt"不镜像")
    )
  
)



(defun txt1 (txt_s txt_h txt_r txt_m ss txt_p_x txt_p_y / txt_s_back)
   (setq txt_s_back txt_s)
   (setq txt_s (strcat "0" (itoa txt_s)))
   (command "text"
            "j"
	    "m"
	    (list txt_p_x txt_p_y)
	    txt_h
	    txt_r
	    txt_s
	    ""
   )
   (setq ss (entlast))
   (mirr_x_y txt_m ss txt_p_x txt_p_y)    
   (setq txt_s txt_s_back)		;(setq txt_s ( + txt_s 1))
					;(setq txt_p_y (+ txt_d txt_p_y))
)


(defun c:sn (/ txt_h txt_r txt_m txt_s txt_n txt_d txt_p txt_p_x txt_p_y)
  (setq txt_h (getreal "\n请输入字高："))
  (setq txt_r (getint "请输入文字要旋转的度数/<Enter>："))
  (if(equal txt_r nil)
     (setq txt_r 0)
    )
  
  (setq txt_m (getstring "请输入文字要以什么为轴镜像(X/Y)/<Enter>:"))
  (setq txt_s (getint "请输入此列文字起始数字："))
  (setq txt_n (getint "请输入此列要排文字的个数："))
  (setq txt_d (getreal "请输入排版步距："))
  (setvar "osmode" 2)
  (setq txt_p (getpoint "点击方框相对应的点："))
  (setvar "osmode" 0)
  (setq txt_p_x (car txt_p))
  (setq txt_p_y (cadr txt_p))
  (setq txt_t (+ txt_s txt_n))
  (while (< txt_s txt_t)

     (if(or (equal txt_s 1)
	    (equal txt_s 2)
	    (equal txt_s 3)
	    (equal txt_s 4)
	    (equal txt_s 5)
	    (equal txt_s 6)
	    (equal txt_s 7)
	    (equal txt_s 8)
	    (equal txt_s 9)
	)
      (txt1 txt_s txt_h txt_r txt_m ss txt_p_x txt_p_y)
      (progn
	(command "text"
		 "j"
		 "m"
		 (list txt_p_x txt_p_y)
		 txt_h
		 txt_r
		 txt_s
		 ""
	)
	(setq ss (entlast))
	(mirr_x_y txt_m ss  txt_p_x  txt_p_y)
      )
    )

    (setq txt_s (+ txt_s 1))
    (setq txt_p_y (+ txt_d txt_p_y))
  )
)



;;;;;;;;;;;;;;;;;;;;;;;;;;
(prompt " \n 请输入SN执行程序!")
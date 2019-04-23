					;get 识别C,并让它来调用mac和mas且返回了rotate的度数
					;mac 返回让C变正的角度
					;mas 在C变正后由它来区分是否沿X轴MIRROR
(defun get (/ sc sc_len sc_ent sc_n ang_c)
  (setq sc (ssget))
  ;(setq sc_len (sslength sc))
  (setq ang_c nil)
  (setq sc_ent (entget (ssname sc 0)))
  (setq sc_ent_ba sc_ent)
  (setq c_is t)
  (while (and c_is sc_ent)
    (setq sc_n (assoc 42 sc_ent))
    (if	(or (= (cdr sc_n) 1) (= (cdr sc_n) -1))
      (progn
	(setq ang_c (mac sc_ent_ba))	;c的角度
	(setq c_is nil)
      )
      (setq sc_ent (cdr (member sc_n sc_ent)))
    )
  )
  (if ang_c
    (mas (entget (ssname sc 1)) ang_c)
    (progn
      (setq ang_c (mac (entget (ssname sc 1))))
      (mas sc_ent_ba ang_c)
    )
  )
  (setq ang_c ang_c)
)					;识别C,并让它来调用mac和mas且返回了rotate的度数

(defun mac (txt_c / c_fi xmax xmin ymax ymin dt ang)
  (setq c_fi (assoc 10 txt_c))
  (setq xmax (cadr c_fi))
  (setq xmin (cadr c_fi))
  (setq ymax (caddr c_fi))
  (setq ymin (caddr c_fi))
  (setq dt (cdr c_fi))			;dt存放所有组码为10的x,y值
  (while txt_c
    (setq txt_c (cdr (member c_fi txt_c)))
    (setq c_fi (assoc 10 txt_c))
    (if	c_fi
      (progn
	(setq xmax (max (cadr c_fi) xmax))
	(setq xmin (min (cadr c_fi) xmin))
	(setq ymax (max (caddr c_fi) ymax))
	(setq ymin (min (caddr c_fi) ymin))
	(setq dt (append (cdr c_fi) dt))
      )
    )
  )
  (if (> (abs (- xmax xmin))
	 (abs (- ymax ymin))
      )
    (if	(and (< (sequ xmin dt) 3) (= (sequ xmax dt) 4))
      (setq ang 0)
      (setq ang 180)
    )
    (progn
      (setq dt (cdr dt))
      (if (and (< (sequ ymin dt) 3) (= (sequ ymax dt) 4))
	(setq ang -90)
	(setq ang 90)
      )
    )
  )
  (setq ang ang)
)					;返回rotate的角度是由C开口的方向确定,开口方向又是由4,与2的次数和值大小

(defun sequ (xy_n s_dt / xy_men)
  (setq n 0)
  (while s_dt
    (setq xy_mem (car s_dt))
    (if	(equal xy_mem xy_n 0.00001)
      (setq n (+ n 1))
    )
    (setq s_dt (cdr (cdr s_dt)))
  )
  (setq n n)
)					;得xy_n在s_dt出现的次数,其中n 是存放次数的全居变量

(defun mas (txt_s ang_s / xmax xmin ymax ymin c_fi txt_s_ba dt txt_42)
  (setq c_fi (assoc 10 txt_s))
  (setq xmax (cadr c_fi))
  (setq xmin (cadr c_fi))
  (setq ymax (caddr c_fi))
  (setq ymin (caddr c_fi))
  (setq dt (cdr c_fi))
  (setq txt_s_ba txt_s)
  (while txt_s
    (setq txt_s (cdr (member c_fi txt_s)))
    (setq c_fi (assoc 10 txt_s))
    (if	c_fi
      (progn
	(setq xmax (max (cadr c_fi) xmax))
	(setq xmin (min (cadr c_fi) xmin))
	(setq ymax (max (caddr c_fi) ymax))
	(setq ymin (min (caddr c_fi) ymin))
	(setq dt (append (cdr c_fi) dt))
      )
    )
  )
  (if (= ang_s 90)
    (progn
      (setq dt (reverse dt))
      (setq xmin (cadr (member ymax dt)))
      (setq xmin (list 10 xmin ymax))
    )
  )
  (if (= ang_s -90)
    (progn
      (setq dt (reverse dt))
      (setq xmin (cadr (member ymin dt)))
      (setq xmin (list 10 xmin ymin))
    )
  )
  (if (= ang_s 180)
    (progn
      (setq xmin xmax)
      (setq xmin (cadr (member xmax dt)))
      (setq xmin (list 10 xmax xmin))
    )
  )
  (if (= ang_s 0)
    (setq xmin (list 10 xmin (cadr (member xmin dt))))
  )					;这一部份主要是求在C变正后XMIN所对应的点
					;下面一部份是找XMIN所对应点后的组码值为42的且它的值不为0
					;然后再识别它是否要MIRROR
  (setq txt_s txt_s_ba)
  (setq txt_s (cdr (member xmin txt_s)))
  (setq txt_42 (cdr (assoc 42 txt_s)))
  (while (= txt_42 0)
    (setq txt_s (cdr txt_s))
    (setq txt_42 (cdr (assoc 42 txt_s)))
  )
  (if (> txt_42 0)
    (setq txt_m 0)
  )
  (if (< txt_42 0)
    (setq txt_m "X")
  )
)					;得txt_m 值(全局变量)(通过他可知它是否沿X轴MIRROR
					;mirr_x函数用来MIRROR文字,沿X轴

(defun mirr_x (ss txt_p_x txt_p_y)
  (command "mirror"
	   ss
	   ""
	   (list txt_p_x txt_p_y)
	   (list (+ txt_p_x 1) txt_p_y)
	   "y"
  )
)

(defun c:sn_num (/ txt_h txt_r txt_m txt_s txt_n txt_d txt_p txt_p_x txt_p_y
	     txt)
  
  ;(setq txt_s (getint "请输入文字起始数字："))
  (setq txt_s 1)
  (setq txt_h (getreal"请输入字高:"))
  (setq txt_r (getint "请输入一列要排文字的个数："))
  (setq txt_c (getint "请输入要排的列数："))
  (setq txt_d (getreal "请输入排版步距："))
  (setvar "mirrtext" 1)
  (repeat txt_c
    (prompt "请选择SC")
    (setq ang_sc (get))
    (setq ang_sc
	   (cond ((= ang_sc 90) -90)
		 ((= ang_sc -90) 90)
		 ((= ang_sc 180) 180)
		 (t 0)
	   )
    )					;这里的角度要反过来,因为我求的是让SC变正的角度
    (setvar "osmode" 2)
    (setq txt_p (getpoint "点击方框相对应的点："))
    (setvar "osmode" 0)
    (setq txt_p_x (car txt_p))
    (setq txt_p_y (cadr txt_p))
    (repeat txt_r
      (if (<= txt_s 9)
	(setq txt (strcat "0" (itoa txt_s)))
	(setq txt (itoa txt_s))
      )
      (progn
	(command "text"
		 "j"
		 "m"
		 (list txt_p_x txt_p_y)
		 txt_h
		 0
		 txt
		 ""
	)
	(setq ss (entlast))
	(if (= txt_m "X")
	  (mirr_x ss txt_p_x txt_p_y)
	)				;在这里要注意先要MIRROR后再ROTATE,因为我在找角度和txt_m时是先R后在MI
	(if (/= ang_sc 0)
	   (command "rotate" ss "" (list txt_p_x txt_p_y) ang_sc)
	  ) 
	(setq txt_s (+ txt_s 1))
	(setq txt_p_y (+ txt_d txt_p_y))
      )
    )
  )
  (princ)
)



;;;;;;;;;;;;;;;;;;;;;;;;;;
(prompt " \n 请输入SN_NUM执行程序!")
(prompt " \n 请先将SC闭合!")
(prompt " \n 请只选择SC!")





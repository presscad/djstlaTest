(defun set_var()
  (setvar "orthomode" 0)
  (setvar "osmode" 0)
)

;=================================================================================

(defun shflpbk ()
  (command "pline"
	   (list -212.0000 270.2000)
	   "w"
	   0
	   0
	   (list -210.0000 270.2000)
	   (list -210.0000 278.2000)
	   (list 210.0000 278.2000)
	   (list 210.0000 270.2000)
	   (list 212.0000 270.2000)
	   (list 212.0000 280.2000)
	   (list -212.0000 280.2000)
	   (list -212.0000 270.2000)
	   "c"
  )
  (command "pline"
	   (list -212.0000 -253.8000)
	   "w"
	   0
	   0
	   (list -212.0000 -263.8000)
	   (list 212.0000 -263.8000)
	   (list 212.0000 -253.8000)
	   (list 210.0000 -253.8000)
	   (list 210.0000 -261.8000)
	   (list -210.0000 -261.8000)
	   (list -210.0000 -253.8000)
	   (list -212.0000 -253.8000)
	   (list -212.0000 -253.8000)
	   "c"
  )
  (command "pline"
	   (list -212.0000 228.2000)
	   "w"
	   0
	   0
	   (list -210.0000 228.2000)
	   (list -210.0000 -216.8000)
	   (list -212.0000 -216.8000)
	   (list -212.0000 228.2000)
	   "c"
  )
  (command "pline"
	   (list 210.0000 228.2000)
	   "w"
	   0
	   0
	   (list 212.0000 228.2000)
	   (list 212.0000 -216.8000)
	   (list 210.0000 -216.8000)
	   (list 210.0000 228.2000)
	   "c"
  )
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun scale_y (layer_name ke)
  (command "zoom" "E")
  (setq
    ss_lwpl (ssget "x"
		   (list (cons 0 "lwpolyline") (cons 8 layer_name))
	    )
  )
  (if ss_lwpl
    (progn
      (setq ss_cnt (sslength ss_lwpl))
      (setq i_loop 0)
      (while (< i_loop ss_cnt)
	(setq pl_dt (entget (ssname ss_lwpl i_loop)))
	(setq dt nil)
	(while pl_dt
	  (if (/= (caar pl_dt) 10)
	    (setq dt (append dt (list (car pl_dt))))
	    (progn
	      (setq scl_x (cadar pl_dt))
	      (setq scl_y (* (caddar pl_dt) ke))
	      (setq
		dt (append dt (list (cons 10 (list scl_x scl_y 0))))
	      )
	    )
	  )
	  (setq pl_dt (cdr pl_dt))
	)
	(entmod dt)
	(setq i_loop (1+ i_loop))
      )
    )
  )
  (command "zoom" "e")
  (setq
      ss_lwp2 (ssget "x"
		     (list (cons -4 "<or")
		           (cons 0 "CIRCLE")
			   (cons 0 "arc")
			   (cons -4 "or>")
			   (cons 8 "scl")
			   )
	      )
    )
	(if	ss_lwpl
        (progn
	(setq ss_cnt (sslength ss_lwp2))
	(setq i_loop 0)
	(while (< i_loop ss_cnt)
	  (setq pl_dt (entget (ssname ss_lwp2 i_loop)))
	  (setq center (cdr (assoc 10 pl_dt)))
	  (setq center (list (* 1.0 (car center)) (* ke (cadr center))))	  
	  (setq pl_dt (subst (cons 10 center) (assoc 10 pl_dt) pl_dt))
	  (entmod pl_dt)
	  (setq i_loop (1+ i_loop))
	)
      )
    )
    (command "zoom" "E")
)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun scale_x ( ke)
  (command "zoom" "E")
  (setq
    ss_lwpl (ssget "x"
		   (list (cons 0 "lwpolyline") (cons 8 "0"))
	    )
  )
  (if ss_lwpl
    (progn
      (setq ss_cnt (sslength ss_lwpl))
      (setq i_loop 0)
      (while (< i_loop ss_cnt)
	(setq pl_dt (entget (ssname ss_lwpl i_loop)))
	(setq dt nil)
	(while pl_dt
	  (if (/= (caar pl_dt) 10)
	    (setq dt (append dt (list (car pl_dt))))
	    (progn
	      (setq scl_x (* (cadar pl_dt) kf))
	      (setq scl_y (caddar pl_dt))
	      (setq
		dt (append dt (list (cons 10 (list scl_x scl_y 0))))
	      )
	    )
	  )
	  (setq pl_dt (cdr pl_dt))
	)
	(entmod dt)
	(setq i_loop (1+ i_loop))
      )
    )
  )
  (command "zoom" "e")
  (setq
      ss_lwp2 (ssget "x"
		     (list (cons -4 "<or")
		           (cons 0 "CIRCLE")
			   (cons 0 "arc")
			   (cons -4 "or>")
			   (cons 8 "0")
			   )
	      )
    )
	(if	ss_lwpl
        (progn
	(setq ss_cnt (sslength ss_lwp2))
	(setq i_loop 0)
	(while (< i_loop ss_cnt)
	  (setq pl_dt (entget (ssname ss_lwp2 i_loop)))
	  (setq center (cdr (assoc 10 pl_dt)))
	  (setq center (list (* kf (car center)) (* 1.0 (cadr center))))	  
	  (setq pl_dt (subst (cons 10 center) (assoc 10 pl_dt) pl_dt))
	  (entmod pl_dt)
	  (setq i_loop (1+ i_loop))
	)
      )
    )
    (command "zoom" "E")  
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun flpedit(/ a b c cell ke kf text_model sys_data pt1 pt2 ss_all )
   (set_var)
   ;(command "change" cell ""  "p"   "la" "0" "" )
   (command "zoom" "all" "")
   (setq a (list 0 0))
   (setq b (list 0 -15.0))
   (setq c (list -7 -60.0)) 
   (command "mirror" "all" "" a b   "y" "")
   (command "layer" "m" "scl" "" )
   (prompt "\请选中要收缩的图形")
   (setq cell(ssget))
   (command "change" cell ""  "p"   "la" "scl" "" )
   (setq ke 0.98762)
   (setq kf 1.0002)
   (scale_y "scl" ke)
   (prompt "\ 请选中APR的MODEL号:")
   (setq text_model(ssget))
   (command "zoom" "all" "")
   (command "change" text_model ""  "p"   "la" "scl" "" )
   (command "move" text_model "" a c )
   (setq sys_data (strcat "QINGYI" (itoa(fix(getvar "cdate")))))
   (entmake (list (cons 0 "text")
		  (cons 1 sys_data)
		  (cons 10 (list 200.8 155.0))
		  (cons 40 3.8)
		  (cons 50 (* (/ 90 180.0) pi))
		  (cons 8 "scl")
		  )
	    )
  (setq pt1(list 209.0 -216.7000))
  (setq pt2(list -209.0 228.1995))
  (setq ss_all(ssget "w" pt2 pt1))
  (command "change" ss_all "" "p" "la" "scl" "" )
  (command "layer" "lo" "scl" "")
  (command "erase" "all" "")
  (command "layer" "u" "scl" "")
  (shflpbk)
  (command "change" "all" "" "p" "la" "0" "c" "7" "" )
  (scale_x  kf)
  (command "layer" "s"  "0" "")
  (command "purge" "all" "" "n")
  (command "-units" "2" "6" "" "" "" "")
  (alert (strcat "2005-04-25 <TANGWEI>
   请自已处理cut!!!!!!!!!!
   请确认系数是：
   Ke="(rtos ke) "; kf= "(rtos kf)))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun c:flp()
  (alert "\         请先endchk处理ok\n
         请注意原图中心应在0,0点,\n
         如不在,请以dummy对角中心点移到0,0点:\n
         否则会结果不正确:")
  (flpedit)
  )

;1:20051208在选择MODEL号后加了一句全图最大化显示命令,解决"-"丢失了的问题.
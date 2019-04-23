(defun njhrgu () 
        (command "pline" (list -228.2 -212.0) "w" 0 0 
                         (list 216.8 -212.0) 
                         (list 216.8 -210.0) 
                         (list -228.2 -210.0) 
                         "c"
         )
        (command "pline" (list -228.2 212.0) "w" 0 0 
                         (list 216.8 212.0) 
                         (list 216.8 210.0) 
                         (list -228.2 210.0) 
                         "c"
         )
        (command "pline" (list -278.2 -210.0) "w" 0 0 
                         (list -278.2 210.0) 
                         (list -264.2 210.0) 
                         (list -264.2 212.0) 
                         (list -280.2 212.0) 
                         (list -280.2 -212.0) 
                         (list -264.2 -212.0) 
                         (list -264.2 -210.0) 
                         "c"
         )
        (command "pline" (list -200.2 -200.25) "w" 0 0 
                         (list -200.2 -199.75) 
                         (list -209.95 -199.75) 
                         (list -209.95 -192.5) 
                         (list -210.45 -192.5) 
                         (list -210.45 -199.75) 
                         (list -215.2 -199.75) 
                         (list -215.2 -200.25) 
                         (list -210.45 -200.25) 
                         (list -210.45 -207.5) 
                         (list -209.95 -207.5) 
                         (list -209.95 -200.25) 
                         "c"
         )
        (command "pline" (list -210.45 192.5) "w" 0 0 
                         (list -209.95 192.5) 
                         (list -209.95 199.75) 
                         (list -200.2 199.75) 
                         (list -200.2 200.25) 
                         (list -209.95 200.25) 
                         (list -209.95 207.5) 
                         (list -210.45 207.5) 
                         (list -210.45 200.25) 
                         (list -215.2 200.25) 
                         (list -215.2 199.75) 
                         (list -210.45 199.75) 
                         "c"
         )
        (command "pline" (list 247.8 -212.0) "w" 0 0 
                         (list 263.8 -212.0) 
                         (list 263.8 212.0) 
                         (list 247.8 212.0) 
                         (list 247.8 210.0) 
                         (list 261.8 210.0) 
                         (list 261.8 -210.0) 
                         (list 247.8 -210.0) 
                         "c"
         )
        (command "pline" (list 206.8 -199.75) "w" 0 0 
                         (list 216.8 -199.75) 
                         (list 216.8 -200.25) 
                         (list 206.8 -200.25) 
                         "c"
         )
        (command "pline" (list 216.8 200.25) "w" 0 0 
                         (list 216.8 199.75) 
                         (list 206.8 199.75) 
                         (list 206.8 200.25) 
                         "c"
         )
  )  ;液体版的边框数据                                       


  

(defun scale (layer_name ke / ss_lwpl ss_cnt i_loop pl_dt dt scl_x scl_y)
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
	      (setq scl_x (* (cadar pl_dt) ke))
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
  (command "zoom" "E")

)					;        defun scale(layer_name ke)                                                          




(defun ofst (layer_name cf1 ce1 / ss_lwpl i_loop ss_cnt pl_dt cx cy cnt dt ofst_x ofst_y)
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
	(setq cx 0)
	(setq cy 0)
	(setq cnt 0)
	(setq dt pl_dt)
	(while pl_dt
	  (if (= (caar pl_dt) 10)
	    (progn
	      (setq cx (+ (cadar pl_dt) cx))
	      (setq cy (+ (caddar pl_dt) cy))
	      (setq cnt (1+ cnt))
	    )
	  )
	  (setq pl_dt (cdr pl_dt))
	)
	(setq cx (/ cx cnt))
	(setq cy (/ cy cnt))
	(setq pl_dt dt)
	(setq dt nil)
	(while pl_dt
	  (if (/= (caar pl_dt) 10)
	    (setq dt (append dt (list (car pl_dt))))
	    (progn
	      (setq ofst_x (cadar pl_dt))
	      (setq ofst_y (caddar pl_dt))
	      (if (> ofst_x cx)
		(setq ofst_x (- ofst_x cf1))
		(setq ofst_x (+ ofst_x cf1))
	      )
	      (if (> ofst_y cy)
		(setq ofst_y (- ofst_y ce1))
		(setq ofst_y (+ ofst_y ce1))
	      )
	      (setq dt
		     (append dt (list (cons 10 (list ofst_x ofst_y 0))))
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
)					;      defun ofst (layer_name cf1 ce1)


(defun c:huari (/ apr_ld_cn xc	yc ss sc ke ce1	cf1 cells ss_txt txt_dt	apr_di c_date ssDim)
  (setq ke (getreal " 请输入KE的值:"))
  (setq ce1 (getreal " 请输入CE的值:"))
  (setq cf1 (getreal " 请输入CF的值:"))
  (setvar "osmode" 1)

  (setq ssDim(ssget"x"(list(cons 0 "dimension"))))
  (command "erase" ssDim "")
  
  (command "zoom" "w" '(-420 -365) '(-390 -346))
  (setq apr_ld_cn (getpoint "/n请点选凸版ITO的左下角"))

  (setvar "osmode" 0)
  (setq xc (+ (car apr_ld_cn) 203.2))
  (setq yc (+ (cadr apr_ld_cn) 177.8))
  (command "move" "all" "" (list xc yc) "0,0")
  (command "mirror" "all" "" "0,0" "0,9" "y")
  (command "layer" "on" "*" "thaw" "*" "unlock" "*" "")
  (command "layer" "lo" "0" "lo" "pi" "")
  (command "erase" "all" "")
  (command "layer" "unlock" "0" "")
  (command "layer" "unlock" "pi" "")
  (command "layer" "n" "ok" "")

  (command "zoom" "e")
  (setq ss (ssget "w" '(-235 -229) '(203 194)))
  (command "change" ss "" "p" "la" "ok" "")
  (command "layer" "lo" "ok" "")
  (command "layer" "m" "ok" "")
  (command "clear" "")
  (command "layer" "unlock" "ok" "")
  (command "layer" "n" "scl" "")
  (setq sc (ssget "w" '(-203.2 -177.8) '(203.2 177.8)))
  (command "change" sc "" "p" "la" "scl" "")

  (setq ce1 (* ce1 0.5))
  (setq cf1 (* cf1 0.5))


  (scale "scl" ke)
  (command "layer" "n" "ofst" "")

  (prompt "/n请选中所有单粒！")
  (setq cells (ssget))
  (command "change" cells "" "p" "la" "ofst" "")
  (ofst "ofst" ce1 cf1)
  (njhrgu)
  					;change text
  (setq ss_txt (ssget "x" (list (cons 0 "MTEXT"))))
  (COMMAND "EXPLODE" SS_TXT "")
  (setq ss_txt (ssget "x" (list (cons 0 "TEXT"))))
  (if (= (sslength ss_txt) 1)
    (progn
      (setq txt_dt (entget (ssname ss_txt 0)))
      (setq apr_id (cdr (assoc 1 txt_dt)))
      (setq c_date (getvar "CDATE"))
      (setq apr_id (strcat apr_id " QINGYI " (itoa (fix c_date))))
      (setq apr_id (strcase apr_id))
      (setq txt_dt (subst (cons 1 apr_id) (assoc 1 txt_dt) txt_dt))
      (setq txt_dt
	     (subst (cons 10 '(-500 -500 0)) (assoc 8 txt_dt) txt_dt)
      )
      (entmod txt_dt)
    )
  )
  (command "change" "all" "" "p" "la" "0" "")
  (command "layer" "lock" "0" "")
  (command "layer" "m" "0" "")
  (command "clear" "")
  (command "layer" "unlock" "0" "")
  (command "zoom" "e")


					;(getstring
					; (strcat "2004-10-24 writen by XifengCheng请确认系数是：Ke="
					;	    (rtos ke)
					;	    "; Ce="
					;	    (rtos (* 2 ce1))
					;	    "; Cf="
					;	    (rtos (* 2 cf1))
					;   )
					;
					; )
 
    (getstring
      (strcat "2004-10-24 writen by XifengCheng请确认系数是：Ke="
	      (rtos ke)
	      "; Ce="
	      (rtos (* 2 ce1))
	      "; Cf="
	      (rtos (* 2 cf1))
	      "---液体版---"
      )

    )
  )

(alert"切记：一定要先对右下角的“L”状图形做TOPL! 最好对有效图形先检查是否OK！")
(PROMPT "\n-----输入 huari 运行程序！注意查看报告文字!---")
(prompt "\n-----请对右下角的L状图形做TOPL------")

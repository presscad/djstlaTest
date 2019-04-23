;changed by cheng xifeng 20060922
(defun scale (layer_name ke)
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
	      (setq scl_x (*(cadar pl_dt)ke))
	      (setq scl_y  (caddar pl_dt))
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
)


(defun offset_two_dummy(ce1 cf1 / ss_lwpl ss_cnt i_loop pl_dt cx cy dt cnt ofst_x  ofst_y)			   
  ;offset inner dummy
      (command "zoom" "w" "-200,-220" "-120,-140")
      (prompt "\n请选dummy内框")
      (setq ss_lwpl (ssget))
           
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
		    (setq ofst_x (+ ofst_x cf1))
		    (setq ofst_x (- ofst_x cf1))
		  )
		  (if (> ofst_y cy)
		    (setq ofst_y (+ ofst_y ce1))
		    (setq ofst_y (- ofst_y ce1))
		  )
		  (setq	dt
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

   ;offset outside dummy
      (prompt "\n请选dummy外框")
      (setq ss_lwpl (ssget))
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
		  (setq	dt
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
  );peforming on the dummy 2006-03-30 owal



(defun c:shgd ()
  (command "convert" "all" "")
  (setq ke 0.9785)
  (setq kf 1.0004)
  (setq ce1 (/ 0.15 2.0))
  (setq cf1 (/ 0.15 2.0))
  (getstring (strcat "请确认系数是液体版ke=" (rtos ke) ";kf=" (rtos kf) "; Ce=" (rtos (* 2 ce1)) "; Cf=" (rtos (* 2 cf1))))
  (defun draw_edge () 
        (command "pline" (list -190.5 -203.774) "w" 0 0 
                         (list -189.5 -203.774) 
                         (list -189.5 -187.774) 
                         (list -190.5 -187.774) 
                         "c"
         )
        (command "pline" (list -197.5 195.276) "w" 0 0 
                         (list -190.5 195.276) 
                         (list -190.5 188.276) 
                         (list -189.5 188.276) 
                         (list -189.5 195.276) 
                         (list -182.5 195.276) 
                         (list -182.5 196.276) 
                         (list -189.5 196.276) 
                         (list -189.5 203.276) 
                         (list -190.5 203.276) 
                         (list -190.5 196.276) 
                         (list -197.5 196.276) 
                         "c"
         )
        (command "pline" (list -199.5 -203.424) "w" 0 0 
                         (list -197.5 -203.424) 
                         (list -197.5 210.776) 
                         (list -199.5 210.776) 
                         "c"
         )
        (command "pline" (list 189.5 -203.774) "w" 0 0 
                         (list 190.5 -203.774) 
                         (list 190.5 -187.774) 
                         (list 189.5 -187.774) 
                         "c"
         )
        (command "pline" (list 197.5 -278.224) "w" 0 0 
                         (list 197.5 -233.424) 
                         (list 199.5 -233.424) 
                         (list 199.5 -280.224) 
                         (list -199.5 -280.224) 
                         (list -199.5 -233.424) 
                         (list -197.5 -233.424) 
                         (list -197.5 -278.224) 
                         "c"
         )
        (command "pline" (list 197.5 196.276) "w" 0 0 
                         (list 190.5 196.276) 
                         (list 190.5 203.276) 
                         (list 189.5 203.276) 
                         (list 189.5 196.276) 
                         (list 182.5 196.276) 
                         (list 182.5 195.276) 
                         (list 189.5 195.276) 
                         (list 189.5 188.276) 
                         (list 190.5 188.276) 
                         (list 190.5 195.276) 
                         (list 197.5 195.276) 
                         "c"
         )
        (command "pline" (list -197.5 281.776) "w" 0 0 
                         (list -197.5 240.776) 
                         (list -199.5 240.776) 
                         (list -199.5 283.776) 
                         (list 199.5 283.776) 
                         (list 199.5 240.776) 
                         (list 197.5 240.776) 
                         (list 197.5 281.776) 
                         "c"
         )
        (command "pline" (list 197.5 210.776) "w" 0 0 
                         (list 199.5 210.776) 
                         (list 199.5 -203.424) 
                         (list 197.5 -203.424) 
                         "c"
         )
  )

  (defun get_dt_vl (item dt)
    (cdr (assoc item dt))
  )
  (command "zoom" "e")
  (command "layer" "m" "pi" "unlock" "*" "lock"	"pi" "lock" "glass" "")
  (command "erase" "all" "")
  (command "purge" "all" "" "n")
  (command "purge" "all" "" "n")
  (command "purge" "all" "" "n")
  (command "layer" "unlock" "*" "")
					; (setq line_ss (ssget "x" (list (cons 0 "line"))))
					;(setq lwpl_ss (ssget "x" (list (cons 0 "*polyline")(cons 70 0))))
					; (if (or line_ss lwpl_ss)
					;   (command "pljoin" "all" "0.005")
					;   )
  (setq ito_line (ssget "x" (list (cons 8 "glass"))))
  (if not
    ito_line
    exit
  )
  (if (= (sslength ito_line) 1)
    (progn
      (setq pl_dt (entget (ssname ito_line 0)))
      (while (/= (caar pl_dt) 10)
	(setq pl_dt (cdr pl_dt))
      )
      (setq min_x (car (get_dt_vl 10 pl_dt)))
      (setq min_y (cadr (get_dt_vl 10 pl_dt)))
      (setq max_x (car (get_dt_vl 10 pl_dt)))
      (setq max_y (cadr (get_dt_vl 10 pl_dt)))
      (setq pl_dt (cdr pl_dt))
      (while pl_dt
	(if (/= (caar pl_dt) 10)
	  (setq pl_dt (cdr pl_dt))
	  (progn
	    (setq min_x (min min_x (car (get_dt_vl 10 pl_dt))))
	    (setq min_y (min min_y (cadr (get_dt_vl 10 pl_dt))))
	    (setq max_x (max max_x (car (get_dt_vl 10 pl_dt))))
	    (setq max_y (max max_y (cadr (get_dt_vl 10 pl_dt))))
	    (setq pl_dt (cdr pl_dt))
	  )
	)
      )
      (setq mid_x (/ (+ min_x max_x) 2))
      (setq mid_y (/ (+ min_y max_y) 2))
      (command "move" "all" "" (list mid_x mid_y) "0,0")
      (command "zoom" "e")
      (command "zoom" "scale" "0.5X")
      (command "erase" "all" "r" "w" '(-204.3 -178.8) '(204.3 178.8) "")
      (command "rotate" "all" "" '(0 0) "-90")
      (command "layer" "lock" "glass" "")
      (command "zoom" "E")
      (setq layer_name "pi")
      (setq
	ss_lwpl
	 (ssget	"x"
		(list (cons 0 "lwpolyline") (cons 8 layer_name))
	 )
      )
      (setq ss_all (ssget "x"
			  (list (cons 8 layer_name))
		   )
      )
      (if (/= (sslength ss_lwpl) (sslength ss_all))
	(progn
	  (getstring "\n请对有用图形选做TOPL，然后再执！")
	  (exit)
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
		    dt
		     (append dt (list (cons 10 (list scl_x scl_y 0))))
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
      (setq
	ss_lwpl
	 (ssget "x" (list (cons 0 "circle") (cons 8 layer_name)))
      )
      (if ss_lwpl
	(progn
	  (setq ss_cnt (sslength ss_lwpl))
	  (setq i_loop 0)
	  (while (< i_loop ss_cnt)
	    (setq pl_dt (entget (ssname ss_lwpl i_loop)))
	    (setq cx (* (cadr (assoc 10 pl_dt)) ke))
	    (if	(or (< cx -192) (> cx 192))
	      (if (> cx 0)
		(setq cx (- cx 0.048))
		(setq cx (+ cx 0.048))
	      )
	      (progn
		(setq cr (cdr (assoc 40 pl_dt)))
		(setq
		  pl_dt
		   (subst (cons 40 (+ cr 0.115)) (cons 40 cr) pl_dt)
		)
	      )
	    )
	    (setq yx (caddr (assoc 10 pl_dt)))
	    (setq
	      dt
	       (subst (cons 10 (list cx yx 0)) (assoc 10 pl_dt) pl_dt)
	    )
	    (setq dt (subst (cons 8 "OK") (assoc 8 pl_dt) dt))
	    (entmake dt)
	    (setq i_loop (1+ i_loop))
	  )
	)
      )

      (command "change" "all" "" "p" "layer" "0" "")
      (prompt "\n请选中所有单粒")
      (setq cell_ss (ssget))
      (command "change" cell_ss "" "p" "la" "pi" "")
      (command "zoom" "E")
      (setq layer_name "pi")
      (setq
	ss_lwpl
	 (ssget	"x"
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
		  (setq	dt
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

      ;处理dummy
      (setq YesNo(getstring T "dummy是内外两个框吗?"))
      (if(or (equal YesNo "")(equal YesNo "y")(equal YesNo "Y"))
	 (offset_two_dummy ce1 cf1)
	 (repeat 3(alert"注意:dummy需要另外手工补偿!"))
	)

      (command "zoom" "all")
      (command "layer" "unlock" "*" "")
      (command "mirror" "all" "" '(0 0) '(100 0) "Y")
    )
  )
  (command "zoom" "all" )
  (draw_edge)
  (command "zoom" "scale" "0.5X")
  (setq input_text (getstring T "请输入标识ID:"))
  (setq c_date (itoa (fix (getvar "cdate"))))
  (setq input_text (strcat input_text " QINGYI " c_date))
  (setq txt_dt (list (cons 0 "text")(cons 1 input_text)(cons 40 7)(cons 10 '(-189 104 0))(cons 50 (* pi 1.5))))
  (entmake txt_dt)
  
  
  (command "layer" "lock" "glass" "off" "glass" "m" "0" "")
  (command "change" "all" "" "P" "la" "0" "")
  (command "purge" "All" "" "n")
  (scale "0" kf)  
)


(getstring "\n输入shgd运行,运行之前需要对Pi层与Glass层做topl,且必须ENDCHK确认!")
(getstring  "\n如果pi层不存在，请将放凸块的层改名为PI")
(getstring "\n请事先记住凸版的型号")
(getstring"\n-----------------------------------------")
(getstring"\n注意非印刷方向要整体收缩2004-06-01")
(command "convert""all""")
(getstring"\n----------已经对2D多义线进行转换了！")
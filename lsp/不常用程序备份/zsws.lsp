
(defun c:zsws ()
  (defun set_var ()
    (setq osnap_old (getvar "osmode"))
    (setq orthomode_old (getvar "orthomode"))
    (setvar "osmode" 0)
    (setvar "orthomode" 0)
    (list osnap_old orthomode_old)
  )
  (defun get_dt_vl (item dt)
    (cdr (assoc item dt))
  )
  
 (defun draw_edge () 
        (command "pline" (list 172.917 273.2) "w" 0 0 
                         (list 228.6 273.2) 
                         (list 228.6 -239.8) 
                         (list -228.6 -239.8) 
                         (list -228.6 273.2) 
                         (list 171.695 273.2) 
                         (list 171.676 275.2) 
                         (list -230.6 275.2) 
                         (list -230.6 -241.8) 
                         (list 230.6 -241.8) 
                         (list 230.6 275.2) 
                         (list 172.841 275.2) 
                         "c"
         )
        (command "pline" (list 210.3 -172.617) "w" 0 0 
                         (list 209.7 -172.617) 
                         (list 209.7 -201.217) 
                         (list 210.3 -201.217) 
                         "c"
         )
        (command "pline" (list -210.3 -172.617) "w" 0 0 
                         (list -209.7 -172.617) 
                         (list -209.7 -201.217) 
                         (list -210.3 -201.217) 
                         "c"
         )
        (command "pline" (list 223.6 -233.963) "w" 0 0 
                         (list 223.6 -233.763) 
                         (list -223.6 -233.763) 
                         (list -223.6 -233.963) 
                         "c"
         )
        (command "pline" (list 223.6 -231.963) "w" 0 0 
                         (list 223.6 -231.763) 
                         (list -223.6 -231.763) 
                         (list -223.6 -231.963) 
                         "c"
         )
        (command "pline" (list 223.6 -229.963) "w" 0 0 
                         (list 223.6 -229.763) 
                         (list -223.6 -229.763) 
                         (list -223.6 -229.963) 
                         "c"
         )
        (command "pline" (list 223.6 -235.963) "w" 0 0 
                         (list 223.6 -235.763) 
                         (list -223.6 -235.763) 
                         (list -223.6 -235.963) 
                         "c"
         )
        (command "pline" (list 223.6 -237.963) "w" 0 0 
                         (list 223.6 -237.763) 
                         (list -223.6 -237.763) 
                         (list -223.6 -237.963) 
                         "c"
         )
        (command "pline" (list 210.3 217.5) "w" 0 0 
                         (list 209.7 217.5) 
                         (list 209.7 203.5) 
                         (list 195.7 203.5) 
                         (list 195.7 202.9) 
                         (list 209.7 202.9) 
                         (list 209.7 188.9) 
                         (list 210.3 188.9) 
                         (list 210.3 202.9) 
                         (list 224.3 202.9) 
                         (list 224.3 203.5) 
                         (list 210.3 203.5) 
                         "c"
         )
        (command "pline" (list 223.6 250.2) "w" 0 0 
                         (list 223.6 250.0) 
                         (list -223.6 250.0) 
                         (list -223.6 250.2) 
                         "c"
         )
        (command "pline" (list 223.6 252.2) "w" 0 0 
                         (list 223.6 252.0) 
                         (list -223.6 252.0) 
                         (list -223.6 252.2) 
                         "c"
         )
        (command "pline" (list 223.6 254.2) "w" 0 0 
                         (list 223.6 254.0) 
                         (list -223.6 254.0) 
                         (list -223.6 254.2) 
                         "c"
         )
        (command "pline" (list 223.6 256.2) "w" 0 0 
                         (list 223.6 256.0) 
                         (list -223.6 256.0) 
                         (list -223.6 256.2) 
                         "c"
         )
        (command "pline" (list 223.6 258.2) "w" 0 0 
                         (list 223.6 258.0) 
                         (list -223.6 258.0) 
                         (list -223.6 258.2) 
                         "c"
         )
        (command "pline" (list 223.6 268.2) "w" 0 0 
                         (list 223.6 268.0) 
                         (list -223.6 268.0) 
                         (list -223.6 268.2) 
                         "c"
         )
        (command "pline" (list 223.6 266.2) "w" 0 0 
                         (list 223.6 266.0) 
                         (list -223.6 266.0) 
                         (list -223.6 266.2) 
                         "c"
         )
        (command "pline" (list 223.6 264.2) "w" 0 0 
                         (list 223.6 264.0) 
                         (list -223.6 264.0) 
                         (list -223.6 264.2) 
                         "c"
         )
        (command "pline" (list 223.6 262.2) "w" 0 0 
                         (list 223.6 262.0) 
                         (list -223.6 262.0) 
                         (list -223.6 262.2) 
                         "c"
         )
        (command "pline" (list 223.6 260.2) "w" 0 0 
                         (list 223.6 260.0) 
                         (list -223.6 260.0) 
                         (list -223.6 260.2) 
                         "c"
         )
        (command "pline" (list -209.7 188.9) "w" 0 0 
                         (list -210.3 188.9) 
                         (list -210.3 202.9) 
                         (list -224.3 202.9) 
                         (list -224.3 203.5) 
                         (list -210.3 203.5) 
                         (list -210.3 217.5) 
                         (list -209.7 217.5) 
                         (list -209.7 203.5) 
                         (list -195.7 203.5) 
                         (list -195.7 202.9) 
                         (list -209.7 202.9) 
                         "c"
         )
        (command "pline" (list -200.2 22.4623) "w" 0 0 
                         (list -193.379 22.4623) 
                         (list -204.2 42.4671) 
                         (list -215.021 22.4623) 
                         (list -208.2 22.4623) 
                         (list -208.2 -41.6328) 
                         (list -200.2 -41.6328) 
                         "c"
         )
  )
  (defun to_0 ()
    (command "zoom" "E")
    (command "layer" "unlock" "*" "thaw" "*" "ON" "*" "lock" "P" "lock" "PI" "")
    (command "erase" "all" "")
    (command "layer" "unlock" "*" "M" "0" "")
    (command "purge"   "all"  ""	"N")
    (command "purge"   "all" ""  "n")
    (command "purge"   "all"  ""	"N")
    (command "purge"   "all" ""  "n")       
    (setq text_ss (ssget "x" (list (cons 0 "*text"))))
    (if text_ss
      (if (= (sslength text_ss) 1)
	(command "change" text_ss "" "P" "layer" "0" "")
	(getstring "Can't find the apr model text, please check!")
	)
      )
    (setq err_line (ssget "x" (list (cons 0 "line"))))
    (if err_line
      (progn
      (prompt "\nI find some lines was put in problem layer, Please check!")
      (command "layer" "M" "problem" "")
      (command "change" err_line "" "p" "layer" "problem" "")
      )
      )          
     (setq ss (ssget "x" (list (cons 8 "pi"))))
    (if ss
      (progn
	  (setq num (sslength ss))
	  (setq count 0)
	    (setq pl_name (ssname ss count))
	    (setq ent_obj (vlax-ename->vla-object pl_name))
	    (vla-getboundingbox ent_obj 'ld 'rd)
	    (setq ld (vlax-safearray->list ld))
	    (setq rd (vlax-safearray->list rd))
	    (setq max_x (car rd) )
	    (setq max_y (cadr rd) )
	    (setq min_x (car ld) )
	    (setq min_y (cadr ld) )
	    (setq count (1+ count))
	    (vlax-release-object ent_obj)
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
	    (vlax-release-object ent_obj)
	  )
	(setq mid_pt (list
		       (/ (+ max_x min_x) 2)
	      	       (/ (+ max_y min_y) 2))
	      )
	(command "move" "all" "" mid_pt "0,0")	
	(command "rotate" "all" "" "0,0" "90")
	(command "zoom" "e")	
	)
      )    
    )

  (defun chg_txt ()
    (setq text_ss (ssget "x" (list (cons 8 "0"))))
    (if	(= (sslength text_ss) 1)
      (progn
	(setq txt_dt (entget (ssname text_ss 0)))
	(setq alg_left (list 205 -140 0))
	(setq txt_dt (subst (cons 10 alg_left) (assoc 10 txt_dt) txt_dt))
	(setq apr_id (cdr (assoc 1 txt_dt)))
	(setq c_date (getvar "CDATE"))
	(setq apr_id (strcat apr_id " QINGYI " (itoa (fix c_date))))
	(setq txt_dt (subst (cons 1 apr_id) (assoc 1 txt_dt) txt_dt))
	;(setq txt_dt (subst (cons 8 "ofst")(assoc 8 txt_dt) txt_dt))
	(setq txt_dt (subst (cons 40 6)(assoc 40 txt_dt) txt_dt))
	(entmod txt_dt)
      )
      (PROMPT "/n请手工处理文字")
    )
  )

  (defun scale (layer_name ke)
    (command "zoom" "E")
    (setq
      ss_lwpl (ssget "x"
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
    (if	ss_lwpl
      (progn
	(setq ss_cnt (sslength ss_lwpl))
	(setq i_loop 0)
	(while (< i_loop ss_cnt)
	  (setq pl_dt (entget (ssname ss_lwpl i_loop)))
	  (setq dt nil)
	  (while pl_dt
	    (if	(/= (caar pl_dt) 10)
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
    ))
    (command "zoom" "E")
    (setq
      ss_lwpl (ssget "x" (list (cons 0 "circle") (cons 8 layer_name)))
    )
    (if	ss_lwpl
      (progn
	(setq ss_cnt (sslength ss_lwpl))
	(setq i_loop 0)
	(while (< i_loop ss_cnt)
	  (setq pl_dt (entget (ssname ss_lwpl i_loop)))
	  (setq cx (* (cadr (assoc 10 pl_dt)) ke))
	  (if (or (< cx -192) (> cx 192))
	    (if	(> cx 0)
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
	    dt (subst (cons 10 (list cx yx 0)) (assoc 10 pl_dt) pl_dt)
	  )
	  (setq dt (subst (cons 8 "OK") (assoc 8 pl_dt) dt))
	  (entmake dt)
	  (setq i_loop (1+ i_loop))
	)
      )
    )
  )
  (defun ofst (layer_name cf1 ce1)
    (command "zoom" "E")
    (setq
      ss_lwpl (ssget "x"
		     (list (cons 0 "lwpolyline") (cons 8 layer_name))
	      )
    )
    (if	ss_lwpl
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
	    (if	(= (caar pl_dt) 10)
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
	    (if	(/= (caar pl_dt) 10)
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
  )
  (set_var)
  ;update 2002/09/20
  ;(setq ke 0.9858
  ;	 ce 0.1500
  ;	 cf 0.1500
  ;)
  (setq	ke 0.983
	ce 0.6700
	cf 0.6000
  )
  (command "zoom" "E")
  (vl-load-com)					;explode all inserts
  (setq exp_ss (ssget "x" (list (cons 0 "insert"))))
  (while exp_ss
    (setq sum_cnt (sslength exp_ss))
    (setq cnt 0)
    (while (< cnt sum_cnt)
      (setq ent_name (ssname exp_ss cnt))      
      (setq blk_obj (vlax-ename->vla-object ent_name))
      (vlax-invoke blk_obj 'explode)
      (vlax-invoke blk_obj 'delete)
      (vlax-release-object blk_obj)
      (setq cnt (1+ cnt))
    )
    (setq exp_ss (ssget "x" (list (cons 0 "insert"))))
  )
  (to_0)
  (scale "pi" ke)
  (scale "p" ke)  
  (ofst "pi" (/ cf 2) (/ ce 2))
  (chg_txt)
  (command "layer" "m" "0" "lock" "problem" "")
  (command "change" "all" "" "p" "la" "0" "")
  (draw_edge)
  (command "change" "all" "" "p" "la" "0" "")
  (command "purge"   "all"  ""	"N")
  (command "purge"   "all" ""  "n")
  (command "purge"   "all"  ""	"N")
  (command "purge"   "all" ""  "n")
  (command "zoom" "E")
  (getstring "如果原图形中存在箭头，请删除！")
)
(PROMPT "\n 输入 zsws运行，新试用，检查不可用此程序！")

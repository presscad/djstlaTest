;2004-07-22  因为客户增加液体版系数更改而修改 by owal  液体版：;


(defun set_units()
  (command "-units" "2" "8" "1" "8" "1" "n")
  );设置测量结果的数值格式及精度//2004-10-28

(defun c:deldim()
  (setq dim_ss (ssget "x" (list (cons 0 "DIM*"))))
  (if dim_ss
    (command "erase" dim_ss ""))
  )


(defun to0()
  (prompt "\n 请选中全部单粒 ")
  (setq s (ssget))
  (setq num (sslength s))
  (setq count 1)
  (vl-load-com)
  (setq pl_name (ssname s 0))
  (setq ent_obj (vlax-ename->vla-object pl_name))
  (vla-getboundingbox ent_obj 'ld 'ru)
  (setq ru (vlax-safearray->list ru))
  (setq max_x (car ru))
  (setq max_y (cadr ru))
  (setq count (1+ count))
  (vlax-release-object ent_obj)
  (while (< count num)
    (setq pl_name (ssname s count))
    (setq ent_obj (vlax-ename->vla-object pl_name))
    (vla-getboundingbox ent_obj 'ld 'ru)
    (setq ru (vlax-safearray->list ru))
    (setq max_x (max (car ru) max_x))
    (setq max_y (max (cadr ru) max_y))
    (setq count (1+ count))
    (vlax-release-object ent_obj)
  )
  (setq	max_pt (list max_x max_y 0))
  (command "move" "all" "" max_pt "0,0")
  (setq num num)
 )


(defun set_var ()
    (setq osnap_old (getvar "osmode"))
    (setq orthomode_old (getvar "orthomode"))
    (setvar "osmode" 0)
    (setvar "orthomode" 0)
    (list osnap_old orthomode_old)
  )



(defun ofst_pt(pst X_size Y_size)
      (setq pst (list (+ (car pst) X_size)
		      (+ (cadr pst) y_size)
		      )
	    )
      (setq pst pst)
  )


(defun draw_frm(crs_pnt)
       (setq rt_pt (ofst_pt crs_pnt 37.2 60.0))
       (command "zoom" "e")
  
       (setq sgl_frm (ssget rt_pt))
       (if sgl_frm
            (progn
                (command "layer" "m" "tmp" "")
                (command "change" sgl_frm "" "P" "la" "tmp" "")
                (command "layer" "m" "1" "")
            )
	 
            (progn
                (prompt "无法定位切割框，请自己处理，并确认单粒的对位")
                (exit)
            )
        )
  
        (setq p1 (ofst_pt rt_pt -420 0))
        (setq p2 (ofst_pt p1 0 -250))
        (setq p3 (ofst_pt p2 -2 0))
        (setq p4 (ofst_pt p3 0 252))
        (setq p5 (ofst_pt p4 424 0))
        (setq p6 (ofst_pt p5 0 -252))
        (setq p7 (ofst_pt p6 -2 0))
        (command "pline" p1 p2 p3 p4 p5 p6 p7 rt_pt "c")
        (setq ld_pt (ofst_pt rt_pt -420 -527))
        (setq p1 (ofst_pt ld_pt 420 0))
        (setq p2 (ofst_pt p1 0 250))
        (setq p3 (ofst_pt p2 2 0))
        (setq p4 (ofst_pt p3 0 -252))
        (setq p5 (ofst_pt p4 -424 0))
        (setq p6 (ofst_pt p5 0 252))
        (setq p7 (ofst_pt p6 2 0))
        (command "pline" p1 p2 p3 p4 p5 p6 p7 ld_pt "c")
        (command "layer" "lock" "tmp" "m" "0" "")
        (command "change" "all" "" "p" "la" "0" "")
        (command "purge" "all" "" "n")
        (command "purge" "all" "" "n")
  )


  (defun c:ocl16a()
         (set_units)
         (set_var)
         ;(setq is_liquid_solid(getstring"\n请问是不是液体版？<Yes/No/Enter>:"))
         (setq is_new_old     (getstring"\n请问是新机还是旧机器？<New/Old/Enter>:"))
         (setq num (to0))
         (command "zoom" "E")
    
         (if (not (tblsearch "layer" "pi"))
             (progn
                 (prompt "请将所有单料与Dummy放在PI层！")
                 (exit)
              )
          )
        (setq flags 0)
        ;(if(< num 150)
        ;   (setq y_scl 0.9858
	;         ce1   0.250
	;         x_scl 1.0
	;         cf1   0.250
        ;    )
        ;    (setq y_scl 0.9875
	;          ce1	0.150
	;          x_scl 1.0
	;          cf1	0.150
        ;     )
        ; )     2004-09-07
    
    ;(if(or(equal is_liquid_solid "")
    ;	   (equal is_liquid_solid "y")
    ;	  (equal is_liquid_solid "Y"))
    ;   (progn
    ;	   (setq y_scl 0.9862
    ;	         ce1   0.2
    ;	         x_scl 1.0
    ;	         cf1   0.2
    ;       )
    ;	   (setq flags 1)
    ;	 )
    ;    
    ;  )          2004-09-07

    (if(or(equal is_new_old "")
    	  (equal is_new_old "N")
    	  (equal is_new_old "n"))
        (progn
    	    (setq y_scl 0.9875
    	          ce1   0.2
    	          x_scl 1.0
    	          cf1   0.2
            )
    	    (setq flags 2)
    	 )
      (progn
           (setq y_scl 0.9865
    	         ce1   0.2
    	         x_scl 1.0
    	         cf1   0.2
           )
           (setq flags 3)
	)
      )
 
    
    (setq ss_lwpl (ssget "x"(list (cons 0 "lwpolyline") (cons 8 "pi"))))
	      
    
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
		(setq scl_x (* (cadar pl_dt) x_scl))
		(setq scl_y (* (caddar pl_dt) y_scl))
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
    (setq x_cpt (/ cf1 2.0))
    (setq y_cpt (/ ce1 2.0))
    (setq
      ss_lwpl (ssget "x"
		     (list (cons 0 "lwpolyline") (cons 8 "pi"))
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
		  (setq ofst_x (- ofst_x x_cpt))
		  (setq ofst_x (+ ofst_x x_cpt))
		)
		(if (> ofst_y cy)
		  (setq ofst_y (- ofst_y y_cpt))
		  (setq ofst_y (+ ofst_y y_cpt))
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
    (setq
      ss_txt (ssget "x" (list (cons 0 "TEXT")))
    )
    (if	(= (sslength ss_txt) 1)
      (progn
	(setq txt_dt (entget (ssname ss_txt 0)))	
	(setq apr_id (cdr (assoc 1 txt_dt)))
	(setq c_date (getvar "CDATE"))
	(setq apr_id (strcat apr_id " QINGYI " (itoa (fix c_date))))
	(setq apr_id (strcase apr_id))
	(setq txt_dt (subst (cons 1 apr_id) (assoc 1 txt_dt) txt_dt))	
	(setq txt_dt (subst (cons 10 '(-284 -420 0)) (assoc 10 txt_dt) txt_dt))
	(entmod txt_dt)
      )
    )
    (command "zoom" "w" '(-30 -30) '(80 120)) 
    (setvar "OSMODE" 2)
    (setq crs_pnt (getpoint "\n请选中对位十字的最左边的中心点："))
    (setvar "Osmode" 0)
    (setq scl_val (cadr crs_pnt))
    (setq scl_val (- scl_val (* scl_val y_scl)))
    (setq mov_ss (ssget "x" (list (cons 8 "pi"))))
    (setq mov_pt (list 0 scl_val 0))    
    (command "move" mov_ss "" '(0 0 0) mov_pt)
    (draw_frm crs_pnt)
    (setq str_scale (strcat "\n请确认系数是:" "ke = " (rtos y_scl)
		      "、kf = "(rtos x_scl)"、ce = "(rtos ce1)
		      "、cf = "(rtos cf1)))
    (if(equal flags 0)(setq str_type "---固体版---"))
    (if(equal flags 1)(setq str_type "---液体版---"))
    (if(equal flags 2)(setq str_type "---新机器---"))
    (if(equal flags 3)(setq str_type "---旧机器---"))
    (getstring (strcat str_scale str_type))
    
  )
(alert"注意：目前该客户没有液体版的正式工艺单！")
(PROMPT "\n------- 输入  ocl16a  运行程序---------")
(prompt "\n-请删除无用实体，将单料与DUMMY放在PI层-")
(prompt "\n-将8个对位标与外框放在1层，型号放在0层-")
(prompt "\n-将除文字外的所有实体变为闭合多义线----")
(prompt "\n---------------------------------------")

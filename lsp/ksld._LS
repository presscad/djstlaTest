					;--------------------------------------------------

(defun set_var ()
  (setvar "osmode" 0)
  (setvar "orthomode" 0)
  (list osnap_old orthomode_old)
)


					;--------------------------------------------------


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
  (command "zoom" "E")
)


					;        defun scale(layer_name ke)                                               


(defun cirsca1 (/ ss_lwp2 ss_cnt i_loop pl_dt center)
  (command "zoom" "e")
  (setq
    ss_lwp2 (ssget "x"
		   (list (cons 0 "CIRCLE") (cons 8 "0"))
	    )
  )
  (if ss_lwpl
    (progn
      (setq ss_cnt (sslength ss_lwp2))
      (setq i_loop 0)
      (while (< i_loop ss_cnt)
	(setq pl_dt (entget (ssname ss_lwp2 i_loop)))
	(setq center (cdr (assoc 10 pl_dt)))
	(setq center (list (* 1.0 (car center)) (* kf (cadr center))))
	(setq pl_dt (subst (cons 10 center) (assoc 10 pl_dt) pl_dt))
	(entmod pl_dt)
	(setq i_loop (1+ i_loop))
      )
    )
  )
  (command "zoom" "E")
)

					;---------------------------------------------------------------------------


(defun cirsca0 (/ ss_lwp2 ss_cnt i_loop pl_dt center)
  (command "zoom" "e")
  (setq
    ss_lwp2 (ssget "x"
		   (list (cons 0 "CIRCLE") (cons 8 "scl"))
	    )
  )
  (if ss_lwpl
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


					;                                                                                


(defun ofst (layer_name cf1 ce1)
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
)


					;      defun ofst (layer_name cf1 ce1)                                                    


(defun aprbk_pi	()
  (command "pline"
	   (list -199.5000 88.0000)
	   "w"
	   0
	   0
	   (list -199.5000 46.0000)
	   (list -197.5000 46.0000)
	   (list -197.5000 86.0000)
	   (list 195.5000 86.0000)
	   (list 197.5000 81.0000)
	   (list 197.5000 46.0000)
	   (list 199.5000 46.0000)
	   (list 199.5000 81.3852)
	   (list 196.8541 88.0000)
	   (list -199.5000 88.0000)
	   "c"
  )
  (command "circle" (list -185.0000 75.5000) "1.0" "")
  (command "circle" (list -157.5000 75.5000) "1.5" "")
  (command "circle" (list -52.5000 75.5000) "1.5" "")
  (command "circle" (list 52.5000 75.5000) "1.5" "")
  (command "circle" (list 157.5000 75.5000) "1.5" "")
  (command "circle" (list 185.0000 75.5000) "1.0" "")
  (command "pline"
	   (list -199.5000 16.0000)
	   "w"
	   0
	   0
	   (list -199.5000 -400.0000)
	   (list -197.5000 -400.0000)
	   (list -197.5000 16.0000)
	   (list -199.5000 16.0000)
	   "c"
  )
  (command "pline"
	   (list 197.5000 16.0000)
	   "w"
	   0
	   0
	   (list 197.5000 -400.0000)
	   (list 199.5000 -400.0000)
	   (list 199.5000 16.0000)
	   (list 197.5000 16.0000)
	   "c"
  )
  (command "pline"
	   (list -199.5000 -431.0000)
	   "w"
	   0
	   0
	   (list -199.5000 -476.0000)
	   (list 199.5000 -476.0000)
	   (list 199.5000 -431.0000)
	   (list 197.5000 -431.0000)
	   (list 197.5000 -474.0000)
	   (list -197.5000 -474.0000)
	   (list -197.5000 -431.0000)
	   (list -199.5000 -431.0000)
	   "c"
  )
  (command "circle" (list -185.0000 -463.5000) "1.0" "")
  (command "circle" (list -157.5000 -463.5000) "1.5" "")
  (command "circle" (list -52.5000 -463.5000) "1.5" "")
  (command "circle" (list 52.5000 -463.5000) "1.5" "")
  (command "circle" (list 157.5000 -463.5000) "1.5" "")
  (command "circle" (list 185.0000 -463.5000) "1.0" "")
  (command "pline"
	   (list -188.0000 5.0000)
	   "w"
	   0
	   0
	   (list -187.0000 5.0000)
	   (list -187.0000 -5.0000)
	   (list -188.0000 -5.0000)
	   (list -188.0000 -0.2500)
	   (list -195.0000 -0.2500)
	   (list -195.0000 0.2500)
	   (list -188.0000 0.2500)
	   (list -188.0000 5.0000)
	   "c"
  )
  (command "pline"
	   (list -188.0000 -383.5500)
	   "w"
	   0
	   0
	   (list -188.0000 -399.5500)
	   (list -187.0000 -399.5500)
	   (list -187.0000 -383.5500)
	   (list -188.0000 -383.5500)
	   "c"
  )
  (command "pline"
	   (list 187.0000 5.0000)
	   "w"
	   0
	   0
	   (list 187.0000 -5.0000)
	   (list 188.0000 -5.0000)
	   (list 188.0000 -0.2500)
	   (list 195.0000 -0.2500)
	   (list 195.0000 0.2500)
	   (list 188.0000 0.2500)
	   (list 188.0000 5.0000)
	   (list 187.0000 5.0000)
	   "c"
  )
  (command "pline"
	   (list 187.0000 -383.5500)
	   "w"
	   0
	   0
	   (list 187.0000 -399.5500)
	   (list 188.0000 -399.5500)
	   (list 188.0000 -383.5500)
	   (list 187.0000 -383.5500)
	   "c"
  )
)


					;----------------------------------------------------------------------------------------


(defun qylogo (/ ss_txt sys_data ss_content)
  (setq ss_text (ssget "x" (list (cons 0 "text"))))
  (if (= (sslength ss_text) 1)
    (progn
      (setq ss_txt (entget (ssname ss_text 0)))
      (setq ss_content (cdr (assoc 1 ss_txt)))
      (setq sys_data (getvar "cdate"))
      (setq sys_data (strcase (itoa (fix sys_data))))
      (setq sys_data (strcat ss_content " " "QINGYI " sys_data))
      (setq ss_txt (subst (cons 1 sys_data) (cons 1 ss_content) ss_txt))
      (entmod ss_txt)
    )
  )
)


					;-----------------------------------------------------------------------------------------


(defun apr_editpi (/	     start_pt  start_pt_x	   start_pt_y
		   cen_pt    a	       ss_all	 p1	   p2
		   ss_scal   no_user
		  )
  (setvar "osmode" 2)
  (setvar "orthomode" 1)
  (setvar "mirrtext" 1)
  (setq start_pt (getpoint "\请点中左边十字的右边中心点:"))
  (setq start_pt_x (car start_pt))
  (setq start_pt_y (cadr start_pt))
  (setq cen_pt (list (+ start_pt_x 187.00) start_pt_y))
  (setq a (list (+ start_pt_x 187.00) -1.0))
  (setq ss_all (ssget "x" (list (cons 8 "0"))))
  (command "mirror" ss_all "" cen_pt a "y" "")
  (command "move" ss_all "" cen_pt (list 0 0))
  (command "zoom" "e" "")
  (command "change" ss_all "" "p" "la" "0" "")
  (setvar "osmode" 0)
  (setq p1 (list 186.000 5.0))
  (setq p2 (list -186.0000 -399.5500))
  (setq ss_scal (ssget "w" p1 p2))
  (command "layer" "n" "scl" "")
  (command "change" ss_scal "" "p" "la" "scl" "")
  (command "change"
	   (ssget "x" (list (cons 0 "text")))
	   ""
	   "p"
	   "la"
	   "scl"
	   ""
  )
  (command "zoom" "e" "")
  (setq no_user (ssget "x" (list (cons 8 "0"))))
  (command "erase" no_user "")
)


					;-----------------------------------------------------------------------------------------


(defun longofst_z	(/ ss_lwpl ss_cnt i_loop cx cy cnt pl_dt)
  (vl-load-com)
  (command "zoom" "e")
  (setq
    ss_lwpl (ssget "x"
		   (list (cons 0 "lwpolyline")
			 (cons 8 "longofst")
		   )
	    )
  )
  (if ss_lwpl
    (progn
      (setq ss_cnt (sslength ss_lwpl))
      (setq i_loop 0)
      (while (< i_loop ss_cnt)
	(setq pl_dt (ssname ss_lwpl i_loop))
	(setq pl_dt(vlax-ename->vla-object pl_dt))
	(setq pt(vla-getboundingbox pl_dt 'minpoint 'maxpoint))
	(setq pt_max(vlax-safearray->list maxpoint))
	(setq pt_max(list
		      (- (car pt_max) 0.001)
		      (- (cadr pt_max) 0.001)
		      ))
	(setq pl_dt (cdar (entget (ssname ss_lwpl i_loop))))
	(command "offset" ce1 pl_dt pt_max "")
	(setq i_loop (+ i_loop 1))
      )
    )
  )
  (command "erase" ss_lwpl "")
  )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun longofst_y	(/ ss_lwpl ss_cnt i_loop cx cy cnt pl_dt)
  (vl-load-com)
  (command "zoom" "e")
  (setq
    ss_lwpl (ssget "x"
		   (list (cons 0 "lwpolyline")
			 (cons 8 "longofst")
		   )
	    )
  )
  (if ss_lwpl
    (progn
      (setq ss_cnt (sslength ss_lwpl))
      (setq i_loop 0)
      (while (< i_loop ss_cnt)
	(setq pl_dt (ssname ss_lwpl i_loop))
	(setq pl_dt(vlax-ename->vla-object pl_dt))
	(setq pt(vla-getboundingbox pl_dt 'minpoint 'maxpoint))
	(setq pt_min(vlax-safearray->list minpoint))
	(setq pt_min(list
		      (+ (car pt_min) 0.001)
		      (+ (cadr pt_min) 0.001)
		      ))
	(setq pl_dt (cdar (entget (ssname ss_lwpl i_loop))))
	(command "offset" ce1 pl_dt pt_min "")
	(setq i_loop (+ i_loop 1))
      )
    )
  )
  (command "erase" ss_lwpl "")
)

					;------------------------------------------------------------------------


(defun smallofst (layer_name cf1 ce1)
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
		(setq ofst_x (+ ofst_x cf1))
		(setq ofst_x (- ofst_x cf1))
	      )
	      (if (> ofst_y cy)
		(setq ofst_y (+ ofst_y ce1))
		(setq ofst_y (- ofst_y ce1))
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


					;-----------------------------------------------------------------------------------


(defun aprbk_top ()
  (command "layer" "m" "topbk" "")
  (aprbk_pi)
  (command "rotate"
	   (ssget "x" (list (cons 8 "topbk")))
	   ""
	   (list 0 0)
	   "180"
  )
)

					;-----------------------------------------------------------------------------------

(defun apr_edittop (/	      start_pt	start_pt_x	    start_pt_y
		    cen_pt    a		ss_all	  p1	    p2
		    ss_scal   no_user
		   )
  (setvar "osmode" 2)
  (setvar "orthomode" 1)
  (setvar "mirrtext" 1)
  (setq start_pt (getpoint "\请点中左边十字的右边中心点:"))
  (setq start_pt_x (car start_pt))
  (setq start_pt_y (cadr start_pt))
  (setq cen_pt (list (+ start_pt_x 187.00) start_pt_y))
  (setq a (list (+ start_pt_x 187.00) -1.0))
  (setq ss_all (ssget "x" (list (cons 8 "0"))))
  (command "mirror" ss_all "" cen_pt a "y" "")
  (command "move" ss_all "" cen_pt (list 0 0))
  (command "zoom" "e" "")
  (command "change" ss_all "" "p" "la" "0" "")
  (setvar "osmode" 0)
  (setq p1 (list 186.0 399.550))
  (setq p2 (list -186.0 -5.0))
  (setq ss_scal (ssget "w" p2 p1))
  (command "layer" "n" "scl" "")
  (command "change" ss_scal "" "p" "la" "scl" "")
  (command "change"
	   (ssget "x" (list (cons 0 "text")))
	   ""
	   "p"
	   "la"
	   "scl"
	   ""
  )
  (command "zoom" "e" "")
  (setq no_user (ssget "x" (list (cons 8 "0"))))
  (command "erase" no_user "")
)

					;-------------------------------------------------------------------------------------

(defun ksldtop ()
  (prompt
    "/程序运行前请先将图形cam处理ok,\n
	  图形放在0层\n :"
  )
  (command "zoom" "e")
  (setq ke 0.979)
  (setq ce1 (/ 0.2 2.0))
  (setq cf1 (/ 0.2 2.0))
  (setq kf 1.0002)
  (set_var)
  (apr_edittop)
  (set_var)
  (scale "scl" ke)
  (cirsca0)
  (command "layer" "m" "longofst" "")
  (prompt "/n请选中所有长单粒！")
  (setq patten (ssget))
  (command "change" patten "" "p" "la" "longofst" "")
    (setq ss(strcase(getstring"/你现在看到的长单粒的凸起是向左<Z>,向右(Y):")))
  (if (= ss "Z")
      (longofst_z)
    )
  (if (= ss "Y")
      (longofst_y)
    )
  (command "layer" "m" "smallofst" "")
  (prompt "/n请选中所有小单粒！")
  (setq cells (ssget))
  (command "change" cells "" "p" "la" "smallofst" "")
  (smallofst "smallofst" ce1 cf1)
  (aprbk_top)
  (command "change" "all" "" "p" "la" "0" "")
  (command "purge" "a" "" "n")
  (command "rotate" "all" "" (list 0 0) "-90" "")
  (scale "0" kf)
  (cirsca1)
  (command "rotate" "all" "" (list 0 0) "90" "")
  (command "layer" "s" "0" "")
  (command "change" "all" "" "p" "la" "0" "")
  (command "purge" "a" "" "n")
  (command "zoom" "e")
  (qylogo)
  (set_var)
)

					;                                                                                    


(defun ksldpi ()
  
  (command "zoom" "e")
  (setq ke 0.979)
  (setq ce1 (/ 0.2 2.0))
  (setq cf1 (/ 0.2 2.0))
  (setq kf 1.0002)
  (set_var)
  (apr_editpi)
  (set_var)
  (scale "scl" ke)
  (cirsca0)
  (command "layer" "m" "ofst" "")
  (prompt "/n请选中所有单粒！")
  (setq patten (ssget))
  (command "change" patten "" "p" "la" "ofst" "")
  (ofst "ofst" cf1 ce1)
  (aprbk_pi)
  (command "change" "all" "" "p" "la" "0" "")
  (command "rotate" "all" "" (list 0 0) "90" "")
  (scale "0" kf)
  (cirsca1)
  (command "rotate" "all" "" (list 0 0) "-90" "")
  (command "change" "all" "" "p" "la" "0" "")
  (command "layer" "s" "0" "")
  (command "purge" "a" "" "n")
  (command "zoom" "e")
  (qylogo)

)
(defun is_pi_top()
       (setq txt_ss(ssget"x"(list(cons 0 "text"))))
       (setq sslen(sslength txt_ss))
       (if (equal sslen 1)(setq txt(ssname txt_ss 0)))
       (if txt(setq txt_apr(cdr (assoc 1 (entget txt)))))
       (setq txt_back txt_apr)
  
       (if txt_apr(setq txt_len(strlen txt_apr)))

       (while(>= txt_len 3)
             (setq is_txt(substr txt_apr 1 2))
             (if (equal is_txt "PI")
                 (ksldpi)	 
             );endif	     

             (if (equal is_txt "TC")
                 (ksldtop)	  	   
             );endif
	     
    
             (setq txt_apr(substr txt_apr 2))
             (setq txt_len(strlen txt_apr))
        )
  )
					;---------------------------------------------------------------------------


(defun c:ksld ()
  (is_pi_top)
  ;(setq a (strcase (getstring "\请问所做凸板是: <top>_or<pi>:")))
  ;(if (or
;	　
;	(= a "PI")
;	　
;	(= a "P")
 ;     )
  ;  (progn
   ;   (ksldpi)
    ;)
  ;)
  ;(if (or
;	(= a "TOP")
;	(= a "T")
 ;     )
  ;  (progn
   ;   (prompt "\程序运行前请先将长单粒做merge处理:")
    ;  (ksldtop)
   ; )
  ;)
  (alert
    (strcat
      "               2005-04-25 <TANGWEI>
   请自已处理cut!!!!!!!!!!
   请确认系数是：
   Ke="
      (rtos ke)
      "; kf= "
      (rtos kf)
      ";Ce="
      (rtos (* 2 ce1))
      "; Cf="
      (rtos (* 2 cf1))
    )
  )
)
(prompt"\n*********TOP版请先将各个长单粒中间的间隔线删除*********")
(prompt"\n－－－－－－－－－－－－－－－－－－－－－－－")
 (prompt"\n****程序运行前请先将图形处理OK(除了文字)*****")
(prompt"\n－－－－－－－－－－－－－－－－－－－－－－－")
　(prompt"\n************并将所有图形放在0层**************")

					;请注意目前top与pi是用的同一系数，要修改的话有两处地方修改。
(defun set_var ()
  (setq osnap_old (getvar "osmode"))
  (setq orthomode_old (getvar "orthomode"))
  (setvar "osmode" 0)
  (setvar "orthomode" 0)
  (list osnap_old orthomode_old)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun scale (layer_name ke)
  (command "zoom" "E")
  (setq
    ss_lwpl (ssget "x"
		   (list (cons 0 "lwpolyline,polyline") (cons 8 layer_name))
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
  (setq
    ss_cic (ssget "x"
		  (list (cons 0 "circle") (cons 8 layer_name))
	   )
  )
  (setq num (sslength ss_cic))
  (setq i_poot 0)
  (while
    (if	(< i_poot num)
      (progn
	(setq cir_att (entget (ssname ss_cic i_poot)))
	(setq cir_cen (cdr (assoc 10 cir_att)))
	(setq cir_cennew
	       (list (* 1.0 (car cir_cen)) (* ke (cadr cir_cen)))
	)
	(setq cir_att (subst (cons 10 cir_cennew)
			     (assoc 10 cir_att)
			     cir_att
		      )
	)
	(entmod cir_att)
      )
    )
     (setq i_poot (1+ i_poot))
  )
  (command "zoom" "E")
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun piedit
       (/  pt1 pt2 pt2x pt2y pt2 pt w1 w2 patten cell)
  (set_var)
  (setvar "osmode" 4)
  (command "zoom" "e")
  (setq pt1 (getpoint "点中左上角圆环的圆心:"))
  (command "zoom" "e")
  (setq pt2 (getpoint "点中右上角圆环的圆心:"))
  (setq pt2x (+ (car pt1) (/ (- (car pt2) (car pt1)) 2)))
  (setq pt2y (cadr pt1))
  (setq pt2 (list pt2x pt2y))
  (setq pt (list 0 0))
  (set_var)
  (command "move" "all" "" pt2 pt "")
  (command "layer" "n" "patten" "")
  (command "zoom" "e")
  (setq w1 (list  -171.5125 -219.5000))
  (setq w2 (list 171.4875 2.6000))
  (setq patten (ssget "w" w2 w1))
  (command "change" patten "" "p" "la" "patten" "")
  (scale "patten" ke)
  (command "layer" "n" "cell" "")
  (prompt "请选中要补偿的单粒:")
  (setq cell (ssget))
  (command "zoom" "E")
  (command "change" cell "" "p" "la" "cell" "")
  (ofst "cell" cf1 ce1)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun topedit
       (/  pt1 pt2 pt2x pt2y pt2 pt w1 w2 patten cell)
  (setvar "osmode" 4)
  (command "zoom" "e")
  (setq pt1 (getpoint "点中左边圆环的圆心:"))
  (setq pt2 (getpoint "点中右边圆环的圆心:"))
  (setq pt2x (+ (car pt1) (/ (- (car pt2) (car pt1)) 2)))
  (setq pt2y (cadr pt1))
  (setq pt2 (list pt2x pt2y))
  (setq pt (list 0 0))
  (set_var)
  (command "move" "all" "" pt2 pt "")
  (command "layer" "n" "patten" "")
  (command "zoom" "e")
  (setq w1 (list -171.6125 -217.7000))
  (setq w2 (list 171.5875 3.7000))
  (setq patten (ssget "w" w2 w1))
  (command "change" patten "" "p" "la" "patten" "")
  (scale "patten" ke)
  (command "layer" "n" "cell" "")
  (prompt "请选中要补偿的单粒:")
  
  (setq cell (ssget))
 (command "zoom" "e")
  (command "change" cell "" "p" "la" "cell" "")
  (ofst "cell" cf1 ce1)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun edit (/ bar cell bat_l bat_r bat_l1 bat_r1)
  (vl-load-com)
  (command "zoom" "E")
  (setq ss_all (ssget "X"(list (cons 0 "lwpolyline,line,circle,line,polyline,arc,text"))))
  (setq ss_len (sslength ss_all))
  (setq n 1)
  (setq pl_name (ssname ss_all 0))
  (setq ent_obj (vlax-ename->vla-object pl_name))
  (vla-getboundingbox ent_obj 'ld 'rd)
  (setq ld (vlax-safearray->list ld))
  (setq rd (vlax-safearray->list rd))
  (setq max_x (car rd))
  (setq min_x (car ld))
  (setq max_y (cadr rd))
  (setq min_y (cadr ld))
  (repeat (- ss_len 1)
    (setq pl_name (ssname ss_all n))
    (setq ent_obj (vlax-ename->vla-object pl_name))
    (vla-getboundingbox ent_obj 'ld 'rd)
    (setq ld (vlax-safearray->list ld))
    (setq rd (vlax-safearray->list rd))
    (setq max_x (max (car rd) max_x))
    (setq min_x (min (car ld) min_x))
    (setq max_y (max (cadr rd) max_y))
    (setq min_y (min (cadr ld) min_y))
    (setq n (1+ n))
  )
  (setq rd (list max_x max_y))
  (setq ld (list min_x min_y))
  (setq rd1_x(- max_x 400))
  (setq rd1_y(- max_y 20))
  (setq ld1_x(+ min_x 400))
  (setq ld1_y(+ min_y 20))
  (setq rd1(list rd1_x rd1_y))
  (setq ld1(list ld1_x ld1_y))
  (command "layer" "s" "cell" "")
  (command "rectang" rd rd1 "")
  (command "rectang" ld ld1 "")
  (set_var)
  (command "zoom" "E")
  (setq cell (ssget "x"(list (cons 8 "cell"))))
  (command "change" cell "" "p" "la" "patten" "")
  (command "change" txt_ss "" "p" "la" "patten" "")
  (command "layer" "lo" "patten" "")
  (command "erase" "all" "")
  (command "layer" "u" "patten" "")
  (command "change" "all" "" "p" "la" "0" "")
  (command "layer" "s" "0" "")
  (command "purge" "all" "" "n" "")
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun lgo(/ txt_ss1 sslen i_po1 txt_att1 sys_data txt ss_txt n txt ss att_txt txt_int_x txt_int_y txt_int)
  (command "zoom" "E")
    (setq ss_txt(ssget "x"(list(cons 0 "text"))))
    (setq n 0)
    (setq txt(sslength ss_txt))
    (setq ss nil)
(while
  (if(< n txt)
     (progn
     (setq att_txt(entget (ssname ss_txt n)))
     (setq txt_int_x(cadr(assoc 10 att_txt)))
     (setq ss (append ss (list txt_int_x)))
     (setq txt_int_x(max (car ss) txt_int_x))
     (setq txt_int_y(caddr(assoc 10 att_txt)))
     )
  )
  (setq n (1+ n))
)  
(setq txt_int(list txt_int_x txt_int_y))
  (command "zoom" "E")
(setq txt_ss1(ssget "x"(list (cons 10 txt_int))))
    (setq txt_att1(entget (ssname txt_ss1 0)))
    (setq txt_name (strcase (cdr (assoc 1 txt_att1))))
    (setq sys_data (getvar "cdate"))
    (setq sys_data (strcase (itoa (fix sys_data))))
    (setq sys_data (strcat txt_name " " "QINGYI" sys_data))
    (setq txt_att1(subst (cons 1 sys_data) (assoc 1 txt_att1) txt_att1))
    (entmod txt_att1)                        
    (setq mt(list 0 0))
    (setq mt1(list -15 0))
  (command "zoom" "E")
    (setq txt(ssget "x"  (list
                         (cons -4 "<or")
			 (cons 0 "text")
			 (cons 0 "mtext")
			 (cons -4 "or>"))))
    (command "move" txt "" mt mt1 "")
  )
  

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun ar(/ textname ipoot textnum textatt text_style)
    (setvar "orthomode" 0)
    (setvar "snapmode" 0)
  (command "zoom" "E")
    (setq textname(ssget "x"(list (cons 0 "text"))))
    (setq ipoot 0 )
    (setq textnum(sslength textname ))
    (while
      (if (< ipoot textnum)
           (progn
           (setq textatt(entget(ssname textname ipoot)))
           (setq text_style(cdr(assoc 7 textatt)))
           (command "-style" text_style "arial" "" "" "" "" "")
	   (setq ipoot(1+ ipoot))
      )
     )
   )
  )






;根据APR文字的前几个字母判断是PI还是TOP版,并调用相应函数
(defun c:nbwt(/ ke ce1 cf1 kf txt_ss sslen i_poo txt_att)
  (alert "请先将图形CAM处理OK;多余图形请删掉,否则影响加边框:")
  (ar)
  (command "convert" "all" "" "" "")
  (command "zoom" "E")
  (setq txt_ss (ssget "x" (list (cons 0 "text"))))
  (setq sslen (sslength txt_ss))
  (setq i_poo 0)
  (while
    (if (< i_poo sslen)
        (progn
        (progn
        (setq
             txt_att (strcase (cdr (assoc 1 (entget (ssname txt_ss i_poo))))))
                     (if (equal (substr txt_att 1 2) "PI")
                           (progn
			     (setq ke 0.9843)
                             (setq ce1 (/ 0.2 2.0))
                             (setq cf1 (/ 0.2 2.0))
                             (setq kf 1.0)
	                     (piedit)
		             (edit)
		             (lgo)
			       (alert
                                 (strcat
      "               2005-11-11 <TANGWEI>
   请自已处理cut!!!!!!!!!!
   请确认PI版系数是：
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
		      )
	              (if  (equal (substr txt_att 1 3) "TOP")
		            (progn
			     (setq ke 0.9843)
                             (setq ce1 (/ 0.4 2.0))
                             (setq cf1 (/ 0.4 2.0))
                             (setq kf 1.0)
	                    (topedit)
			    (edit)
			    (lgo)
			      (alert
                                 (strcat
      "               2005-11-11 <TANGWEI>
   请自已处理cut!!!!!!!!!!
   请确认TOP版系数是：
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
	               )
	) 
        (setq i_poo (1+ i_poo))
	)
     )
  )
  
  )
(prompt"输入NBWT运行程序!!")
  



;说明:此程序为客户=宇顺电子=凸版而编写.2005-07-11


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun apr_scale (ss_lwpl x_scl y_scl / ss_cnt i_loop pl_dt dt)	;ss_lwpl  The objects to scale;
      (setq ss_cnt (sslength ss_lwpl))                         	;  x_scl  the scale factor of x axis;
      (setq i_loop 0)    				       	;  y_scl  the scale factor of y axis;
      (while (< i_loop ss_cnt) 				       	; ss_cnt  the number of pickset;
	(setq pl_dt (entget (ssname ss_lwpl i_loop)))	       	; i_loop  the varieable of circulation;
	(setq dt nil) 					       	;  pl_dt  a common varieble;
	(while pl_dt					       	;     dt  a common varieble;
	  (if (/= (caar pl_dt) 10)
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;补偿-函数;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun apr_ofst (ss_lwpl x_cpt y_cpt / ss_cnt i_loop pl_dt cx cy cnt dt ofst_x ofst_y)
  (setq x_cpt (/ x_cpt 2.0))                           ;x_cpt the complement of x axis;
  (setq y_cpt (/ y_cpt 2.0))			       ;y_cpt the complement of y axis;
  (if ss_lwpl					       ;ss_cnt i_loop pl_dt cx cy cnt dt ofst_x ofst_y,local varieble;
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
);---------------------------------apr_ofst----------------------------------------


;判断该凸版是PI还是TOP.
(defun is_pi_top(txt_content / txt_apr txt_back txt_len is_txt return_txt);txt_content是字符串.
       (setq txt_apr txt_content)
       (setq txt_back txt_apr)
  
       (if txt_apr(setq txt_len(strlen txt_apr)))

       (while(>= txt_len 3)
             (setq is_txt(substr txt_apr 1 3))
             (if (equal is_txt "P.I")
                 (setq return_txt "PI");返回值.
             );endif	     

             (if (equal is_txt "TOP")
                 (setq return_txt "TOP");返回值.
             );endif    
             (setq txt_apr(substr txt_apr 2))
             (setq txt_len(strlen txt_apr))
        )

        (while(>= txt_len 2)
             (setq is_txt(substr txt_back 1 2))
             (if (equal is_txt "PI")
                 (setq return_txt "PI");返回值.
	       );endif               
             (setq txt_back(substr txt_back 2))
             (setq txt_len(strlen txt_back))
        )

        (setq return_txt return_txt);返回值.
  )



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;收缩-函数;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(defun add_frame(str_1);加边框
  	(print"\n加边框......")
  	(if(equal str_1 "PI")
	   (progn
	     	  (command "pline" (list 179.8 -198.2) "w" 0 0 
                         (list 180.2 -198.2) 
                         (list 180.2 -208.2) 
                         (list 179.8 -208.2) 
                         "c"
         	  )
        	(command "pline" (list -179.8 203.4) "w" 0 0 
                         (list -176.5 203.4) 
                         (list -176.5 203.0) 
                         (list -179.8 203.0) 
                         (list -179.8 198.2) 
                         (list -180.2 198.2) 
                         (list -180.2 203.0) 
                         (list -183.5 203.0) 
                         (list -183.5 203.4) 
                         (list -180.2 203.4) 
                         (list -180.2 208.2) 
                         (list -179.8 208.2) 
                         "c"
         	)
        	(command "pline" (list 195.0 268.2) "w" 0 0 
                         (list -197.0 268.2) 
                         (list -197.0 268.2) 
                         (list -197.0 -280.8) 
                         (list 197.0 -280.8) 
                         (list 197.0 268.2) 
                         (list 195.0 268.2) 
                         (list 195.0 266.2) 
                         (list 195.0 266.2) 
                         (list 195.0 266.2) 
                         (list 195.0 -278.8) 
                         (list -195.0 -278.8) 
                         (list -195.0 266.2) 
                         (list 195.0 266.2) 
                         "c"
         	)
	   )
	   (progn
	     (command "pline" (list -197.0 263.7) "w" 0 0 
                         (list -197.0 -283.3) 
                         (list -197.0 -283.3) 
                         (list 197.0 -283.3) 
                         (list 197.0 265.7) 
                         (list -197.0 265.7) 
                         (list -197.0 263.7) 
                         (list -197.0 263.7) 
                         (list -195.0 263.7) 
                         (list 195.0 263.7) 
                         (list 195.0 263.7) 
                         (list 195.0 -281.3) 
                         (list -195.0 -281.3) 
                         (list -195.0 263.7) 
                         (list -195.0 263.7) 
                         "c"
        	 )
        	(command "pline" (list -179.8 200.9) "w" 0 0 
                         (list -175.0 200.9) 
                         (list -175.0 200.5) 
                         (list -179.8 200.5) 
                         (list -179.8 195.7) 
                         (list -180.2 195.7) 
                         (list -180.2 200.5) 
                         (list -185.0 200.5) 
                         (list -185.0 200.9) 
                         (list -180.2 200.9) 
                         (list -180.2 205.7) 
                         (list -179.8 205.7) 
                         "c"
         	)
        	(command "pline" (list 179.8 -200.7) "w" 0 0 
                         (list 180.2 -200.7) 
                         (list 180.2 -210.7) 
                         (list 179.8 -210.7) 
                         "c"
        	 )
	     	
	     )
	)        
 )


(defun move_ito_zero(str_1 / ss_all ss_lefttop ss_rightbot ent_lefttop ent_rightbot list_data
		        pt_lefttop pt_rightbot x_lt x_rb ito_center return )
  ;移动全图，从ITO中心到(0,0) .
  ;返回实体+坐标的链表.
  	(setq ss_all(ssget"X"))
  	(print"\n请选择左上角的+图形:")
  	(setq ss_lefttop(ssget))
        (if(> (sslength ss_lefttop) 1)
	   	(progn
		  	(print"\n多选了图形:error,select(),编号001.")
		  	(exit)
		  )
	  )
  	(setq ent_lefttop(ssname ss_lefttop 0))
  	(print"\n请选择右下角的-图形:")
  	(setq ss_rightbot(ssget))
  	(if(> (sslength ss_rightbot) 1)
	   	(progn
		  	(print"\n多选了图形:error,select(),编号002.")
		  	(exit)
		  )
	)
  	(setq ent_rightbot(ssname ss_rightbot 0))

  	(command "zoom" "e");此处居中很有必要.

  	(setq list_data nil)
  	(setq list_data(find_center list_data ent_lefttop));调用函数.
  	(setq list_data(find_center list_data ent_rightbot))  
  	(setq pt_lefttop(cdr(car list_data)))
  	(setq pt_rightbot(cdr(cadr list_data)))
  
  	(setq x_lt (car pt_lefttop) y_lt (cadr pt_lefttop))
  	(setq x_rb (car pt_rightbot) y_rb (cadr pt_rightbot))
  	(if(equal str_1 "TOP")
	  	(progn
		  	(setq x_lt (car pt_lefttop) y_lt (+ (cadr pt_lefttop) 2.5))
  			(setq x_rb (car pt_rightbot) y_rb (+ (cadr pt_rightbot) 2.5))
		  )
	);end if
  	
  	(setq ito_center(list (/(+ x_lt x_rb)2.0)
			      (/(+ y_lt y_rb)2.0)))

  	(command "move" "all" "" ito_center "0,0")
  	(command "zoom" "e")

  	(setq list_data nil)
  	(setq list_data(find_center list_data ent_lefttop));调用函数.
  	(setq list_data(find_center list_data ent_rightbot))

  	(setq head_old (car list_data))  	
  	(setq end_old(cadr list_data))
  	(setq head_new(list (car head_old)(cadr head_old)(+ (caddr head_old) 2.5)))
  	(setq end_new(list (car end_old)(cadr end_old)(+ (caddr end_old) 2.5)))
  	(if(equal str_1 "TOP");若是TOP版的时候.
	   (progn
	     	(subst head_new head_old list_data)
	     	(subst end_new end_old list_data)
	   )	  
	)
        (setq return list_data)
  
  )



(defun select_ito_graphic(list_data  / pt_lefttop pt_rightbot ent_in_ito);选择ITO以内图形,并返回.
  ;list_data 是从函数move_ito_zero()返回的两个对位标的实体+坐标数据.
	(command "zoom" "e")	   
  	(setq pt_lefttop(cdr(car list_data)))
  	(setq pt_rightbot(cdr(cadr list_data)))
  	(setq ent_in_ito(ssget"w" pt_rightbot pt_lefttop))	
 )


(defun find_center(list_data entname / total_x total_y center_x center_y numverts
		  data_end data list_unit)
                  ;找出一条多义线的所有点的几何中心坐标值.
                  ;list_data是存放实体名及其中心坐标的变量的表,返回(用来移动凸块).
  
	(setq data(entget entname));取得多义线数据.
 	(setq data_end data)
  	(setq numverts(cdr(assoc 90 data)));取得多义线顶点数。
  	(setq total_x 0.0 total_y 0.0)
  	
  	(while(setq data_head(car data_end))
	  	(setq head (car data_head))  	  	 	   	
 	   	(if(equal head 10)
 	  	   (progn
			(setq total_x (+ total_x (cadr data_head)))
			(setq total_y (+ total_y (caddr data_head)))
		   )
   	        );if
	   	(setq data_end(cdr data_end))
    	)
  	(setq center_x (/ total_x numverts))
  	(setq center_y (/ total_y numverts))
  	(setq list_unit (list(list entname center_x center_y)));建立一个表.
  	(setq list_data(append list_data list_unit));返回值.  
 )


(defun ajust_list(list_data  / list_tmp count num head step_y_1 len i list_i
		  step_y_i newlist  return)
  	;对list_data进行调整，使得按Y坐标排列.
  	;data_list是存放实体名及其坐标的变量的表,返回.
 	(setq list_tmp list_data)
 	(setq num (length list_tmp));表的长度.
  	(setq count 0);用来表示处理了几个最大值.
  	
  	(setq newlist nil);存放新表，用来返回.
	
  	(while list_tmp
    		;(setq tmp list_tmp);tmp用来中间过渡.    	
    		(setq head(car list_tmp))
    		(setq list_tmp(cdr list_tmp));list_tmp去掉头部.
	
    		(setq step_y_1(caddr head))
	
    		(setq len(length list_tmp));取表的长度.
    		(setq i 0)
  		(while(< i len);对head的Y逐一比较
		      (setq list_i(nth i list_tmp))
		      (setq step_y_i(caddr list_i));求第二个表的Y值.
		      (if(> step_y_1 step_y_i)
				(setq count (+ count 1))
		      )
		      (if(equal step_y_1 step_y_i 0.006)
				(setq count (+ count 1))
		      )
		      (setq i (+ i 1))
		);求count的值
    		(if(equal count len)
	  		(setq newlist(append newlist (list head)))
	  		(setq list_tmp(append list_tmp (list head)))
	 	)
        	(setq count 0)
   	 )
  	 (setq return newlist);返回值.
  );函数结束.


(defun cal_row_column(list_data / len return head head_y i list_unit unit_y row column row)
  	(setq len(length list_data))
  	(setq head(car list_data))
  	(setq head_y(caddr head))
  	(setq i 0 row 0)
  	(while(< i len)
	  	(setq list_unit(nth i list_data))
	  	(setq unit_y(caddr list_unit))
	  	(if(equal head_y unit_y 0.006)
		   	(setq row (+ row 1))
		)
	  	(setq i (+ i 1))
	)
  	(setq column(/ len row))
  	(setq return (list row column))
  )


(defun array_unit(ent_units x y xstep ystep / num bool);返回值是单粒是否包含小凸块
  	;(prompt"\n注意:全图必须是只有一个文字,其他图形endchk通过OK!")
  	(command "array" ent_units "" "r" y x ystep xstep)
	(if(not (setq num(sslength ent_units)))
	  	(exit)
	  )  
  	(setq num (sslength ent_units))
  	(if(equal num 1)(setq bool 1))
        (if(equal num 2)(setq bool 2))
	(if(equal num 3)(setq bool 3))
  	(if(equal num 4)(setq bool 4))
  	(if(equal num 5)(setq bool 5))
  	(if(equal num 6)(setq bool 6))
)



(defun c:ysdz( / scale_x           scale_y                 offset_x           dist_moveto_right
	         dist_move_left	   orth_old                osnp_old           ent_insert
	         txt_ss  	   txt_apr                 data_txt           logo
	         content_txt_old   content_txt_new         str_1              
	         layername         str_2                   x                  y
	         xstep             ystep                   ent_units          bool_unit
	         data_ito_center   ent_in_ito              lens_ent
	         icount            entname                 len_list           iter_x
	         iter_y            newy                    dist_to_move       ent
	         dest_coord        yesno                   row                unit_move
	         str3              str_display	           dist_to_move       dest_coord
	         len               inum                    row_column)
  
  	(setq scale_x 1.0  scale_y 0.98540 offset_x 0.15 offset_y 0.25);对收缩系数赋值
  	(setq dist_moveto_right 0.2 dist_move_left 0.2)
  	;(command "pc");为了将层名都改成大写.
  	(setq orth_old(getvar"orthomode") osnp_old (getvar"osmode"))
	(setvar "osmode" 0 )
	(setvar "orthomode" 0)

  	(while(setq ent_insert(ssget"x"(list(cons 0 "insert"))))
	  	(command "explode" ent_insert);炸块
	  )
  ;----------------------------处理文字,顺便看是top还是pi--------------------------
  	(print"\n请点取凸版图形的文字:")
  	(setq txt_ss(ssget ))
  	(setq txt_apr(ssname txt_ss 0))
        (setq data_txt(entget txt_apr))
  	(setq logo(itoa(fix(getvar"cdate"))))
  	(setq content_txt_old(cdr(assoc 1 data_txt)))
  	(setq content_txt_new(strcat content_txt_old " " "QINGYI" " "logo))
  	(setq data_txt(subst(cons 1 content_txt_new)(cons 1 content_txt_old) data_txt))
  	(entmake data_txt)
  ;-----------------------做一些清理工作---------------------------------------
	(setq str_1(is_pi_top content_txt_old));对文字进行判断,看是TOP还是PI,下面好清理图形.

  	(command "layer" "on" "*" "T" "*" "u" "*" "");全部解锁\解冻\打开.
   	(setq layername(cdr(assoc 2(tblnext "layer" T))))
  	(command "layer" "lo" "0" "")
  	(while(setq layername(cdr(assoc 2(tblnext "layer"))))
	      	(setq str_2(is_pi_top layername))
	  	(if(equal str_1 str_2)
		  	(command "layer" "lo" layername "")
		  )
	   	(if(equal layername "COM")
		  	(command "layer" "lo" layername "")
		  )
	  );将layer"0" "top(或pi)" "COM"层锁定
  	(command "erase" "all" "")
  	(command "la" "s" "0" "")
  	(repeat 2 (command "purge" "a" "" "n"))
  	(command "layer" "on" "*" "T" "*" "u" "*" "");全部解锁\解冻\打开.
  ;-----------------单粒排版------------------------------------------------------
  	(setq x (getint"\n请输入X方向个数:"))
 	(setq y (getint"\n请输入Y方向个数:"))
 	(setq xstep (getreal"\n请输入X方向步距:"))
 	(setq ystep (getreal"\n请输入Y方向步距:"))
  	(print"\n请选择单粒:")
 	(setq ent_units(ssget))
  	(setq bool_unit(array_unit ent_units x y xstep ystep));返回值:单粒图形是两个-0?大于两个-1?
  	(command "zoom" "e");bool_unit记载每个单粒中图形个数.
  ;------------------------------移动全图( ITO -> 0,0 )--------------------------------
  	(setq data_ito_center(move_ito_zero str_1))
  	(command "erase" (ssget"x"(list(cons 8 "COM"))) "")
  	(command "la" "s" "0" "")
  	(repeat 2 (command "purge" "a" "" "n"))
  ;---------------------------收缩补偿------------------------ 
  	(setq ent_in_ito(select_ito_graphic data_ito_center))
  	(apr_scale ent_in_ito scale_x scale_y)
  	(apr_ofst ent_in_ito offset_x offset_y)
  ;---------------------对单粒移动---------------------------------------
	(print"\n注意,只能选择大凸块")
  	(setq ent_units(ssget))
  	(while(not ent_units)
	  	(setq ent_units(ssget"\n注意,只能选择大凸块"))
	)
  	(setq lens_ent(sslength ent_units))
  	(setq list_data nil icount 0)
  	(while(< icount lens_ent)
	  	(setq entname(ssname ent_units icount))
	  	(setq list_data(find_center list_data entname))
	  	(setq icount (+ icount 1))
	);建立凸块的链表.
  	(setq list_data(ajust_list list_data));对链表的元素重新排列.
  	(setq len_list(length list_data) iter_x 0 iter_y 0)

	(setq row_column(cal_row_column list_data));从list_data计算出row,column.
  	(setq x (car row_column))
  	(setq newy (/ len_list x))  
  	
  	(while(< iter_y newy)
	  	(setq dist_to_move(- 0.2 (*(/ 0.4 (- newy 1)) iter_y)))
	  	(while(< iter_x x)
		  	(setq ent(car(nth (+(* iter_y x) iter_x) list_data)))
		  	(setq dest_coord(list dist_to_move 0))
		  	(command "move" ent "" "0,0" dest_coord)
		  	(setq iter_x(+ iter_x 1))
		)
	  	(setq iter_y(+ iter_y 1))
	  	(setq iter_x 0)
	  );对每一行单粒移动,只考虑了x列(如果单粒在x方向有2列,就出错)
   
  ;--------------------------如果有小粒块,则也移动----------------------------------
  ;	(setq yesno(getstring"需要移动小单粒吗?(Yes/No):"))
  ;	(if(not (or(equal yesno "N")(equal yesno "n")(equal yesno "")))
;	   (progn
;	  	(setq row 1);记载行数.
;	     	(print"\n请选择第 1 行小单粒:")
 ; 		(setq unit_move(ssget))
  ;		(while(not unit_move)((setq unit_move(ssget"\n请选择第 1 行小单粒:"))))
;	     
 ; 		(while  unit_move
;		  	(setq row(+ row 1))
;	  		(setq str3 (itoa row))
;	  		(setq str_display(strcat"\n请选择第 " str3 " 行小单粒:"))
;	  		(print str_display)
;	  		(setq unit_move(ssget))
;	  		(while(not unit_move)
;			  	(setq str_display(strcat"\n请选择第 " str3 " 行小单粒:"))
;			  	(setq unit_move(ssget))		  	
;			)
;	  		(setq dist_to_move(- 0.2 (*(/ 0.4 (- newy 1)) row)))
;	  		(setq dest_coord(list dist_to_move 0))
;	  		(setq len(sslength unit_move) inum 0)
;	  		(while(< inum len)
;			  	(setq unit(ssname unit_move inum))
;			  	(command "move" unit "0,0" dest_coord)
;			)
;		)
;	     );end progn
;	);end if
  ;---------------------------加边框----------------------------------------
  	(add_frame str_1)
  	(setq str_report(strcat str_1 "版--" "系数是:" (rtos scale_y) ";"
				(rtos scale_x)";"
				(rtos offset_y)";"
				(rtos offset_x)";"
				",Writed by Owal20050715."
				))
  )
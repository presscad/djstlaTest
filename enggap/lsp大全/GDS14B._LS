;last modified date 2003/7/21
;customer change thire design, can the circle used to deside the apr ito center disappear.
;use the new way to get center.
;if the E < 25 use the new scale factor.
;all factor changed ke=0.9784,ce=0.25, cf=0.3
;last modified date 2003/7/28
;ke=0.9784,ce=0.3,cf=0.3
;ke = 0.9784,ce = cf = 0.2;   20040225 CHANGED BY OWAL
;change the border of the apr by using function framein;2004.05.01; by owal;


(defun addfr()
    (arxload "//Supermask/engapp/pubfile/lsp/apr_fr/fr.arx")
    (command "framein" "gdsapr")
    (command "arx" "u" "fr")
  )


(defun draw_edge ()                   ;before date of 2004.05.01
    (command "layer" "m" "OK" "")
					;  (command "pline"
					;	     (list -234.6 -199.5)
					;	     "w"
					;	     0
					;	     0
					;	     (list -283.5 -199.5)
					;	     (list -283.5 -152.867)
					;	     (list -281.5 -152.867)
					;	     (list -281.5 -197.5)
					;	     (list -234.6 -197.5)
					;	     "c"
					;   )
					;  (command "pline"
					;	     (list -281.5 152.566)
					;	     "w"
					;	     0
					;	     0
					;	     (list -281.5 197.5)
					;	     (list -234.6 197.5)
					;	     (list -234.6 199.5)
					;	     (list -283.5 199.5)
					;	     (list -283.5 152.566)
					;	     "c"
					;   )
					;  (command "pline"
					;	     (list 225.8 -197.5)
					;	     "w"
					;	     0
					;	     0
					;	     (list 276.5 -197.5)
					;	     (list 276.5 -152.867)
					;	     (list 278.5 -152.867)
					;	     (list 278.5 -199.5)
					;	     (list 225.8 -199.5)
					;	     "c"
					;   )
					;(command "pline"
					;	     (list 276.5 152.566)
					;	     "w"
					;	     0
					;	     0
					;	     (list 276.5 197.5)
					;	     (list 225.8 197.5)
					;	     (list 225.8 199.5)
					;	     (list 278.5 199.5)
					;	     (list 278.5 152.566)
					;	     "c"
					;   )
    (command "pline"
	     (list -270.257 -199.5)
	     "w"
	     0
	     0
	     (list -283.5 -199.5)
	     (list -283.5 -152.867)
	     (list -281.5 -152.867)
	     (list -281.5 -197.5)
	     (list -270.257 -197.5)
	     "c"
    )
    (command "pline"
	     (list -240.5 -199.5)
	     "w"
	     0
	     0
	     (list -210.5 -199.5)
	     (list -210.5 -197.5)
	     (list -240.5 -197.5)
	     "c"
    )
    (command "pline"
	     (list -270.257 197.5)
	     "w"
	     0
	     0
	     (list -281.5 197.5)
	     (list -281.5 152.566)
	     (list -283.5 152.566)
	     (list -283.5 199.5)
	     (list -270.257 199.5)
	     "c"
    )
    (command "pline"
	     (list -240.5 197.5)
	     "w"
	     0
	     0
	     (list -210.5 197.5)
	     (list -210.5 199.5)
	     (list -240.5 199.5)
	     "c"
    )
    (command "pline"
	     (list 257.796 -197.5)
	     "w"
	     0
	     0
	     (list 276.5 -197.5)
	     (list 276.5 -152.867)
	     (list 278.5 -152.867)
	     (list 278.5 -199.5)
	     (list 257.796 -199.5)
	     "c"
    )
    (command "pline"
	     (list 235.5 -197.5)
	     "w"
	     0
	     0
	     (list 235.5 -199.5)
	     (list 205.5 -199.5)
	     (list 205.5 -197.5)
	     "c"
    )
    (command "pline"
	     (list 235.5 199.5)
	     "w"
	     0
	     0
	     (list 235.5 197.5)
	     (list 205.5 197.5)
	     (list 205.5 199.5)
	     "c"
    )
    (command "pline"
	     (list 257.796 199.5)
	     "w"
	     0
	     0
	     (list 278.5 199.5)
	     (list 278.5 152.566)
	     (list 276.5 152.566)
	     (list 276.5 197.5)
	     (list 257.796 197.5)
	     "c"
    )
    (command "pline"
	     (list 188.0 190.0)
	     "w"
	     0
	     0
	     (list 188.7 190.5)
	     (list 202.3 190.5)
	     (list 203.0 190.0)
	     (list 202.3 189.5)
	     (list 188.7 189.5)
	     "c"
    )
    (command "pline"
	     (list -198.7 196.8)
	     "w"
	     0
	     0
	     (list -198.7 190.5)
	     (list -205.0 190.5)
	     (list -205.7 190.0)
	     (list -205.0 189.5)
	     (list -198.7 189.5)
	     (list -198.7 183.2)
	     (list -198.2 182.5)
	     (list -197.7 183.2)
	     (list -197.7 189.5)
	     (list -191.4 189.5)
	     (list -190.7 190.0)
	     (list -191.4 190.5)
	     (list -197.7 190.5)
	     (list -197.7 196.8)
	     (list -198.2 197.5)
	     "c"
    )
    (command "pline"
	     (list 188.0 -190.0)
	     "w"
	     0
	     0
	     (list 188.7 -190.5)
	     (list 202.3 -190.5)
	     (list 203.0 -190.0)
	     (list 202.3 -189.5)
	     (list 188.7 -189.5)
	     "c"
    )
    (command "pline"
	     (list -198.7 -196.8)
	     "w"
	     0
	     0
	     (list -198.7 -190.5)
	     (list -205.0 -190.5)
	     (list -205.7 -190.0)
	     (list -205.0 -189.5)
	     (list -198.7 -189.5)
	     (list -198.7 -183.2)
	     (list -198.2 -182.5)
	     (list -197.7 -183.2)
	     (list -197.7 -189.5)
	     (list -191.4 -189.5)
	     (list -190.7 -190.0)
	     (list -191.4 -190.5)
	     (list -197.7 -190.5)
	     (list -197.7 -196.8)
	     (list -198.2 -197.5)
	     "c"
    )
  ) ;-----------The function to add frame -----



(defun gds_fr( / pbase xbase)
  (setvar"osmode"0)
  (setvar"osmode"512)
  (setvar"orthomode"0)  
  (setq pbase(getpoint"\n请输入一个dummy上最左边的任意点:"))
  (setvar"osmode"0)
  (setq xbase(car pbase))
  (setq xbase(- xbase 2.5))
  (command "pline"       (list (+ -0.5 xbase) -196.8) "w" 0 0 
                         (list (+ -0.5 xbase) -190.5) 
                         (list (+ -6.8 xbase) -190.5) 
                         (list (+ -7.5 xbase) -190.0) 
                         (list (+ -6.8 xbase) -189.5) 
                         (list (+ -0.5 xbase) -189.5) 
                         (list (+ -0.5 xbase) -183.2) 
                         (list (+ 0.0  xbase) -182.5) 
                         (list (+ 0.5  xbase) -183.2) 
                         (list (+ 0.5  xbase) -189.5) 
                         (list (+ 6.8  xbase) -189.5) 
                         (list (+ 7.5  xbase) -190.0) 
                         (list (+ 6.8  xbase) -190.5) 
                         (list (+ 0.5  xbase) -190.5) 
                         (list (+ 0.5  xbase) -196.8) 
                         (list (+ 0.0  xbase) -197.5) 
                         "c"
         )
        (command "pline" (list (+ -0.5 xbase) 196.8) "w" 0 0 
                         (list (+ -0.5 xbase) 190.5) 
                         (list (+ -6.8 xbase) 190.5) 
                         (list (+ -7.5 xbase) 190.0) 
                         (list (+ -6.8 xbase) 189.5) 
                         (list (+ -0.5 xbase) 189.5) 
                         (list (+ -0.5 xbase) 183.2) 
                         (list (+ 0.0  xbase) 182.5) 
                         (list (+ 0.5  xbase) 183.2) 
                         (list (+ 0.5  xbase) 189.5) 
                         (list (+ 6.8  xbase) 189.5) 
                         (list (+ 7.5  xbase) 190.0) 
                         (list (+ 6.8  xbase) 190.5) 
                         (list (+ 0.5  xbase) 190.5) 
                         (list (+ 0.5  xbase) 196.8) 
                         (list (+ 0.0  xbase) 197.5) 
                         "c"
         )   ;draw  two "+" on the right


         (command "pline" (list -270.257 -199.5) "w" 0 0 
                         (list -283.5 -199.5) 
                         (list -283.5 -152.867) 
                         (list -281.5 -152.867) 
                         (list -281.5 -197.5) 
                         (list -270.257 -197.5) 
                         "c"
         )
        (command "pline" (list -270.257 197.5) "w" 0 0 
                         (list -281.5 197.5) 
                         (list -281.5 152.566) 
                         (list -283.5 152.566) 
                         (list -283.5 199.5) 
                         (list -270.257 199.5) 
                         "c"
         )
        (command "pline" (list 257.796 -197.5) "w" 0 0 
                         (list 276.5 -197.5) 
                         (list 276.5 -152.867) 
                         (list 278.5 -152.867) 
                         (list 278.5 -199.5) 
                         (list 257.796 -199.5) 
                         "c"
         )
        (command "pline" (list 257.796 199.5) "w" 0 0 
                         (list 278.5 199.5) 
                         (list 278.5 152.566) 
                         (list 276.5 152.566) 
                         (list 276.5 197.5) 
                         (list 257.796 197.5) 
                         "c"
         )
        (command "pline" (list -283.5 199.5) "w" 0 0 
                         (list -240.5 199.5) 
                         (list -240.5 197.5) 
                         (list -283.5 197.5) 
                         "c"
         )
        (command "pline" (list -210.5 197.5) "w" 0 0 
                         (list -150.5 197.5) 
                         (list -150.5 199.5) 
                         (list -210.5 199.5) 
                         "c"
         )
        (command "pline" (list 278.5 199.5) "w" 0 0 
                         (list 235.5 199.5) 
                         (list 235.5 197.5) 
                         (list 278.5 197.5) 
                         "c"
         )
        (command "pline" (list 205.5 199.5) "w" 0 0 
                         (list 145.5 199.5) 
                         (list 145.5 197.5) 
                         (list 205.5 197.5) 
                         "c"
         )
        (command "pline" (list -283.5 -199.5) "w" 0 0 
                         (list -240.5 -199.5) 
                         (list -240.5 -197.5) 
                         (list -283.5 -197.5) 
                         "c"
         )
        (command "pline" (list -210.5 -199.5) "w" 0 0 
                         (list -150.5 -199.5) 
                         (list -150.5 -197.5) 
                         (list -210.5 -197.5) 
                         "c"
         )
        (command "pline" (list 278.5 -199.5) "w" 0 0 
                         (list 235.5 -199.5) 
                         (list 235.5 -197.5) 
                         (list 278.5 -197.5) 
                         "c"
         )
        (command "pline" (list 205.5 -197.5) "w" 0 0 
                         (list 145.5 -197.5) 
                         (list 145.5 -199.5) 
                         (list 205.5 -199.5) 
                         "c"
         )
        (command "pline" (list 188.0 -190.0) "w" 0 0 
                         (list 188.7 -190.5) 
                         (list 202.3 -190.5) 
                         (list 203.0 -190.0) 
                         (list 202.3 -189.5) 
                         (list 188.7 -189.5) 
                         "c"
         )
        (command "pline" (list 188.0 190.0) "w" 0 0 
                         (list 188.7 190.5) 
                         (list 202.3 190.5) 
                         (list 203.0 190.0) 
                         (list 202.3 189.5) 
                         (list 188.7 189.5) 
                         "c"
         )
 );---------------The function to add a frame!



          
                    ;-------------------------------------------------------------------
(defun c:gdsapr	()  ;------------------------Main function();---------------------------
  (defun set_var () ;-------------------------------------------------------------------
    (setq osnap_old (getvar "osmode"))
    (setq orthomode_old (getvar "orthomode"))
    (setvar "osmode" 0)
    (setvar "orthomode" 0)
    (list osnap_old orthomode_old)
    (setvar"gridmode"0)
  );--Set the environment;

  
  
  (defun to_0 ()
    (command "zoom" "E")    
    (setq
      4c (ssget	"x"
		(list (cons 0 "CIRCLE") (cons 8 "2") (cons 40 2.0))
	 )
    )    
    (if 4c
    (if	(= (sslength 4c) 4)
      (progn
	(setq i_loop 0)
	(setq xc 0)
	(setq yc 0)
	(repeat	4
	  (setq circle_dt (entget (ssname 4c i_loop)))
	  (setq xc (+ xc (car (cdr (assoc 10 circle_dt)))))
	  (setq yc (+ yc (cadr (cdr (assoc 10 circle_dt)))))
	  (setq i_loop (1+ i_loop))
	)
	(setq xc (/ xc 4))
	(setq yc (/ yc 4))
      )
    )
       (progn
	(setvar "osmode" 1)
	(setq apr_ld_cn (getpoint "/n请点选凸版外框的左下角"))
	(setvar "osmode" 0)
	(setq xc (+ (car apr_ld_cn) 291))
	(setq yc (+ (cadr apr_ld_cn) 197.5))
	)
      )
    (command "move" "all" "" (list xc yc) "0,0")
  )


  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;added by owal
    (setq 4d(ssget"x"(list(cons 0 "circle")(cons 40 2.0))))
    (if 4d(alert"请注意，在非002层发现有半径为2.0的圆"))

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;end;;;;;;;;;;;


  
  (defun chg_txt() 
    ;(setq
    ;  4c (ssget	"x"
;		(list (cons 0 "CIRCLE") (cons 8 "2") (cons 40 2.0))
;	 )
 ;   )
  ;  (if	(= (sslength 4c) 4)
   ;   (progn
;	(setq i_loop 0)
;	(setq xc 0)
;	(setq yc 0)
;	(repeat	4
;	  (setq circle_dt (entget (ssname 4c i_loop)))
;	  (setq xc (+ xc (car (cdr (assoc 10 circle_dt)))))
;	  (setq yc (+ yc (cadr (cdr (assoc 10 circle_dt)))))
;	  (setq i_loop (1+ i_loop))
;	)
;	(setq xc (/ xc 4))
;	(setq yc (/ yc 4))
 ;     )
  ;  )
    (setq pt_lst (list (list -250 -200) (list 250 -200) (list 250 200) (list -250 200)))
    (command "zoom" "E")
    (setq
      ss_txt (ssget "WP" pt_lst (list (cons 0 "TEXT") (cons 8 "1")))
    )
    (if	(= (sslength ss_txt) 1)
      (progn
	(setq txt_dt (entget (ssname ss_txt 0)))
	(setq txt_dt (subst (cons 8 "OK") (assoc 8 txt_dt) txt_dt))
	(setq apr_id (cdr (assoc 1 txt_dt)))
	(setq c_date (getvar "CDATE"))
	(setq apr_id (strcat apr_id " QINGYI " (itoa (fix c_date))))
	(setq txt_dt (subst (cons 1 apr_id) (assoc 1 txt_dt) txt_dt))
	(entmake txt_dt)
      )
    )
  )

  (defun scale (layer_name ke)
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
	  (setq dt nil)
	  (while pl_dt
	    (if	(/= (caar pl_dt) 10)
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
	  (setq dt (subst (cons 8 "OK") (cons 8 layer_name) dt))
	  (entmake dt)
	  (setq i_loop (1+ i_loop))
	)
      )
    )
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
  (defun ofst (layer_name ce cf)
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
		  (setq ofst_x (- ofst_x ce))
		  (setq ofst_x (+ ofst_x ce))
		)
		(if (> ofst_y cy)
		  (setq ofst_y (- ofst_y cf))
		  (setq ofst_y (+ ofst_y cf))
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
  ;(initget "Yes No")  
  ;(setq	apr_type
;	 (getKword
;	   "\n当液体凸版的E小于25时,需要特别的系数,这张版需要特别的系数吗？(Yes/No)"
;	 )
;  )
;  (if (= apr_type "No")
;  (setq	ke 0.97800
;	ce 0.10000
;	cf 0.10000
;  )
    (setq
        ke 0.97840
	ce 0.20000
	cf 0.20000
  )
;  )
  (getstring (strcat "2004-02-02 changed by owal请确认系数是：Ke=" (rtos ke) "; Ce=" (rtos ce) "; Cf=" (rtos cf)))
  (command "zoom" "E")
  ;(setq	4c (ssget "x"
;		  (list (cons 0 "CIRCLE") (cons 8 "1") (cons 40 2.0))
;	   )
;  )
  ;(if 4c
  ;  (command "change" 4c "" "p" "la" "2" "")
  ;  (progn
  ;    ("\n 不能发现1层的4个半径为2mm圆，如在其它层发现，请手工将其放入一层。"
   ;   )
    ;  (exit)
   ; )
 ; )
  (command "layer" "on" "*" "thaw" "*" "unlock" "*"  "")
  (to_0)
  (chg_txt)    
  (command "layer" "M" "0" "F" "2" "F" "002" "F" "OK" "")
  (command "erase" "all" "")
  (command "layer" "T" "2" "T" "002" "T" "OK" "")
  (command "zoom" "E")
  (scale "002" ke)
  (ofst "OK" (/ ce 2) (/ cf 2))
  (scale "2" ke)
  ;(draw_edge) ;------------------------------->This function is substitued by command framein at 2004.05.01;
  
  (command "zoom" "E")
  (command "layer" "M" "0" "F" "OK" "")
  (command "erase" "all" "")
  (command "layer" "M" "0" "T" "OK" "")
  (command "change" "all" "" "p" "la" "0" "")
  (command "purge"     "all" ""	   "y"	 "y"   "y"   "y"   "y"	 "y"
	   "y"	 "y"   "y"   "y"   "y"	 "y"   "y"   "y"   "y"	 "y"
	   "y"	 "y"   "y"   "y"   "y"	 "y"   "y"   "y"   "y"	 "y"
	   "y"	 "y"   "y"   "y"   "y"	 "y"   "y"   "y"   "y"	 "y"
	   "y"	 "y"   "y"   "y"   "y"	 "y"   "y"   "y"   "y"	 "y"
	   "y"	 "y"   "y"   "y"   "y"	 "y"   "y"   "y"   "y"	 "y"
	   "y"	 "y"   "y"   "y"   "y"	 "y"   "y"   "y"   "y"	 "y"
	   ""
	  )
  (command "purge"     "all" ""	   "y"	 "y"   "y"   "y"   "y"	 "y"
	   "y"	 "y"   "y"   "y"   "y"	 "y"   "y"   "y"   "y"	 "y"
	   "y"	 "y"   "y"   "y"   "y"	 "y"   "y"   "y"   "y"	 "y"
	   "y"	 "y"   "y"   "y"   "y"	 "y"   ""
	  )
  (command "purge"     "all" ""	   "y"	 "y"   "y"   "y"   "y"	 "y"
	   "y"	 "y"   "y"   "y"   "y"	 "y"   "y"   "y"   "y"	 "y"
	   ""
	  )
  (command "purge" "all" "" "y" "y" "y" "y" "y" "y" "")
  (command "zoom" "E")
  (setq	4c (ssget "x"
		  (list (cons 0 "CIRCLE"))
	   )
  )
  (if 4c
    (progn
      (command "layer" "N" "0C" "")
      (command "change" 4c "" "p" "la" "0c" "")
    )
    ;(progn
    ;  ("\n Can't find the 4 circle")
    ;  (exit)
    ;)
  )
  

  
  (gds_fr);(addfr)
  (getstring  "\n请手工做CUT")
)
(getstring "\n 输入 GDSAPR 运行程序,运行程序前,请先对2层与002层进行TOPL处理。")
(getstring"\n")
(getstring"\n请注意左边的十字标记要移按客户规定的尺寸移动")
(getstring"\n")

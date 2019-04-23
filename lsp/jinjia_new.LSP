
;-----------------------------------------------------------
;ÊÖ¹¤×ö·¨£ºÒÔÓ¡Ë¢·½ÏòÎªÝSÈ«Í¼¾µÏñ¡¢ITO¾ÓÖÐ¡¢ITOÄÚÊÕËõ¡¢     
;PIºÍTOPÏµÊý²»Ò»Ñù¡¢                                        
;          Ì×¾É±ß¿òPIºÍTOPÒ»Ñù£                              
;ÏµÊý£ºpi--ke = 0.9832 ce = cf = 0.175                      
;      top-ke = 0.9829 ce = cf = 0.175                      
;-----------------------------------2004-06-22 by Cxf       


;ÏµÊý£ºpi--ke = 0.9832 ce = cf = 0.175                      
;      top-ke = 0.9829 ce = cf = 0.200                      
;-----------------------------------2004-12-29 by zhg
;ÏµÊý£ºpi--ke = 0.9835 ce = cf = 0.175                      
;      top-ke = 0.9835 ce = 0.2 cf = 0.15                    
;-----------------------------------2005-04-21 by cxf

;ÏµÊý£ºpi--ke = 0.9835 ce = cf = 0.25                      
;      top-ke = 0.9838 ce = 0.4 cf = 0.3                    
;-----------------------------------2006-11-16 by zhg       

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
    
  )   ;        defun scale(layer_name ke)                                                          




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
  )   ;      defun ofst (layer_name cf1 ce1)                                                           


(defun draw_edge_pi()
  ;draw edge
      (command "pline"
	   (list -212.0  257.5)
	   "w"
	   0
	   0
	   (list -210.0 257.5)
	   (list -210.0  272.5)
	   (list 210.0   272.5)          
	   (list 210.0000   257.5000)
	   (list 212.0000   257.5000)
	   (list 212.0000  274.5000)
	   (list -212.0000  274.5000)
	   "c")
      (command "pline"
	   (list -212.0000 -222.5000)
	   "w"
	   0
	   0
	   (list -212.0000  222.5000)
	   (list -210.0000  222.5000)
	   (list -210.0000  -222.5000)
	  "c" )    
      (command "pline"
	   (list -212.0000  -257.5000)
	   "w"
	    0
	    0
	    (list -210.0000  -257.5000)
		 (list -210.0000  -272.5000)
		 (list 210.0000   -272.5000)
		 (list 210.0000   -257.5000)
		 (list 212.0000   -257.5000)
		 (list 212.0000   -274.5000)
		 (list -212.0000  -274.5000)
		 "c" )       
      (command "pline"
		(list 212.0000  -222.5000)
		"w"
		0
		0
		(list 210.0000  -222.5000)
		(list 210.0000  222.5000)
		(list 212.0000  222.5000)
		"c" )
  )



(defun draw_edge_top()
    ;draw edge
      (command "pline"
	   (list -212.0  257.5)
	   "w"
	   0
	   0
	   (list -210.0    257.5   )
	   (list -210.0    272.5   )
	   (list 210.0     272.5   )          
	   (list 210.0000  257.5000)
	   (list 212.0000  257.5000)
	   (list 212.0000  274.5000)
	   (list -212.000  274.5000)
	   "c"
       )
      (command "pline"
	   (list -212.0000 -222.5000)
	   "w"
	   0
	   0
	   (list -212.0000  222.5000)
	   (list -210.0000  222.5000)
	   (list -210.0000  -222.5000)
	  "c"
        )
    
    
      
        
      (command "pline"
		 (list -212.0000  -257.5000)
		 "w"
		 0
		 0
		 (list -210.0000  -257.5000)
		 (list -210.0000  -272.5000)
		 (list 210.0000   -272.5000)
		 (list 210.0000   -257.5000)
		 (list 212.0000   -257.5000)
		 (list 212.0000   -274.5000)
		 (list -212.0000  -274.5000)
		 "c"
         )
        
        
       
       
      (command "pline"
		(list 212.0000  -222.5000)
		"w"
		0
		0
		(list 210.0000  -222.5000)
		(list 210.0000  222.5000)
		(list 212.0000  222.5000)
		"c"
         )
  
  )


(defun draw_edge(flag /)
       (if (equal flag 1)(draw_edge_pi))
       (if (equal flag 2)(draw_edge_top))  
  )


(defun is_pi_top()
       (setq txt_ss(ssget"x"(list(cons 0 "text"))))
       (setq sslen(sslength txt_ss))
       (if (equal sslen 1)(setq txt(ssname txt_ss 0)))
       (if txt(setq txt_apr(cdr (assoc 1 (entget txt)))))
       (setq txt_back txt_apr)
  
       (if txt_apr(setq txt_len(strlen txt_apr)))

       (while(>= txt_len 3)
             (setq is_txt(substr txt_apr 1 3))
             (if (equal is_txt "P.I")
                 (setq ke 0.9835
	               ce1 0.125
	               cf1 0.125
	               flag 1)	 
             );endif	     

             (if (equal is_txt "TOP")
                 (setq ke 0.9838
	               ce1 0.2
	               cf1 0.15
	               flag 2    )	  	   
             );endif
	     
    
             (setq txt_apr(substr txt_apr 2))
             (setq txt_len(strlen txt_apr))
        )

        (while(>= txt_len 2)
             (setq is_txt(substr txt_back 1 2))
             (if (equal is_txt "PI")
                 (setq ke 0.9835
	               ce1 0.125
	               cf1 0.125
	               flag 1)
	       );endif               
             (setq txt_back(substr txt_back 2))
             (setq txt_len(strlen txt_back))
        )
  )






(defun c:jinjia()  
  (setvar "osmode" 1)
  (command "deldim""")
  (setq apr_ld_cn (getpoint "/nÇëµãÑ¡Í¹°æITOµÄ×óÏÂ½Ç"))
  (setvar "osmode" 0)
  (setq xc (+(car apr_ld_cn) 185 ))
  (setq yc (+(cadr apr_ld_cn)  200))
  (command "move" "all" "" (list xc yc) "0,0")
  (command "mirror""all""""0,0""0,9""y")
  (command "layer" "on" "*" "thaw" "*" "unlock" "*"  "")
  (command "layer""lo""apr""lo""top""")
  (command "clear""")
  (command "layer""unlock""apr""")
  (command "layer""unlock""top""")
  (command "layer""n""ok""")
  
  (command "zoom" "e")
  (setq ss (ssget "w" '(-210 -222.5) '(210 222.5)))
  (command "change" ss """p""la""ok""")
  (command "layer""lock""ok""")
  (command "clear""")
  (command "layer""unlock""ok""")
  (command "zoom" "e")
  (command "layer""n""scl""")
  (setq sc (ssget "w" '(-185 -200) '(185 200)))
  (command "change" sc """p""la""scl""")
  
  
   (is_pi_top)
  
  
  (scale "scl" ke)
  (command "layer""n""ofst""")
  
  (prompt "/nÇëÑ¡ÖÐËùÓÐµ¥Á££¡")
  (setq cells (ssget))
  (command "change" cells "" "p" "la" "ofst" "")
  (ofst "ofst" cf1 ce1)
  ;change text
  (setq ss_txt (ssget "x" (list (cons 0 "TEXT"))))
    (if	(= (sslength ss_txt) 1)
      (progn
	(setq txt_dt (entget (ssname ss_txt 0)))	
	(setq apr_id (cdr (assoc 1 txt_dt)))
	(setq c_date (getvar "CDATE"))
	(setq apr_id (strcat apr_id " QINGYI " (itoa (fix c_date))))
	(setq apr_id (strcase apr_id))
	(setq txt_dt (subst (cons 1 apr_id) (assoc 1 txt_dt) txt_dt))	
	(setq txt_dt (subst (cons 10 '(-500 -500 0)) (assoc 8 txt_dt) txt_dt))
	(entmod txt_dt)
      )
    )
  (draw_edge flag)
  
  (command "change" "all" "" "p" "la" "0" "")
  (command "layer" "m" "0" "")
  (command "purge"   "all"  ""	"N")
  (command "purge"   "all" ""  "n")
  (command "purge"   "all"  ""	"N")
  (command "purge"   "all" ""  "n")
  (command "zoom" "E")
  (if (equal flag 1)
      (getstring (strcat "2004-06-20 writen by XifengChengÇëÈ·ÈÏÏµÊýÊÇ£ºKe="
	         (rtos ke) "; Ce=" (rtos (* 2 ce1)) "; Cf=" (rtos (* 2 cf1)) "---PI°æ")
      )
      
  )
  (if (equal flag 2)
      (getstring (strcat "2004-06-20 writen by XifengChengÇëÈ·ÈÏÏµÊýÊÇ£ºKe="
	         (rtos ke) "; Ce=" (rtos (* 2 ce1)) "; Cf=" (rtos (* 2 cf1)) "---TOP°æ")
      )
      
  )
)
(PROMPT "\n ÊäÈë Jinjia ÔËÐÐ³ÌÐò")


  
(defun c:xr(/ ss_b ss_gr ss_back first first_1 gr_name textname textnum  textatt text_style
               ipoot)
	(setq ss_gr(dictsearch (namedobjdict) "ACAD_GROUP"))
  	(setq ss_back ss_gr)
  	(setq first nil)
  	(while  (setq first(car ss_back))
                (setq first_1 (car first))
	  
	        (if (equal first_1 3)
		    (progn
		      (setq gr_name(cdr first))
		      (command "-group" "e" gr_name "" )
		    )	  		    
	         )
	  
	        (setq ss_back(cdr  ss_back))	        
         )
        (while   
                (setq ss_b(ssget "x"(list (cons 0 "insert"))))
	        (command "explode" ss_b "")
                (setq ss_b(ssget "x"(list (cons 0 "insert"))))
	)
        (while
                (setq ss_hatch(ssget "x"(list (cons 0 "hatch"))))
                (command "erase" ss_hatch "")   
        )  
  )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun c:ar(/ textname ipoot textnum textatt text_style)
    (setvar "orthomode" 0)
    (setvar "snapmode" 0)
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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(defun c:txt(/ textname ipoot textnum textatt text_style)
    (setvar "orthomode" 0)
    (setvar "snapmode" 0)
    (setq textname(ssget "x"(list (cons 0 "text"))))
    (setq ipoot 0 )
    (setq textnum(sslength textname ))
    (while
      (if (< ipoot textnum)
           (progn
           (setq textatt(entget(ssname textname ipoot)))
           (setq text_style(cdr(assoc 7 textatt)))
           (command "-style" text_style "txt.shx" "" "" "" "" "" "n")
	   (setq ipoot(1+ ipoot))
      )
     )
   )
  )




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun c:jd(/ textname ipoot textnum textatt text_style 3um_width count line_data)
    (setvar "orthomode" 0)
    (setvar "snapmode" 0)
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
       (command "layer" "n" "aaa" "")
       (setq 3um_width(ssget "x"(list (cons 40 0.003))))
       (command "change" 3um_width "" "p" "la" "aaa" "")
       (setq i_poot(sslength 3um_width))
       (setq count 0)
       (while
	 (if(< count i_poot)
	    (progn
	    (setq line_data(entget(ssname 3um_width count)))
	    (setq line_data(subst (cons 43 0.0035) (assoc 43 line_data)  line_data))
	    (entmod line_data)
	    )
	   )
	 (setq count(1+ count))
	 ) 
  )
    
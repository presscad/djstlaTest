;;  =================================================
;;;;??:?????,???????????,??0.1,?????;
;;;;      ????????,?????"?"?z??,?"??";?????1;
;;;;???zd??,zd?????;
;;  =================================================
(defun makeInsertsWithHeight( pt /)
  (setq att_text(rtos (caddr pt))) ;;;????;

  (setq bnm "_NBT_cross")
  (if (null (tblsearch "BLOCK" bnm))
      (progn
	  (ENTMAKE '((0 . "BLOCK")  ;;;block head;
		     (8 . "0")
		     (10 0.0 0.0 0.0)
		     (2 . "_NBT_cross")
		     (70 . 2)	     
		     (1 . "")
		     )
	  ) ;;;entmake;
	  
	 
	  ;(draw_point_of_block pt) ;;;block content;
	(command "circle" (list 0 0) 100)
	  
	 
	  (ENTMAKE '((0 . "Endblk"))) ;;;block end;
       );progn
  ) ;if 

  
  (entmake (list '(0 . "INSERT")(cons 66 1) (cons 2 "_NBT_cross") (cons 10 pt))) ;;;entmake insert;
  
  ;;;add attribution to block
  (entmake (list
	     '(0 . "ATTRIB")
	     '(100 . "AcDbEntity")
	     '(100 . "AcDbText")
	     (cons 10 pt)
	     (cons 40 1)  ;text height;
	     (cons 1  att_text)
	     '(100 . "AcDbAttribute")
	     (cons 2  "A")
	     ;(cons 3  "hello")
	     '(70 . 2);(70 . 1)??????  (70 . 0)?????
	     )
	   )    
  (entmake '((0 . "SEQEND")))
)


;???????;
(defun draw_point_of_block(pt /)
  (setq basex (car pt))
  (setq basey (cadr pt))
  (setq pt1 (list (+ -0.05 basex) basey 0 ))
  (setq pt2 (list (+ 0.05 basex) basey 0))
  (entmake (append (list '(0 . "LWPOLYLINE")		
			 '(100 . "AcDbEntity")
			 '(67 . 0)
			 '(410 . "Model")
			 ;'(8 . "0")  ;layer name
			 '(6 . "Continuous")
			 '(100 . "AcDbPolyline")
			 '(90 . 2)
			 '(70 . 129)
			 '(43 . 0.1)
			 '(38 . 0.0) 
			 '(39 . 0.0)
			  (cons 10 pt1)  ;vertex
			 '(40 . 0.1) ;width of start point
			 '(41 . 0.1) ;width of end point
			 '(42 . 1.0) ;bugle
			 '(91 . 0)
			  (cons 10 pt2) ;vertex
			 '(40 . 0.1)
			 '(41 . 0.1)
			 '(42 . 1.0)
			 '(91 . 0)
			 '(210 0.0 0.0 1.0)
		     )
	    ) ;append
  )
)



;a sample,just to be reference;
;how to make a insert with attribution text? read it;
(defun c:qqs()
	(PROGN
	  (ENTMAKE '((0 . "BLOCK")
		     (8 . "0")
		     (10 0.0 0.0 0.0)
		     (2 . "_NBT_cross")
		     (70 . 2)
		     (1 . "")
		    )
	  )
	  (ENTMAKE '((0 . "LINE")
		     (8 . "0")
		     (67 . 0)
		     (10 0.353553 -0.353553 0.0)
		     (11 -0.353553 0.353553 0.0)
		     (210 0.0 0.0 1.0)
		    )
	  )
	  (ENTMAKE '((0 . "LINE")
		     (8 . "0")
		     (10 -0.353553 -0.353553 0.0)
		     (11 0.353553 0.353553 0.0)
		    )
	  )
	  (ENTMAKE
	    '((0 . "LINE") (8 . "0") (10 0.0 0.0 0.0) (11 -1.0 0.0 0.0))
	  )
;;;	  (ENTMAKE (list '(0 . "ATTDEF")
;;;		 (cons 10 '(1 0 0))
;;;		 (cons 11 '(1 0 0))
;;;		 (cons 40 1)		 
;;;		 (cons 1 "0.1")
;;;		 (cons 3 "0.2")
;;;		 (cons 2  "heigth") ;height
;;;		 '(74 . 2)
;;;		 '(70 . 2))
;;;	  )
	  (ENTMAKE '((0 . "Endblk")))
	)

  	(setq pt(getpoint "\n Please input the insert point:"))
        (entmake (list '(0 . "INSERT")(cons 66 1) (cons 2 "_NBT_cross") (cons 10 pt)))
  
	  (entmake (list
	               '(0 . "ATTRIB")
	               '(100 . "AcDbEntity")
	               '(100 . "AcDbText")
	                (cons 10 pt)
	                (cons 40 1)
	                (cons 1  "height_val")  
	               '(100 . "AcDbAttribute")
	                (cons 2  "A")
		        ;(cons 3  "hello")
	               '(70 . 2);(70 . 1)??????  (70 . 0)?????
	           )
	   )    
	  (entmake '((0 . "SEQEND")))
)


;;;  =================================================
;;;   entmake??&????? v1.0
;;;   ??:Mr.Meng      ??:(list-count lst)    ??:2015?5?11?
;;;   ??:??&?????
;;;   ??????——>?????:?????+?????(????????) ????: ??+?????——>??? ??????????????
;;;   ???????,????????,???????????bylayer
;;;   ???????trans,????????????
;;;  =================================================
;(entmake (list '(0 . "LINE") (cons 10 pt1) (cons 11 pt2)))
;(entmake (list '(0 . "CIRCLE") (cons 10 pt) (cons 40 r)))
(defun qqt()
	(entmake (list 
	    '(0 . "block")           
	     (cons 2 "$$$$myequip$$$$0001") ;???
	    '(70 . 2)                 ;??????????
	    '(10 0.0 0.0 0.0))        ;??
	);block??
	(entmake (list 
	    '(0 . "LINE") 
	    '(10 0.353553 0.353553 0.0) 
	    '(11 -0.353553 -0.353553 0.0))
	);block????
	(entmake (list 
	    '(0 . "LINE") 
	    '(10 -0.353553 0.353553 0.0) 
	    '(11 0.353553 -0.353553 0.0))
	);block????
	(entmake (list 
	    '(0 . "CIRCLE")
	    '(10 0.0 0.0 0.0) 
	    '(40 . 0.5))
	);block???
	(entmake '((0 . "ENDBLK")));????

	(entmake (list '(0 . "INSERT") '(66 . 1) (cons 2 "$$$$myequip$$$$0001") '(10 0.0 0.0 0.0) 
	                '(41 . 500.0) '(42 . 500.0) '(43 . 500.0) ))
	   (entmake (list
	               '(0 . "ATTRIB")
	               '(100 . "AcDbEntity")
	               '(100 . "AcDbText")
	               '(10 0.0 0.0 0.0)
	                (cons 40 150)
	                (cons 1 "?????")
	               '(100 . "AcDbAttribute")
	                (cons 2 "A")
	               '(70 . 2);(70 . 1)??????  (70 . 0)?????
	                  )
	   )    
	  (entmake '((0 . "SEQEND")))
	  (entlast)
  )

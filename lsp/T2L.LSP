(defun zoom_4_select ( lst / a b)

 (setq  lst (lsttrans lst 1 2) 
          a (maxminpnt (lsttrans (viewpnts) 1 2))
          b (maxminpnt (append a lst))
 );setq 

 (if (not (equal a b))
     (progn
      (setq b (list (trans (append (car b) '(0.0))  2 1)
                    (trans (append (cadr b) '(0.0)) 2 1)
              )
      );setq
     );progn
     (setq b nil)
 );if

 

  );defun zoom_4_select

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;pixel_unit
;returns the size of a single pixel in drawing units.
;value depends on current zoom factor.
;
;pixunit/viewsize = one pixel/yscreensize
;
;pixunit=viewsize/yscreensize 
;
(defun pixel_unit ( / x y x1 y1)
 (setq  y (getvar "viewsize")
       x1 (car (getvar "screensize"))
       y1 (cadr (getvar "screensize"))
        x (* y (/ x1 y1))
 );setq
 (max (abs (/ y y1))
      (abs (/ x x1))
 );max
);defun pixel_unit



(defun maxminpnt ( lst / x n a b c d)

(setq x (car lst)
      a (car x)
      b (cadr x)
      c (car x)
      d (cadr x)
      n 1
);setq
(repeat (max (- (length lst) 1) 0)
(setq x (nth n lst));setq
(setq a (min a (car x))
      b (min b (cadr x))
      c (max c (car x))
      d (max d (cadr x))
);setq
(setq n (+ n 1));setq
);repeat
(list (list a b)
      (list c d)
);list
)

(defun lsttrans ( lst a b / lst2 c n)

(setq n 0);setq
(repeat (length lst)
(setq	 c (nth n lst)
	 c (trans c a b)
      lst2 (append lst2 (list c))
);setq
(setq n (+ n 1));setq
);repeat

lst2
)


;viewpnts
;returns lower left and upper right coords of current view
(defun viewpnts ( / a b c d x)

(setq b (getvar "viewsize")
      c (car (getvar "screensize"))
      d (cadr (getvar "screensize"))
      a (* b (/ c d))
      x (setq x (getvar "viewctr"))
      x (trans x 1 2)
      c (list (- (car x)  (/ a 2.0))
              (- (cadr x) (/ b 2.0))
              0.0
        );list
      d (list (+ (car x)  (/ a 2.0))
              (+ (cadr x) (/ b 2.0))
              0.0
        );list
      c (trans c 2 1)
      d (trans d 2 1) 
);setq

(list c d)
);defun viewpnts


(defun b_layer_locked ( la / na e1)
 (setq na (tblobjname "layer" la)
       e1 (entget na)
 );setq
 (equal 4 
        (logand 4 (cdr (assoc 70 e1)))
 );equal
);defun b_layer_locked


(defun c:t2l ()
  (setvar "MIRRTEXT" 1)
  (SETVAR "PLINEWID" 0)
  (setq	layer_name
	 (strcase (getstring "请键入层名(直接回车将处理所有层):"))
  )
  (while (and (not (setq found (tblsearch "LAYER" layer_name)))
	      (/= layer_name "")
	 )
    (setq layer_name (getstring "请键入层名(直接回车将处理所有层):"))
  )
  (if found
    (progn  
      (tp layer_name)
    )
    (progn
      (setq layer_name_lst nil)
      (setq layer_name (cdadr (tblnext "LAYER" T)))
      (while layer_name
	(setq layer_name_lst
	       (append layer_name_lst (list layer_name))
	)
	(setq layer_name (cdadr (tblnext "LAYER")))
      )
      (setq I_th 0)
      (setq layer_name (nth i_th layer_name_lst))
      (while layer_name
	(if (/= layer_name "PROBLEM")
	  (progn
	    (tp layer_name)
	  )
	)
	(setq i_th (+ i_th 1))
	(setq layer_name (nth i_th layer_name_lst))
      )
    )
  )
  (command "zoom" "e")
)


(defun tp (lay_name / grplst getgname mtextbox ucs_2_mtext FLTR GLST GDICT SS VIEW
                   UPLFT TMPFIL TMPFIL CNT PT1 PT2 ENT TXT TXTTYP PTLST ZM LOCKED)
  

; --------------------- GROUP LIST FUNCTION ----------------------
;   This function will return a list of all the group names in the
;   drawing and their entity names in the form:
;   ((<ename1> . <name1>) ... (<enamex> . <namex>))
; ----------------------------------------------------------------


  
  (setq width (getstring (strcat "输入 " lay_name "层线条宽度：")))
  (if (/= width "")
    (setq width (atof width))
    (setq width 0)
  )
  (if (<= width 0)
    (progn
    (setq width 0)
    (setq w_0 0)
    )
    (progn
    (setq width (/ width 2))
    (setq w_0 1)
    )
  )
  
  (defun grplst (/ GRP MSTR ITM NAM ENT GLST)

    (setq GRP  (dictsearch (namedobjdict) "ACAD_GROUP"))
    (while (setq ITM (car GRP))       ; While edata item is available
      (if (= (car ITM) 3)             ; if the item is a group name
        (setq NAM (cdr ITM)           ; get the name
              GRP (cdr GRP)           ; shorten the edata
              ITM (car GRP)           ; get the next item
              ENT (cdr ITM)           ; which is the ename
              GRP (cdr GRP)           ; shorten the edata
              GLST                    ; store the ename and name
                  (if GLST
                    (append GLST (list (cons ENT NAM)))
                    (list (cons ENT NAM))
                  )
        )
        (setq GRP (cdr GRP))          ; else shorten the edata
      )
    )
    GLST                              ; return the list
  )

; ------------------- GET GROUP NAME FUNCTION --------------------
;   This function returns a list of all the group names in GLST
;   where ENT is a member. The list has the same form as GLST
; ----------------------------------------------------------------

  (defun getgname (ENT GLST / MSTR GRP GDATA ITM NAM NLST)
    (if (and GLST (listp GLST))
      (progn
        (foreach GRP GLST
          (setq GDATA (entget (car GRP)))
          (foreach ITM GDATA                   ; step through the edata
            (if (and
                  (= (car ITM) 340)            ; if the item is a entity name
                  (eq (setq NAM (cdr ITM)) ENT) ; and the ename being looked for
                )
              (setq NLST                       ; store the ename and name
                      (if NLST
                        (append NLST (list (cons (car GRP) (cdr GRP))))
                        (list (cons (car GRP) (cdr GRP)))
                      )
              )
            )
          )
        )
      )
    )
    NLST
  )

; --------------------- MTEXTBOX FUNCTION ------------------------
;   This function returns a list of four points describing the 
;   bounding box of the mtext (MTXT).
; ----------------------------------------------------------------

  (defun mtextbox (MTXT / WDTH HGHT INS JUST ANG P1 P2 P3 P4)
    (defun ofst_pst(pst X_size Y_size)
      (setq pst (list (+ (car pst) X_size)
		      (+ (cadr pst) y_size)
		      )
	    )
      (setq pst pst)
      )
    (if (and (listp MTXT) (= "MTEXT" (cdr (assoc 0 MTXT))))
      (progn
        (setq WDTH (cdr (assoc 42 MTXT))
              HGHT (cdr (assoc 43 MTXT))
              INS  (trans (cdr (assoc 10 MTXT)) 0 1)
              JUST (cdr (assoc 71 MTXT))
              ANG  (cdr (assoc 50 MTXT))
        )
        (cond
          ((= JUST 1)
            (setq P1 (polar INS (- ANG (* Pi 0.5)) HGHT) 
                  P2 (polar P1 ANG WDTH)
                  P3 (polar INS ANG WDTH)		  
                  p4 INS                                 
            )
          )
          ((= JUST 2)
            (setq P3 (polar INS ANG (/ WDTH 2))
                  P4 (polar INS (+ ANG Pi) (/ WDTH 2))
                  P1 (polar P4 (- ANG (* Pi 0.5)) HGHT)
                  P2 (polar P1 ANG WDTH)
            )
          )
          ((= JUST 3)
            (setq P3 INS
                  P4 (polar INS (+ ANG Pi) WDTH)
                  P1 (polar P4 (- ANG (* Pi 0.5)) HGHT)
                  P2 (polar P1 ANG WDTH)
            )
          )
          ((= JUST 4)
            (setq P4 (polar INS (+ ANG (* Pi 0.5)) (/ HGHT 2))
                  P3 (polar P4 ANG WDTH)
                  P1 (polar P4 (- ANG (* Pi 0.5)) HGHT)
                  P2 (polar P1 ANG WDTH)
            )
          )
          ((= JUST 5)
            (setq P4 (polar INS (- ANG Pi) (/ WDTH 2))
                  P4 (polar P4 (+ ANG (* Pi 0.5)) (/ HGHT 2))
                  P3 (polar P4 ANG WDTH)
                  P1 (polar P4 (- ANG (* Pi 0.5)) HGHT)
                  P2 (polar P1 ANG WDTH)
            )
          )
          ((= JUST 6)
            (setq P3 (polar INS (+ ANG (* Pi 0.5)) (/ HGHT 2))
                  P4 (polar P3 (+ ANG Pi) WDTH)
                  P1 (polar P4 (- ANG (* Pi 0.5)) HGHT)
                  P2 (polar P1 ANG WDTH)
            )
          )
          ((= JUST 7)
            (setq P1 INS
                  P2 (polar P1 ANG WDTH)
                  P3 (polar P2 (+ ANG (* Pi 0.5)) HGHT)
                  P4 (polar P1 (+ ANG (* Pi 0.5)) HGHT)
            )
          )
          ((= JUST 8)
            (setq P1 (polar INS (+ ANG Pi) (/ WDTH 2))
                  P2 (polar P1 ANG WDTH)
                  P3 (polar P2 (+ ANG (* Pi 0.5)) HGHT)
                  P4 (polar P1 (+ ANG (* Pi 0.5)) HGHT)
            )
          )
          ((= JUST 9)
            (setq P2 INS
                  P1 (polar INS (+ ANG Pi) WDTH)
                  P3 (polar P2 (+ ANG (* Pi 0.5)) HGHT)
                  P4 (polar P1 (+ ANG (* Pi 0.5)) HGHT)
            )
          )
        )
	(setq p1 (ofst_pst p1 (- WDTH) (- HGHT)))
	(setq p2 (ofst_pst p2 WDTH (- HGHT)))
	(setq p3 (ofst_pst p3 WDTH HGHT))
	(setq p4 (ofst_pst p3 (- WDTH) HGHT))
      )
      (prompt "\nEntity Not Mtext!")
    )
   
    (list P1 P2 P3 P4)
  )

  (defun stextbox (MTXT / WDTH HGHT INS JUST ANG P1 P2 P3 P4)
    (if (and (listp MTXT) (= "TEXT" (cdr (assoc 0 MTXT))))
      (progn
        (setq HGHT (cdr (assoc 40 MTXT))
	      WDTH (* (cdr (assoc 41 MTXT)) (strlen (cdr (assoc 1 MTXT))))
	      WDTH (* WDTH HGHT)
              INS  (trans (cdr (assoc 10 MTXT)) 0 1)
              ANG  (cdr (assoc 50 MTXT))
        )
	(setq P1 (polar INS (+ ANG (* Pi 0.5)) (* HGHT 2)) 
              P2 (polar P1 ANG (* WDTH 2))
	      p1 (polar p1 (+ ANG pi) WDTH)
              P3 (polar INS ANG (* WDTH 2))
	      P3 (polar p3  (- ANG (* pi 0.5)) HGHT)
              p4 (polar INS (+ ANG pi) WDTH)
	      p4 (polar p4  (- ANG (* pi 0.5)) HGHT)
        )
        )
      (prompt "\nEntity Not Mtext!")
    )
    (list P1 P2 P3 P4)
  )
; ------------------- SET MTEXT UCS FUNCTION ---------------------
;   AutoCAD does not accept mtext as a valid object for setting
;   the ucs. This function will set the current ucs to the 
;   mtext entity name ENT.
; ----------------------------------------------------------------

  (defun ucs_2_mtext (ENT / PTZ PTX PTY PTO)

    (setq PTZ (trans (cdr (assoc 210 (entget ENT))) ENT 1 T)
          PTX (trans (cdr (assoc 11 (entget ENT))) ENT 1 T)
          PTO (trans (cdr (assoc 10 (entget ENT))) ENT 1)
          PTY (list
                (-
                  (* (cadr PTZ) (caddr PTX))
                  (* (cadr PTX) (caddr PTZ))
                );minus
                (* -1
                  (-
                    (* (car PTZ) (caddr PTX))
                    (* (car PTX) (caddr PTZ))
                  );minus
                );multiply by -1
                (-
                  (* (car PTZ) (cadr PTX))
                  (* (car PTX) (cadr PTZ))
                );minus
              );list
          PTX (list (+ (car PTO) (car PTX))
                    (+ (cadr PTO) (cadr PTX))
                    (+ (caddr PTO) (caddr PTX))
              )
          PTY (list (+ (car PTO) (car PTY))
                    (+ (cadr PTO) (cadr PTY))
                    (+ (caddr PTO) (caddr PTY))
              )

    );setq
    (command "_.ucs" "_3" PTO PTX PTY)
  )

; ----------------------------------------------------------------
;                          MAIN PROGRAM
; ----------------------------------------------------------------

  (if (and                                                ; Are we in plan view?
        (equal (car (getvar "viewdir")) 0 0.00001)
        (equal (cadr (getvar "viewdir")) 0 0.00001)
        (> (caddr (getvar "viewdir")) 0)
      )
        
    (progn

      (prompt "\nSelect text to be EXPLODED: ")

      (Setq FLTR  (list (cons -4  "<AND") 
                        (cons -4  "<OR")                      ; filter for mtext and text
                          (cons 0  "MTEXT")
                          (cons 0  "TEXT")
                        (cons -4  "OR>")
                        (cons -4  "<NOT")
                          (cons 102  "{ACAD_REACTORS")        ; and not leader text
                        (cons -4  "NOT>")
                      (cons -4  "AND>")
		      (cons 8 lay_name)
                     )
            GLST     (grplst)                             ; Get all the groups in drawing
            GDICT    (if GLST
                       (dictsearch (namedobjdict) "ACAD_GROUP")
                     )
            SS_all       (ssget "x" FLTR) 
            CNT      0
      )
    (if	ss_all
      (progn
	(setq i_cnt 0)
	(setq tcnt_all (- (sslength ss_all) 1 ))
	(while (<= i_cnt tcnt_all)
	  (setq ss (ssadd))
	  (setq ss (ssadd (ssname ss_all i_cnt) ss))
	  (if (= w_0 0)
	    (progn 
	    (setq txt_dt (entget (ssname ss_all i_cnt)))
	    (setq width (/ (get_dt_vl 40 txt_dt) 20 ))
	    )
	  )
	  
	  (if SS
	    (progn
	      (setq CNT (sslength SS))
	      (princ (strcat "\n" (itoa CNT) " found."))
					; Report number of items found

	      (command "_.move" SS "")	; filter out objects on locked layers

	      (if (> (getvar "cmdactive") 0)
					; if there are still objects left
		(progn
		  (command "0,0" "0,0")
		  (setq	SS  (ssget "p" FLTR)
			CNT (- CNT (sslength SS)) ; count them
		  )
		)
		(setq SS nil)		; else abort operation
	      )

	      (if (> CNT 0)		; if items where filtered out
		(if (= CNT 1)
		  (princ
		    (strcat "\n" (itoa CNT) " was on a locked layer.")
		  )			; report it.
		  (princ
		    (strcat "\n" (itoa CNT) " were on a locked layer.")
		  )
		)
	      )
	    )
	  )

	  (if SS
	    (progn
	      (if (= (cdr (assoc 0 (entget (ssname SS 0)))) "TEXT")
	        (setq txt_box (stextbox (entget (ssname SS 0))))
		(setq txt_box (mtextbox (entget (ssname SS 0))))
		)	
	      (setq left_down (nth 0 txt_box ))
	      (setq right_up (nth 2 txt_box ))
	      (command "zoom" "w" left_down right_up)
	      (setq CNT 0)		; Reset counter
	      (While (setq ENT (ssname SS CNT))
					; step through each object in set
		(and
		  GLST			; if groups are present in the drawing
		  (setq GNAM (getgname ENT GLST))
					; and the text item is in one or more
		  (foreach GRP GNAM	; step through those groups
		    (command "_.-group"
			     "_r"	; and remove the text item
			     (cdr GRP)
			     ENT
			     ""
		    )
		  )
		)

		(setq TXT   (entget ENT)
		      TXTYP (cdr (assoc 0 TXT)) ; Text or Mtext
		)

		(if (= TXTYP "TEXT")
		  (command "_.ucs" "_object" ENT) ; set UCS to object
		  (ucs_2_mtext ENT)
		)

		(if (= TXTYP "TEXT")	; get the points for the bounding box
		  (progn
		    (setq TBX (textbox TXT) ; normal text
			  TBX (list (car TBX)
				    (list (caadr TBX) (cadar TBX))
				    (cadr TBX)
				    (list (caar TBX) (cadadr TBX))
			      )
		    )
		  )
		  (setq TBX (mtextbox TXT)) ; Mtext
		)

		(setq TBX (mapcar '(lambda (x)
				     (trans x 1 0)
					; convert the points to WCS
				   )
				  TBX
			  )
		)

		(setq PTLST (append PTLST TBX))
					; Build list of bounding box
					; points for text items selected


		(command "_.ucs" "_previous") ; reset the ucs

		(setq CNT (1+ CNT))	; get the next text item
	      )				; while

	      (setq PTLST (mapcar '(lambda (x)
				     (trans x 0 1)
					; convert all the points
				   )	; to the current ucs
				  PTLST
			  )
	      )
	      
	      (setq VIEW   (viewpnts)
		    UPLFT  (list (caar VIEW) (cadadr VIEW))
		    TMPFIL (strcat (getvar "tempprefix") "txtexp.wmf")
		    PT1	   (getvar "viewctr")
		    PT2	   (list (car PT1) (cadadr VIEW))
	      )

	      (if (b_layer_locked (getvar "clayer"))
					; if current layer is locked
		(progn
		  (command "_.layer" "_unl" (getvar "clayer") "")
					; unlock it
		  (setq LOCKED T)
		)
	      )
	      (command "zoom" "w" left_down right_up)
	      (command "_.mirror"
		       SS
		       ""
		       PT1
		       PT2
		       "_y"
		       "_.WMFOUT"
		       TMPFIL
		       SS
		       ""
		       "_.ERASE"
		       SS
		       ""
		       "_.WMFIN"
		       TMPFIL
		       UPLFT
		       "2"
		       ""
		       ""
		       "_.mirror"
		       (entlast)
		       ""
		       PT1
		       PT2
		       "_y"
		       "_.EXPLODE"
		       (entlast)
	      )				;end command


	      (command "_.erase"
		       (ssget "p")
		       "_R"
		       "_W"
		       (polar (car VIEW) (* 0.25 Pi) (pixel_unit))
		       (cadr VIEW)
		       ""
	      )


					;(if ZM (command "_.zoom" "_p"))              ; Restore original view if needed
	      (if LOCKED
		(command "_.layer" "_lock" (getvar "clayer") "")
	      )
	      :
	      relock
	      if
	      needed

	      (prompt
		(strcat	"\n"
			(itoa (sslength ss))
			" text object(s) have been exploded to lines."
		)
	      )
	      (prompt "\nThe line objects have been placed on layer 0.")
	    )
	  )
	  (wdl lay_name width)
	  (setq i_cnt (1+ i_cnt))
	)				;while
      )
    )					;if
     )
    (prompt "\nView needs to be in plan (0 0 1).")
  );if equal
  
  (princ)
)
(defun get_dt_vl (item dt)
  (cdr (assoc item dt))
)
(defun wdl(lay_name width)
  (setq ss (ssget "x" (list (cons 0 "line") (cons 8 "0"))))
  (setq cnt_all (sslength ss))
  (setq cnt 0)
  (command "layer" "M" lay_name "")
  (while (< cnt cnt_all)
    (setq l_dt (entget (ssname ss cnt)))
    (setq stt_pnt (get_dt_vl 10 l_dt))
    (setq end_pnt (get_dt_vl 11 l_dt))
    (setq agl (angle stt_pnt end_pnt))
    (setq x0 (car stt_pnt))
    (setq y0 (cadr stt_pnt))
    (setq fst_pnt (list (+ x0 (* width (sin agl))) (- y0 (* width (cos agl)))))
    (setq fth_pnt (list (- x0 (* width (sin agl))) (+ y0 (* width (cos agl)))))
    (setq x0 (car end_pnt))
    (setq y0 (cadr end_pnt))
    (setq scd_pnt (list (+ x0 (* width (sin agl))) (- y0 (* width (cos agl)))))
    (setq thd_pnt (list (- x0 (* width (sin agl))) (+ y0 (* width (cos agl)))))
    (entdel (get_dt_vl -1 l_dt))
    (setq line_len (distance stt_pnt end_pnt))
    (if	(> (/ line_len width) 0.1)
	(command "pline" fst_pnt  scd_pnt "A" thd_pnt "L" fth_pnt "A" "CL" "")
      )
    (setq cnt (1+ cnt))
  )
)


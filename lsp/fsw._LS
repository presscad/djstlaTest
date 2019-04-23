
(defun set_var ()
  (setq osnap_old (getvar "osmode"))
  (setq orthomode_old (getvar "orthomode"))
  (setvar "osmode" 0)
  (setvar "orthomode" 0)
  (list osnap_old orthomode_old)
)


(defun getdetail (item ent / atome)
  (setq atome (cdr (assoc item ent)))
)



(defun point (txt    /	    n	   txt_10 txt10_x	txt10_y
	      txt_40 txt_41 txt_1  fi	  se	 txt_len       txt_width
	      cont   cont_x sp	   kx	  ky	 tt	bot    x1
	      x2     x3	    x4	   y3	  y4
	     )
  (setq n 0)
  (setq txt_10 (getdetail 10 txt))
  (setq txt10_x (car txt_10))
  (setq txt10_y (cadr txt_10))
  (setq txt_40 (getdetail 40 txt))
  (setq txt_41 (getdetail 41 txt))
  (setq txt_1 (getdetail 1 txt))
  (setq txt_len (strlen txt_1))
  (setq txt_width (* txt_41 txt_40))
  (setq cont 0.666667)
  (setq cont_x (* cont txt_40 txt_41))
  (setq sp (/ (- txt_width cont_x) 2))
  (setq x1 (- txt10_x sp))
  (command "layer" "m" "tem" "")
  (while (> txt_len 0)
    (setq cont 0.666667)
    (setq n (+ n 1))
    (setq tt (substr txt_1 n 1))
    (if	(or (= tt "<") (= tt ">") (= tt "0") (= tt "?"))
      (setq cont 0.5)
    )
    (if	(or (= tt ".")(= tt "!")(= tt ""))
      (setq cont 0)
    )
    (if	(or (= tt "1") (= tt "(") (= tt ")") (= tt "I"))
      (setq cont 0.3333)
    )
    (if (or (= tt "W")(= tt "V"))
      (setq cont 1))
    (if	(or (= tt "'")(= tt ","))
      (setq cont 0.1667)
    )
    (setq cont_x (* cont txt_40 txt_41))
    (setq kx nil)
    (if	(= tt "A")
      (setq kx	0.55
	    ky	0.5
	    bot	0
      )
    )
   (if	(= tt "4")
      (setq kx	0.54
	    ky	0.45
	    bot	0
      )
    )
    (if	(= tt "D")
      (setq kx	0.5
	    ky	0.625
	    bot	sp
      )
    )
    (if	(or (= tt "R") (= tt "P") (= tt "9"))
      (setq kx	0.75
	    ky	0.5
	    bot	0
      )
    )
    (if	(= tt "6")
      (setq kx	0.25
	    ky	0.5
	    bot	sp
      )
    )
    (if	(or (= tt "O") (= tt "Q")  (= tt "0"))
      (setq kx	0.5
	    ky	0.5
	    bot	sp
      )
    )
    (if	(= tt "B")
      (setq kx	0.25
	    ky	0.625
	    bot	sp
      )
    )
    (if	(= tt "8")
      (setq kx	0.25
	    ky	0.5
	    bot	sp
      )
    )
    (setq txt_len (- txt_len 1))
    (setq x2 (+ x1 cont_x sp sp))
    (if	kx
      (progn
	(setq y1 (- (* txt_40 kx) barmid))
	(setq y1 (+ y1 txt10_y))

	(setq y2 (+ y1 bar))
	(setq fi (list x1 y1))
	(setq sc (list x2 y2))
	(command "RECTANG" fi sc)
	(if (or (= tt "B") (= tt "8"))
	  (progn
	    (setq y1 (- (* txt_40 0.75) barmid))
	    (setq y1 (+ y1 txt10_y))
	    (setq x2 (+ x1 cont_x sp sp))
	    (setq y2 (+ y1 bar))
	    (setq fi (list x1 y1))
	    (setq sc (list x2 y2))
	    (command "RECTANG" fi sc)
	  )
	)
	(setq x3 (- (* cont_x ky) barmid))
	(setq x3 (+ x1 x3 sp))
	(setq x4 (+ x3 bar))
	(if (or (= tt "P") (= tt "R") (= tt "9"))
	  (setq y3 (- (+ txt10_y (* txt_40 0.5)) SP))
	  (setq y3 (- txt10_y bot))
	)
	(if (= tt "6")
	  (setq y4 (+ (+ txt10_y (* txt_40 0.5)) SP))
	  (setq y4 (+ txt_40 txt10_y sp))
	)
	(setq fi (list x3 y3))
	(setq sc (list x4 y4))
	(command "RECTANG" fi sc)
      )
    )
    (setq x1 x2)
  )
)




(defun c:fsw (/ n txt_sel sel_len txt_name)
  (prompt "select text")
  (setq txt_sel (ssget (list (cons 0 "text"))))
  (setq sel_len (sslength txt_sel))
  (setq n 0)
  (setq bar (getreal "\nimput disconectoin distance:"))
  (setq barmid (/ bar 2))
  (set_var)
  (command "layer" "n" "AC" "")
  (while (< n sel_len)
    (setq txt_name (ssname txt_sel n))
    (setq txt_ent (entget txt_name))
    (setq txt_50 (cdr (assoc 50 txt_ent)))
    (setq txt_71 (cdr (assoc 71 txt_ent)))
    (setq txt_10 (cdr (assoc 10 txt_ent)))
    (setq n (+ n 1))
    (point txt_ent)
    (ro txt_50 txt_71 txt_10)
  )
  (command "layer" "m" "0" "")
  (command "purge" "a" "*" "n")
)





(defun ro (t_50 t_71 t_10 / ro_object txt10_y txt10_x)
  (setq txt10_x (car t_10))
  (setq txt10_y (cadr t_10))
  (setq ro_object (ssget "x" (list (cons 8 "tem"))))
  (if ro_object 
  (progn 
  (setq ang (atof (angtos t_50 0 2)))
  (if (= t_71 4)
    (mi_ox ro_object)
  )
  (if (= t_71 2)
    (mi_oy ro_object)
  )
  (if (= t_71 6)
    (ro_o ro_object 180)
  )
  (if (/= ang 0)
    (ro_o ro_object ang)
  )
  (command "change" ro_object "" "p" "layer" "AC" "")
)))




(defun ro_o (ro_object ang)
  (command "ROTATE" ro_object "" t_10 ang)
)



(defun mi_ox (ro_object)
  (command "mirror"
	   ro_object
	   ""
	   t_10
	   (list (+ txt10_x 2) txt10_y)
	   "Y"
  )
)




(defun mi_oy (ro_object)
  (command "mirror"
	   ro_object
	   ""
	   t_10
	   (list txt10_x (+ txt10_y 2))
	   "y"
  )
)

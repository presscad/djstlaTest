(defun c:sn_widen (/	     lin     stpoint edpoint sc_48   back    s_e
	     lintype sl	     el	     e1	     sl_mid  sl_total
	     sl_el   se_mid  secp    ll	     n
	    )
					;(prompt "请选择单线")
  (setq ll (ssget "x" (list (cons 6 "DASHED"))))
  (setq lin_len (sslength ll))
  (setq n -1)
  (command "layer" "m" "tem" "")
  (set_var)
  (repeat lin_len
    (setq n (+ n 1))
    (setq lin (entget (ssname ll n)))
    (setq stpoint (cdr (assoc 10 lin)))
    (setq stpoint (list (car stpoint) (cadr stpoint)))
    (setq edpoint (cdr (assoc 11 lin)))
    (setq stpoint (list (car stpoint) (cadr stpoint)))
    (setq sc_48 (assoc 48 lin))
    (if	sc_48
      (setq sc_48 (cdr sc_48))
      (setq sc_48 1)
    )
    (if	(< (cadr stpoint) (cadr edpoint))
      (progn
	(setq back stpoint)
	(setq stpoint edpoint)
	(setq edpoint back)
      )
    )
    (setq s_e (abs (distance stpoint edpoint)))
    (if
      (setq lintype (cdr (assoc 6 lin)))
       (progn
	 (setq lintype (tblsearch "ltype" lintype))
	 (setq sl (cdr (assoc 49 lintype)))
	 (setq lintype (reverse lintype))
	 (if (< sl 0)
	   (progn
	     (setq el sl)
	     (setq sl (cdr (assoc 49 lintype)))
	   )
	   (setq el (cdr (assoc 49 lintype)))
	 )
	 (setq sl (* sl sc_48))
	 (setq el (* el sc_48))		;sl >0  el <0
	 (setq sl_total (+ sl (abs el)))
	 (setq sl_el (fix (/ s_e sl_total)))
	 (setq se_mid (- s_e (- (* sl_el sl_total) sl)))
	 (setq se_mid (/ se_mid 2))
	 (setq secp (list (car stpoint) (- (cadr stpoint) se_mid)))
	 (command "line" stpoint secp "")
	 (setq stpoint (list (car stpoint)
			     (- (cadr stpoint) (+ se_mid (abs el)))
		       )
	 )
	 (while	(> sl_el 1)
	   (setq secp (list (car stpoint) (- (cadr stpoint) sl)))
	   (command "line" stpoint secp "")
	   (setq
	     stpoint (list (car stpoint) (- (cadr stpoint) sl_total))
	   )
	   (setq sl_el (- sl_el 1))
	 )
	 (command "line" stpoint edpoint "")
       )
    )
  )
  (setq tem "tem")
  (wdl tem 0.1)
  (setq ll (ssget "x" (list (cons 8 "tem"))))
  (command "change" ll "" "p" "layer" "0" "")
  (command "layer" "m" "0" "")
  (command "purge" "a" "" "n")
)


(defun set_var ()
  (setq osnap_old (getvar "osmode"))
  (setq orthomode_old (getvar "orthomode"))
  (setvar "osmode" 0)
  (setvar "orthomode" 0)
  (list osnap_old orthomode_old)
)

(defun get_dt_vl (item dt)
  (cdr (assoc item dt))
)
					;加宽
(defun wdl (lay_name width    /	       cnt_all	cnt	 l_dt
	    stt_pnt  end_pnt  agl      x0	y0	 fst_pnt
	    fth_pnt  scd_pnt  thd_pnt
	   )
  (setq ss (ssget "x" (list (cons 0 "line") (cons 8 lay_name))))
  (if ss
    (progn

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
	(setq fst_pnt (list (+ x0 (* width (sin agl)))
			    (- y0 (* width (cos agl)))
		      )
	)
	(setq fth_pnt (list (- x0 (* width (sin agl)))
			    (+ y0 (* width (cos agl)))
		      )
	)
	(setq x0 (car end_pnt))
	(setq y0 (cadr end_pnt))
	(setq scd_pnt (list (+ x0 (* width (sin agl)))
			    (- y0 (* width (cos agl)))
		      )
	)
	(setq thd_pnt (list (- x0 (* width (sin agl)))
			    (+ y0 (* width (cos agl)))
		      )
	)
	(entdel (get_dt_vl -1 l_dt))
	(command "pline" fst_pnt scd_pnt thd_pnt fth_pnt "c" "")
	(setq cnt (1+ cnt))
      )
    )
  )

)


;;;;;;;;;;;;;;;;;;;;;;;
(prompt " \n 输入SN_WIDEN运行程序!")
(prompt " \n 所加宽的虚线放到了0层!")













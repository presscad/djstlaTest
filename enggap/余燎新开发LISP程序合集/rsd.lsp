(defun c:rsd ()
  (setq a (getstring "请输入design文件名:"))
  (command "-layer" "n" "s" "")

  (command "-layer" "c" "1" "s" "")

  (command "change" "all" "" "p" "la" "s" "")

  (setq name1 (strcat "p" ":"))
  (setq name2 (strcat "\\" a))
  (setq name3 (strcat "." "dxf"))
  (setq name4 (strcat name1 name2))
  (setq name (strcat name4 name3))
  (setq lay (findfile name))
  (command "insert" lay '(0 0) "1" "1" "0" "explode" "l")

  (crtk)

)
(defun c:rs ()
  (command "-layer" "s" "0" "")

  (command "-layer" "f" "s" "")

  (command "regen")

  (command "-layer" "t" "s" "")

)
(defun c:rd ()
  (command "-layer" "s" "0" "")

  (command "-layer" "f" "f" "")

  (command "regen")

  (command "-layer" "t" "f" "")

)
(defun crtk ()
  (setq ss (ssget "all"))
  (setq n (sslength ss))
  (setq m 0)
  (repeat n
    (setq p (ssname ss m))
    (setq data (entget p))
    (setq la (cdr (assoc 8 data)))
    (if	(= la "f")
      (prin1)
      (if (= la "s")
	(prin1)
	(progn
	  (setq data (subst (cons 8 "f") (assoc 8 data) data))
	  (entmod data)
	)
      )
    )
    (setq m (+ m 1))
  )
)






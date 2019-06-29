(defun c:gg ()

  (VL-LOAD-COM)

  (setq	AcadObject   (vlax-get-acad-object)

	AcadDocument (vla-get-ActiveDocument AcadObject)

	mSpace	     (vla-get-ModelSpace AcadDocument)

  )

  (setq obj (ssget))
  (setq d (getreal "\n请输入偏移量[+表示向外，-表示向内]:"))
  (setq n (sslength obj))
  (vl-cmdf "-layer" "n" "hofst" "" )
  (vl-cmdf "-layer" "c" "2" "hofst" "" )
  (setq m 0)
  (repeat n
    (setq ob (ssname obj m))
    (setq a_data (entget ob))
    (setq old (assoc 8 a_data))
    (setq new (cons 8 "hofst"))
    (setq b_data (subst new old a_data))
    (entmod b_data)
    (setq ss (assoc -1 b_data))
    (setq sso (cdr ss))
   
    (setq ssb (vlax-ename->vla-object sso))
    (vla-offset ssb d)(vla-offset ssb (* d -1))
    (entmake a_data)
    (vla-delete ssb)
    
   (setq m (+ m 1))
  )
  (princ)
)
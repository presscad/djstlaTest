(defun c:selpl()
  (setq a(ssget"x"(list(cons 0 "lwpolyline"))))
  )


(defun c:seltext()
  (setq a(ssget"x"(list(cons 0 "text"))))
  )



(defun c:deltext()
  (setq a(ssget"x"(list(cons 0 "text"))))
  (command "erase" a "")
  )



(defun c:selline()
  (setq a(ssget"x"(list(cons 0 "line"))))
  )


(defun c:selarc()
  (setq a(ssget"x"(list(cons 0 "arc"))))
  )


(defun c:selinsert()
  (setq a(ssget"x"(list(cons 0 "insert"))))
  )
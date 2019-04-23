(defun c:ttaa()
  (setq a 1)
  (setq n 1)
  
  (while (< n 100)
    (setq b (+ a 0.5))
    (setq c (+ b 0.5))
    (setq d (+ c 0.5))
    (command "circle" "0,0" a "")
    (command "circle" "0,0" b "")
    (command "circle" "0,0" c "")
    (command "circle" "0,0" d "")

    (setq a (+ a 3))
    (setq n (+ n 1))
    )
)


(defun subsub(aa bb /)
  ()
  )
(defun c:clr()
  (repeat 3
    (command "erase" "all" "")
    (repeat 10
      (command "purge" "all" "" "n")
      )
    )
  )
(prompt "/n������Ҫ�Ĳ㣬����clr")
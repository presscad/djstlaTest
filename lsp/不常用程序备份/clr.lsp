(defun c:clr()
  (repeat 3
    (command "erase" "all" "")
    (repeat 10
      (command "purge" "all" "" "n")
      )
    )
  )
(prompt "/n销定你要的层，运行clr")
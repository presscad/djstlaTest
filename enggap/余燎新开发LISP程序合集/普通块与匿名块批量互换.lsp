;批量转换匿名块为普通块
(defun c:reblk(/ blks ss n e nam namlst); 
  (setq BLKs (vla-get-blocks (vla-get-activedocument (vlax-get-acad-object)))) 
  (if (setq ss (ssget '((0 . "INSERT")(2 . "`**"))))
      (progn
 (repeat (setq n (sslength ss)) 
         (if (and (setq e (ssname ss (setq n (1- n)))) 
                 (wcmatch (setq nam (vla-get-name (vlax-ename->vla-object e))) "`**") 
                 (not (member nam namlst))) 
          (progn (setq namlst (cons nam namlst)) 
            (vla-put-name (vla-item blks nam) "U") 
          ) 
         ) 
        )
       (vla-auditinfo (vla-get-activedocument (vlax-get-acad-object)) :vlax-true))
  )(princ) 
)
;批量转换普通块为匿名块
(defun c:anblk()
  (setq ss (ssget '((0 . "INSERT")(2 . "~`**"))))
  (repeat (setq n (sslength ss))
    (setq BLKREF (vlax-ename->vla-object (ssname ss (setq n (1- n)))))
    (vla-put-name
      (vla-item (vla-get-blocks
           (vla-get-activedocument (vlax-get-acad-object))
         )
         (vla-get-name BLKREF)
      )
      "*U"
    )
  )  
)
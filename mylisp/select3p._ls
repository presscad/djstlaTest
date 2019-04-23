(defun c:select3p ()
  (setq ptList (getPolylineVertexsList))

  (setq ssall (ssget "wp" ptList))
)


					;获取多一线的各定点，组成一个list表；
(defun getPolylineVertexsList ()
  (setq ptList nil)			;返回值

  (print "Please select the polyline:")
  (setq ss (ssget))
  (setq ent (ssname ss 0))
  (setq dataEnt (entget ent))

					;检测是否闭合多义线；
  (setq isPolyline (cdr (assoc 0 dataEnt)))
  (if (not (equal isPolyline "LWPOLYLINE"))
    (progn
      (setq ptList nil)
      (print "不是多义线")
      (exit)
    )
  )


  (setq isClosed (cdr (assoc 70 dataEnt)))	;判断是否闭合;
  (if (equal isClosed 0)
    (progn
      (print "多义线不闭合")
      (setq ptList nil)
      (exit)
    )
  )

  (setq copyDataEnt dataEnt)
  (setq datan (car copyDataEnt))
  (while (not (equal datan nil))
    (setq head (car datan))
    (if	(equal head 10)
      (progn
	(setq onelist (cdr datan))
	(setq ptList(append ptList (list onelist)))
      )
    )
    (setq copyDataEnt (cdr copyDataEnt))
    (setq datan (car copyDataEnt))
  )

  (setq tmpList ptList) ;返回值；
)



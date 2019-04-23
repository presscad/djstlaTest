(defun c:select3p ()
  (setq ptList (getPolylineVertexsList))

  (setq ssall (ssget "wp" ptList))
)


					;��ȡ��һ�ߵĸ����㣬���һ��list��
(defun getPolylineVertexsList ()
  (setq ptList nil)			;����ֵ

  (print "Please select the polyline:")
  (setq ss (ssget))
  (setq ent (ssname ss 0))
  (setq dataEnt (entget ent))

					;����Ƿ�պ϶����ߣ�
  (setq isPolyline (cdr (assoc 0 dataEnt)))
  (if (not (equal isPolyline "LWPOLYLINE"))
    (progn
      (setq ptList nil)
      (print "���Ƕ�����")
      (exit)
    )
  )


  (setq isClosed (cdr (assoc 70 dataEnt)))	;�ж��Ƿ�պ�;
  (if (equal isClosed 0)
    (progn
      (print "�����߲��պ�")
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

  (setq tmpList ptList) ;����ֵ��
)



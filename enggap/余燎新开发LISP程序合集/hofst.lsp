(prompt
  "运行程序前请确保图形已经通过endchk，请输入hofst运行程序"
)
(defun c:hofst (/	obj	d	n	m	ob	dp
		dp1	dp2	dd1	dd2	a1	a2
		oldorthomode	oldosmode	AcadObject
	       )

  (VL-LOAD-COM)
  (setq	AcadObject   (vlax-get-acad-object)

	AcadDocument (vla-get-ActiveDocument AcadObject)

	mSpace	     (vla-get-ModelSpace AcadDocument)

  )
  (setq oldosmode (getvar "osmode"))
  (setvar "osmode" 0)
  (setq oldorthomode (getvar "orthomode"))
  (setvar "orthomode" 0)
  (setq obj (ssget '((0 . "LWPOLYLINE,circle"))))
  (setq d (getreal "\n请输入偏移量(+表示向外，-表示向内):"))
  (setq n (sslength obj))
  (vl-cmdf "-layer" "n" "hofst" "")
  (vl-cmdf "-layer" "c" "1" "hofst" "")
  (setq m 0)
  (repeat n
    (setq ob (ssname obj m))
    (setq dp (vlax-ename->vla-object ob))
    (setq dp1 (vla-offset dp d))
    (setq dp2 (vla-offset dp (* d -1)))
    (setq dd1 (vlax-safearray-get-element (vlax-variant-value dp1) 0))
    (setq dd2 (vlax-safearray-get-element (vlax-variant-value dp2) 0))
    (setq a1 (vlax-curve-getDistAtParam
	       dd1
	       (vlax-curve-getEndParam dd1)
	     )
    )
    (setq a2 (vlax-curve-getDistAtParam
	       dd2
	       (vlax-curve-getEndParam dd2)
	     )
    )
    (if	(> d 0)
      (progn
	(if (> a1 a2)
	  (progn
	    (vla-delete dd2)
	    (vla-put-layer dd1 "hofst")
	  )
	  (progn

	    (vla-delete dd1)
	    (vla-put-layer dd2 "hofst")

	  )
	)
      )
    )
    (if	(< d 0)
      (progn
	(if (< a1 a2)
	  (progn
	    (vla-delete dd2)
	    (vla-put-layer dd1 "hofst")
	  )
	  (progn
	    (vla-delete dd1)
	    (vla-put-layer dd2 "hofst")
	  )
	)
      )
    )
    (setq m (+ m 1))
  )
  (setvar "osmode" oldosmode)
  (setvar "orthomode" oldorthomode)
  (princ)
)
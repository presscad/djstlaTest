;��������fp
;���ܣ��Ապ϶����ߵ�Բ��
;���룺�û�ѡ��ʵ�弯�ϡ����뵹�ǰ뾶ֵ;

;ѡ��ʵ��
(defun selectSS( / ss)
  (prompt "\n Please select entities to fillet:")
  (setq ss(ssget))
)

(defun isClosedPline(ssUnit / ssdata entDisc isPolyline isClosed isclosedDisc rslt)
  (setq ssdata(entget ssUnit))
  (setq entDisc(assoc 0 ssdata))
  (setq entDisc(cdr entDisc))
  (setq isPolyline(equal entDisc "LWPOLYLINE"))
  ;judge if it is closed
  (setq isClosed nil)
  (if isPolyline
    (progn
      (setq isclosedDisc(assoc 70 ssdata))
      (setq isclosedDisc(cdr isclosedDisc))
      (setq isClosed(equal isclosedDisc 1))
    )
  )
  (setq rslt (and isPolyline isClosed))  ;result return  
)


(defun c:fp( / filletRadius ss nlen i ssUnit)
  (prompt "\n Please select entities to fillet:") 
  (setq ss(ssget))
  (setq filletRadius(getreal "\n Input the fillet radius:")) 

  ;
  (setq nlen (sslength ss))
  (setq i 0)
  (while (< i nlen)
    (setq ssUnit(ssname ss i))
    (if(isClosedPline ssUnit)
      (progn
	(command "fillet" "r" filletRadius)
      	(command "fillet"  "p" ssUnit)  ;fillet the polyline
      )
    )
    (setq i (+ i 1))
  )  
)




;(vl-load-com)
;;;(defun getModeSpace()
;;;  (setq vModelSpace
;;;	 (vla-get-ModelSpace(vla-get-ActiveDocument(vla-get-Acad-Object)))
;;;  )
;;;)
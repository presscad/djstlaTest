;;��������2010���ϵ�cad�汾���洦���������ߡ�
(prompt
  "������ֻ��������2010���ϵ�cad�汾���洦���������ߡ�"
)
(defun c:splined (/ oldosmode oldorthomode obj jingdu n m ob)
  (setq oldosmode (getvar "osmode"))
  (setvar "osmode" 0)
  (setq oldorthomode (getvar "orthomode"))
  (setvar "orthomode" 0)
  (setq obj (ssget '((0 . "spline"))))
  (setq jingdu (getint "�����뾫�ȣ���Χ0-99��:"))
  (setq n (sslength obj))
  (setq m 0)
  (repeat n
    (setq ob (ssname obj m))
    (command "splinedit" ob "p" jingdu)
    (setq m (+ m 1))
  )
  (setvar "osmode" oldosmode)
  (setvar "orthomode" oldorthomode)
  (princ)
)
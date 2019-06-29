;;适用于在2010以上的cad版本里面处理样条曲线。
(prompt
  "本程序只适用于在2010以上的cad版本里面处理样条曲线。"
)
(defun c:splined (/ oldosmode oldorthomode obj jingdu n m ob)
  (setq oldosmode (getvar "osmode"))
  (setvar "osmode" 0)
  (setq oldorthomode (getvar "orthomode"))
  (setvar "orthomode" 0)
  (setq obj (ssget '((0 . "spline"))))
  (setq jingdu (getint "请输入精度（范围0-99）:"))
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
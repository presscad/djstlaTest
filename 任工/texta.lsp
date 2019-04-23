(Defun C:tmpText2Polyline (textfilename ltl lul lvp)
  ;;(PrinC textfilename)
  (SetVar "cmdecho" 0)
  (Command
;;;"mirror" ltl "" lvp "@0,1" "y"
	   "wmfout" textfilename ltl ""
	   "erase" ltl ""
	   "wmfin" textfilename lul "2.0008" "" ""
;;;"mirror" (EntLast)  "" lvp "@0,1" "y"
;;;    "explode"  (EntLast)
;;;    "erase"   (ssget "p") "R" "W"
;;;    (polar (car lvl)
;;;	   (* 0.25 Pi)
;;;	   (Max	(Abs (/ lvs (Cadr lss)))
;;;		(Abs (/ (* lvs (/ (Car lss) (Cadr lss))) (Car lss)))
;;;	   )
;;;    )
;;;    (cadr lvl)
;;;    ""
	  )
  (SetVar "cmdecho" 1)
  (PrinC)
)
(Defun C:tmpZoom (pt1 pt2)
  (SetVar "cmdecho" 0)
  (Command "zoom" "w" pt1 pt2)
  (SetVar "cmdecho" 1)
)
(Defun C:tmpGetSel(/DD layerName findf DCL_F DCL_ID DD PATH)
  ;(initget 1 "S O A")
  ;(setq x (getkword "S选择/O一层/A全部:"))
  (setq findf (findfile "acad.dcl")
	dcl_F  (strcat (substr findf 1 (- (strlen findf) 8)) "ASDKSTARMASKCAD.DCL")
  )
  ;(setq (Create-ArxProgramTestDCL));;;生成DCL文件
  (setq dcl_id (load_dialog dcl_F)) ;载入对话框
  (if (not (new_dialog "ASDKCAD_TEXT2PL" dcl_id))(exit)) ;_ 结束if
  (Set_tile "layerName" "0")
  (action_tile "widen" "(setq widen(get_tile \"widen\"))")
  (action_tile "Select""(done_dialog 1)")
  (action_tile "OneLayer""(setq layerName(get_tile \"layerName\"))(done_dialog 2)")
  (action_tile "AllEntity""(done_dialog 3)")
  (SETQ DD(start_dialog))
  (unload_dialog dcl_id)
  ;(vl-file-delete dcl_F)
  (list DD layerName widen)
)
(Defun C:testCircle (cpt rad) 
  (Command "circle" cpt rad)
)
(defun c:tt(/ sa sb sc) 
(setq sa 100) 
(setq sb 20) 
(setq sc 10) 
(setq sd (+ sa sb sc)) 
) 
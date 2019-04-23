(defun dev_mark	(position AB M NUM ROT)
  (defun draw_1	()
    (command "pline"
	     (list 2.45046 0.76953)
	     "w"
	     0
	     0
	     (list 2.60491 0.923985)
	     (list 2.60484 0.924056)
	     (list 2.45039 0.769601)
	     "c"
    )
    (command "pline"
	     (list 2.60483 0.92402)
	     "w"
	     0
	     0
	     (list 2.60483 0.0)
	     (list 2.60493 0.0)
	     (list 2.60493 0.92402)
	     "c"
    )
    (command "pline"
	     (list 2.60488 5e-005)
	     "w"
	     0
	     0
	     (list 2.60217 5e-005)
	     (list 2.60217 -5e-005)
	     (list 2.60488 -5e-005)
	     "c"
    )
    (command "pline"
	     (list 2.45042 -5e-005)
	     "w"
	     0
	     0
	     (list 2.75662 -5e-005)
	     (list 2.75662 5e-005)
	     (list 2.45042 5e-005)
	     "c"
    )
    (command "pline"
	     (list 2.75662 5e-005)
	     "w"
	     0
	     0
	     (list 2.75391 5e-005)
	     (list 2.75391 -5e-005)
	     (list 2.75662 -5e-005)
	     "c"
    )
  )
  (defun draw_2	()
    (command "pline"
	     (list 2.45046 0.76963)
	     "w"
	     0
	     0
	     (list 2.60491 0.924085)
	     (list 2.60484 0.924156)
	     (list 2.45039 0.769701)
	     "c"
    )
    (command "pline"
	     (list 2.60488 0.92407)
	     "w"
	     0
	     0
	     (list 2.91108 0.92407)
	     (list 2.91108 0.92417)
	     (list 2.60488 0.92417)
	     "c"
    )
    (command "pline"
	     (list 2.91104 0.924085)
	     "w"
	     0
	     0
	     (list 3.0655 0.76963)
	     (list 3.06557 0.769701)
	     (list 2.91111 0.924156)
	     "c"
    )
    (command "pline"
	     (list 3.06548 0.769665)
	     "w"
	     0
	     0
	     (list 3.06548 0.61521)
	     (list 3.06558 0.61521)
	     (list 3.06558 0.769665)
	     "c"
    )
    (command "pline"
	     (list 3.0655 0.615246)
	     "w"
	     0
	     0
	     (list 2.91104 0.463501)
	     (list 2.91111 0.463429)
	     (list 3.06557 0.615175)
	     "c"
    )
    (command "pline"
	     (list 2.91108 0.463515)
	     "w"
	     0
	     0
	     (list 2.60488 0.463515)
	     (list 2.60488 0.463415)
	     (list 2.91108 0.463415)
	     "c"
    )
    (command "pline"
	     (list 2.60484 0.4635)
	     "w"
	     0
	     0
	     (list 2.45039 0.309045)
	     (list 2.45046 0.308975)
	     (list 2.60491 0.46343)
	     "c"
    )
    (command "pline"
	     (list 2.45037 0.30901)
	     "w"
	     0
	     0
	     (list 2.45037 0.0001)
	     (list 2.45047 0.0001)
	     (list 2.45047 0.30901)
	     "c"
    )
    (command "pline"
	     (list 2.45042 5e-005)
	     "w"
	     0
	     0
	     (list 3.06553 5e-005)
	     (list 3.06553 0.00015)
	     (list 2.45042 0.00015)
	     "c"
    )
    (command "pline"
	     (list 3.06553 0.00015)
	     "w"
	     0
	     0
	     (list 3.06282 0.00015)
	     (list 3.06282 5e-005)
	     (list 3.06553 5e-005)
	     "c"
    )
  )
  (defun draw_3	()
    (command "pline"
	     (list 2.4666 0.76432)
	     "w"
	     0
	     0
	     (list 2.61835 0.918775)
	     (list 2.61828 0.918845)
	     (list 2.46653 0.76439)
	     "c"
    )
    (command "pline"
	     (list 2.61831 0.91876)
	     "w"
	     0
	     0
	     (list 2.92722 0.91876)
	     (list 2.92722 0.91886)
	     (list 2.61831 0.91886)
	     "c"
    )
    (command "pline"
	     (list 2.92719 0.918774)
	     "w"
	     0
	     0
	     (list 3.08164 0.764319)
	     (list 3.08171 0.76439)
	     (list 2.92726 0.918845)
	     "c"
    )
    (command "pline"
	     (list 3.08163 0.764355)
	     "w"
	     0
	     0
	     (list 3.08163 0.6099)
	     (list 3.08173 0.6099)
	     (list 3.08173 0.764355)
	     "c"
    )
    (command "pline"
	     (list 3.08164 0.609935)
	     "w"
	     0
	     0
	     (list 2.92719 0.45548)
	     (list 2.92726 0.455409)
	     (list 3.08171 0.609864)
	     "c"
    )
    (command "pline"
	     (list 2.92722 0.455495)
	     "w"
	     0
	     0
	     (list 2.77277 0.455495)
	     (list 2.77277 0.455395)
	     (list 2.92722 0.455395)
	     "c"
    )
    (command "pline"
	     (list 2.77277 0.455495)
	     "w"
	     0
	     0
	     (list 2.77006 0.455495)
	     (list 2.77006 0.455395)
	     (list 2.77277 0.455395)
	     "c"
    )
    (command "pline"
	     (list 2.92719 0.455409)
	     "w"
	     0
	     0
	     (list 3.08164 0.303664)
	     (list 3.08171 0.303735)
	     (list 2.92726 0.45548)
	     "c"
    )
    (command "pline"
	     (list 3.08163 0.303699)
	     "w"
	     0
	     0
	     (list 3.08163 0.149244)
	     (list 3.08173 0.149244)
	     (list 3.08173 0.303699)
	     "c"
    )
    (command "pline"
	     (list 3.08164 0.14928)
	     "w"
	     0
	     0
	     (list 2.92719 -0.00517534)
	     (list 2.92726 -0.00524605)
	     (list 3.08171 0.149209)
	     "c"
    )
    (command "pline"
	     (list 2.92722 -0.0051607)
	     "w"
	     0
	     0
	     (list 2.61831 -0.0051607)
	     (list 2.61831 -0.0052607)
	     (list 2.92722 -0.0052607)
	     "c"
    )
    (command "pline"
	     (list 2.61835 -0.00517565)
	     "w"
	     0
	     0
	     (list 2.4666 0.149279)
	     (list 2.46653 0.149209)
	     (list 2.61828 -0.00524574)
	     "c"
    )
    (command "pline"
	     (list 2.46657 0.149294)
	     "w"
	     0
	     0
	     (list 2.46386 0.149294)
	     (list 2.46386 0.149194)
	     (list 2.46657 0.149194)
	     "c"
    )
  )


  (defun draw_4	()
    (command "pline"
	     (list 3.0805 0.303749)
	     "w"
	     0
	     0
	     (list 2.46539 0.303749)
	     (list 2.46539 0.303649)
	     (list 3.0805 0.303649)
	     "c"
    )
    (command "pline"
	     (list 2.46543 0.303669)
	     "w"
	     0
	     0
	     (list 2.9288 0.91878)
	     (list 2.92872 0.91884)
	     (list 2.46535 0.303729)
	     "c"
    )
    (command "pline"
	     (list 2.92871 0.91881)
	     "w"
	     0
	     0
	     (list 2.92871 -0.0052107)
	     (list 2.92881 -0.0052107)
	     (list 2.92881 0.91881)
	     "c"
    )
    (command "pline"
	     (list 2.92876 -0.0051607)
	     "w"
	     0
	     0
	     (list 2.92605 -0.0051607)
	     (list 2.92605 -0.0052607)
	     (list 2.92876 -0.0052607)
	     "c"
    )
  )

  (defun draw_5	()
    (command "pline"
	     (list 2.45687 0.164242)
	     "w"
	     0
	     0
	     (list 2.61132 0.00978711)
	     (list 2.61139 0.00985782)
	     (list 2.45694 0.164313)
	     "c"
    )
    (command "pline"
	     (list 2.61136 0.00977247)
	     "w"
	     0
	     0
	     (list 2.91756 0.00977247)
	     (list 2.91756 0.00987247)
	     (list 2.61136 0.00987247)
	     "c"
    )
    (command "pline"
	     (list 2.91759 0.00978711)
	     "w"
	     0
	     0
	     (list 3.07205 0.164242)
	     (list 3.07198 0.164313)
	     (list 2.91752 0.00985782)
	     "c"
    )
    (command "pline"
	     (list 3.07206 0.164278)
	     "w"
	     0
	     0
	     (list 3.07206 0.470478)
	     (list 3.07196 0.470478)
	     (list 3.07196 0.164278)
	     "c"
    )
    (command "pline"
	     (list 3.07205 0.470513)
	     "w"
	     0
	     0
	     (list 2.91759 0.624968)
	     (list 2.91752 0.624898)
	     (list 3.07198 0.470442)
	     "c"
    )
    (command "pline"
	     (list 2.91756 0.624983)
	     "w"
	     0
	     0
	     (list 2.4569 0.624983)
	     (list 2.4569 0.624883)
	     (list 2.91756 0.624883)
	     "c"
    )
    (command "pline"
	     (list 2.45695 0.624933)
	     "w"
	     0
	     0
	     (list 2.45695 0.933843)
	     (list 2.45685 0.933843)
	     (list 2.45685 0.624933)
	     "c"
    )
    (command "pline"
	     (list 2.4569 0.933793)
	     "w"
	     0
	     0
	     (list 3.07201 0.933793)
	     (list 3.07201 0.933893)
	     (list 2.4569 0.933893)
	     "c"
    )
    (command "pline"
	     (list 3.07201 0.933893)
	     "w"
	     0
	     0
	     (list 3.0693 0.933893)
	     (list 3.0693 0.933793)
	     (list 3.07201 0.933793)
	     "c"
    )
  )

  (defun draw_6	()
    (command "pline"
	     (list 2.46609 0.469886)
	     "w"
	     0
	     0
	     (list 2.92675 0.469886)
	     (list 2.92675 0.469986)
	     (list 2.46609 0.469986)
	     "c"
    )
    (command "pline"
	     (list 2.92672 0.4699)
	     "w"
	     0
	     0
	     (list 3.08117 0.318155)
	     (list 3.08124 0.318226)
	     (list 2.92679 0.469972)
	     "c"
    )
    (command "pline"
	     (list 3.08116 0.318191)
	     "w"
	     0
	     0
	     (list 3.08116 0.163736)
	     (list 3.08126 0.163736)
	     (list 3.08126 0.318191)
	     "c"
    )
    (command "pline"
	     (list 3.08117 0.163771)
	     "w"
	     0
	     0
	     (list 2.92671 0.00931609)
	     (list 2.92679 0.00924538)
	     (list 3.08124 0.1637)
	     "c"
    )
    (command "pline"
	     (list 2.92675 0.00933074)
	     "w"
	     0
	     0
	     (list 2.61784 0.00933074)
	     (list 2.61784 0.00923074)
	     (list 2.92675 0.00923074)
	     "c"
    )
    (command "pline"
	     (list 2.61788 0.00931578)
	     "w"
	     0
	     0
	     (list 2.46613 0.163771)
	     (list 2.46606 0.163701)
	     (list 2.6178 0.00924569)
	     "c"
    )
    (command "pline"
	     (list 2.46614 0.163736)
	     "w"
	     0
	     0
	     (list 2.46614 0.624391)
	     (list 2.46604 0.624391)
	     (list 2.46604 0.163736)
	     "c"
    )
    (command "pline"
	     (list 2.46613 0.624356)
	     "w"
	     0
	     0
	     (list 2.77233 0.933266)
	     (list 2.77226 0.933336)
	     (list 2.46606 0.624426)
	     "c"
    )
    (command "pline"
	     (list 2.7723 0.933251)
	     "w"
	     0
	     0
	     (list 2.92675 0.933251)
	     (list 2.92675 0.933351)
	     (list 2.7723 0.933351)
	     "c"
    )
    (command "pline"
	     (list 2.92675 0.933351)
	     "w"
	     0
	     0
	     (list 2.92404 0.933351)
	     (list 2.92404 0.933251)
	     (list 2.92675 0.933251)
	     "c"
    )
  )


  (defun draw_7	()
    (command "pline"
	     (list 2.53674 0.937029)
	     "w"
	     0
	     0
	     (list 3.15185 0.937029)
	     (list 3.15185 0.937129)
	     (list 2.53674 0.937129)
	     "c"
    )
    (command "pline"
	     (list 3.15181 0.937101)
	     "w"
	     0
	     0
	     (list 2.69115 0.0130807)
	     (list 2.69124 0.0130361)
	     (list 3.1519 0.937057)
	     "c"
    )
    (command "pline"
	     (list 2.6912 0.0131084)
	     "w"
	     0
	     0
	     (list 2.68849 0.0131084)
	     (list 2.68849 0.0130084)
	     (list 2.6912 0.0130084)
	     "c"
    )
  )

  (defun draw_8	()
    (command "pline"
	     (list 2.6049 0.00470398)
	     "w"
	     0
	     0
	     (list 2.45044 0.159159)
	     (list 2.45037 0.159088)
	     (list 2.60483 0.00463327)
	     "c"
    )
    (command "pline"
	     (list 2.45046 0.159124)
	     "w"
	     0
	     0
	     (list 2.45046 0.313579)
	     (list 2.45036 0.313579)
	     (list 2.45036 0.159124)
	     "c"
    )
    (command "pline"
	     (list 2.45044 0.313543)
	     "w"
	     0
	     0
	     (list 2.6049 0.465288)
	     (list 2.60483 0.46536)
	     (list 2.45037 0.313614)
	     "c"
    )
    (command "pline"
	     (list 2.60486 0.465274)
	     "w"
	     0
	     0
	     (list 2.91106 0.465274)
	     (list 2.91106 0.465374)
	     (list 2.60486 0.465374)
	     "c"
    )
    (command "pline"
	     (list 2.9111 0.465289)
	     "w"
	     0
	     0
	     (list 3.06555 0.619744)
	     (list 3.06548 0.619814)
	     (list 2.91103 0.465359)
	     "c"
    )
    (command "pline"
	     (list 3.06557 0.619779)
	     "w"
	     0
	     0
	     (list 3.06557 0.774234)
	     (list 3.06547 0.774234)
	     (list 3.06547 0.619779)
	     "c"
    )
    (command "pline"
	     (list 3.06555 0.774269)
	     "w"
	     0
	     0
	     (list 2.9111 0.928724)
	     (list 2.91103 0.928654)
	     (list 3.06548 0.774199)
	     "c"
    )
    (command "pline"
	     (list 2.91106 0.928739)
	     "w"
	     0
	     0
	     (list 2.60486 0.928739)
	     (list 2.60486 0.928639)
	     (list 2.91106 0.928639)
	     "c"
    )
    (command "pline"
	     (list 2.60483 0.928724)
	     "w"
	     0
	     0
	     (list 2.45037 0.774269)
	     (list 2.45044 0.774199)
	     (list 2.6049 0.928654)
	     "c"
    )
    (command "pline"
	     (list 2.45036 0.774234)
	     "w"
	     0
	     0
	     (list 2.45036 0.619779)
	     (list 2.45046 0.619779)
	     (list 2.45046 0.774234)
	     "c"
    )
    (command "pline"
	     (list 2.45037 0.619744)
	     "w"
	     0
	     0
	     (list 2.60483 0.465289)
	     (list 2.6049 0.465359)
	     (list 2.45044 0.619814)
	     "c"
    )
    (command "pline"
	     (list 2.60486 0.465374)
	     "w"
	     0
	     0
	     (list 2.60215 0.465374)
	     (list 2.60215 0.465274)
	     (list 2.60486 0.465274)
	     "c"
    )
    (command "pline"
	     (list 2.91103 0.465288)
	     "w"
	     0
	     0
	     (list 3.06548 0.313543)
	     (list 3.06555 0.313614)
	     (list 2.9111 0.46536)
	     "c"
    )
    (command "pline"
	     (list 3.06547 0.313579)
	     "w"
	     0
	     0
	     (list 3.06547 0.159124)
	     (list 3.06557 0.159124)
	     (list 3.06557 0.313579)
	     "c"
    )
    (command "pline"
	     (list 3.06548 0.159159)
	     "w"
	     0
	     0
	     (list 2.91103 0.00470398)
	     (list 2.9111 0.00463327)
	     (list 3.06555 0.159088)
	     "c"
    )
    (command "pline"
	     (list 2.91106 0.00471862)
	     "w"
	     0
	     0
	     (list 2.60486 0.00471862)
	     (list 2.60486 0.00461862)
	     (list 2.91106 0.00461862)
	     "c"
    )
    (command "pline"
	     (list 2.60486 0.00471862)
	     "w"
	     0
	     0
	     (list 2.60215 0.00471862)
	     (list 2.60215 0.00461862)
	     (list 2.60486 0.00461862)
	     "c"
    )
  )

  (defun draw_9	()
    (command "pline"
	     (list 2.60784 0.00481862)
	     "w"
	     0
	     0
	     (list 2.75959 0.00481862)
	     (list 2.75959 0.00491862)
	     (list 2.60784 0.00491862)
	     "c"
    )
    (command "pline"
	     (list 2.75962 0.00483327)
	     "w"
	     0
	     0
	     (list 3.06853 0.313743)
	     (list 3.06846 0.313814)
	     (list 2.75955 0.00490398)
	     "c"
    )
    (command "pline"
	     (list 3.06855 0.313779)
	     "w"
	     0
	     0
	     (list 3.06855 0.774434)
	     (list 3.06845 0.774434)
	     (list 3.06845 0.313779)
	     "c"
    )
    (command "pline"
	     (list 3.06853 0.774469)
	     "w"
	     0
	     0
	     (list 2.91408 0.928924)
	     (list 2.91401 0.928854)
	     (list 3.06846 0.774399)
	     "c"
    )
    (command "pline"
	     (list 2.91404 0.928939)
	     "w"
	     0
	     0
	     (list 2.60784 0.928939)
	     (list 2.60784 0.928839)
	     (list 2.91404 0.928839)
	     "c"
    )
    (command "pline"
	     (list 2.60781 0.928924)
	     "w"
	     0
	     0
	     (list 2.45335 0.774469)
	     (list 2.45342 0.774399)
	     (list 2.60788 0.928854)
	     "c"
    )
    (command "pline"
	     (list 2.45334 0.774434)
	     "w"
	     0
	     0
	     (list 2.45334 0.619979)
	     (list 2.45344 0.619979)
	     (list 2.45344 0.774434)
	     "c"
    )
    (command "pline"
	     (list 2.45335 0.619944)
	     "w"
	     0
	     0
	     (list 2.60781 0.465489)
	     (list 2.60788 0.465559)
	     (list 2.45342 0.620014)
	     "c"
    )
    (command "pline"
	     (list 2.60784 0.465474)
	     "w"
	     0
	     0
	     (list 3.0685 0.465474)
	     (list 3.0685 0.465574)
	     (list 2.60784 0.465574)
	     "c"
    )
    (command "pline"
	     (list 3.0685 0.465574)
	     "w"
	     0
	     0
	     (list 3.06579 0.465574)
	     (list 3.06579 0.465474)
	     (list 3.0685 0.465474)
	     "c"
    )
  )

  (defun draw_10 ()
    (command "pline"
	     (list 2.45051 0.76968)
	     "w"
	     0
	     0
	     (list 2.60496 0.924135)
	     (list 2.60489 0.924206)
	     (list 2.45044 0.769751)
	     "c"
    )
    (command "pline"
	     (list 2.60488 0.92417)
	     "w"
	     0
	     0
	     (list 2.60488 0.00015)
	     (list 2.60498 0.00015)
	     (list 2.60498 0.92417)
	     "c"
    )
    (command "pline"
	     (list 2.60493 0.0002)
	     "w"
	     0
	     0
	     (list 2.60222 0.0002)
	     (list 2.60222 0.0001)
	     (list 2.60493 0.0001)
	     "c"
    )
    (command "pline"
	     (list 2.45047 0.0001)
	     "w"
	     0
	     0
	     (list 2.75938 0.0001)
	     (list 2.75938 0.0002)
	     (list 2.45047 0.0002)
	     "c"
    )
    (command "pline"
	     (list 2.75938 0.0002)
	     "w"
	     0
	     0
	     (list 2.75667 0.0002)
	     (list 2.75667 0.0001)
	     (list 2.75938 0.0001)
	     "c"
    )
    (command "pline"
	     (list 3.22007 0.000185355)
	     "w"
	     0
	     0
	     (list 3.06562 0.15464)
	     (list 3.06555 0.15457)
	     (list 3.22 0.000114645)
	     "c"
    )
    (command "pline"
	     (list 3.06563 0.154605)
	     "w"
	     0
	     0
	     (list 3.06563 0.769715)
	     (list 3.06553 0.769715)
	     (list 3.06553 0.154605)
	     "c"
    )
    (command "pline"
	     (list 3.06562 0.76968)
	     "w"
	     0
	     0
	     (list 3.22007 0.924135)
	     (list 3.22 0.924206)
	     (list 3.06555 0.769751)
	     "c"
    )
    (command "pline"
	     (list 3.22004 0.92412)
	     "w"
	     0
	     0
	     (list 3.37449 0.92412)
	     (list 3.37449 0.92422)
	     (list 3.22004 0.92422)
	     "c"
    )
    (command "pline"
	     (list 3.37446 0.924135)
	     "w"
	     0
	     0
	     (list 3.52891 0.76968)
	     (list 3.52898 0.769751)
	     (list 3.37453 0.924206)
	     "c"
    )
    (command "pline"
	     (list 3.5289 0.769715)
	     "w"
	     0
	     0
	     (list 3.5289 0.154605)
	     (list 3.529 0.154605)
	     (list 3.529 0.769715)
	     "c"
    )
    (command "pline"
	     (list 3.52891 0.15464)
	     "w"
	     0
	     0
	     (list 3.37446 0.000185355)
	     (list 3.37453 0.000114645)
	     (list 3.52898 0.15457)
	     "c"
    )
    (command "pline"
	     (list 3.37449 0.0002)
	     "w"
	     0
	     0
	     (list 3.22004 0.0002)
	     (list 3.22004 0.0001)
	     (list 3.37449 0.0001)
	     "c"
    )
    (command "pline"
	     (list 3.22004 0.0002)
	     "w"
	     0
	     0
	     (list 3.21733 0.0002)
	     (list 3.21733 0.0001)
	     (list 3.22004 0.0001)
	     "c"
    )
  )

  (defun draw_11 ()
    (command "pline"
	     (list 2.45051 0.76968)
	     "w"
	     0
	     0
	     (list 2.60496 0.924135)
	     (list 2.60489 0.924206)
	     (list 2.45044 0.769751)
	     "c"
    )
    (command "pline"
	     (list 2.60488 0.92417)
	     "w"
	     0
	     0
	     (list 2.60488 0.00015)
	     (list 2.60498 0.00015)
	     (list 2.60498 0.92417)
	     "c"
    )
    (command "pline"
	     (list 2.60493 0.0002)
	     "w"
	     0
	     0
	     (list 2.60222 0.0002)
	     (list 2.60222 0.0001)
	     (list 2.60493 0.0001)
	     "c"
    )
    (command "pline"
	     (list 2.45047 0.0001)
	     "w"
	     0
	     0
	     (list 2.75667 0.0001)
	     (list 2.75667 0.0002)
	     (list 2.45047 0.0002)
	     "c"
    )
    (command "pline"
	     (list 2.75667 0.0002)
	     "w"
	     0
	     0
	     (list 2.75396 0.0002)
	     (list 2.75396 0.0001)
	     (list 2.75667 0.0001)
	     "c"
    )
    (command "pline"
	     (list 3.06562 0.76968)
	     "w"
	     0
	     0
	     (list 3.22007 0.924135)
	     (list 3.22 0.924206)
	     (list 3.06555 0.769751)
	     "c"
    )
    (command "pline"
	     (list 3.21999 0.92417)
	     "w"
	     0
	     0
	     (list 3.21999 0.00015)
	     (list 3.22009 0.00015)
	     (list 3.22009 0.92417)
	     "c"
    )
    (command "pline"
	     (list 3.22004 0.0002)
	     "w"
	     0
	     0
	     (list 3.21733 0.0002)
	     (list 3.21733 0.0001)
	     (list 3.22004 0.0001)
	     "c"
    )
    (command "pline"
	     (list 3.06558 0.0001)
	     "w"
	     0
	     0
	     (list 3.37449 0.0001)
	     (list 3.37449 0.0002)
	     (list 3.06558 0.0002)
	     "c"
    )
    (command "pline"
	     (list 3.37449 0.0002)
	     "w"
	     0
	     0
	     (list 3.37178 0.0002)
	     (list 3.37178 0.0001)
	     (list 3.37449 0.0001)
	     "c"
    )
  )


  (defun draw_12 ()
    (command "pline"
	     (list 2.45041 0.76958)
	     "w"
	     0
	     0
	     (list 2.60486 0.924035)
	     (list 2.60479 0.924106)
	     (list 2.45034 0.769651)
	     "c"
    )
    (command "pline"
	     (list 2.60478 0.92407)
	     "w"
	     0
	     0
	     (list 2.60478 5e-005)
	     (list 2.60488 5e-005)
	     (list 2.60488 0.92407)
	     "c"
    )
    (command "pline"
	     (list 2.60483 0.0001)
	     "w"
	     0
	     0
	     (list 2.60212 0.0001)
	     (list 2.60212 0.0)
	     (list 2.60483 0.0)
	     "c"
    )
    (command "pline"
	     (list 2.45037 0.0)
	     "w"
	     0
	     0
	     (list 2.75657 0.0)
	     (list 2.75657 0.0001)
	     (list 2.45037 0.0001)
	     "c"
    )
    (command "pline"
	     (list 2.75657 0.0001)
	     "w"
	     0
	     0
	     (list 2.75386 0.0001)
	     (list 2.75386 0.0)
	     (list 2.75657 0.0)
	     "c"
    )
    (command "pline"
	     (list 3.06552 0.76958)
	     "w"
	     0
	     0
	     (list 3.21997 0.924035)
	     (list 3.2199 0.924106)
	     (list 3.06545 0.769651)
	     "c"
    )
    (command "pline"
	     (list 3.21994 0.92402)
	     "w"
	     0
	     0
	     (list 3.52614 0.92402)
	     (list 3.52614 0.92412)
	     (list 3.21994 0.92412)
	     "c"
    )
    (command "pline"
	     (list 3.5261 0.924035)
	     "w"
	     0
	     0
	     (list 3.68056 0.76958)
	     (list 3.68063 0.769651)
	     (list 3.52617 0.924106)
	     "c"
    )
    (command "pline"
	     (list 3.68054 0.769615)
	     "w"
	     0
	     0
	     (list 3.68054 0.61516)
	     (list 3.68064 0.61516)
	     (list 3.68064 0.769615)
	     "c"
    )
    (command "pline"
	     (list 3.68056 0.615196)
	     "w"
	     0
	     0
	     (list 3.5261 0.460741)
	     (list 3.52617 0.46067)
	     (list 3.68063 0.615125)
	     "c"
    )
    (command "pline"
	     (list 3.52614 0.460755)
	     "w"
	     0
	     0
	     (list 3.21994 0.460755)
	     (list 3.21994 0.460655)
	     (list 3.52614 0.460655)
	     "c"
    )
    (command "pline"
	     (list 3.2199 0.460741)
	     "w"
	     0
	     0
	     (list 3.06545 0.308996)
	     (list 3.06552 0.308924)
	     (list 3.21997 0.46067)
	     "c"
    )
    (command "pline"
	     (list 3.06543 0.30896)
	     "w"
	     0
	     0
	     (list 3.06543 5e-005)
	     (list 3.06553 5e-005)
	     (list 3.06553 0.30896)
	     "c"
    )
    (command "pline"
	     (list 3.06548 0.0)
	     "w"
	     0
	     0
	     (list 3.68059 0.0)
	     (list 3.68059 0.0001)
	     (list 3.06548 0.0001)
	     "c"
    )
    (command "pline"
	     (list 3.68059 0.0001)
	     "w"
	     0
	     0
	     (list 3.67788 0.0001)
	     (list 3.67788 0.0)
	     (list 3.68059 0.0)
	     "c"
    )
  )

  (defun draw_13 ()
    (command "pline"
	     (list 2.45051 0.76978)
	     "w"
	     0
	     0
	     (list 2.60496 0.924235)
	     (list 2.60489 0.924306)
	     (list 2.45044 0.769851)
	     "c"
    )
    (command "pline"
	     (list 2.60488 0.92427)
	     "w"
	     0
	     0
	     (list 2.60488 0.00025)
	     (list 2.60498 0.00025)
	     (list 2.60498 0.92427)
	     "c"
    )
    (command "pline"
	     (list 2.60493 0.0003)
	     "w"
	     0
	     0
	     (list 2.60222 0.0003)
	     (list 2.60222 0.0002)
	     (list 2.60493 0.0002)
	     "c"
    )
    (command "pline"
	     (list 2.45047 0.0002)
	     "w"
	     0
	     0
	     (list 2.75938 0.0002)
	     (list 2.75938 0.0003)
	     (list 2.45047 0.0003)
	     "c"
    )
    (command "pline"
	     (list 2.75938 0.0003)
	     "w"
	     0
	     0
	     (list 2.75667 0.0003)
	     (list 2.75667 0.0002)
	     (list 2.75938 0.0002)
	     "c"
    )
    (command "pline"
	     (list 3.06833 0.76978)
	     "w"
	     0
	     0
	     (list 3.22007 0.924235)
	     (list 3.22 0.924306)
	     (list 3.06826 0.76985)
	     "c"
    )
    (command "pline"
	     (list 3.22004 0.92422)
	     "w"
	     0
	     0
	     (list 3.52895 0.92422)
	     (list 3.52895 0.92432)
	     (list 3.22004 0.92432)
	     "c"
    )
    (command "pline"
	     (list 3.52891 0.924235)
	     "w"
	     0
	     0
	     (list 3.68337 0.76978)
	     (list 3.68344 0.769851)
	     (list 3.52898 0.924306)
	     "c"
    )
    (command "pline"
	     (list 3.68335 0.769815)
	     "w"
	     0
	     0
	     (list 3.68335 0.61536)
	     (list 3.68345 0.61536)
	     (list 3.68345 0.769815)
	     "c"
    )
    (command "pline"
	     (list 3.68337 0.615396)
	     "w"
	     0
	     0
	     (list 3.52891 0.460941)
	     (list 3.52898 0.46087)
	     (list 3.68344 0.615325)
	     "c"
    )
    (command "pline"
	     (list 3.52895 0.460955)
	     "w"
	     0
	     0
	     (list 3.37449 0.460955)
	     (list 3.37449 0.460855)
	     (list 3.52895 0.460855)
	     "c"
    )
    (command "pline"
	     (list 3.37449 0.460955)
	     "w"
	     0
	     0
	     (list 3.37178 0.460955)
	     (list 3.37178 0.460855)
	     (list 3.37449 0.460855)
	     "c"
    )
    (command "pline"
	     (list 3.52891 0.46087)
	     "w"
	     0
	     0
	     (list 3.68337 0.309124)
	     (list 3.68344 0.309196)
	     (list 3.52898 0.460941)
	     "c"
    )
    (command "pline"
	     (list 3.68335 0.30916)
	     "w"
	     0
	     0
	     (list 3.68335 0.154705)
	     (list 3.68345 0.154705)
	     (list 3.68345 0.30916)
	     "c"
    )
    (command "pline"
	     (list 3.68337 0.15474)
	     "w"
	     0
	     0
	     (list 3.52891 0.000285355)
	     (list 3.52898 0.000214645)
	     (list 3.68344 0.15467)
	     "c"
    )
    (command "pline"
	     (list 3.52895 0.0003)
	     "w"
	     0
	     0
	     (list 3.22004 0.0003)
	     (list 3.22004 0.0002)
	     (list 3.52895 0.0002)
	     "c"
    )
    (command "pline"
	     (list 3.22007 0.000285041)
	     "w"
	     0
	     0
	     (list 3.06833 0.15474)
	     (list 3.06826 0.15467)
	     (list 3.22 0.000214959)
	     "c"
    )
    (command "pline"
	     (list 3.06829 0.154755)
	     "w"
	     0
	     0
	     (list 3.06558 0.154755)
	     (list 3.06558 0.154655)
	     (list 3.06829 0.154655)
	     "c"
    )
  )

  (defun draw_14 ()
    (command "pline"
	     (list 2.45046 0.76943)
	     "w"
	     0
	     0
	     (list 2.60491 0.923885)
	     (list 2.60484 0.923956)
	     (list 2.45039 0.769501)
	     "c"
    )
    (command "pline"
	     (list 2.60483 0.92392)
	     "w"
	     0
	     0
	     (list 2.60483 -0.0001)
	     (list 2.60493 -0.0001)
	     (list 2.60493 0.92392)
	     "c"
    )
    (command "pline"
	     (list 2.60488 -5e-005)
	     "w"
	     0
	     0
	     (list 2.60217 -5e-005)
	     (list 2.60217 -0.00015)
	     (list 2.60488 -0.00015)
	     "c"
    )
    (command "pline"
	     (list 2.45042 -0.00015)
	     "w"
	     0
	     0
	     (list 2.75662 -0.00015)
	     (list 2.75662 -5e-005)
	     (list 2.45042 -5e-005)
	     "c"
    )
    (command "pline"
	     (list 2.75662 -5e-005)
	     "w"
	     0
	     0
	     (list 2.75391 -5e-005)
	     (list 2.75391 -0.00015)
	     (list 2.75662 -0.00015)
	     "c"
    )
    (command "pline"
	     (list 3.68064 0.30886)
	     "w"
	     0
	     0
	     (list 3.06553 0.30886)
	     (list 3.06553 0.30876)
	     (list 3.68064 0.30876)
	     "c"
    )
    (command "pline"
	     (list 3.06557 0.30878)
	     "w"
	     0
	     0
	     (list 3.52623 0.923891)
	     (list 3.52615 0.92395)
	     (list 3.06549 0.30884)
	     "c"
    )
    (command "pline"
	     (list 3.52614 0.92392)
	     "w"
	     0
	     0
	     (list 3.52614 -0.0001)
	     (list 3.52624 -0.0001)
	     (list 3.52624 0.92392)
	     "c"
    )
    (command "pline"
	     (list 3.52619 -5e-005)
	     "w"
	     0
	     0
	     (list 3.52348 -5e-005)
	     (list 3.52348 -0.00015)
	     (list 3.52619 -0.00015)
	     "c"
    )
  )

  (defun
	    draw_15
		   ()
    (command "pline"
	     (list 2.45046 0.76943)
	     "w"
	     0
	     0
	     (list 2.60491 0.923885)
	     (list 2.60484 0.923956)
	     (list 2.45039 0.769501)
	     "c"
    )
    (command "pline"
	     (list 2.60483 0.92392)
	     "w"
	     0
	     0
	     (list 2.60483 -0.0001)
	     (list 2.60493 -0.0001)
	     (list 2.60493 0.92392)
	     "c"
    )
    (command "pline"
	     (list 2.60488 -5e-005)
	     "w"
	     0
	     0
	     (list 2.60217 -5e-005)
	     (list 2.60217 -0.00015)
	     (list 2.60488 -0.00015)
	     "c"
    )
    (command "pline"
	     (list 2.45042 -0.00015)
	     "w"
	     0
	     0
	     (list 2.75933 -0.00015)
	     (list 2.75933 -5e-005)
	     (list 2.45042 -5e-005)
	     "c"
    )
    (command "pline"
	     (list 2.75933 -5e-005)
	     "w"
	     0
	     0
	     (list 2.75662 -5e-005)
	     (list 2.75662 -0.00015)
	     (list 2.75933 -0.00015)
	     "c"
    )
    (command "pline"
	     (list 3.06821 0.15432)
	     "w"
	     0
	     0
	     (list 3.21995 -0.000135041)
	     (list 3.22002 -6.49589e-005)
	     (list 3.06828 0.15439)
	     "c"
    )
    (command "pline"
	     (list 3.21999 -0.00015)
	     "w"
	     0
	     0
	     (list 3.5289 -0.00015)
	     (list 3.5289 -5e-005)
	     (list 3.21999 -5e-005)
	     "c"
    )
    (command "pline"
	     (list 3.52893 -0.000135355)
	     "w"
	     0
	     0
	     (list 3.68339 0.15432)
	     (list 3.68332 0.15439)
	     (list 3.52886 -6.46447e-005)
	     "c"
    )
    (command "pline"
	     (list 3.6834 0.154355)
	     "w"
	     0
	     0
	     (list 3.6834 0.460555)
	     (list 3.6833 0.460555)
	     (list 3.6833 0.154355)
	     "c"
    )
    (command "pline"
	     (list 3.68339 0.460591)
	     "w"
	     0
	     0
	     (list 3.52893 0.615046)
	     (list 3.52886 0.614975)
	     (list 3.68332 0.46052)
	     "c"
    )
    (command "pline"
	     (list 3.5289 0.61506)
	     "w"
	     0
	     0
	     (list 3.06824 0.61506)
	     (list 3.06824 0.61496)
	     (list 3.5289 0.61496)
	     "c"
    )
    (command "pline"
	     (list 3.06829 0.61501)
	     "w"
	     0
	     0
	     (list 3.06829 0.92392)
	     (list 3.06819 0.92392)
	     (list 3.06819 0.61501)
	     "c"
    )
    (command "pline"
	     (list 3.06824 0.92387)
	     "w"
	     0
	     0
	     (list 3.68335 0.92387)
	     (list 3.68335 0.92397)
	     (list 3.06824 0.92397)
	     "c"
    )
    (command "pline"
	     (list 3.68335 0.92397)
	     "w"
	     0
	     0
	     (list 3.68064 0.92397)
	     (list 3.68064 0.92387)
	     (list 3.68335 0.92387)
	     "c"
    )
  )

  (defun draw_16 ()
    (command "pline"
	     (list 2.45041 0.76968)
	     "w"
	     0
	     0
	     (list 2.60486 0.924135)
	     (list 2.60479 0.924206)
	     (list 2.45034 0.769751)
	     "c"
    )
    (command "pline"
	     (list 2.60478 0.92417)
	     "w"
	     0
	     0
	     (list 2.60478 0.00015)
	     (list 2.60488 0.00015)
	     (list 2.60488 0.92417)
	     "c"
    )
    (command "pline"
	     (list 2.60483 0.0002)
	     "w"
	     0
	     0
	     (list 2.60212 0.0002)
	     (list 2.60212 0.0001)
	     (list 2.60483 0.0001)
	     "c"
    )
    (command "pline"
	     (list 2.45037 0.0001)
	     "w"
	     0
	     0
	     (list 2.75928 0.0001)
	     (list 2.75928 0.0002)
	     (list 2.45037 0.0002)
	     "c"
    )
    (command "pline"
	     (list 2.75928 0.0002)
	     "w"
	     0
	     0
	     (list 2.75657 0.0002)
	     (list 2.75657 0.0001)
	     (list 2.75928 0.0001)
	     "c"
    )
    (command "pline"
	     (list 3.06548 0.460755)
	     "w"
	     0
	     0
	     (list 3.52614 0.460755)
	     (list 3.52614 0.460855)
	     (list 3.06548 0.460855)
	     "c"
    )
    (command "pline"
	     (list 3.5261 0.46077)
	     "w"
	     0
	     0
	     (list 3.68056 0.309024)
	     (list 3.68063 0.309096)
	     (list 3.52617 0.460841)
	     "c"
    )
    (command "pline"
	     (list 3.68054 0.30906)
	     "w"
	     0
	     0
	     (list 3.68054 0.154605)
	     (list 3.68064 0.154605)
	     (list 3.68064 0.30906)
	     "c"
    )
    (command "pline"
	     (list 3.68056 0.15464)
	     "w"
	     0
	     0
	     (list 3.5261 0.000185355)
	     (list 3.52617 0.000114645)
	     (list 3.68063 0.15457)
	     "c"
    )
    (command "pline"
	     (list 3.52614 0.0002)
	     "w"
	     0
	     0
	     (list 3.21994 0.0002)
	     (list 3.21994 0.0001)
	     (list 3.52614 0.0001)
	     "c"
    )
    (command "pline"
	     (list 3.21997 0.000185355)
	     "w"
	     0
	     0
	     (list 3.06552 0.15464)
	     (list 3.06545 0.15457)
	     (list 3.2199 0.000114645)
	     "c"
    )
    (command "pline"
	     (list 3.06553 0.154605)
	     "w"
	     0
	     0
	     (list 3.06553 0.61526)
	     (list 3.06543 0.61526)
	     (list 3.06543 0.154605)
	     "c"
    )
    (command "pline"
	     (list 3.06552 0.615225)
	     "w"
	     0
	     0
	     (list 3.37443 0.924135)
	     (list 3.37436 0.924206)
	     (list 3.06545 0.615296)
	     "c"
    )
    (command "pline"
	     (list 3.37439 0.92412)
	     "w"
	     0
	     0
	     (list 3.52614 0.92412)
	     (list 3.52614 0.92422)
	     (list 3.37439 0.92422)
	     "c"
    )
    (command "pline"
	     (list 3.52614 0.92422)
	     "w"
	     0
	     0
	     (list 3.52343 0.92422)
	     (list 3.52343 0.92412)
	     (list 3.52614 0.92412)
	     "c"
    )
  )

  (defun draw_a	()
    (command "pline"
	     (list 5e-005 0.0)
	     "w"
	     0
	     0
	     (list 5e-005 0.30891)
	     (list -5e-005 0.30891)
	     (list -5e-005 0.0)
	     "c"
    )
    (command "pline"
	     (list 4.46819e-005 0.308888)
	     "w"
	     0
	     0
	     (list 0.308955 0.923998)
	     (list 0.308865 0.924043)
	     (list -4.46819e-005 0.308933)
	     "c"
    )
    (command "pline"
	     (list 0.308865 0.923998)
	     "w"
	     0
	     0
	     (list 0.615066 0.308888)
	     (list 0.615155 0.308932)
	     (list 0.308955 0.924043)
	     "c"
    )
    (command "pline"
	     (list 0.61506 0.30891)
	     "w"
	     0
	     0
	     (list 0.61506 0.0)
	     (list 0.61516 0.0)
	     (list 0.61516 0.30891)
	     "c"
    )
    (command "pline"
	     (list 0.61511 5e-005)
	     "w"
	     0
	     0
	     (list 0.612401 5e-005)
	     (list 0.612401 -5e-005)
	     (list 0.61511 -5e-005)
	     "c"
    )
    (command "pline"
	     (list 0.0 0.30886)
	     "w"
	     0
	     0
	     (list 0.61511 0.30886)
	     (list 0.61511 0.30896)
	     (list 0.0 0.30896)
	     "c"
    )
    (command "pline"
	     (list 0.61511 0.30896)
	     "w"
	     0
	     0
	     (list 0.612401 0.30896)
	     (list 0.612401 0.30886)
	     (list 0.61511 0.30886)
	     "c"
    )
  )

  (defun draw_b	()
    (command "pline"
	     (list -0.00705884 -5e-005)
	     "w"
	     0
	     0
	     (list 0.453597 -5e-005)
	     (list 0.453597 5e-005)
	     (list -0.00705884 5e-005)
	     "c"
    )
    (command "pline"
	     (list 0.453632 -3.53553e-005)
	     "w"
	     0
	     0
	     (list 0.608087 0.15442)
	     (list 0.608016 0.15449)
	     (list 0.453561 3.53553e-005)
	     "c"
    )
    (command "pline"
	     (list 0.608102 0.154455)
	     "w"
	     0
	     0
	     (list 0.608102 0.30891)
	     (list 0.608002 0.30891)
	     (list 0.608002 0.154455)
	     "c"
    )
    (command "pline"
	     (list 0.608087 0.308945)
	     "w"
	     0
	     0
	     (list 0.453632 0.4634)
	     (list 0.453561 0.46333)
	     (list 0.608016 0.308875)
	     "c"
    )
    (command "pline"
	     (list 0.453597 0.463415)
	     "w"
	     0
	     0
	     (list 0.147396 0.463415)
	     (list 0.147396 0.463315)
	     (list 0.453597 0.463315)
	     "c"
    )
    (command "pline"
	     (list 0.147396 0.463415)
	     "w"
	     0
	     0
	     (list 0.144686 0.463415)
	     (list 0.144686 0.463315)
	     (list 0.147396 0.463315)
	     "c"
    )
    (command "pline"
	     (list 0.453632 0.463329)
	     "w"
	     0
	     0
	     (list 0.608087 0.615075)
	     (list 0.608017 0.615146)
	     (list 0.453561 0.463401)
	     "c"
    )
    (command "pline"
	     (list 0.608102 0.61511)
	     "w"
	     0
	     0
	     (list 0.608102 0.769565)
	     (list 0.608002 0.769565)
	     (list 0.608002 0.61511)
	     "c"
    )
    (command "pline"
	     (list 0.608087 0.769601)
	     "w"
	     0
	     0
	     (list 0.453632 0.924056)
	     (list 0.453561 0.923985)
	     (list 0.608016 0.76953)
	     "c"
    )
    (command "pline"
	     (list 0.453597 0.92407)
	     "w"
	     0
	     0
	     (list -0.00705884 0.92407)
	     (list -0.00705884 0.92397)
	     (list 0.453597 0.92397)
	     "c"
    )
    (command "pline"
	     (list -0.00705884 0.92407)
	     "w"
	     0
	     0
	     (list -0.00976858 0.92407)
	     (list -0.00976858 0.92397)
	     (list -0.00705884 0.92397)
	     "c"
    )
    (command "pline"
	     (list 0.147346 0.92402)
	     "w"
	     0
	     0
	     (list 0.147346 0.0)
	     (list 0.147446 0.0)
	     (list 0.147446 0.92402)
	     "c"
    )
    (command "pline"
	     (list 0.147396 5e-005)
	     "w"
	     0
	     0
	     (list 0.144686 5e-005)
	     (list 0.144686 -5e-005)
	     (list 0.147396 -5e-005)
	     "c"
    )
  )

  (defun draw_m	()
    (command "pline"
	     (list 1.71931 0.972554)
	     "w"
	     0
	     0
	     (list 1.71931 0.0489174)
	     (list 1.71941 0.0489174)
	     (list 1.71941 0.972554)
	     "c"
    )
    (command "pline"
	     (list 1.4117 0.356728)
	     "w"
	     0
	     0
	     (list 1.7194 0.972531)
	     (list 1.71931 0.972576)
	     (list 1.41161 0.356773)
	     "c"
    )
    (command "pline"
	     (list 1.10392 0.972531)
	     "w"
	     0
	     0
	     (list 1.41161 0.356728)
	     (list 1.4117 0.356773)
	     (list 1.10401 0.972576)
	     "c"
    )
    (command "pline"
	     (list 1.10401 0.0489174)
	     "w"
	     0
	     0
	     (list 1.10401 0.972554)
	     (list 1.10391 0.972554)
	     (list 1.10391 0.0489174)
	     "c"
    )
  )
  (defun draw_mn ()
    (command "pline"
	     (list 0.985159 0.156392)
	     "w"
	     0
	     0
	     (list 1.83909 0.736757)
	     (list 1.83903 0.73684)
	     (list 0.985103 0.156475)
	     "c"
    )
    (command "pline"
	     (list 0.962142 0.6996)
	     "w"
	     0
	     0
	     (list 1.8621 0.19355)
	     (list 1.86215 0.193638)
	     (list 0.962191 0.699687)
	     "c"
    )
    (command "pline"
	     (list 1.12118 -0.00451849)
	     "w"
	     0
	     0
	     (list 1.12118 0.919118)
	     (list 1.12108 0.919118)
	     (list 1.12108 -0.00451849)
	     "c"
    )
    (command "pline"
	     (list 1.12109 0.919096)
	     "w"
	     0
	     0
	     (list 1.42878 0.303292)
	     (list 1.42887 0.303337)
	     (list 1.12118 0.91914)
	     "c"
    )
    (command "pline"
	     (list 1.42887 0.303292)
	     "w"
	     0
	     0
	     (list 1.73657 0.919096)
	     (list 1.73648 0.91914)
	     (list 1.42878 0.303337)
	     "c"
    )
    (command "pline"
	     (list 1.73647 0.919118)
	     "w"
	     0
	     0
	     (list 1.73647 -0.00451849)
	     (list 1.73657 -0.00451849)
	     (list 1.73657 0.919118)
	     "c"
    )
    (command "pline"
	     (list 1.73652 -0.00446849)
	     "w"
	     0
	     0
	     (list 1.73639 -0.00446849)
	     (list 1.73639 -0.00456849)
	     (list 1.73652 -0.00456849)
	     "c"
    )
  )
 (setq tmp_post (list (- (car position)) (- (cadr position)) 0))
  (command "ucs" "o" position)
  (command "layer" "M" "f_dev" "")  
  (if (= AB "A")
    (draw_a)
    (draw_b)
    )
  (if (= M "Yes")
    (draw_m)
    (draw_mn)
    )
  (cond
    ((= num 1) (draw_1))
    ((= num 2) (draw_2))
    ((= num 3) (draw_3))
    ((= num 4) (draw_4))
    ((= num 5) (draw_5))
    ((= num 6) (draw_6))
    ((= num 7) (draw_7))
    ((= num 8) (draw_8))
    ((= num 9) (draw_9))
    ((= num 10) (draw_10))
    ((= num 11) (draw_11))
    ((= num 12) (draw_12))
    ((= num 13) (draw_13))
    ((= num 14) (draw_14))
    ((= num 15) (draw_15))
    ((= num 16) (draw_16))
    )
  (setq devmrk (ssget "x" (list (cons 8 "f_dev"))))
  (if (= rot "Y")
    (command "rotate" devmrk "" '(0 0 0) 90)
    )
  (command "change" devmrk "" "p" "layer" "f" "")
  (command "layer" "M" "F" "")
  (command "ucs" "o" tmp_post)
)
(defun ofst_pnt	(p x_ofst y_ofst)
  (setq x_val (car p))
  (setq y_val (cadr p))
  (list
    (+ x_val x_ofst)
    (+ y_val y_ofst)
  )
)
(defun chk_box (x_size y_size)
  (setq half_x_size (/ x_size 2))
  (setq half_y_size (/ y_size 2))
  (setq	rgt_up_cnr  (ofst_pnt (list 0 0) half_x_size half_y_size)
	lft_dwn_cnr (ofst_pnt (list 0 0) (- half_x_size) (- half_y_size))
  )
  (setq ss_ld lft_dwn_cnr)
  (setq ss_ru (ofst_pnt lft_dwn_cnr 10 y_size))
  (setq nothing_ss (ssget "C" ss_ld ss_ru))
  (if nothing_ss
    (progn
      (getstring
	"\n在左边的11MM区有图形，如铬版尺寸等于或接近于版材尺材，请在流程单上注明这种情况！"
      )
    )
  )
  (setq ss_ld lft_dwn_cnr)
  (setq ss_ru (ofst_pnt lft_dwn_cnr x_size 10))
  (setq nothing_ss (ssget "C" ss_ld ss_ru))
  (if nothing_ss
    (progn
      (getstring
	"\n在下边的11MM区有图形，如铬版尺寸等于或接近于版材尺材，请在流程单上注明这种情况！"
      )
    )
  )
  (setq ss_ru (ofst_pnt rgt_up_cnr (- x_size) -10))
  (setq ss_ld rgt_up_cnr)
  (setq nothing_ss (ssget "C" ss_ld ss_ru))
  (if nothing_ss
    (progn
      (getstring
	"\n在上边的11MM区有图形，如铬版尺寸等于或接近于版材尺材，请在流程单上注明这种情况！"
      )
    )
  )
  (setq ss_ru (ofst_pnt rgt_up_cnr -10 (- y_size)))
  (setq ss_ld rgt_up_cnr)
  (setq nothing_ss (ssget "C" ss_ld ss_ru))
  (if nothing_ss
    (progn
      (getstring
	"\n在右边的11MM区有图形，如铬版尺寸等于或接近于版材尺材，请在流程单上注明这种情况！"
      )
    )
  )
  (command "layer" "M" "F" "")

)
(defun chk_dev_pst (left_down right_up)
  (setq nothing_ss (ssget "C" left_down right_up))
  (if nothing_ss
    (setq result nil)
    (setq result T)
  )
)
(defun get_dev_pst_x (xsize ysize dist_to_frm hlf_dev_high)
  (setq	left_down (ofst_pnt (list (+ (- (/ xsize 2)) dist_to_frm) 0)
			    0
			    (- hlf_dev_high)
		  )
  )
  (setq	right_up (ofst_pnt (list (+ (- (/ xsize 2)) dist_to_frm) 0)
			   9
			   hlf_dev_high
		 )
  )
  (setq half_high (- (fix (/ ysize 2)) 10))
  (setq n_loop 0)
  (setq ok_rst "N")
  (if (chk_dev_pst left_down right_up)
    (setq ok_rst "U")
  )
  (while (and (< n_loop half_high) (= ok_rst "N"))
    (if	(chk_dev_pst
	  (ofst_pnt left_down 0 n_loop)
	  (ofst_pnt right_up 0 n_loop)
	)
      (setq ok_rst "U")
      (if (chk_dev_pst
	    (ofst_pnt left_down 0 (- n_loop))
	    (ofst_pnt right_up 0 (- n_loop))
	  )
	(setq ok_rst "D")
      )
    )
    (setq n_loop (+ n_loop 2))
  )
  (if (= ok_rst "U")
    (setq dev_pst (ofst_pnt left_down 0 n_loop))
  )
  (if (= ok_rst "D")
    (setq dev_pst (ofst_pnt left_down 0 (- n_loop)))
  )
  (if (= ok_rst "N")
    (setq dev_pst nil)
  )
  (setq dev_pst dev_pst)
)

(defun get_dev_pst_y (xsize ysize dist_to_frm hlf_dev_high)
  (setq	left_down (ofst_pnt (list 0 (- (/ ysize 2) dist_to_frm))
			    (- hlf_dev_high)
			    -9
		  )
  )
  (setq	right_up (ofst_pnt (list 0 (- (/ ysize 2) dist_to_frm))
			   hlf_dev_high
			   0
		 )
  )
  (setq half_high (- (fix (/ xsize 2)) 10))
  (setq n_loop 0)
  (setq ok_rst "N")
  (if (chk_dev_pst left_down right_up)
    (setq ok_rst "R")
  )
  (while (and (< n_loop half_high) (= ok_rst "N"))
    (if	(chk_dev_pst
	  (ofst_pnt left_down n_loop 0)
	  (ofst_pnt right_up n_loop 0)
	)
      (setq ok_rst "R")
      (if (chk_dev_pst
	    (ofst_pnt left_down (- n_loop) 0)
	    (ofst_pnt right_up (- n_loop) 0)
	  )
	(setq ok_rst "L")
      )
    )
    (setq n_loop (+ n_loop 2))
  )
  (if (= ok_rst "R")
    (setq dev_pst (ofst_pnt left_down n_loop 0))
  )
  (if (= ok_rst "L")
    (setq dev_pst (ofst_pnt left_down (- n_loop) 0))
  )
  (if (= ok_rst "N")
    (setq dev_pst nil)
  )
  (setq dev_pst dev_pst)
)
(defun dev (xsize ysize m10)
  (initget 1 "A B")
  (setq machine (getkword "\n请选机型800(A)/800(B)?:"))
  (if (>= ysize xsize)
    (progn
      (initget 1 "Yes No")
      (setq mirror (getkword "\n图形是否镜像(Yes/No)?"))
    )
    (setq mirror "No")
  )
  (initget 6)
  (setq dev_num (getint "请输入要加的显影标的区数:"))
  (if (> dev_num 16)
    (progn
      (prompt "\n显影区数目太多,我无法正常工作!")
      (exit)
    )
  )
  (initget 0)
  (if m10
    (if	(>= y_size x_size)
      (progn
	(setq left_pst (get_dev_pst_x xsize ysize 8 17))
	(setq right_pst (get_dev_pst_x xsize ysize (- xsize 17) 17))
	(if (and left_pst right_pst)
	  (progn
	    (draw_dev left_pst "Y" xsize ysize dev_num machine mirror)
	    (draw_dev right_pst "Y" xsize ysize dev_num machine mirror)
	  )
	  (getstring
	    "\n 找不到合适的位置加显影标，请手工忝加"
	  )
	)
      )
      (progn
	(setq up_pst (get_dev_pst_y xsize ysize 8 17))
	(setq down_pst (get_dev_pst_y xsize ysize (- ysize 17) 17))
	(if (and up_pst down_pst)
	  (progn
	    (draw_dev up_pst "X" xsize ysize dev_num machine mirror)
	    (draw_dev down_pst "X" xsize ysize dev_num machine mirror)
	  )
	  (getstring
	    "\n 找不到合适的位置加显影标，请运行m_dev手工选点"
	  )
	)
      )
    )
    (if	(>= y_size x_size)
      (progn
	(setq frm_dist 8)
	(setq left_pst (get_dev_pst_x xsize ysize frm_dist 17))
	(setq right_pst	(get_dev_pst_x
			  xsize
			  ysize
			  (- xsize (+ frm_dist 9))
			  17
			)
	)
	(while (and (not (and left_pst right_pst)) (> frm_dist 2))
	  (setq frm_dist (- frm_dist 2))
	  (setq left_pst (get_dev_pst_x xsize ysize frm_dist 17))
	  (setq	right_pst (get_dev_pst_x
			    xsize
			    ysize
			    (- xsize (+ frm_dist 9))
			    17
			  )
	  )
	)
	(if (and left_pst right_pst)
	  (progn
	    (draw_dev left_pst "Y" xsize ysize dev_num machine mirror)
	    (draw_dev right_pst "Y" xsize ysize dev_num machine mirror)
	  )
	  (getstring
	    "\n 找不到合适的位置加显影标，请运行m_dev手工选点"
	  )
	)
      )
      (progn
	(setq frm_dist 8)
	(setq up_pst (get_dev_pst_y xsize ysize frm_dist 17))
	(setq down_pst (get_dev_pst_y
			 xsize
			 ysize
			 (- ysize (+ frm_dist 9))
			 17
		       )
	)
	(while (and (not (and up_pst down_pst)) (> frm_dist 2))
	  (setq frm_dist (- frm_dist 2))
	  (setq up_pst (get_dev_pst_y xsize ysize frm_dist 17))
	  (setq	down_pst (get_dev_pst_y
			   xsize
			   ysize
			   (- ysize (+ frm_dist 9))
			   17
			 )
	  )
	)
	(if (and up_pst down_pst)
	  (progn
	    (draw_dev up_pst "X" xsize ysize dev_num machine mirror)
	    (draw_dev down_pst "X" xsize ysize dev_num machine mirror)
	  )
	  (getstring
	    "\n 找不到合适的位置加显影标，请运行m_dev手工选点"
	  )
	)
      )
    )
  )
)
(defun draw_dev	(position direction xsize ysize dev_num machine mirror)
  (setq base_high 0.399875)
  (setq line_num 300)
  (if (= machine "A")
    (setq increase_width 0.000125)
    (if	(= machine "B")
      (setq increase_width 0.0001)
      (prompt "\n请选择正确的机型!")
    )
  )
  (setq dev_num_tmp dev_num)
  (setq bg_blk (* (/ dev_num 4) 4))
  (setq dev_num (- dev_num bg_blk))
  (if (> bg_blk 0)
    (setq bg_blk (- bg_blk (- 4 dev_num)))
  )
  (setq bg_wid (* bg_blk 2 increase_width))
  (if (or (> bg_blk 0) (= dev_num 0))
    (setq dev_num 4)
  )
  (setq line_patch (* 0.01 (/ increase_width 0.000125)))
  (setq step_len (* line_num 2 line_patch))
  (setq step_len (fix (+ step_len 2)))
  (if (= direction "Y")
    (if	(= mirror "Yes")      
      (progn
	(setq position (ofst_pnt position 0 34))
	(setq y_pst (cadr position))
	(setq diff (+ (/ ysize 2.0) 0.15))
	(setq diff (- diff (fix diff)))
	(setq diff (- base_high diff))
	;;;;;;;;;;;;;;;;;;;;;;;;;;;
	(dev_mark (ofst_pnt position 2 -1.5) machine mirror dev_num_tmp "N")
	(setq position (list (car position) (- (fix y_pst) diff)))
	(setq position (ofst_pnt position 2 -2))
	(setq i_loop 1)
	(while (<= i_loop dev_num)
	  (setq	p1 (ofst_pnt position 0 (- (* (- i_loop 1) step_len)))
		P2 (ofst_pnt position 5 (- (* (- i_loop 1) step_len)))
		p3 (ofst_pnt position
			     5
			     (-
			       (+ bg_wid
				  (* i_loop 2.0 increase_width)
				  (- increase_width)
				  (* (- i_loop 1) step_len)
			       )
			     )
		   )
		p4 (ofst_pnt position
			     0
			     (-	(+ bg_wid
				   (* i_loop 2.0 increase_width)
				   (- increase_width)
				   (* (- i_loop 1) step_len)
				)
			     )
		   )
	  )
	  (command "pline" p1 p2 p3 p4 "c")
	  (command "array" "L" "" "R" line_num "1" (- line_patch))
	  (setq	p1 (ofst_pnt
		     position
		     0
		     (- (+ (* (- i_loop 1) step_len) (* line_num line_patch)))
		   )
		P2 (ofst_pnt
		     position
		     5
		     (- (+ (* (- i_loop 1) step_len) (* line_num line_patch)))
		   )
		p3 (ofst_pnt position
			     5
			     (-
			       (+	bg_wid
				(* i_loop 2 increase_width)
				(* (- i_loop 1) step_len)
				(* line_num line_patch)
			     ))
		   )
		p4 (ofst_pnt position
			     0
			     (-
			       (+	bg_wid
				(* i_loop 2 increase_width)
				(* (- i_loop 1) step_len)
				(* line_num line_patch)
			     ))
		   )
	  )
	  (command "pline" p1 p2 p3 p4 "c")
	  (command "array" "L" "" "R" line_num "1" (- line_patch))
	  (setq i_loop (1+ i_loop))
	)
      )
      (progn
	(setq y_pst (cadr position))
	(setq diff (+ (/ ysize 2.0) 0.15))
	(setq diff (- diff (fix diff)))
	(setq diff (- base_high diff))
	;;;;;;;;;;;;;;;;;;;;;;;;;;;
	(dev_mark (ofst_pnt position 2 1.0) machine mirror dev_num_tmp "N")
	(setq position (list (car position) (+ (fix y_pst) diff)))
	(setq position (ofst_pnt position 2 2))
	(setq i_loop 1)
	(while (<= i_loop dev_num)
	  (setq	p1 (ofst_pnt position 0 (* (- i_loop 1) step_len))
		P2 (ofst_pnt position 5 (* (- i_loop 1) step_len))
		p3 (ofst_pnt position
			     5
			     (+	bg_wid
				(* i_loop 2.0 increase_width)
				(- increase_width)
				(* (- i_loop 1) step_len)
			     )
		   )
		p4 (ofst_pnt position
			     0
			     (+	bg_wid
				(* i_loop 2.0 increase_width)
				(- increase_width)
				(* (- i_loop 1) step_len)
			     )
		   )
	  )
	  (command "pline" p1 p2 p3 p4 "c")
	  (command "array" "L" "" "R" line_num "1" line_patch)
	  (setq	p1 (ofst_pnt
		     position
		     0
		     (+ (* (- i_loop 1) step_len) (* line_num line_patch))
		   )
		P2 (ofst_pnt
		     position
		     5
		     (+ (* (- i_loop 1) step_len) (* line_num line_patch))
		   )
		p3 (ofst_pnt position
			     5
			     (+	bg_wid
				(* i_loop 2 increase_width)
				(* (- i_loop 1) step_len)
				(* line_num line_patch)
			     )
		   )
		p4 (ofst_pnt position
			     0
			     (+	bg_wid
				(* i_loop 2 increase_width)
				(* (- i_loop 1) step_len)
				(* line_num line_patch)
			     )
		   )
	  )
	  (command "pline" p1 p2 p3 p4 "c")
	  (command "array" "L" "" "R" line_num "1" line_patch)
	  (setq i_loop (1+ i_loop))
	)
      )
    )
    (progn
      (setq x_pst (car position))
      (setq diff (+ (/ xsize 2.0) 0.15))
      (setq diff (- diff (fix diff)))
      (setq diff (- base_high diff))
      	;;;;;;;;;;;;;;;;;;;;;;;;;;;
      (dev_mark (ofst_pnt position 1 2) machine mirror dev_num_tmp "Y")
      (setq position (list (+ (fix x_pst) diff) (cadr position)))
      (setq position (ofst_pnt position 2.0 2.0))
      (setq i_loop 1)
      (while (<= i_loop dev_num)
	(setq p1 (ofst_pnt position (* (- i_loop 1) step_len) 0)
	      P2 (ofst_pnt position
			   (+ bg_wid
			      (* i_loop 2 increase_width)
			      (- increase_width)
			      (* (- i_loop 1) step_len)
			   )
			   0
		 )
	      p3 (ofst_pnt position
			   (+ bg_wid
			      (* i_loop 2 increase_width)
			      (- increase_width)
			      (* (- i_loop 1) step_len)
			   )
			   5
		 )
	      p4 (ofst_pnt position (* (- i_loop 1) step_len) 5)
	)
	(command "pline" p1 p2 p3 p4 "c")
	(command "array" "L" "" "R" "1" line_num line_patch)
	(setq p1 (ofst_pnt
		   position
		   (+ (* line_num line_patch) (* (- i_loop 1) step_len))
		   0
		 )
	      P2 (ofst_pnt position
			   (+ bg_wid
			      (* i_loop 2 increase_width)
			      (* (- i_loop 1) step_len)
			      (* line_num line_patch)
			   )
			   0
		 )
	      p3 (ofst_pnt position
			   (+ bg_wid
			      (* i_loop 2 increase_width)
			      (* (- i_loop 1) step_len)
			      (* line_num line_patch)
			   )
			   5
		 )
	      p4 (ofst_pnt
		   position
		   (+ (* line_num line_patch)
		      (* (- i_loop 1) step_len)
		   )
		   5
		 )
	)
	(command "pline" p1 p2 p3 p4 "c")
	(command "array" "L" "" "R" "1" line_num line_patch)
	(setq i_loop (1+ i_loop))
      )
    )
  )
)
(defun drw_box (xsize ysize)
  (setq	p1 (list (- (/ xsize 2)) (- (/ ysize 2)))
	p2 (list (/ xsize 2) (- (/ ysize 2)))
	p3 (list (/ xsize 2) (/ ysize 2))
	p4 (list (- (/ xsize 2)) (/ ysize 2))
  )
  (command "pline"
	   (ofst_pnt p1 -0.05 -0.05)
	   (ofst_pnt p2 0.05 -0.05)
	   (ofst_pnt p3 0.05 0.05)
	   (list 0.1 (+ (/ ysize 2) 0.05))
	   (list 0.1 (- (/ ysize 2) 0.05))
	   (ofst_pnt p3 -0.05 -0.05)
	   (ofst_pnt p2 -0.05 0.05)
	   (ofst_pnt p1 0.05 0.05)
	   (ofst_pnt p4 0.05 -0.05)
	   (list -0.1 (- (/ ysize 2) 0.05))
	   (list -0.1 (+ (/ ysize 2) 0.05))
	   (ofst_pnt p4 -0.05 0.05)
	   "c"
  )
  (command "pline"
	   (ofst_pnt p1 -0.15 -0.15)
	   (ofst_pnt p1 -0.05 -0.15)
	   (ofst_pnt p1 -0.05 -0.05)
	   (ofst_pnt p1 -0.15 -0.05)
	   "c"
  )
  (command "array"
	   "L"
	   ""
	   "R"
	   "2"
	   "2"
	   (+ ysize 0.2)
	   (+ xsize 0.2)
  )
)
(defun chk_mtr (xsize ysize thick)
  (defun match (xsize ysize thick mtr)
    (if	(> xsize ysize)
      (progn
	(setq tmp xsize)
	(setq xsize ysize)
	(setq ysize tmp)
      )
    )
    (setq mtr_x (car mtr))
    (setq mtr_y (cadr mtr))
    (setq mtr_thick (caddr mtr))
    (if	(and (= thick mtr_thick)
	     (or (and
		   (and (< (- mtr_x xsize) 20) (>= (- mtr_x xsize) 0))
		   (>= mtr_y ysize)
		 )
		 (and
		   (and (< (- mtr_y ysize) 20) (>= (- mtr_y ysize) 0))
		   (>= mtr_x xsize)
		 )
	     )
	)
      (progn
	(getstring (strcat "\n这块将使用版材尺寸为:"
			   (rtos mtr_x)
			   "X"
			   (rtos mtr_y)
			   "X"
			   (rtos mtr_thick)
		   )
	)
	(setq mt T)
      )
      (setq mt nil)
    )
    (setq mt mt)
  )
  (setq	mtr_list (list '(400 400 3)
		       '(450 550 3)
		       '(450 470 3)
		       '(508.4 609.6 4.8)
		 )
  )
  (setq n (length mtr_list))
  (setq m 0)
  (setq mtr (nth m mtr_list))
  (setq mch (match xsize ysize thick mtr))
  (while (and (not mch) (< m n))
    (setq m (1+ m))
    (setq mtr (nth m mtr_list))
    (setq mch (match xsize ysize thick mtr))
  )
  (if mch
    (chk_box x_size y_size)
  )
  (setq mch mch)
)

(defun c:cbk ()
  (setvar "osmode" 0)
  (setvar "orthomode" 0)
  (setvar "plinewid" 0)
  (setq frm_wid 0.1)
  (setq x_size (getreal "\n请输入X方向的尺寸:"))
  (setq y_size (getreal "\n请输入Y方向的尺寸:"))
  (setq thick (getreal "\n请输入版材厚度(3/4.8):"))
  (command "zoom"
	   "w"
	   (list (- (- (/ x_size 2)) 10) (- (- (/ y_size 2)) 10))
	   (list (+ (/ x_size 2) 10) (+ (/ y_size 2) 10))
  )
  (setq m10 (chk_mtr x_size y_size thick))
  (command "layer" "M" "F" "")
  (dev x_size y_size m10)
  (drw_box x_size y_size)
  (command "purge" "all" "" "N")
)
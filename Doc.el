;;;;;;;;;;;;;;;;;;;;;;;;;;;;[32]
;;;;;;;;;;;;;;;;;;;;;;;;;[;;];;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;[64]
;;;;;;;;;;[;;];;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;[48];;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;[;;];;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;[40]
;;;;;;;;;[;;];;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;[56];;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;[;;];;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;[72];;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;[;;];;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 72 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; VII. MEDICAL VISITOR'S REGISTER A medical visitor would like to have
;; a program which would schedule all his medical appointments and help
;; him meet as many doctors as possible in one day in order to advertise
;; the medical products of the company he represents. YOU_ARE
;; ASKED_TO_WRITE_THE_PROGRAM_WHICH_WOULD_DO_THIS_TASK_FOR_HIM. The
;; input file consists of lines, each of which contains the name of a
;; doctor, the beginning and the end of the interval when the doctor is
;; ready to meet the medical visitor, as well as the name of his medical
;; institute. THE-RULES-FOR-SCHEDULING-THE-APPOINTMENTS-ARE-AS-FOLLOWS:
;; 1. An appointment has at least 70 minutes duration; furthermore the
;; medical visitor needs at least 30 minutes between any two
;; appointments to travel to the next medical institute. 2. ALL
(defconst at-least 70 "duration")
;; THE TIMES IN THE INPUT FILE BELONG TO THE SAME DAY, AND THE MEDICAL
;; VISITOR DOES NOT WANT TO MEET ANY DOCTOR TWICE ON THE SAME
;; DAY. 3. Also, two consequtive appointments cannot be held at the same
;; institute. 4. AMONG SEVERAL DOCTORS THE MEDICAL VISITOR ALWAYS
(defconst betwe-en 30 "travel")
;; PREFERS THE ONE WHOM HE CAN MEET EARLIER. 5. If there is more than
;; one doctor whom the medical visitor would be able to meet at the same
;; time (either because by the time he finishes from the previous
;; appointment there are doctors already waiting or because their
;; proposed appointment would begin later but at the same time during
;; the day) he prefers the one who has less remaining time for the given
;; day ( but of course this time at the beginning of the appointment
;; must be enough for the required 70 minutes). 6. TO VISIT AS MANY
;; DOCTORS AS POSSIBLE, THE MEDICAL VISITOR ALWAYS ( EVEN DURING
;; ANAPPOINTMENT ) KEEPS IN MIND THE NEXT APPOINTMENT'S STARTING TIME,
;; THEREFORE IF IT IS NECESSARY HE CAN TERMINATE THE ON-GOING
;; APPOINTMENT AFTER THE MINIMAL 70 MINUTES EXPIRE, TAKE HIS 30 MINUTES
;; FOR TRAVELING AND BEGIN THE NEXT APPOINTMENT ACCORDING TO RULE
;; 5. 7. If he is not in a hurry for a new appointment ( according to
;; rule 6 ), the medical visitor stays with a doctor as long as he
(defconst mph 60 "minutes per hour")
;; can. INPUT FILE: CONSISTS OF LINES EACH OF WHICH CONTAINS A NAME (
;; WITH THE ENGLISH ALPHABET ), A BLANK SPACE, A TIME ( IN HH.MM FORM )
;; INDICATING THE POSSIBLE BEGINNING OF AN APPOINTMENT, A DASH ('-'), A
;; TIME AGAIN INDICATING THE LAST POSSIBLE MOMENT OF THE APPOINTMENT, A
;; BLANK SPACE, AND A NAME (WITH THE ENGLISH ALPHABET) OF THE MEDICAL
;; INSTITUTE. The input file does not contain empty lines, nor is the
;; end of it marked with special characters. A POSSIBLE INPUT FILE IS AS
;; FOLLOWS:
;; Bob 16.00-17.25 Cross
;; John 09.30-11.50 Health
;; Charles 11.00-20.00 Chest
;; Don 08.00-13.20 Cross
;; Norman 22.00-23.05 Brain
;; Jerry 10.00-17.00 Health
;; Charles 09.20-10.40 Orthopedic
;; Evelyn 19.15-20.40 Orthopedic
;; Peter 09.35-11.55 Brain
;; Don 18.00-20.00 Eye
(cl-defstruct
    (doc
     (:constructor
      cons-doc (name t1 t2 &optional (inst "Cross"))))
  name t1 t2 inst)
;; Output file: should contain a table in which all the possible
;; appointments appear in their proposed chronological order. THE
;; APPOINTMENTS WHICH ARE RULED OUT BY ANY OF THE RULES ABOVE SHOULD
;; NOT APPEAR IN THE TABLE. The table should consist of lines
;; containing the realizable beginning and end time of the possible
;; appointments, their place, and the proposing doctor's name. THE
;; EXACT SPACING OF THE OUTPUT TABLE IS NOT IMPORTANT, BUT SHOULD LOOK
;; SIMILAR TO THE ONE BELOW. The output for the previous input file is
;; as follows:
;; 08.00-09.10 Cross      Don
;; 09.40-10.50 Health     John
;; 11.20-12.30 Chest      Charles
;; 13.00-15.30 Health     Jerry
;; 16.00-17.25 Cross      Bob
;; 19.15-20.40 Orthopedic Evelyn
;; 8. Solve the above problem for two medical visitors A and B
;; preserving the same scheduling rules and the additional restriction
;; that they are not allowed to visit the same doctor. Each time an
;; appointment is available, it is taken by that medical visitor who has
;; been free for the longest period. If both have been free for the same
;; time period, Mr. A takes the appointment. The output consists of two
;; appointment lists. Evaluation: One medical visitor 45 points Two
;; medical visitor 45 points Jury 10 points (elegance, clarity,
;; progr. style)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Yee, Ok, The problem seems quite complicated especially for the 
;; 2nd scenario, but in principle it can be solved for arbitrary number
;; of visitors with the method I've first saw in Knuth Vol1 (282-298.)
;; namely the elevator problem. We have a cycle line and we throw on
;; the waiting stack task sorted by time.
;;
;; I've decided to write my fyorst program in elisp and by far this is
;; the most beautiful language I've seen. Ok here only the case of one
;; visitor is considered, in this simple case we can write classical
;; straightforward algorithm (shedl). The only tricky part is how to 
;; handle consecutive doctors from same institute. In the solution
;; presented above Jerry from Health is visited after Charles form
;; Chest despite that he has earlier opening time.
;;
;; In the file TakeItEasyDoc.py is the second part. Don't know the
;; the name, but this is quite a clever method and a general approach
;; to similar problems.
;;
;; To run this program load in emacs and type M-x eval-buffer, for
;; the python program redirect the input e.g:
;; ./TakeItEasyDoc.py <input/input1
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;[56]
(defun file-string (filename)
  "Get filename contents as string."
  (with-temp-buffer
    (insert-file-contents filename)
    (buffer-string)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;[;;];;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;[64]
(defun str2min (str)
  "string to minutes, e.g.: 10.15 to 615"
  (let* ((n (split-string str "\\."))      ;; twice escaped .!
	 (h (string-to-number (nth 0 n)))  ;; hour
	 (m (string-to-number (nth 1 n)))) ;; minutes
    (+ m (* mph h))))                      ;; total minutes
;;;;;;;;;;[;;];;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;[40];;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun unpack-time (str)
  "interval string 2 minutes list"
  (let ((ls (split-string str "-")))
    (mapcar 'str2min ls)))
;;;;;;;;;;;;;;;;;;;[;;];;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;[48];;;;;;;;;;;;
(defun unpack-line (line)
  "Unpack input line"
  (let* ((ls (split-string line " "))
	 (name (nth 0 ls))
	 (time (unpack-time (nth 1 ls)))
	 (inst (nth 2 ls)))
    (list name (nth 0 time) (nth 1 time) inst)))
;;;;;;;;;;;;;;;;;;;;;[;;];;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;[40]
(defun cmp (x y)
  "=|8(_,"
  (cond
   ((<  (doc-t1 x) (doc-t1 y)) t)
   ((>  (doc-t1 x) (doc-t1 y)) nil)
   ((<= (doc-t2 x) (doc-t2 y)))))
;;;;;;;;;[;;];;;;;;;;;;;;;;;;;;;;;;;;;;;
;;[48];;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun mrg (x y)
  "Dasgupta et al."
  (cond
   ((null x) y)
   ((null y) x)
   ((let ((p) (l))
      (if (cmp (car x) (car y))
	  (setq p (pop x))
	(setq p (pop y)))
      (setq l (mrg x y))
      (push p l)))))
;;;;;;;;;;;;;;;;;;[;;];;;;;;;;;;;;;;;;;;;;;;;;;`
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;[40]
(defun mrg-sort (x)
  (let ((n (/ (length x) 2)) (l) (r))
    (if (= n 0)	x
      (setq l (seq-take x n)
	    r (seq-drop x n))
      (mrg (mrg-sort l) (mrg-sort r)))))
;;;;;;;;;[;;];;;;;;;;;;;;;;;;;;;;;;;;;;'
;;[64];;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun cons-appt (filename)
  "Construct an appointment list"
  (let* ((buf (file-string filename))
	 (buf (split-string buf "\n" t))
	 (buf (mapcar 'unpack-line buf))
	 (buf (mapcar #'(lambda (x) (apply 'cons-doc x)) buf)))
    (mrg-sort buf)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;[;;];;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;[72];;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun ckck (a x l)
  ;; a - appt record
  ;; x - time
  ;; l - last visited record
  "Duration and Institute"
  (if (< (- (doc-t2 a) x) at-least)
      -1
    (if (string= (doc-inst a) (doc-inst l)) 
        0
      1)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;[;;];;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;[80];;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; "
;; 08.00-13.20          Cross            Don
;; 09.20-10.40     Orthopedic        Charles
;; 09.30-11.50         Health           John
;; 09.35-11.55          Brain          Peter
;; 10.00-17.00         Health          Jerry
;; 11.00-20.00          Chest        Charles
;; 16.00-17.25          Cross            Bob
;; 18.00-20.00            Eye            Don
;; 19.15-20.40     Orthopedic         Evelyn
;; 22.00-23.05          Brain         Norman
;; "
(defun shedl (A)
  "Staät"
  ;; [0.iNit]
  ;;  x|A[0].t¹
  ;; ls|[("" 0 0 "")]
  (let ((x (doc-t1 (car A)))
        (ls (list (cons-doc "" 0 0 "")))
        (rec) (y) (w) (cure) (next) (ck))
    (catch 'break
      (while t
        (catch 'continue
          ;; [1.ARVEdON?]
          ;; cure|pop(A)
          ;; next|A[0]
          ;; «A.empty¿» yee: >>> exit >>>
          (setf cure (pop A)
                next (car A))
          (if (not cure) (throw 'break t))
          ;; [2.ckck]
          ;; «x < cure.t¹?» yea: x|cure.t¹
          ;; «ckck(cure, x, ls[-1])¿» No: goto [1]
          (if (< x (doc-t1 cure)) (setf x (doc-t1 cure)))
          (setf ck (ckck cure x (car (last ls))))
          (if (< ck 1)
              (progn
                (if (= ck 0) (push cure (cdr A)))
                (throw 'continue t)))
          ;; [3.cons]
          ;; B|(cure.nom, x, ?, cure.inst)
          ;; x += 70
          (setf rec (cons-doc (doc-name cure) x -1
                              (doc-inst cure)))
          (setf x (+ at-least x))
          ;; [4.Vait?]
          ;; y|x + 30
          ;; { next and y < next.t¹¿ }
          (setf y (+ x betwe-en))
          (if (or (not next) (>= y (doc-t1 next)))
              ;; [5.Immediately]
              ;; No) w|0
              (setf w 0)
            ;; [6.Tik-Tak]
            ;; yea) w|min(cure.t² - t, next.t¹ - y)
            (setf w (min (- (doc-t2 cure) x)
                         (- (doc-t1 next) y))))
          ;; [7.Push]
          ;; B.t²|t + w
          ;; ls.push(B)
          ;; t|w + y
          (setf (doc-t2 rec) (+ x w)
                ls (append ls (list rec))
                x (+ w y)))))
    ls))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;[;;];;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;[48];;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun min2str (m)
  "minutes to string, e.g.: 60 to 01.00"
  (format "%02d.%02d" (/ m mph) (% m mph)))
;;;;;;;[;;];;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;56
(defun doc-str (rec)
  "wtf is prety printing?"
  (format "%s-%s %15s %15s"
	  (min2str (doc-t1 rec))
	  (min2str (doc-t2 rec))
	  (doc-inst rec)
	  (doc-name rec)))
;;;;;;;;;;;;;;;;;;;[;;;;;;;;;;;;;;;;;;;;;;;;];;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;[72];;;;;;;;
(defun dunf-docs (A)
  "yeah\yeah!"
  (concat
   (apply 'concat (mapcar #'(lambda (x) (concat "\n" (doc-str x))) A))
   "\n"))  
;;;;;;;;;;;;;;;;;;;[;;];;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq A (cons-appt "input/input1"))
(message "%s" (dunf-docs (cdr (shedl A))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; log:
;; cure:
;; next:

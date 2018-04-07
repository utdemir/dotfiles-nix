(defun up2n-read-file (path)
  (with-temp-buffer
    (insert-file-contents path)
    (buffer-string)))

(defun up2n-parse-file (contents)
  (car (read-from-string (format "(progn %s)" contents))))

(defun up2n-use-package-name (ast)
  (pcase ast
    (`(use-package ,pname . ,_) pname)))

(defun up2n-find-packages (ast)
  (cond
   ((up2n-use-package-name ast) (cons (up2n-use-package-name ast) nil))
   ((consp ast)
    (append (up2n-find-packages (car ast)) (up2n-find-packages (cdr ast))))
   ((atom ast) ())))

(defun up2n-format-packages (pnames)
  (format
   "[ %s ]\n"
   (mapconcat (lambda (p) (format "\"%s\"" (symbol-name p))) pnames " ")))

(defun up2n-run (paths)
  (let*
      ((extract (lambda (p) (up2n-find-packages (up2n-parse-file (up2n-read-file p)))))
       (packages (delete-dups (apply 'append (mapcar extract paths)))))
    (princ (up2n-format-packages packages))))

(up2n-run command-line-args-left)

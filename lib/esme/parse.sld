;; esme - Shell inspired by Scheme
;; Copyright (C) 2017  Thomas Tuegel
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

(define-library (esme parse)
  (import (chibi)
          (except (chibi parse) parse-word parse-word+))
  (export parse-word skip-whitespace parse-sep-by+)
  (include "parse.scm"))

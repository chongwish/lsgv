(for-each
 (lambda (style)
   (lsgv-parse style))
 '(

;; none section

($ none
   :shape "none"
   :color #xFFFFFF
   :filled-color #xFFFFF
   :fontcolor #xFFFFFF
   :style "invis")

;; line section

($ mean
   :style "tapered"
   :arrowtail "none"
   :dir "back"
   :penwidth "5"
   :relation child)

($ grow
   :style "tapered"
   :arrowhead "none"
   :penwidth "5"
   :relation parent)

($ has
   :arrowhead "none"
   :dir "none"
   :penwidth "3"
   :relation parent)

($ use
   :relation parent)

($ make
   :style "dashed"
   :penwidth "2"
   :relation parent)

;; rainbow section

($ rainbow-halo
   :shape "ellipse"
   :override (rainbow-color)
   :fontcolor-ratio 0.8
   :filled-color-ratio 1.6
   :fix-fontcolor-blue-offset #x90
   :style "filled,radial")

($ rainbow
   :shape "ellipse"
   :fontcolor #xffffff
   :override (rainbow-color)
   :style "filled")

($ rainbow-simple
   :shape "ellipse"
   :fontcolor-ratio 1
   :override (rainbow-color))

;; project section

($ core
   :filled-color #xBD0015
   :color #xFF7080
   :fontcolor #xFFB8BF
   :shape "circle"
   :style "filled,radial")

($ machine
   :filled-color #x0038FA
   :color #x00208F
   :fontcolor #xDBE3FF
   :style "filled,radial"
   :shape "house")

($ program
   :color #x330070
   :filled-color #xA65CFF
   :fontcolor #xCCCCCC
   :style "filled,radial"
   :shape "parallelogram")

($ signature
   :color #x000000
   :filled-color #xCCCCCC
   :fontcolor #xFF6060
   :style "filled"
   :shape "signature")

($ note
   :color #xE5F000
   :filled-color #xF9FF80
   :fontcolor #x0B00F0
   :style "filled,radial"
   :shape "egg")

($ feature
   :color #x00990D
   :filled-color #x34FF0A
   :fontcolor #x325C00
   :style "filled,radial"
   :shape "ellipse")

($ component
   :color #xFF7AFF
   :filled-color #xFF7A9B
   :fontcolor #x7F0000
   :shape "component"
   :style "filled")

($ folder
   :color #x00ADCC
   :filled-color #x47E3FF
   :fontcolor #x00806E
   :shape "folder"
   :style "filled")

($ function
   :color #x00A87D
   :filled-color #x7AFFDD
   :fontcolor #x006B50
   :shape "hexagon"
   :style "filled,radial")

($ test
   :filled-color #x008A1E
   :color #xFF0000
   :fontcolor #xFFFF00
   :shape "diamond"
   :style "filled")

($ file
   :color #xc0c0c0
   :fontcolor #x000000
   :shape "note"
   :style "filled,radial")

($ data
   :filled-color #x67a9cf
   :color #x016450
   :fontcolor #xe5d8bd
   :shape "cylinder"
   :style "filled,radial")

; simple section

($ simple-core
   :color #xBD0015
   :fontcolor #xBD0015
   :shape "circle")

($ simple-machine
   :color #x00208F
   :fontcolor #x00208F
   :shape "house")

($ simple-program
   :color #x008A88
   :fontcolor #x008A88
   :shape "parallelogram")

($ simple-signature
   :color #xAAAAAA
   :fontcolor #xAAAAAA
   :shape "signature")

($ simple-note
   :color #xAAAA00
   :fontcolor #xAAAA00
   :shape "egg")

($ simple-feature
   :color #x00990D
   :fontcolor #x00990D
   :shape "ellipse")

($ simple-component
   :color #xFF7AFF
   :fontcolor #xFF7AFF
   :shape "component")

($ simple-folder
   :color #x0ADDFF
   :fontcolor #x0ADDFF
   :shape "folder")

($ simple-function
   :color #x00A87D
   :fontcolor #x00A87D
   :shape "hexagon")

($ simple-test
   :color #xFFAA00
   :fontcolor #xFFAA00
   :shape "diamond")

($ simple-file
   :color #x000000
   :fontcolor #x000000
   :shape "note")

($ simple-data
   :color #x016450
   :fontcolor #x016450
   :shape "cylinder")

   ))
